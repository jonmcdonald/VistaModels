#!/usr/bin/python

import Tkinter
import socket
import tkMessageBox
import struct
import os
import time 
import signal 
import sys 
import math

from Tkinter import *
from time import sleep

TCP_IP = '127.0.0.1'
TCP_PORT = 5005

radioAnimationValue = 0

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

    def handler(self,*args):
        data = comms.recv(8)
        if (data == ''):
            comms.close()
	    self.destroy()
            return
	print('instruments.py: Received data: ', data) 

    def initialize(self):
        self.grid()
        global accelerator
	accelerator = Scale(self, from_=100, to=0, showvalue=1, command=self.changeAccelerator)
	accelerator.grid(column=0,row=0,sticky='NS',rowspan=1)
        global brake
	brake = Scale(self, from_=100, to=0, showvalue=1, command=self.changeBrake)
	brake.grid(column=1,row=0,sticky='NS',rowspan=1)
        global radio
	radio = Tkinter.Canvas(self, width=640, height=240)
        radio.grid(column=2,row=0)
        global volume
	volume = Scale(self, from_=10, to=0, showvalue=1, command=self.changeVolume)
	volume.set(5)
	volume.grid(column=3,row=0,sticky='NS',rowspan=1)
        self.protocol("WM_DELETE_WINDOW", self.shutDown)
        self.resizable(False,False)
        self.createfilehandler(comms, tkinter.READABLE, self.handler)
	self.animateRadio()

    def animateRadio(self):
	self.changeVolume()
        radio.after(50, self.animateRadio)

    def changeAccelerator(event, *args):
	brake.set(0)
        ident = 0
        value = accelerator.get()
        comms.send(struct.pack("II", ident, int(value)))

    def changeBrake(event, *args):
	accelerator.set(0)
        ident = 1
        value = brake.get()
        comms.send(struct.pack("II", ident, int(value)))

    def changeVolume(event, *args):
        global radioAnimationValue
	radioAnimationValue = radioAnimationValue + 7
	width = radio.winfo_width()
	height = radio.winfo_height()
	center = height / 2
	x_increment = 1
	x_factor = 0.04
	y_amplitude = 10 * volume.get()
	radio.delete("all")
	center_line = radio.create_line(0, center, width, center, fill='black')
	xy1 = []
	for x in range(640):
	    xy1.append(x * x_increment)
	    xy1.append(int(math.sin((x - radioAnimationValue) * x_factor) * y_amplitude) + center)
	sin_line = radio.create_line(xy1, fill='blue')
	xy2 = []
	for x in range(640):
	    xy2.append(x * x_increment)
	    xy2.append(int(math.cos((x + radioAnimationValue) * x_factor) * y_amplitude) + center)
	cos_line = radio.create_line(xy2, fill='red')

    def shutDown(self):
        if tkMessageBox.askokcancel("Quit", "Do you really wish to end the simulation?"):
            comms.close()
            self.destroy()

def signal_handler(signal, frame):
	print('instruments.py: Closing down')
	sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)

    app = simpleapp_tk(None)
    app.title('Instruments')
    app.mainloop()

