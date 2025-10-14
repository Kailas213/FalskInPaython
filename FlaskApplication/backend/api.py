from flask import Flask, request
from dotenv import load_dotenv
import pymongo
from pymongo import MongoClient
import certifi
from flask_cors import CORS
import os

load_dotenv()

Mongo_URI = os.getenv("MONGO_URI")  

client = MongoClient(Mongo_URI, tlsCAFile=certifi.where())

db=client['sample_mflix']

collection=db['myCollection']

api = Flask(__name__)
CORS(api) 

@api.route('/api')
def home():
    collectiondata=collection.find({}, {'_id': 0})  # Exclude the _id field for cleaner output
   
    data=list(collectiondata)
    print(data)
    data={"data":data}

    return data


@api.route('/add_user', methods=['POST'])
def add_user(): 
    form_data = dict(request.json)
    client = MongoClient(Mongo_URI, tlsCAFile=certifi.where())
    print(form_data) 
    db = client["sample_mflix"]
    collection = db["myCollection"]   
    collection.insert_one(form_data)


    collectiondata=collection.find({}, {'_id': 0})  # Exclude the _id field for cleaner output
   
    data=list(collectiondata)
    print(data)
    data={"data":data}



    return data



if __name__== '__main__':
    api.run(host='0.0.0.0', port=8000, debug=True);


