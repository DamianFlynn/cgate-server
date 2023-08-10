# CGate Server

This docker image installs the Clipsal CGate Server for use with CBus applicances.

## Install

Easy installation can be achieved if you already have the XML version of the project file.
Place this file in the `/tag` directory

Access to the server is goverened by a file named access.txt
If this file does not already exist, create it in `/config` and follow the doco

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=cgate-server \
  -p 20023:20023 \
  -p 20024:20024 \
  -p 20025:20025 \
  -p 20026:20026 \
  -p 20123:20123 \
  -v <path-to-config-dir>:/config \
  -v <path-to-tag-dir>:/tag \
  -v <path-to-logs-dir>:/logs \
  --restart unless-stopped \
  steppinghat/cgate-server
```

### docker-compose

Compatble with docker-compose v3 schemas

```
version: '3'
services:
  cgate-server:
    image: steppinghat/cgate-server
    container_name: cgate-server
    ports:
        - 20023:20023
        - 20024:20024
        - 20025:20025
        - 20026:20026
        - 20123:20123
    volumes:
        - [path-to-config-dir]:/config
        - [path-to-tag-dir]:/tag
        - [path-to-logs-dir]:/logs
    restart: unless-stopped
```

### Version tags

| Tag | Description |
| --- | ----------- |
| latest | Releases from the latest stable branch |
| 2.11 | Releases from the 2.11.x branch |



### Parameters

| Parameter | Function |
| --------- | -------- |
| `-p 20023` | CGate Command port |
| `-p 20024` | CGate Event port |
| `-p 20025` | CGate Load Change port |
| `-p 20026` | CGate Config Change port |
| `-p 20123` | CGate Secure Command port |
| `-v :/config` | CGate config directory (`access.txt` goes here) |
| `-v :/tag` | CGate tag directory (XML project files go here) |
| `-v :/logs` | CGate logs directory |

_Written by Javan Eskander @SteppingHat_
