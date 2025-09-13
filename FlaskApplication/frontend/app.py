from flask import Flask, request, render_template
from datetime import datetime
import requests
import os
app = Flask(__name__)

Backend_URL = os.getenv("Backend_URI")

@app.route('/add_user', methods=['GET'])
def get_users():
    return render_template('users.html') 

@app.route('/add_user', methods=['POST'])
def add_user():
    form_data = dict(request.form)
   
    requests.post(Backend_URL+'/add_user',json=form_data)
    return "User added successfully!"

@app.route('/view_users')
def view_users():
    # client = MongoClient(uri, tlsCAFile=certifi.where())
    # db = client["sample_mflix"]
    # collection = db["myCollection"]   
    # users = list(collection.find({}, {'_id': 0}))  # Exclude the _id field for cleaner output
    users = [{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]  # Sample data
    data={"users":users}
    return data

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
    app.run(host='0.0.0.0',port=9000,debug=True);

