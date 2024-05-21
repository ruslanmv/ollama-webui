#!/bin/bash

# Source the virtual environment
source /app/venv/bin/activate

# Starting server
echo "Starting Ollama server"
ollama serve &
sleep 1

# Splitting the models by comma and pulling each
IFS=',' read -ra MODELS <<< "$model"
for m in "${MODELS[@]}"; do
    echo "Pulling $m"
    ollama pull "$m"
    sleep 5
done


# Run the Python application
exec python ./run.py

# Keep the script running to prevent the container from exiting
#wait
