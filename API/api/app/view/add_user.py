##
## EPITECH PROJECT, 2020
## API
## File description:
## add_user
##


import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC  = os.environ['ELASTIC']
app = Blueprint('add_user', __name__, url_prefix='/add_user')


#--------------------------------------------------------------------------------------- add_user
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
    "ReqStatus" : "ok"
}
"""
#-------------------------------------------------------------- Json answer

#-------------------------------------------------------------- add_user
@app.route('/add_user', methods = ['POST'])
@cross_origin()
def add_user():
    get = request.get_json()

    res = requests.post("http://" + ELASTIC + ":9200/users/_doc/", json=get)
    print(res.status_code, file=sys.stderr)
    print(res.text, file=sys.stderr)
    if (res.status_code == 200 or res.status_code == 201):
        return ({"ReqStatus" : "ok"})
    return ({"ReqStatus" : "error"})
#-------------------------------------------------------------- add_user
#--------------------------------------------------------------------------------------- add_user