# Home
This repo is the heart of my homeserver setup. It contains all data needed to recreate it from scratch.

It's fully managed by FluxCD and kept up to date with Renovate Bot.

## Tool & Apps
```
> tree -d -L 2 apps/
apps/
├── databases
│   ├── cloudnative-pg
│   └── redis
├── downloads
├── flux-system
│   ├── tf-controller
│   └── weave-gitops
├── home-automation
│   ├── esphome
│   ├── homeassistant
│   ├── homepage
│   ├── mosquitto
│   ├── node-red
│   ├── nut
│   ├── spoolman
│   └── zigbee2mqtt
├── kube-system
│   ├── node-feature-discovery
│   ├── reloader
│   └── traefik
├── media
│   ├── frigate
│   ├── immich
│   ├── jellyfin
│   └── paperless-ngx
├── monitoring
│   ├── grafana
│   ├── kube-prometheus-stack
│   ├── loki
│   ├── promtail
│   └── unpoller
├── networking
│   ├── cert-manager
│   ├── external-dns
│   └── unifi-controller
├── secrets
│   ├── bitwarden-cli
│   ├── external-secrets
│   └── kubed
├── security
│   ├── kanidm
│   └── kanidm-radius
├── storage
│   ├── configuration
│   └── samba-operator
├── system-upgrade
│   └── system-upgrade-controller
└── vms
    ├── kubevirt
    └── router
```
