##
## EPITECH PROJECT, 2020
## API
## File description:
## check_doors
##

import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC  = os.environ['ELASTIC']
app = Blueprint('check_doors', __name__, url_prefix='/check_doors')


#--------------------------------------------------------------------------------------- check_door
#-------------------------------------------------------------- Json to send
"""
{
    "username" : "username",
    "name" : "blabla"
}
"""
#-------------------------------------------------------------- Json to send

#-------------------------------------------------------------- Json answer
"""
good
{
    "status" : "ok",
    "username" : "blabal"
    "name" : "main1",
    "position" : "main1",
    "status" : "open1",
    "ReqStatus" : "ok"
}

error
{
    "ReqStatus" : "error"
}
"""
#-------------------------------------------------------------- Json answer

#-------------------------------------------------------------- check_door
@app.route('/check_door', methods = ['GET'])
@cross_origin()
def check_door():
    get = request.get_json()
    name = get["name"]
    username = get["username"]

    res = requests.post("http://" + ELASTIC + ":9200/doors/_search")
    if (res.status_code != 200):
        return ({"ReqStatus" : "error"})
    res = json.loads(res.text)
    elemList = res["hits"]["hits"]
    for elem in elemList:
        elem = elem["_source"]
        if elem["username"] == username and elem["name"] == name:
            elem["ReqStatus"] = "ok"
            return (elem)
    return ({"ReqStatus" : "error"})

#-------------------------------------------------------------- check_door
#--------------------------------------------------------------------------------------- check_door

#--------------------------------------------------------------------------------------- check_doors
#-------------------------------------------------------------- Json to send
"""
{
    "username" : "username",
}
"""
#-------------------------------------------------------------- Json to send

#-------------------------------------------------------------- Json answer
"""
good
{
    "data": [
        {
            "status" : "ok",
            "username" : "blabal"
            "name" : "main1",
            "position" : "main1",
            "status" : "open1"
        },....
    ]
}

error
{
    "ReqStatus" : "error"
}
"""
#-------------------------------------------------------------- Json answer

#-------------------------------------------------------------- check_doors
@app.route('/check_doors', methods = ['GET'])
@cross_origin()
def check_doors():
    get = request.get_json()
    username = get["username"]
    listReturn = []

    res = requests.post("http://" + ELASTIC + ":9200/doors/_search")
    if (res.status_code != 200):
        return ({"ReqStatus" : "error"})
    res = json.loads(res.text)
    elemList = res["hits"]["hits"]
    for elem in elemList:
        elem = elem["_source"]
        if elem["username"] == username:
            elem["ReqStatus"] = "ok"
            listReturn.append(elem)
    if (listReturn == []):
        return ({"ReqStatus" : "error"})
    return ({"data" : listReturn})

#-------------------------------------------------------------- check_doors
#--------------------------------------------------------------------------------------- check_doors