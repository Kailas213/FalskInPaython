from flask import Flask, request, render_template,redirect,redirect, url_for, flash
from dotenv import load_dotenv
import requests
import os

load_dotenv()

Backend_URI = os.getenv("Backend_URI")

formApp = Flask(__name__)

@formApp.route('/')
def Home():
    print("Home Page")
    return render_template('users.html');


@formApp.route('/form_submit', methods=['POST'])
def form_submit():
    form_data = dict(request.form)

    response =requests.post(Backend_URI+'/form_submit',json=form_data)
    print(response)
    if response.status_code == 200:
        # Redirect to success page
        return redirect(url_for('success'))
    else:
        # Show error without redirect
        flash(f"Error: {response.text}")
        return redirect(url_for('Home'))

@formApp.route('/success')
def success():
    return "Data submitted successfully"

if __name__== '__main__':
    formApp.run(host='0.0.0.0',port=9000,debug=True);
