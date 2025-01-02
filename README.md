# Home
This repository contains the configuration files and scripts for my personal homelab setup.

I use k3s as my lightweight Kubernetes distribution for running containerized applications. FluxCD is employed for continuous deployment and GitOps workflows, while Renovate Bot helps in automating dependency updates.

## Core Components
1. k3s: Lightweight Kubernetes distribution optimized for edge and IoT devices.
2. FluxCD: GitOps operator for Kubernetes.
3. Renovate Bot: Automated dependency update tool.

## Current Applications
```
> tree -d -L 2 apps/
apps/
├── databases
│   ├── cloudnative-pg
│   ├── mongodb-operator
│   ├── redis
│   └── shared-pg
├── downloads
│   ├── jellyseerr
│   ├── prowlarr
│   ├── radarr
│   ├── sabnzbd
│   └── sonarr
├── home-automation
│   ├── esphome
│   ├── homeassistant
│   ├── homepage
│   ├── maybe
│   ├── mosquitto
│   ├── nut
│   ├── whisper
│   └── zigbee2mqtt
├── kube-system
│   ├── amd-k8s-plugin
│   ├── cilium
│   ├── node-feature-discovery
│   ├── reloader
│   ├── system-upgrade-controller
│   └── traefik
├── media
│   ├── calibre-web
│   ├── dawarich
│   ├── ersatztv
│   ├── frigate
│   ├── immich
│   ├── jellyfin
│   ├── mailbackup
│   ├── memos
│   ├── paperless-ngx
│   ├── shlink
│   ├── shlink-ui
│   ├── stirling-pdf
│   └── tandoor
├── monitoring
│   ├── alertmanager
│   ├── blackbox-exporter
│   ├── fritz-exporter
│   ├── gatus
│   ├── grafana
│   ├── healthcheck
│   ├── kube-prometheus-stack
│   ├── mqtt-exporter
│   ├── smartctl_exporter
│   ├── snmp-exporter
│   └── unpoller
├── networking
│   ├── cert-manager
│   ├── openspeedtest
│   └── unifi-controller
├── secrets
│   ├── bitwarden-cli
│   ├── external-secrets
│   └── reflector
├── security
│   ├── crowdsec
│   ├── kanidm
│   └── oauth2-proxy
└── storage
    ├── backup
    ├── configuration
    ├── filebrowser
    ├── minio
    ├── snapshot
    └── volsync
```
## Contributing
Contributions are welcome! If you have any suggestions, improvements, or fixes, feel free to open an issue or submit a pull request. Please bare in mind that my homelab is constanly changing and never close to what I'd call "production ready".

## License
This project is licensed under the MIT License.

---

Happy Homelabbing! 🚀
