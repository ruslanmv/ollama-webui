#!/bin/bash
# Run additional commands from your Dockerfile
(curl -fsSL https://ollama.com/install.sh | sh && ollama serve > ollama.log 2>&1) &
# Keep the container running by running a dummy command
# Start ollama
ollama serve &
sleep 2
ollama list
ollama pull nomic-embed-text
ollama pull llama3:8b