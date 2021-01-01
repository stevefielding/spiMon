import serial
import time
import argparse

LOOP_BACK_MESS_OK = b'\x72\x20\x72\x00\x72\x01\x72\x02\x72\x03\x72\x04\x72\x05\x72\x06\x72\x07'
LOOP_BACK_MESS_OVER_RUN = b'\x72\x20\x72\x00\x72\x01\x72\x02\x72\x03\x72\x04\x52\x05\x72\x06\x72\x07'

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
serPort = serial.Serial(args["port"], args["baudRate"], timeout=10, parity='N', stopbits=1)

print("Serial port monitor: {} is open: {}".format(serPort.name, serPort.is_open))
print(serPort)
time.sleep(1)
from datetime import timedelta

# this function may discard characters the first time it is called,
# but on all subsequent calls it should be in sync with the incoming
# data stream
def getSpiTrans():
  overRun = False
  # read from the serial port until 'r' or 'R' sync char is located
  while (True):
    resp = serPort.read(1)
    hexResp = [hex(i) for i in resp]
    if hexResp[0] == '0x52' or hexResp[0] == '0x72':
      # if char is 'R' then an overrun has occurred.
      if hexResp[0] == '0x52':
        overRun = True
      break

  # read from the serial port until ' ' sync char is located
  while (True):
    resp = serPort.read(1)
    hexResp = [hex(i) for i in resp]
    if hexResp[0] == '0x20':
      break

  # read the remainder of the transaction
  resp = serPort.read(16)
  if resp == None:
    print("[ERROR] serPort returned no data")
  if len(resp) != 16:
    print("[ERROR] serPort returned insufficient data. Expected 16 chars, received {}".format(len(resp)))
  hexResp = [hex(i) for i in resp]
  # extract the data, which is in the odd locations
  message = hexResp[1::2]
  # extract the sync chars, which are in the even locations
  syncList = hexResp[::2]
  # if any sync char is 'R' then register an over run.
  if '0x52' in syncList:
    overRun = True
  return message, overRun



curTime = time.time()
# send some debug messages
# assumes uart RXD is connected to TXD
serPort.write(LOOP_BACK_MESS_OK)
serPort.write(LOOP_BACK_MESS_OVER_RUN)
while (True):
  message, overRun = getSpiTrans()
  oldTime = curTime
  curTime = time.time()
  timeDiff = curTime - oldTime
  print("[INFO] Response: {}, timeDiff: {}".format(message, timeDiff))
  if overRun == True:
    print("  [ERROR] Over run in spi capture fifo")

serPort.close()
print("serial port: {} is open: {}".format(serPort.name, serPort.is_open))
