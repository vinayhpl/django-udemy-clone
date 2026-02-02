
# ===============================
# Stage 1: Build Stage
# ===============================
FROM python:3.11-slim AS build

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential gcc libffi-dev git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements and install Python packages into /install
COPY requirements.txt .
RUN python -m pip install --upgrade pip
#RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
# Copy project code
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# ===============================
# Stage 2: Runtime Stage
# ===============================
FROM python:3.11-slim AS runtime

WORKDIR /app

# Create non-root user
RUN useradd -m -d /app -s /bin/bash vinay && chown -R vinay:vinay /app

# Switch to non-root user
USER vinay

# Copy installed Python packages from build stage
#COPY --from=build /install /usr/local
COPY --from=build /usr/local /usr/local

# Copy app code from build stage
COPY --from=build /app /app

# Expose port
EXPOSE 8000

# Environment variables
ENV DJANGO_SETTINGS_MODULE=udemyclone.settings
ENV PYTHONUNBUFFERED=1

# Run Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "udemyclone.wsgi:application", "--workers=4", "--threads=2"]
