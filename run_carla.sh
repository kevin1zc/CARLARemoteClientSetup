#!/bin/bash

# Script to build and run a CARLA Docker container with X11 forwarding

# Function to print usage
usage() {
    echo "Usage: $0 --host <HOST> --port <PORT>"
    exit 1
}

# Check if at least two arguments are provided
if [ "$#" -ne 4 ]; then
    usage
fi

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --host) HOST="$2"; shift ;;
        --port) PORT="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# Check if HOST and PORT variables are set
if [ -z "$HOST" ] || [ -z "$PORT" ]; then
    usage
fi

# Build the Docker image
echo "Building the Docker image 'carla-remote-connection'..."
docker build -t carla-remote-connection .

# Check if Docker build was successful
if [ $? -ne 0 ]; then
    echo "Docker build failed. Exiting."
    exit 1
fi

echo "Docker image built successfully."

# Get the IP address of the host
IP=$(/usr/sbin/ipconfig getifaddr en0)

# Allow local connections to X server
echo "Allowing X11 forwarding for IP: $IP"
/opt/X11/bin/xhost + "$IP"

# Run the Docker container with the provided host and port
echo "Running the Docker container..."
docker run -it -u root \
  -e DISPLAY="${IP}:0" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  --privileged \
  carla-remote-connection \
  --host "$HOST" \
  --port "$PORT"
