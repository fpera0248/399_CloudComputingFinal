from flask import Flask, send_from_directory, render_template

app = Flask(__name__)

# serve the application on the root path
@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)