FROM python:3.10-slim-buster  
WORKDIR /app  
COPY requirements.txt requirements.txt  
RUN python -m venv venv  
ENV PATH="/app/venv/bin:$PATH"  
RUN apt-get update && \
apt-get clean && \  
apt-get install -y --no-install-recommends build-essential libffi-dev cmake libcurl4-openssl-dev && \
python3 -m pip install --upgrade pip && \
pip3 install --no-cache-dir -r requirements.txt  && \
curl -fsSL https://ollama.com/install.sh | sh
COPY . .  
RUN chmod -R 777 translations  
CMD ["python3", "./run.py"]  