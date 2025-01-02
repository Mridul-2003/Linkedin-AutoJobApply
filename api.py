from flask import Flask, request, jsonify
from flask_cors import CORS
import subprocess
import json
import os
import tempfile
import uuid
import shutil

app = Flask(__name__)
CORS(app)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'pdf', 'docx'}


@app.route('/run_bot', methods=['POST'])
def run_bot():
    """
    Endpoint to trigger the background job application bot.
    Receives configuration variables as a JSON payload in the request body.
    """
    try:
        config_string = request.form.get('config')
        if not config_string:
            return jsonify({"error": "No config parameter provided in form data"}), 400
        print("Received config string:", config_string)
        try:
            user_config = json.loads(config_string)
        except json.JSONDecodeError:
            return jsonify({"error": "Invalid JSON format in config parameter"}), 400
            
        required_keys = {
            "first_name", "last_name", "phone_number", "current_city", "state", "zipcode", "country",
            "search_terms"
        }
        missing_keys = required_keys - set(user_config.keys())
        if missing_keys:
            error_message = f"Error: Missing required keys in configuration: {missing_keys}"
            print(error_message)
            return jsonify({"error": error_message}), 400

        if 'resume_pdf' not in request.files:
            return jsonify({"error": "No resume file part"}), 400
        resume_file = request.files['resume_pdf']
        if resume_file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        if resume_file and allowed_file(resume_file.filename):
            with tempfile.TemporaryDirectory() as temp_dir:  # Create a temporary directory
                temp_filename = os.path.join(temp_dir, f"{uuid.uuid4()}-{resume_file.filename}")
                resume_file.save(temp_filename)
                user_config['resume_path'] = temp_filename

                # Construct the command to execute runaibot.py
                
                command = ['python', 'runAiBot.py', json.dumps(user_config)]

                        # Start the runaibot.py script in the background.  Consider using a process pool for better management.
                subprocess.Popen(command)

                return jsonify({"message": "Job application bot started in the background..."}), 200
        # else:
        #     return jsonify({"error": "Invalid resume file type"}), 400

    except Exception as e:
        return jsonify({"error": f"Failed to start the bot: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0",debug=True, port=56581)
