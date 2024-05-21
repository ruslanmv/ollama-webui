import secrets

from server.bp import bp
from server.website import Website
from server.backend import Backend_Api
from server.babel import create_babel
from json import load
from flask import Flask
import ollama

# Optionally specify the model to pull during startup:
model_name = "llama3"  # Replace with the desired model name
import os
import subprocess
# List of allowed models
ALLOWED_MODELS = [
    'llama3',
    'llama3:70b',
    'phi3',
    'mistral',
    'neural-chat',
    'starling-lm',
    'codellama',
    'llama2-uncensored',
    'llava',
    'gemma:2b',
    'gemma:7b',
    'solar',
]

# Directory where models are stored (current directory)
MODEL_DIR = os.getcwd()

def is_model_downloaded(model_name):
    """Check if the model is already downloaded."""
    model_path = os.path.join(MODEL_DIR, model_name.replace(':', '_'))
    return os.path.exists(model_path)

def download_model(model_name):
    """Download the model using the ollama command."""
    if model_name in ALLOWED_MODELS:
        if not is_model_downloaded(model_name):
            print(f"Downloading model: {model_name}")
            subprocess.run(['ollama', 'pull', model_name], check=True)
            print(f"Model {model_name} downloaded successfully.")
        else:
            print(f"Model {model_name} is already downloaded.")
    else:
        print(f"Model {model_name} is not in the list of allowed models.")

if __name__ == '__main__':
    import os
    #os.system(" ollama serve")
    # Start Ollama in server mode:
    ollama.pull=model_name
    # Load configuration from config.json
    config = load(open('config.json', 'r'))
    site_config = config['site_config']
    url_prefix = config.pop('url_prefix')

    # Create the app
    app = Flask(__name__)
    app.secret_key = secrets.token_hex(16)

    # Set up Babel
    create_babel(app)

    # Set up the website routes
    site = Website(bp, url_prefix)
    for route in site.routes:
        bp.add_url_rule(
            route,
            view_func=site.routes[route]['function'],
            methods=site.routes[route]['methods'],
        )

    # Set up the backend API routes
    backend_api = Backend_Api(bp, config)
    for route in backend_api.routes:
        bp.add_url_rule(
            route,
            view_func=backend_api.routes[route]['function'],
            methods=backend_api.routes[route]['methods'],
        )

    # Register the blueprint
    app.register_blueprint(bp, url_prefix=url_prefix)

    # Run the Flask server
    print(f"Running on {site_config['port']}{url_prefix}")
    app.run(**site_config)
    print(f"Closing port {site_config['port']}")