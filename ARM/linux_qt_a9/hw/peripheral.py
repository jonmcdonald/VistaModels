#!/usr/bin/python

import Tkinter
import socket
import tkMessageBox
import struct
import os
import time 
import signal
import sys

from Tkinter import *
from time import sleep

TCP_IP = '127.0.0.1'
TCP_PORT = 5005

class simpleapp_tk(Tkinter.Tk):
    def __init__(self,parent):
        global comms
        comms = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        while(1):
            try:
                comms.connect((TCP_IP, TCP_PORT))
                break
            except:
                sleep(0.5)
        Tkinter.Tk.__init__(self,parent)
        self.parent = parent
        self.initialize()

    def handler(*args):
        data = comms.recv(4)
        if (data == ''):
            comms.close()
            self.destroy()
            return
        status = struct.unpack("=I", data)[0]
        if (status & ( 1 << 2)):
            redCanvas.itemconfigure(redLED, fill='red')
        else:
            redCanvas.itemconfigure(redLED, fill='black')
        if (status & ( 1 << 1)):
            greenCanvas.itemconfigure(greenLED, fill='green')
        else:
            greenCanvas.itemconfigure(greenLED, fill='black')
        if (status & ( 1 << 0)):
            blueCanvas.itemconfigure(blueLED, fill='blue')
        else:
            blueCanvas.itemconfigure(blueLED, fill='black')

    def initialize(self):
        self.grid()
        global redCanvas
	global redLED
	redCanvas = Tkinter.Canvas(self, width=48, height=48)
	redLED = redCanvas.create_oval(3, 3, 45, 45, fill="black")
        redCanvas.grid(column=0,row=0)
	global greenCanvas
	global greenLED
        greenCanvas = Tkinter.Canvas(self, width=48, height=48)
	greenLED = greenCanvas.create_oval(3, 3, 45, 45, fill="black")
        greenCanvas.grid(column=1,row=0)
	global blueCanvas
	global blueLED
        blueCanvas = Tkinter.Canvas(self, width=48, height=48)
	blueLED = blueCanvas.create_oval(3, 3, 45, 45, fill="black")
        blueCanvas.grid(column=2,row=0)
        interruptButton = Tkinter.Button(self,text=u"Interrupt",command=self.OnInterruptButtonClicked)
	interruptButton.grid(column=0,row=1,sticky='EW',columnspan=3)
        self.protocol("WM_DELETE_WINDOW", self.shutDown)
        self.resizable(False,False)
        self.createfilehandler(comms, tkinter.READABLE, self.handler)

    def OnInterruptButtonClicked(self):
        comms.send("irq")

    def shutDown(self):
        if tkMessageBox.askokcancel("Quit", "Do you really wish to quit?"):
            comms.close()
            self.destroy()

def signal_handler(signal, frame):
    print('peripheral.py: Closing down')
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)

    app = simpleapp_tk(None)
    app.title('Peripheral')

    app.mainloop()

