from flask import Flask, request, render_template
from dotenv import load_dotenv
import pymongo
from pymongo import MongoClient  
import certifi  
import os
import requests

load_dotenv()



Mongo_URI = os.getenv("MONGO_URI")

client = MongoClient(Mongo_URI, tlsCAFile=certifi.where())
db=client['sample_mflix']
collection=db['myCollection']

formApi = Flask(__name__)


@formApi.route('/')
def home():
    collectiondata=collection.find({}, {'_id': 0})  # Exclude the _id field for cleaner output
   
    data=list(collectiondata)
    print(data)
    data={"data":data}

    return data


@formApi.route('/form_submit', methods=['POST'])
def form_user_add(): 
    form_data = dict(request.json)
    client = MongoClient(Mongo_URI, tlsCAFile=certifi.where())
    print(form_data) 
    db = client["sample_mflix"]
    collection = db["myCollection"]   
    collection.insert_one(form_data)
    return "User added successfully!"


if __name__== '__main__':
    formApi.run(host='0.0.0.0', port=8000, debug=True);
