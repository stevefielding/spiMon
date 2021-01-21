import serial
import time
import argparse

LOOP_BACK_MESS_OK = b'\x55\x72\x20\x72\x00\x72\x01\x72\x02\x72\x03\x72\x04\x72\x05\x72\x06\x72\x07'
LOOP_BACK_MESS_OVER_RUN = b'\x72\x20\x72\x00\x72\x01\x72\x02\x72\x03\x72\x04\x52\x05\x72\x06\x72\x07'
LOOP_BACK_MESS2_OK = b'\x55\x72\x20\x72\x65\x72\x50\x72\x00\x72\x00\x72\x00\x72\x00\x72\x00\x72\x00'

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
from datetime import timedelta

# this function may discard characters the first time it is called,
# but on all subsequent calls it should be in sync with the incoming
# data stream
# ------------------------------------ getSpiTrans ---------------------------------
def getSpiTrans():
  overRun = False
  spiAddr = 0x0
  spiDataIn = 0x0
  spiDataOut = 0x0
  message = "[ERROR] no message found"
  # read from the serial port until 'r' or 'R' sync char is located
  while True:
    resp = serPort.read(1)
    hexResp = [hex(i) for i in resp]
    if hexResp[0] == '0x52' or hexResp[0] == '0x72':
      # if char is 'R' then an overrun has occurred.
      if hexResp[0] == '0x52':
        overRun = True
      break

  # read from the serial port until ' ' sync char is located
  while True:
    resp = serPort.read(1)
    hexResp = [hex(i) for i in resp]
    if hexResp[0] == '0x20':
      break

  # read the remainder of the transaction
  resp = serPort.read(16)
  if resp is None:
    print("[ERROR] serPort returned no data")
  elif len(resp) != 16:
    print("[ERROR] serPort returned insufficient data. Expected 16 chars, received {}".format(len(resp)))
  else:
    # extract the data, which is in the odd locations
    addr = resp[1:5:2]
    spiAddr = (addr[0] << 8) + addr[1]
    dataIn = resp[5:9:2]
    spiDataIn = (dataIn[0] << 8) + dataIn[1]
    dataOut = resp[9::2]
    spiDataOut = (dataOut[0] << 24) + (dataOut[1] << 16) + (dataOut[2] << 8) + dataOut[3]
    # extract the sync chars, which are in the even locations
    # convert to readable format, and extract the message data
    hexResp = [hex(i) for i in resp]
    message = hexResp[1::2]
    syncList = hexResp[::2]
    # if any sync char is 'R' then register an over run.
    if '0x52' in syncList:
      overRun = True
  return message, spiAddr, spiDataIn, spiDataOut, overRun

# --------------------------- parseMessage ----------------------------------
def parseMessage(addr, dIn, dOut):
  boardId = (addr & 0xe000) >> 13
  regAddr = (addr & 0x1fe0) >> 5
  readNotWrite = (addr & 0x10) >> 4
  if (boardId & 0x1) == 1: # FPGA[n] = boardId[2:1]
    fpgaNum = (boardId & 0x6) >> 1
    devName = "Scaler FPGA#" + str(fpgaNum)
    if regAddr == 0x2a:
      regName = "Hot_plug_status"
    elif regAddr == 0x0:
      regName = "Status"
    elif regAddr == 0x4:
      regName = "Generic"
    else:
      regName = "Unknown reg"
  elif boardId == 0: # CPLD = 0x0
    devName = "CPLD    "
    if regAddr == 0x0 and readNotWrite == 1:
      regName = "Status"
    elif regAddr == 0x2 and readNotWrite == 1:
      regName = "DLL_lock_status"
    elif regAddr == 0x2 and readNotWrite == 0:
      regName = "fpga_prog_gate"
    elif regAddr == 0xa:
      regName = "sync_gen_ctrl"
    elif regAddr == 0x8:
      regName = "pll_href_mod"
    elif regAddr == 0x12:
      regName = "en_16v1"
    elif regAddr == 0x14:
      regName = "en_16v2"
    elif regAddr == 0x16:
      regName = "en_16v3"
    elif regAddr == 0x18:
      regName = "en_16v4"
    elif regAddr == 0x22:
      regName = "i2c_in_en1"
    elif regAddr == 0x24:
      regName = "i2c_in_en2"
    elif regAddr == 0x26:
      regName = "i2c_in_en3"
    elif regAddr == 0x28:
      regName = "i2c_in_en4"
    elif regAddr == 0x0 and readNotWrite == 0:
      regName = "fpga_prog"
    else:
      regName = "Unknown reg"
  elif boardId == 0x6: # win FPGA = 0x0
    devName = "Win FPGA"
    regName = "Unknown"
  else: # device address not recognized. Not in set: 0(cpld), 6(winFpga), 1(sFpga0), 3(sFpga1), 5(sFpga2), 7(sFpga3)
    devName = "Unknown(" + str(boardId) + ")"
    regName = "Unknown reg"
  return devName, regAddr, regName, readNotWrite


# -------------------------------------- main loop ---------------------------------
curTime = time.time()
# send some debug messages
# assumes uart RXD is connected to TXD
serPort.write(LOOP_BACK_MESS_OK)
serPort.write(LOOP_BACK_MESS_OVER_RUN)
messageCnt = 0
while (True):
  message1, spiAddr1, spiDataIn1, spiDataOut1, overRun1 = getSpiTrans()
  devName1, regAddr1, regName1, readNotWrite1 = parseMessage(spiAddr1, spiDataIn1, spiDataOut1)
  rNotwMess = "Read" if readNotWrite1 else "Write"
  messageCnt += 1
  oldTime = curTime
  curTime = time.time()
  timeDiff = round((curTime - oldTime) * 1000)
  # print("[INFO] Raw data: {}, timeDiff: {}mS".format(message1, timeDiff)
  print("  #{}\t{}\t{}\t{}({})\tdo: {}\tdi: {}\t{}mS"
        .format(messageCnt, devName1, rNotwMess, regName1, hex(regAddr1), hex(spiDataIn1), hex(spiDataOut1), timeDiff))
  if overRun1 == True:
    print("  [ERROR] Over run in spi capture fifo")

serPort.close()
print("serial port: {} is open: {}".format(serPort.name, serPort.is_open))
