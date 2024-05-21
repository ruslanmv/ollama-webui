FROM python:3.10-slim-buster
# Update packages and install curl and gnupg
RUN apt-get update && apt-get install -y \
    curl \
    gnupg

# Add NVIDIA package repositories
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://nvidia.github.io/libnvidia-container/stable/deb/ $(. /etc/os-release; echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Install NVIDIA container toolkit (Check for any updated methods or URLs for Ubuntu jammy)
RUN apt-get update && apt-get install -y nvidia-container-toolkit || true

# Install application
RUN curl https://ollama.ai/install.sh | sh
# Below is to fix embedding bug as per
# RUN curl -fsSL https://ollama.com/install.sh | sed 's#https://ollama.com/download#https://github.com/jmorganca/ollama/releases/download/v0.1.29#' | sh


# Create the directory and give appropriate permissions
RUN mkdir -p /.ollama && chmod 777 /.ollama

WORKDIR /.ollama

# Copy the entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the model as an environment variable (this can be overridden)
ENV model=${model}

# Expose the server port
EXPOSE 7860

# Set the working directory
WORKDIR /app
# Copy requirements file
COPY requirements.txt requirements.txt
# Create a virtual environment
RUN python -m venv venv

# Set the PATH to use the virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Update package list and install necessary packages in a single step
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libffi-dev \
    cmake \
    libcurl4-openssl-dev \
    tini \
    systemd && \
    apt-get clean

# Upgrade pip and install dependencies
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh


RUN which ollama
# Expose the port the application uses (replace 11434 with the actual port)
EXPOSE 11434

# Copy the entire application
COPY . .

# Set proper permissions for the translations directory
RUN chmod -R 777 translations


# Copy the init script
COPY init.sh /app/init.sh
RUN chmod +x /app/init.sh

# Set the entry point script as the default command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["ollama", "serve"]

