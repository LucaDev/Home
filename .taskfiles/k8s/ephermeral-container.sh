#!/bin/zsh

pod_name="$1"
container_name="$2"
namespace="${3:-default}"
if [[ -z "${pod_name}" || -z "${container_name}" ]]; then
    echo "requires pod name as first argument and container name as second argument"
    return 1
fi
pod_json="$(kubectl -n "${namespace}" get pod "${pod_name}" -o json)"
if [[ -z "${pod_json}" ]]; then
    echo "invalid pod"
    return 2
fi
volume_mounts="$(jq --arg CONTAINERNAME "${container_name}" '.spec.containers[] | select(.name==$CONTAINERNAME) | .volumeMounts | map(select(.subPath==null))' <<<"${pod_json}")"
env_variables="$(jq --arg CONTAINERNAME "${container_name}" '.spec.containers[] | select(.name==$CONTAINERNAME) | .env' <<<"${pod_json}")"
env_froms="$(jq --arg CONTAINERNAME "${container_name}" '.spec.containers[] | select(.name==$CONTAINERNAME) | .envFrom' <<<"${pod_json}")"
exec 3< <(
    kubectl proxy --port=0 &
    echo $!
)
port_number=''
kubectl_pid=''
while [[ "${port_number}" == '' || "${kubectl_pid}" == '' ]]; do
    read -r -u 3 line
    if [[ "${kubectl_pid}" == '' && "${line}" =~ ^[0-9]+$ ]]; then
        kubectl_pid="${line}"
        continue
    elif [[ "${port_number}" == '' && "${line}" =~ :[0-9]+$ ]]; then
        port_number="$(grep -oE '[0-9]+$' <<<"${line}")"
        continue
    fi
done

ephemeral_container_name="debugger-${RANDOM}"
patch_api_body="$(jq -r tostring <<EOF
{
    "spec": {
        "ephemeralContainers": [{
            "name": "${ephemeral_container_name}",
            "command": ["sh"],
            "image": "ghcr.io/onedr0p/alpine:rolling",
            "targetContainerName": "${container_name}",
            "stdin": true,
            "tty": true,
            "volumeMounts": ${volume_mounts},
            "envFrom": ${env_froms},
            "env": ${env_variables}
        }]
    }
}
EOF
)"
echo "Patching with the following:"
echo "${patch_api_body}"
curl "http://localhost:${port_number}/api/v1/namespaces/${namespace}/pods/${pod_name}/ephemeralcontainers" -X PATCH -H 'Content-Type: application/strategic-merge-patch+json' --data-binary "${patch_api_body}"
kill "${kubectl_pid}"

try=1
while [[ "$(kubectl -n "${namespace}" get pod "${pod_name}" -o jsonpath='{.status.ephemeralContainerStatuses}' | jq --arg EPHEMERALCONTAINERNAME "${ephemeral_container_name}" -r 'map(select(.name==$EPHEMERALCONTAINERNAME))[0].state | has("running")')" != 'true' ]]; do
    echo 'Ephemeral container still not running...'
    sleep 1
    ((try++))
    if [[ ${try} -gt 30 ]]; then
        echo 'Waiting for ephemeral container to be running timed out.'
        return 3
    fi
done

kubectl -n "${namespace}" attach "${pod_name}" -c "${ephemeral_container_name}" -it
