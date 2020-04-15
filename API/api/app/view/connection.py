##
## EPITECH PROJECT, 2020
## API
## File description:
## connection
##


import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC  = os.environ['ELASTIC']
app = Blueprint('connection', __name__, url_prefix='/connection')


#--------------------------------------------------------------------------------------- connection
#-------------------------------------------------------------- Json to send
"""
{
    "username" : "blabla",
    "password" : "blabla",
}
"""
#-------------------------------------------------------------- Json to send

#-------------------------------------------------------------- Json answer
"""
{
    "status" : "ok"
}
"""
#-------------------------------------------------------------- Json answer

#-------------------------------------------------------------- connection
@app.route('/connection', methods = ['POST'])
@cross_origin()
def connexion():
    get = request.get_json()
    password = get["password"]
    username = get["username"]

    res = requests.post("http://" + ELASTIC + ":9200/users/_search")
    elemList = res["hits"]["hits"]
    for elem in elemList:
        if elem["username"] == username and elem["password"] == password:
            return ({"status" : "ok"})
    return ({"status" : "error"})
#-------------------------------------------------------------- connection
#--------------------------------------------------------------------------------------- connection