#!/bin/bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama in the background.
ollama serve &
# Record Process ID.
pid=$!

# Pause for Ollama to start.
sleep 5

echo "🔴 Retrieve LLAMA3 model..."
ollama pull llama3
echo "🟢 Done!"
# Wait for Ollama process to finish.
wait $pid
# Start the Python application
echo "Starting Python application..."
python ./run.py


