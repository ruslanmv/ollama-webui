#!/bin/bash
# Starting server
echo "Starting Ollama server..."
ollama serve &

# Wait for the Ollama server to be ready
echo "Waiting for Ollama server to be ready..."
until curl -sSf http://localhost:11434/api/status > /dev/null; do
    echo "Waiting for Ollama server to start..."
    sleep 2
done

echo "Ollama server is ready."

# Pull the required model
echo "Pulling llama3 model..."
ollama pull llama3

# Start the web UI
echo "Starting web UI..."
python run.py
