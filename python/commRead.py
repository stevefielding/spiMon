import serial
import time
import argparse

# construct the argument parse and parse the arguments
ap = argparse.ArgumentParser()
ap.add_argument("-b", "--baudRate", required=True, type=int,
	help="Baud rate for serial communications")

ap.add_argument("-p", "--port", required=True, type=str,
	help="serial communications port, eg /dev/ttyUSB0 or COM4")
args = vars(ap.parse_args())
print("Setting baud rate to: {}".format(args["baudRate"]))
print("Using serial port: {}".format(args["port"]))

# ----------- Open serial port
serPort = serial.Serial(args["port"], args["baudRate"], timeout=100, parity='N', stopbits=1)

print("Serial port monitor: {} is open: {}".format(serPort.name, serPort.is_open))
print(serPort)
time.sleep(1)


# -------------------------------------- main loop ---------------------------------
curTime = time.time()
while (True):
  # read from the serial port
  while True:
    resp = serPort.read(1)
    oldTime = curTime
    curTime = time.time()
    timeDiff = round((curTime - oldTime) * 1000)
    hexResp = [hex(i) for i in resp]
    print("At {}, recvd: {}".format(timeDiff, hexResp))



serPort.close()
print("serial port: {} is open: {}".format(serPort.name, serPort.is_open))
