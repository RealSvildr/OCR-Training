# Base image
FROM python:3.10-slim

# Layer Consistences
ENV PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install System dependences
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgl1-mesa-glx \
    wget \
    unzip \
    curl \
    gnupg2
#\  && rm -rf /var/lib/apt/lists/*

## Install Nvidia-Toolkit to use CUDA
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-container-toolkit

# Create Project Folder
WORKDIR /app

# Copy Code Files
COPY . /app

# Install Dependences 
RUN pip3 install -r requirements.txt

