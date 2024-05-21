#!/bin/bash
# Starting server
echo "Starting server"
ollama serve &
sleep 1
ollama pull llama3
python run.py

