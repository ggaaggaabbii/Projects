#!/usr/bin/python

import sqlite3

db_name = "test_status.db"

def update_db(status_value):
	try:
		conn = sqlite3.connect(db_name)
		print ("Opened database successfully for UPDATE")
	except sqlite3.Error as er:
		print("Some error occured in UPDATE:\n", er)
	
	try:
		conn.execute("UPDATE status SET value=(?) WHERE id=1", str(status_value))
		conn.commit()
		print ("UPDATE operation done successfully\n")
	except sqlite3.Error as er:
		print("Some error occured in UPDATE:\n", er)
	finally:
		conn.close()

def select_db():
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

update_db(1)
select_db()