from flask import Flask
app = Flask(__name__)

@app.route('/')
def index():
    return "Hello from CI/CD demo!"

if __name__ == '__main__':
    # for local debug only; in Docker we'll run via gunicorn
    app.run(host='0.0.0.0', port=5000, debug=True)
