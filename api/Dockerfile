FROM python:3.9-slim

USER root

# Install Python3, pip, venv, and additional dependencies
RUN apt-get update && apt-get install -y \
    python3-pip python3-venv build-essential libffi-dev python3-dev libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Python-related environment variables
ENV PYTHONUNBUFFERED=1

# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set up the working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /app/requirements.txt

# Copy the application code
COPY . /app

# Create the 'seluser' group and user
RUN groupadd -r seluser && useradd -r -g seluser seluser

# Change ownership of /app and venv to seluser
RUN chown -R seluser:seluser /opt/venv /app

# Switch to seluser
USER seluser
# Expose port for Flask API
EXPOSE 5000
# Run Python script
CMD ["python3", "-u", "api/api.py"]
