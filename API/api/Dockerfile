FROM python:latest

RUN apt update -y && apt upgrade -y

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV ELASTIC 172.18.0.3
COPY ./app .

CMD ["python", "worker.py"]
