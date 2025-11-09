FROM python:3.11-slim

# Install curl (needed for testing inside container)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Install system deps (if any) and python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY . .

# Expose port and run via gunicorn for production-like behavior
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "2", "--timeout", "120"]
