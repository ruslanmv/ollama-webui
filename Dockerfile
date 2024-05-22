FROM python:3.10-slim-buster

# Set the working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt requirements.txt

# Update package list and install necessary packages in a single step
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libffi-dev \
    cmake \
    libcurl4-openssl-dev \
    tini && \
    apt-get clean

# Upgrade pip and install dependencies
RUN python -m venv venv && \
    . /app/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Install Ollama
RUN curl https://ollama.ai/install.sh | sh

# Create the directory and give appropriate permissions
RUN mkdir -p /.ollama && chmod 777 /.ollama

# Ensure Ollama binary is in the PATH
ENV PATH="/app/venv/bin:/root/.ollama/bin:$PATH"

# Expose the server port
EXPOSE 7860
EXPOSE 11434

# Copy the entry point script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the model as an environment variable (this can be overridden)
ENV model="default_model"

# Copy the entire application
COPY . .

# Set proper permissions for the translations directory
RUN chmod -R 777 translations

# Copy the startup script and make it executable
#COPY start.sh .
#RUN chmod +x start.sh

# Define the command to run the application
# Set the entry point script as the default command
ENTRYPOINT ["/entrypoint.sh"]
