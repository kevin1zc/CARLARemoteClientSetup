# CARLA Remote Client Setup

This repository contains a setup designed to help Mac users easily connect to a remote CARLA server.

## Prerequisites

Before proceeding, ensure you have the following installed:

- Docker
- XQuartz (for X11 forwarding)

## Running the Client

To start the CARLA remote client, open a terminal and run the following command:

```bash
chmod +x run_carla.sh
./run_carla.sh --host <SERVER_IP> --port <PORT_NUMBER>
