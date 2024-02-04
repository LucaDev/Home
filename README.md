# Home
This repo is the heart of my homeserver setup. It contains all data needed to recreate it from scratch.

It's fully managed by FluxCD and kept up to date with Renovate Bot.

## Tool & Apps
Todo: eza --tree --icons -D -L 2 ./apps/
```
> tree -d -L 2 apps/
./apps
├── databases
│  ├── cloudnative-pg
│  ├── mongodb-operator
│  └── redis
├── downloads
│  ├── gluetun
│  ├── jellyseerr
│  ├── prowlarr
│  ├── radarr
│  ├── sabnzbd
│  └── sonarr
├── home-automation
│  ├── esphome
│  ├── homeassistant
│  ├── homepage
│  ├── mosquitto
│  ├── node-red
│  ├── nut
│  └── zigbee2mqtt
├── kube-system
│  ├── amd-k8s-plugin
│  ├── node-feature-discovery
│  ├── reloader
│  └── traefik
├── media
│  ├── calibre-web
│  ├── frigate
│  ├── immich
│  ├── jellyfin
│  ├── mealie
│  ├── paperless-ngx
│  └── stirling-pdf
├── monitoring
│  ├── alertmanager
│  ├── grafana
│  ├── kube-prometheus-stack
│  ├── loki
│  ├── mqtt-exporter
│  ├── smartctl_exporter
│  ├── unpoller
│  └── vector
├── networking
│  ├── cert-manager
│  ├── external-dns
│  └── unifi-controller
├── secrets
│  ├── bitwarden-cli
│  ├── external-secrets
│  └── kubed
├── security
│  ├── kanidm
│  └── kanidm-radius
└── storage
   ├── configuration
   ├── samba
   ├── snapshot
   └── volsync
```
