#!flask/bin/python
from flask import Flask
import sqlite3

app = Flask(__name__)

def getStatusFromDB():
	db_name="/home/pi/Desktop/database/test_status.db"
	try:
		conn = sqlite3.connect(db_name)
		print ("Opened database successfully for SELECT")
	except sqlite3.Error as er:
		print("Some error occured in SELECT:\n", er)
	
	try:	
		cursor = conn.execute("SELECT * FROM status")
		for row in cursor:
			print ("ID = ", row[0])
			print ("VALUE = ", row[1])
		print ("SELECT operation done successfully\n")		
		return row[1]
	except sqlite3.Error as er:
		print("Some error occured in SELECT:\n", er)
	finally:
		conn.close()
	return 0

# trebuie vazut eventual da-l drq
#@app.route('/status', methods=['GET'])
#def get_status():
 #   return jsonify(str(getStatusFromDB()))

@app.route('/')
def index():
	#print(str(getStatusFromDB()))
	return (str(getStatusFromDB()))

if __name__ == '__main__':
	app.run(host='0.0.0.0')