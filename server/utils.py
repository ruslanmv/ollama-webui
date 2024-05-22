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



def make_simple_prompt(input, messages):
    """
    Create a simple prompt based on the input and messages.
    
    :param input: str, input message from the user
    :param messages: list, conversation history as a list of dictionaries containing 'role' and 'content'
    :return: str, generated prompt
    """
    if len(messages) == 1:
        prompt = f'''You are a friendly AI companion.
You should answer what the user request.
user: {input}'''
    else:
        conversation_history = '\n'.join(
            f"{message['role']}: {message['content']}" for message in reversed(messages[:-1])
        )
        prompt = f'''You are a friendly AI companion.
history: {conversation_history}.
You should answer what the user request.
user: {input}'''

    print(prompt)
    return prompt


def make_prompt(input, messages, model):
    """
    Create a prompt based on the input, messages, and model used.
    
    :param input: str, input message from the user
    :param messages: list, conversation history as a list of dictionaries containing 'role' and 'content'
    :param model: str, name of the model ("llama3", "mistral", or other)
    :return: str, generated prompt
    """
    if model == "llama3":
        # Special Tokens used with Meta Llama 3
        BEGIN_OF_TEXT = "<|begin_of_text|>"
        EOT_ID = "<|eot_id|>"
        START_HEADER_ID = "<|start_header_id|>"
        END_HEADER_ID = "<|end_header_id|>"
    elif model == "mistral":
        # Special tokens Mistral
        BEGIN_OF_TEXT = "<s>"
        EOT_ID = "</s>"
        START_HEADER_ID = ""  # Not applicable to Mistral
        END_HEADER_ID = ""  # Not applicable to Mistral
    else:
        # No Special tokens
        BEGIN_OF_TEXT = ""
        EOT_ID = ""
        START_HEADER_ID = ""
        END_HEADER_ID = ""

    if len(messages) == 1:
        prompt = f'''{BEGIN_OF_TEXT}{START_HEADER_ID}system{END_HEADER_ID}
You are a friendly AI companion.
{EOT_ID}{START_HEADER_ID}user{END_HEADER_ID}
{input}
{EOT_ID}'''
    else:
        conversation_history = '\n'.join(
            f"{START_HEADER_ID}{message['role']}{END_HEADER_ID}\n{message['content']}{EOT_ID}" for message in reversed(messages[:-1])
        )
        prompt = f'''{BEGIN_OF_TEXT}{START_HEADER_ID}system{END_HEADER_ID}
You are a friendly AI companion.
history:
{conversation_history}
{EOT_ID}{START_HEADER_ID}user{END_HEADER_ID}
{input}
{EOT_ID}'''

    print(prompt)
    return prompt
