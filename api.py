from flask import Flask, request, jsonify
import subprocess
import json
import os
import tempfile
import uuid
import shutil

app = Flask(__name__)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'pdf', 'docx'}


@app.route('/run_bot', methods=['POST'])
def run_bot():
    """
    Endpoint to trigger the background job application bot.
    Receives configuration variables as a JSON payload in the request body.
    """
    try:
        user_config = request.get_json()
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
                config_string = json.dumps(user_config)
                command = ['python', '/Users/useradmin/Desktop/AutoJobsApply/Linkedin/runAiBot.py', config_string]

                        # Start the runaibot.py script in the background.  Consider using a process pool for better management.
                subprocess.Popen(command)

                return jsonify({"message": "Job application bot started in the background..."}), 200
        # else:
        #     return jsonify({"error": "Invalid resume file type"}), 400

    except Exception as e:
        return jsonify({"error": f"Failed to start the bot: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0",debug=True, port=8000)
