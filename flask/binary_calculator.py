from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def calculation():
    result = 0
    error = ''
    commit = open("HEAD","r").read()
    if request.method=='POST':
        first = request.form['first']
        second = request.form['second']
        action = request.form['action']
        if first and second:
            try:
                for x in first + second:
                    if x != "0" and x != "1":
                        raise ValueError
                if action == "+":       
                    result = bin(int(first, 2) + int(second, 2))[2:]
                elif action == "-": 
                    result = bin(int(first, 2) - int(second, 2))[2:]
            except ValueError:
                error = 'Please use binary input only.'
    return render_template('main.html', result=result, error=error, commit=commit)

if __name__ == "__main__":
    app.run()
