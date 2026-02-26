FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app/calculator.py .

EXPOSE 80

CMD ["python", "calculator.py"]
