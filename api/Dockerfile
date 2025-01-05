# Use Python 3.9-slim as the base image
FROM python:3.9-slim

# Run commands as root
USER root

# Install Python3, pip, Xvfb, and necessary system dependencies
RUN apt-get update && \
    apt-get install -y \
    python3-pip \
    xvfb \
    build-essential \
    libffi-dev \
    python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python-related environment variables
ENV PYTHONUNBUFFERED=1 \
    DISPLAY=:99

# Create a virtual environment and add it to the PATH
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set the working directory to /app
WORKDIR /app

# Copy requirements.txt first to leverage Docker cache
COPY api/requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create a non-root user 'seluser' and give access to necessary directories
RUN groupadd -r seluser && \
    useradd -r -g seluser seluser && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chown -R seluser:seluser /opt/venv /app

# Switch to non-root user
USER seluser

# Expose the port the Flask app runs on
EXPOSE 8000

# Start Xvfb and the Flask application
CMD ["sh", "-c", "Xvfb :99 -ac & exec python3 -u api/flask_api.py"]
