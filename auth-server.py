import os
from flask import Flask, request

app = Flask(__name__)
 
STREAM_KEY = os.getenv("STREAM_KEY")

@app.route('/auth', methods=['GET', 'POST'])
def auth():
    name = request.args.get('name') or request.form.get('name')
    print(f' - - - - - Checking ${name} against ${STREAM_KEY}')
    if name == STREAM_KEY:
        return "", 200
    else:
        return "", 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
