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

xvalue = 0

class simpleapp_tk(Tkinter.Tk):


    def __init__(self,parent):
        Tkinter.Tk.__init__(self,parent)
        self.parent = parent
        self.initialize()

    def initialize(self):
        self.grid()
        global canvas
	canvas = Tkinter.Canvas(self, width=640, height=240)
        canvas.grid(column=0,row=0)
        global volume
	volume = Scale(self, from_=10, to=0, showvalue=1, command=self.changeVolume)
	volume.set(5)
	volume.grid(column=1,row=0,sticky='NS',rowspan=1)
        self.protocol("WM_DELETE_WINDOW", self.shutDown)
        self.resizable(False,False)
	self.animate()

    def animate(self):
	self.changeVolume()
        canvas.after(50, self.animate)

    def changeVolume(event, *args):
        global xvalue
	xvalue = xvalue + 7

	width = canvas.winfo_width()
	height = canvas.winfo_height()

	center = height / 2
	x_increment = 1
	x_factor = 0.04

	y_amplitude = 10 * volume.get()

	canvas.delete("all")

	center_line = canvas.create_line(0, center, width, center, fill='black')

	xy1 = []
	for x in range(640):
	    xy1.append(x * x_increment)
	    xy1.append(int(math.sin((x - xvalue) * x_factor) * y_amplitude) + center)
	sin_line = canvas.create_line(xy1, fill='blue')

	xy2 = []
	for x in range(640):
	    xy2.append(x * x_increment)
	    xy2.append(int(math.cos((x + xvalue) * x_factor) * y_amplitude) + center)
	cos_line = canvas.create_line(xy2, fill='red')



    def shutDown(self):
        if tkMessageBox.askokcancel("Quit", "Do you really wish to quit?"):
            self.destroy()

def signal_handler(signal, frame):
    print('peripheral.py: Closing down')
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)

    app = simpleapp_tk(None)
    app.title('Sound Wave')

    app.mainloop()

