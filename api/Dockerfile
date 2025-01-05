FROM python:3.9-slim

USER root

# install Python3, pip, venv, and Xvfb
RUN apt-get update && apt-get install -y python3-pip python3-venv xvfb build-essential libffi-dev python3-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

# set Python-related environment variables
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:99

# create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# set up the working directory
WORKDIR /app


# Create and activate a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set up the working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY api/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /app/requirements.txt

# Copy the application code
COPY . /app

# Create the 'seluser' group and user
RUN groupadd -r seluser && useradd -r -g seluser seluser

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
# Change ownership of /app and venv to seluser
RUN chown -R seluser:seluser /opt/venv /app

# Switch to seluser
USER seluser
# Expose port for Flask API
EXPOSE 5000
# Run Python script
CMD ["sh", "-c", "Xvfb :99 -ac 2>/dev/null & python3 -u api/flask_api.py"]
