# AdGuardHome
## Overview
[There is](https://hub.docker.com/r/adguard/adguardhome) well documented way of deploying adguardhome container created by application developers.

## Deployment
### Compose example
``` yaml title="docker-compose.yml"
version: '3.3'

services:
  app:
    image: adguard/adguardhome:latest
    container_name: adguard
    volumes:
      - /docker_data/adguard/work:/opt/adguardhome/work
      - /docker_data/adguard/conf:/opt/adguardhome/conf
    ports:
      - 53:53/tcp
      - 53:53/udp
      - 853:853/tcp
      - 3000:3000/tcp
    networks:
      - adguard_network
      - proxy
    restart: always


networks:
  adguard_network:
    driver: bridge
  proxy:
    external: true
```

### Troubleshooting

## Update
I had an error that after update some of the DNS filter lists stopped working so i had to delete them and set them up again

## Backup and Restore

## Issues
