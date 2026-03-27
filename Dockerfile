# Multi stage - Non ROOT user docker build 

FROM python:3.11-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /install

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libffi-dev \
    libssl-dev \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel

RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app
COPY . .

# Run collectstatic
RUN python manage.py collectstatic --noinput

FROM python:3.11-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONOTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=udemyclone.settings

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create vinay user
RUN useradd -m -d /app -s /bin/bash vinay \
    && chown -R vinay:vinay /app

USER vinay
COPY --from=builder /usr/local /usr/local

COPY --from=builder /app /app

EXPOSE 8000

CMD ["gunicorn", "udemyclone.wsgi:application", "--bind", "0.0.0.0:8000", "--workers=4", "--threads=2"]

