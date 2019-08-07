from flask import Flask
from flask import render_template
from flask import request

app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def calculation():
    result = 0
    error = ''
    # you may want to customize your GET... in this case not applicable
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
    return render_template('main.html', result=result, error=error)

if __name__ == "__main__":
    app.run()
