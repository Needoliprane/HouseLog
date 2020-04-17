##
## EPITECH PROJECT, 2020
## API
## File description:
## add_door
##

import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC  = os.environ['ELASTIC']
app = Blueprint('add_door', __name__, url_prefix='/add_door')


#--------------------------------------------------------------------------------------- add_door
#-------------------------------------------------------------- Json to send
"""
{
    "username" : "username",
    "name" : "blabla",
    "position" : "blabla",
    "status" : "blabla",
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

#-------------------------------------------------------------- add_door
@app.route('/add_door', methods = ['POST'])
@cross_origin()
def add_door():
    get = request.get_json()

    res = requests.post("http://" + ELASTIC + ":9200/doors/_doc/", json=get)
    print(res.status_code, file=sys.stderr)
    print(res.text, file=sys.stderr)
    if (res.status_code == 200 or res.status_code == 201):
        return ({"ReqStatus" : "ok"})
    return ({"ReqStatus" : "error"})
#-------------------------------------------------------------- add_door
#--------------------------------------------------------------------------------------- add_door