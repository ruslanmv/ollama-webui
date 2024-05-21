FROM python:3.10-slim-buster  
WORKDIR /app  
COPY requirements.txt requirements.txt  
RUN python -m venv venv  
ENV PATH="/app/venv/bin:$PATH"  
RUN apt-get update 
RUN apt-get install -y curl
RUN apt-get install -y --no-install-recommends build-essential libffi-dev cmake libcurl4-openssl-dev && 
RUN apt-get clean 
RUN python3 -m pip install --upgrade pip 
RUN pip3 install --no-cache-dir -r requirements.txt 
RUN curl -fsSL https://ollama.com/install.sh | sh
COPY . .
RUN chmod -R 777 translations
CMD ["python3", "./run.py"]