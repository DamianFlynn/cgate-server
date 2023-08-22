# CGate Server

This docker image installs the Clipsal CGate Server for use with CBus appliances.

## Install

Here are some example snippets to help you get started creating a container.

### Docker

The container supports the following parameters

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

Example usage

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

Compatible with docker-compose v3 schemas

```
version: '3.8'

x-disabled:

services:

  # CNI Serial port (RS232 to USB) to TCP 10001
  ser2sock:
    hostname: "ser2sock"
    image: ser2sock:latest
    container_name: ser2sock
    restart: unless-stopped
    networks:
      - proxy
    ports:
        - 10001:10001
    environment:
      - "SERIAL_DEVICE=/dev/ttyUSB0"
    volumes:
      - /dev/ttyUSB0:/dev/ttyUSB0
    devices:
      - /dev/serial/by-id/usb-Prolific_Technology_Inc._USB-Serial_Controller_D-if00-port0:/dev/ttyUSB0
    privileged: true

  # Clipsal C-Bus C-Gate Server
  cgate-server:
    hostname: "cgate-server"
    image: cgate-server:latest
    container_name: cgate-server
    depends_on:
      - ser2sock
    networks:
      - proxy
    ports:
        - 20023:20023
        - 20024:20024
        - 20025:20025
        - 20026:20026
        - 20123:20123
    volumes:
        - /opt/appdata/cbus/config:/config
        - /opt/appdata/cbus/tags:/tag
        - /opt/appdata/cbus/logs:/logs
    restart: unless-stopped


networks:
  proxy:
    driver: bridge
    external: true
```

### Version tags

| Tag | Description |
| --- | ----------- |
| latest | Releases from the latest stable branch |
| 2.11 | Releases from the 2.11.x branch |
        


## Usage

Easy installation can be achieved if you already have the XML version of the C-Bus Toolkit project file.
Place this file in the `/tag` directory; In my example the location on storage is `/opt/appdata/cbus/tags`

```yaml
    volumes:
        - /opt/appdata/cbus/tags:/tag
```


### C-Gate Access Control file

Access to the server is governed by a file named `access.txt`
If this file does not already exist, create it in your mapped`/config` folder, as you defined in your docker configuration. 
In my example the location on storage is `/opt/appdata/cbus/config`

```yaml
    volumes:
        - /opt/appdata/cbus/config:/config
```

Edit the file, for example using `vi` or `nano`; similar to the following `nano /opt/appdata/cbus/config/access.txt`.
At the end of the file add a line `remote IPADDRESS program` replacing IPADDRESS with the source you wish to allow. 
Then save the file when you have added all the addresses you require. 

```text
##C-Gate Server Access Control File
## This file was written automatically by the server.
## Created:Sat Aug 05 01:45:38 GMT 2023
## File name: /usr/local/bin/cgate/config/access.txt
 
interface 0:0:0:0:0:0:0:1 Program
interface localhost Program
interface 127.0.0.1 Program
 
remote 127.0.0.1 Program
remote 172.18.0.1 Program
remote 172.16.100.10 Program
```

In my example the final line is my windows machine which runs C-Bus toolkit when i need to work on the system
