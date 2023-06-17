# Home
This repo is the heart of home-server setup. It contains all data needed to recreate it from scratch.

## Tools used
- 🛜 [Cilium](https://cilium.io/) for providing networking and network observability to K8s
- 📡 [Multus](https://github.com/k8snetworkplumbingwg/multus-cni) to allow voll network access to pods
- 🤖 [Rennovate Bot](https://github.com/renovatebot/renovate) for automatically updating applications in the cluster
- 🦾 [Flux CD](https://fluxcd.io/) to automatically sync the changes in this repo with the cluster
- 💾 [Hwameistor](https://hwameistor.io/) to easyly manage all the storage attatched to the cluster
- 🟰 [external-dns](https://github.com/kubernetes-sigs/external-dns) to keep cloudflare DNS records in sync with the services in the cluster
- 🏡 [k8s-gateway](https://github.com/ori-edge/k8s_gateway) to allow for internal DNS resolution while being at home

## Applications
- Unifi Controller
- ToDo

