#!/bin/bash

# Source the virtual environment
source /app/venv/bin/activate

# Starting server
echo "Starting Ollama server"
ollama serve &
sleep 1

# Try to get the model environment variable
if [ -n "${MODEL}" ]; then
  # Split the MODEL variable into an array
  IFS=',' read -ra MODELS <<< "${MODEL}"
else
  # Use the default list of models
  MODELS=(phi3 mistral llama3 gemma:2b)
fi


# Splitting the models by comma and pulling each
#IFS=',' read -ra MODELS <<< "$model"
for m in "${MODELS[@]}"; do
    echo "Pulling $m"
    ollama pull "$m"
    sleep 5
done


# Run the Python application
exec python ./run.py

# Keep the script running to prevent the container from exiting
#wait
