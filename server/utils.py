import subprocess
def check_model_exists(model_name):
    try:
        # List available models
        output = subprocess.check_output("ollama list", shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        available_models = [line.split()[0] for line in output.strip().split('\n')[1:]]
        return any(model_name in model for model in available_models)
    except subprocess.CalledProcessError as e:
        print(f"Error checking models: {e.output}")
        return False
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")
        return False
    
    
def download_model(model_name):
    remote_models=['llama3',
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
    'solar']
    if model_name in remote_models:
        try:
            # Download the model
            print(f"Downloading model '{model_name}'...")
            subprocess.check_call(f"ollama pull {model_name}", shell=True)
            print(f"Model '{model_name}' downloaded successfully.")
        except subprocess.CalledProcessError as e:
            print(f"Error downloading model: {e.output}")
            raise e
        except Exception as e:
            print(f"An unexpected error occurred: {str(e)}")
            raise e
    else:
        print("Not supported model currently")


def check_model(model_name):
    if not check_model_exists(model_name):
            try:
                download_model(model_name)
            except Exception as e:
                print(f"Failed to download model '{model_name}': {e}")
                return
    else:
        print("OK")