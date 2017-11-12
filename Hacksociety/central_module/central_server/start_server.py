#!flask/bin/python
from flask import Flask
import urllib.request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def requestStatusFromPi(uri):
	return urllib.request.urlopen(uri).read()

def parseAllPis():
	addressList = ["http://10.5.4.196:5000"]
	allStatuses = ""
	
	for address in addressList:
		allStatuses += str(int(requestStatusFromPi(address)))

	return allStatuses

@app.route('/')
def index():
	return (parseAllPis())

if __name__ == '__main__':
	app.run(host='0.0.0.0')