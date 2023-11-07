# Use the base image with Carla installed
FROM carlasim/carla:0.9.11

# Set the environment variables
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LIBGL_ALWAYS_INDIRECT=1

# Run as root
USER root

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list

# Install the required packages
RUN apt-get update && apt-get install -y \
    python3-pip \
    libjpeg-turbo8 \
    libtiff-dev \
    language-pack-en \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libfreetype6-dev \
    libportmidi-dev \
    libjpeg-dev \
    python3-setuptools \
    python3-dev \
    python3-numpy \
    vim \
    fontconfig \
    mesa-utils && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory to the Python API directory
WORKDIR /home/carla/PythonAPI/carla

# Copy the requirements file and install Python dependencies
RUN pip3 install -r requirements.txt
RUN pip3 install pygame

# Add the egg path to PYTHONPATH
ENV PYTHONPATH "${PYTHONPATH}:/home/carla/PythonAPI/carla/dist/carla-0.9.11-py3.7-linux-x86_64.egg"

# Set the working directory to the examples
WORKDIR /home/carla/PythonAPI/examples

# Set the entrypoint to run the manual_control.py script
ENTRYPOINT ["python3", "manual_control.py"]

# Set the default HOST_IP and PORT as environment variables
# Users can override these at runtime if needed
CMD ["--host", "127.0.0.1", "--port", "2000"]
