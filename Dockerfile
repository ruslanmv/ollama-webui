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
# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh && ollama serve
RUN mkdir -p /.ollama && chmod 777 /.ollama
WORKDIR /.ollama
RUN which ollama
# Expose the port the application uses (replace 11434 with the actual port)
EXPOSE 11434
# Copy the entire application
COPY . .
# Set proper permissions for the translations directory
RUN chmod -R 777 translations
# Define the command to run the application
CMD ["python", "./run.py"]

