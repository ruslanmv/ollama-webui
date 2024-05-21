FROM python:3.10-slim-buster
FROM python:3.10-slim-buster

# Install curl
RUN apt-get update && apt-get install -y curl
# Install ollama
RUN curl -fsSL https://ollama.com/install.sh | sh
# Set environment variable
ENV OLLAMA_HOST=0.0.0.0
# Create the directory and set permissions
RUN mkdir -p /app/.ollama && chmod 777 /app/.ollama
# Create a new user and group
RUN groupadd -r app && useradd -r -g app app
# Change ownership of the directory
RUN chown -R app:app /app/.ollama
# Switch to the new user
USER app
# Set working directory
WORKDIR /app/.ollama
# Copy models directory (uncomment if you have a models directory to copy)
# COPY --chown=app:app models /app/.ollama
# Ensure the models directory exists before changing permissions
RUN mkdir -p /app/.ollama/models && chmod 777 /app/.ollama/models
# Copy the entry point script
COPY start.sh /app/start.sh
# Make the entry point script executable
RUN chmod +x /app/start.sh
# Expose the server port
EXPOSE 7860
# Set the entry point script as the default command
CMD ["/app/start.sh"]
USER root 


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

# Define the command to run the init script
CMD ["/bin/bash", "/app/init.sh"]
