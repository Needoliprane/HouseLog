#!/usr/bin/env python
# -*- coding: utf-8 -*-

##
## EPITECH PROJECT, 2020
## WorshopHub
## File description:
## worker
##

import json
import os
import requests
import random
import sys

from flask import Flask, request, jsonify, Response, Blueprint
from flask_cors import CORS, cross_origin

ELASTIC = os.environ['ELASTIC']
APP = Flask(__name__)
CORS(APP)

from view.add_door import app as add_door
from view.add_user import app as add_user
from view.check_doors import app as check_doors
from view.connection import app as connection
from view.update_door import app as update_door

APP.register_blueprint(update_door)
APP.register_blueprint(connection)
APP.register_blueprint(check_doors)
APP.register_blueprint(add_door)
APP.register_blueprint(add_user)


@APP.route('/ping', methods=['GET'])
@cross_origin()
def ping():
    return Response("pong",mimetype='text/html')

def initTable():
    try:
        requests.put("http://" + ELASTIC + ":9200/users")
        requests.put("http://" + ELASTIC + ":9200/doors")
    except:
        pass

if __name__ == "__main__":

    initTable()
    print("API start")
    try :
        APP.run(host="0.0.0.0", port=80, debug=True)
    except Exception as e:
        print(str(e))
        pass
