# Clipsal C-Gate Server Docker Container

The Clipsal C-Gate Server is a powerful utility designed to interface with the Clipsal PLC system, connecting via either serial or network connections. This repository provides a Dockerized version of the C-Gate Server, enabling convenient deployment and management of the server within a containerized environment. The C-Gate Server acts as a bridge between the Clipsal PLC system and other devices, facilitating seamless communication.

## Purpose

The primary purpose of this project is to encapsulate the Clipsal C-Gate Server within a Docker container, allowing users to deploy the server effortlessly on various platforms. By leveraging Docker's isolation and management capabilities, this solution simplifies the installation and usage of the C-Gate Server, making it an ideal choice for users looking to connect and interact with the Clipsal PLC system.

## Features

- **Flexible Connectivity:** The C-Gate Server offers support for both serial and network connections, providing a versatile interface to the Clipsal PLC system.
- **Dockerized Deployment:** The provided Dockerfile enables the creation of a containerized instance of the C-Gate Server, making setup and configuration straightforward.
- **Customizable Configuration:** The container supports customization through configuration files, allowing users to tailor the server's behavior to their specific needs.

## Usage

To utilize the Dockerized `cgate-server` container, follow these steps:

1. **Build the Docker Image:**

   ```bash
   docker build -t cgate-server .
   ```

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


### Docker 

Start the container directly with the following example

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

### Docker Compose:**

Create a Docker Compose file (`docker-compose.yml`):

 ```yaml
version: '3.8'

x-disabled:

services:

  # CNI Serial port (RS232 to USB) to TCP 10001
  ser2sock:
    hostname: "ser2sock"
    image: ghcr.io/damianflynn/ser2sock:latest
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
    image: ghcr.io/damianflynn/cgate-server:latest
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

   Run the Docker Compose:

   ```bash
   docker-compose up -d
   ```

## Accessing the C-Gate Server:**

Once the container is running, you can access the Clipsal C-Gate Server via the defined ports (e.g., 20023, 20024, etc.). The server will act as an intermediary, managing communication between the Clipsal PLC system and external devices.

## Configuration and Persistence

The C-Gate Server configuration and associated data are persisted using Docker volumes. Customize your server's behavior by modifying the configuration files found in the `/opt/appdata/cbus/config` volume on your host.

#### Toolkit Project

Easy installation can be achieved if you already have the XML version of the C-Bus Toolkit project file.
Place this file in the `/tag` directory; In my example the location on storage is `/opt/appdata/cbus/tags`

```yaml
    volumes:
        - /opt/appdata/cbus/tags:/tag
```


#### C-Gate Access Control file

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

## Troubleshooting

If you encounter any issues, ensure that your configuration settings and Docker Compose file match your specific hardware setup and requirements.

## Conclusion

By containerizing the Clipsal C-Gate Server using Docker, this project empowers users to effortlessly deploy, manage, and utilize the server for seamless communication with the Clipsal PLC system. This containerized approach enhances flexibility and simplifies deployment, enabling users to connect to the Clipsal system with ease and efficiency.
