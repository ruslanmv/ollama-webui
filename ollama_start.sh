#!/bin/bash

# Execute the start.sh script from the base image (assuming it's in /path/to/start.sh)
./start.sh &

# Run additional commands from your Dockerfile
(curl -fsSL https://ollama.com/install.sh | sh && ollama serve > ollama.log 2>&1) &

# Keep the container running by running a dummy command
ollama serve