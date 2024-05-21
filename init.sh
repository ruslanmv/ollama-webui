#!/bin/bash
which ollama
echo "🔴 Retrieve LLAMA3 model..."
ollama pull llama3
echo "🟢 Done!"
# Wait for Ollama process to finish.
wait $pid
# Start the Python application
echo "Starting Python application..."
python ./run.py


