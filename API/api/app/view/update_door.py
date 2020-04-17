##
## EPITECH PROJECT, 2020
## API
## File description:
## update_door
##

import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC  = os.environ['ELASTIC']
app = Blueprint('update_door', __name__, url_prefix='/update_door')


#--------------------------------------------------------------------------------------- update_door
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
    "status" : "ok"
}
"""
#-------------------------------------------------------------- Json answer

#-------------------------------------------------------------- update_door
@app.route('/update_door', methods = ['POST'])
@cross_origin()
def update_door():
    get = request.get_json()
    username = get["username"]
    position = get["position"]
    name = get["name"]

    res = requests.post("http://" + ELASTIC + ":9200/doors/_search")
    if (res.status_code != 200):
        return ({"ReqStatus" : "error"})
    res = json.loads(res.text)
    elemList = res["hits"]["hits"]
    for elem in elemList:
        _id = elem["_id"]
        elem = elem["_source"]
        if elem["username"] == username and elem["position"] == position and elem["name"] == name:
            requests.delete("http://" + ELASTIC + ":9200/doors/_doc/" + _id)
            requests.post("http://" + ELASTIC + ":9200/doors/_doc/", json=get)
            return ({"status" : "ok"})
    return ({"status" : "error"})
#-------------------------------------------------------------- update_door
#--------------------------------------------------------------------------------------- update_door