# Use the Selenium standalone Chrome image as the base
FROM selenium/standalone-chrome:latest

# Switch to root to install dependencies
USER root

# Install x11vnc.
RUN apt-get install -y x11vnc

# Install xvfb.
RUN apt-get install -y xvfb

# Install fluxbox.
RUN apt-get install -y fluxbox

# Install wget.
RUN apt-get install -y wget



# Install Python, pip, venv, and Xvfb for headless display
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    xserver-xephyr\
    xvfb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create the application directory and adjust permissions
RUN mkdir -p /app && chown seluser:seluser /app

# Switch back to the default non-root user
USER seluser
WORKDIR /app

# Create a virtual environment
RUN python3 -m venv /app/venv

# Copy requirements file and install Python dependencies
COPY requirements.txt .
RUN /app/venv/bin/pip install --no-cache-dir -r /app/requirements.txt

# Update PATH to use the virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Copy the application code
COPY . .

# Expose the port for Flask or any other web server
EXPOSE 8000
 

# Start Xvfb and the application
ENTRYPOINT ["python3"]
CMD ["api.py"]
