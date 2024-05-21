FROM python:3.10-slim-buster

RUN apt update &&  apt install curl -y
RUN curl -fsSL https://ollama.com/install.sh | sh
ENV OLLAMA_HOST=0.0.0.0
RUN useradd -m app && chown -R app:app /home/app
# Create the directory and give appropriate permissions
RUN mkdir -p /home/app/.ollama && chmod 777 /home/app/.ollama
#RUN mkdir -p /home/app/.ollama/models && 
USER app
WORKDIR /home/app/.ollama
#Copy dossier de models
#COPY --chown=app models /.ollama
#RUN chmod 777 /home/app/.ollama/models
# Copy the entry point script
COPY --chown=app entrypoint.sh /entrypoint.sh
RUN chmod +x /start.sh
# Set the entry point script as the default command
CMD ["/start.sh"]
#ENV OLLAMA_MODELS="/home/app/.ollama/models"
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

# Define the command to run the init script
CMD ["/bin/bash", "/app/init.sh"]
