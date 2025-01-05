FROM selenium/standalone-chrome:latest

USER root

# Install Python3, pip, venv, Xvfb, and additional dependencies
RUN apt-get update && apt-get install -y \
    python3-pip python3-venv xvfb build-essential libffi-dev python3-dev libpq-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set Python-related environment variables
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:99

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

# Ensure correct permissions for Xvfb
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Change ownership of /app and venv to seluser
RUN chown -R seluser:seluser /opt/venv /app

# Switch to seluser
USER seluser

# Run Xvfb and the Python script
CMD ["sh", "-c", "Xvfb :99 -ac & python3 -u api.py"]
