# Project Setup Instructions

Follow the steps below to set up and run the project:

### Prerequisites
- Ensure **Python 3.6+** is installed.
- Install **pip** and **virtualenv** if not already available.

### Setup and Run

```bash
# Clone the repository and navigate to the project directory
git clone <repository-url>
cd api

# Create a virtual environment
python3 -m venv <env_name>

# Activate the virtual environment
# On macOS/Linux
source <env_name>/bin/activate
# On Windows
<env_name>\Scripts\activate

# Install project dependencies
pip install -r requirements.txt

# Run the Flask API
python flask_api.py
