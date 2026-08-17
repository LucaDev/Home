# Home

This repository contains the configuration files and scripts for my personal homelab setup.

I use k3s as my lightweight Kubernetes distribution for running containerized applications. FluxCD is employed for continuous deployment and GitOps workflows, while Renovate Bot helps in automating dependency updates.

## Core Components

1. k3s: Lightweight Kubernetes distribution optimized for edge and IoT devices.
2. FluxCD: GitOps operator for Kubernetes.
3. Renovate Bot: Automated dependency update tool.

## Current Applications

<!-- This block is generated from apps/ — do not edit by hand, run `task readme:generate` instead -->
<!-- app-tree:start -->
```
> tree -d -L 2 apps/
apps/
├── databases
│   ├── barman-cloud-plugin
│   ├── cloudnative-pg
│   ├── mck
│   ├── redis
│   └── shared-pg
├── downloads
│   ├── jellyseerr
│   ├── prowlarr
│   ├── radarr
│   ├── sabnzbd
│   └── sonarr
├── flux-system
│   ├── flux-instance
│   ├── flux-operator
│   └── konflate
├── home-automation
│   ├── esphome
│   ├── homeassistant
│   ├── homeassistant-maria
│   ├── homepage
│   ├── mosquitto
│   ├── n8n
│   ├── whisper
│   └── zigbee2mqtt
├── kube-system
│   ├── amd-k8s-plugin
│   ├── cilium
│   ├── hermes-agent
│   └── reloader
├── media
│   ├── bento-pdf
│   ├── bichon
│   ├── chhoto-url
│   ├── frigate
│   ├── immich
│   ├── jellyfin
│   ├── kiwix
│   ├── memos
│   ├── paperless-ngx
│   ├── romm
│   └── tandoor
├── monitoring
│   ├── alertmanager
│   ├── alloy
│   ├── blackbox-exporter
│   ├── fritz-exporter
│   ├── gatus
│   ├── geoip_updater
│   ├── goflow2
│   ├── grafana
│   ├── healthcheck
│   ├── kube-prometheus-stack
│   ├── loki
│   ├── mqtt-exporter
│   ├── smartctl_exporter
│   ├── snmp-exporter
│   ├── unpoller
│   └── victorialogs
├── networking
│   ├── cert-manager
│   ├── envoy-gateway
│   ├── external-dns
│   ├── kms
│   ├── netboot
│   ├── netbox
│   ├── openspeedtest
│   ├── unifi-controller
│   └── wg-portal
├── secrets
│   ├── bitwarden-cli
│   └── external-secrets
├── security
│   ├── crowdsec
│   ├── kanidm
│   ├── kube-exposure
│   └── trivy-operator
└── storage
    ├── configuration
    ├── filebrowser
    ├── forgejo
    ├── opencloud
    ├── rustfs
    ├── snapshot
    └── volsync
```
<!-- app-tree:end -->

## Contributing

Contributions are welcome! If you have any suggestions, improvements, or fixes, feel free to open an issue or submit a pull request. Please bare in mind that my homelab is constanly changing and never close to what I'd call "production ready".

## License

This project is licensed under the MIT License.

---

Happy Homelabbing! 🚀
