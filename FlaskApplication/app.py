from flask import Flask, request, render_template;
from datetime import datetime;

app=Flask(__name__)
@app.route('/')
def Home():
    da = datetime.today().strftime("%A");
    return render_template('index.html', day=da);

@app.route('/about')
def About():
    return "About Page </br> This is a simple Flask application.";

@app.route('/api/<name>')
def Api(name):
    
    length=len(name)

    if length > 5:
        return f'Hello {name},<br/> The name is long.'
    else:
        return f"Hello {name}, Nice name"
    
@app.route('/app/oprations/<int:num1>/<int:num2>/<operation>')
def Operations(num1, num2, operation):
    if operation == 'add':
        result = num1 + num2  
    elif operation == 'subtract':
        result = num1 - num2    
    elif operation == 'multiply': 
        result = num1 * num2
    elif operation == 'divide':
        if num2 != 0:
            result = num1 / num2
        else:
            return "Error: Division by zero is not allowed."
    else:
        return "Error: Invalid operation. Use add, subtract, multiply, or divide."  
    return str(result);

@app.route('/app/request')
def Request():
    name=request.values.get('name');
    age=request.values.get('age');
    age=int(age) 
    if age>18:
        return f"Hello {name}, you are an adult.";
    elif age is not None:
        return f"Hello {name}, you are a minor.";   
    
    return "This is a request page. You can add more functionality here.";

if __name__== '__main__':
    app.run(debug=True);

