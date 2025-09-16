# Use Python base image
FROM python:3.13-slim

# Set working directory inside container
WORKDIR /app

# Prevents Python from writing .pyc files & buffers logs
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies for psycopg2 and Pillow
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    musl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy Django project files
COPY . /app/

# Expose Django port
EXPOSE 8000

# Default command (can be overridden in docker-compose.yml)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
