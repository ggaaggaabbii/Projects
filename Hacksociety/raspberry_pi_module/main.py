import RPi.GPIO as GPIO
import time
import sqlite3

def sendToDB(status_value):
	db_name="/home/pi/Desktop/database/test_status.db"
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


def main():
	GPIO.setwarnings(False)
	GPIO.setmode(GPIO.BOARD)
	GPIO.setup(11, GPIO.IN)         #Read output from PIR motion sensor
	GPIO.setup(3, GPIO.OUT)         #LED output pin
	
	motionHappened = 0
	lastMotionHappened = 0
	lastTime = int(time.time())
	lastTime2 = int(time.time())
	lastTime3 = int(time.time())
	deltaTime = 1
	deltaTime2 = 3
	deltaTime3 = 9
	Q = 6
	lastMH = 0
	myList = Q*[0]
	
	fobj = open("database/index.txt", "w")
	fobj.write("0")
	fobj.close()
	
	while True:
		if abs(int(time.time()) - lastTime) >= deltaTime:
			index = Q - 2
			while index >= 0:
				myList[index] = myList[index+1]
				index = index - 1
			myList[Q - 1] = motionHappened
			#lastMotionHappened = motionHappened
			motionHappened = 0
			lastTime = int(time.time())
		
		if abs(int(time.time()) - lastTime2) >=	deltaTime2:
			h = 0
			freq1 = 0
			while h < len(myList):
				if myList[h] == 1:
					freq1 = freq1 + 1
				h = h + 1
			if freq1 > 1:
				sendToDB(1)
			lastTime2 = int(time.time())	
		
		if abs(int(time.time()) - lastTime3) >= deltaTime3:
			if 1 not in myList:
				sendToDB(0)
			lastTime3 = int(time.time())

		i = GPIO.input(11)
		if i == 0:                 #When output from motion sensor is LOW
			#print "No intruders",i
			GPIO.output(3, 1)  #Turn OFF LED
			time.sleep(0.05)
		
		elif i == 1:               #When output from motion sensor is HIGH
			motionHappened = 1
			#print "Intruder detected",i
			GPIO.output(3, 0)  #Turn ON LED
			time.sleep(0.05)

main()