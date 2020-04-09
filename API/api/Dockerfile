FROM python:latest

RUN apt update -y && apt upgrade -y

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV ELASTIC 172.21.0.2

COPY ./app .

CMD ["python", "worker.py"]
