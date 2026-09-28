FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DEMO_MODE=true \
    VISION_ENABLED=false

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends libglib2.0-0 libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN mkdir -p /app/data/alerts /app/data/snapshots /app/logs

EXPOSE 10000

CMD ["sh", "-c", "exec gunicorn app.main:app --worker-class uvicorn.workers.UvicornWorker --workers 1 --bind 0.0.0.0:${PORT:-10000}"]