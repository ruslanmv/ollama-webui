FROM python:3.10-slim-buster

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

# Install additional software
RUN curl -fsSL https://ollama.com/install.sh | sh



# Copy the entire application
COPY . .

# Set proper permissions for the translations directory
RUN chmod -R 777 translations

# Start Ollama service 
RUN systemctl start ollama  

# Download the required model
RUN ollama pull llama3
# Define the command to run the application
CMD ["python", "./run.py"]
