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


sw0val = 0
sw1val = 0
sw2val = 0
sw3val = 0
currentvals = int("0x0000", 16)

l0 = 0
l1 = 0
l2 = 0
l3 = 0

colors = {0:"#000", 1:"#FFF"} 

vals = {0:1, 1:0}

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
	global l0
	global l1
	global l2
	global l3
        data = comms.recv(4)
        if (data == ''):
            comms.close()
	    self.destroy()
            return
        status = struct.unpack("=I", data)[0]
	if (l0 != (status & 1)):
	    l0 = vals[l0]
            lt0Canvas.itemconfigure(lt0LED, fill=colors[l0])
	if (l1 != ((status>>1) & 1)):
	    l1 = vals[l1]
            lt1Canvas.itemconfigure(lt1LED, fill=colors[l1])
	if (l2 != ((status>>2) & 1)):
	    l2 = vals[l2]
            lt2Canvas.itemconfigure(lt2LED, fill=colors[l2])
	if (l3 != ((status>>3) & 1)):
	    l3 = vals[l3]
            lt3Canvas.itemconfigure(lt3LED, fill=colors[l3])

    def initialize(self):
	global iswup 
	global iswdn 
	global swvals
	iswup = PhotoImage(file='gifs/swup.gif')
	iswdn = PhotoImage(file='gifs/swdn.gif')
	swvals = {0:iswdn, 1:iswup}
        self.grid()
        global lt0Canvas
	global lt0LED
	lt0Canvas = Tkinter.Canvas(self, width=16, height=16)
	lt0LED = lt0Canvas.create_oval(2, 2, 14, 14, fill="#000")
        lt0Canvas.grid(column=0,row=0)
        global lt1Canvas
	global lt1LED
	lt1Canvas = Tkinter.Canvas(self, width=16, height=16)
	lt1LED = lt1Canvas.create_oval(2, 2, 14, 14, fill="#000")
        lt1Canvas.grid(column=1,row=0)
        global lt2Canvas
	global lt2LED
	lt2Canvas = Tkinter.Canvas(self, width=16, height=16)
	lt2LED = lt2Canvas.create_oval(2, 2, 14, 14, fill="#000")
        lt2Canvas.grid(column=2,row=0)
        global lt3Canvas
	global lt3LED
	lt3Canvas = Tkinter.Canvas(self, width=16, height=16)
	lt3LED = lt3Canvas.create_oval(2, 2, 14, 14, fill="#000")
        lt3Canvas.grid(column=3,row=0)

	global sw0
        sw0 = Tkinter.Button(self,image=iswdn,command=self.sw0Click)
	sw0.grid(column=0,row=1,sticky='EW')
	global sw1
        sw1 = Tkinter.Button(self,image=iswdn,command=self.sw1Click)
	sw1.grid(column=1,row=1,sticky='EW')
	global sw2
        sw2 = Tkinter.Button(self,image=iswdn,command=self.sw2Click)
	sw2.grid(column=2,row=1,sticky='EW')
	global sw3
        sw3 = Tkinter.Button(self,image=iswdn,command=self.sw3Click)
	sw3.grid(column=3,row=1,sticky='EW')

        self.protocol("WM_DELETE_WINDOW", self.shutDown)
        self.resizable(False,False)
        self.createfilehandler(comms, tkinter.READABLE, self.handler)

    def sw0Click(self):
	global sw0val
	global sw0
	global currentvals
	sw0val = vals[sw0val]
        currentvals = currentvals ^ int("0x0010", 16)
	sw0.config(image=swvals[sw0val])
        comms.send(format(currentvals, '02x'))

    def sw1Click(self):
	global sw1val
	global sw1
	global currentvals
	sw1val = vals[sw1val]
        currentvals = currentvals ^ int("0x0020", 16)
	sw1.config(image=swvals[sw1val])
        comms.send(format(currentvals, '02x'))

    def sw2Click(self):
	global sw2val
	global sw2
	global currentvals
	sw2val = vals[sw2val]
        currentvals = currentvals ^ int("0x0040", 16)
	sw2.config(image=swvals[sw2val])
        comms.send(format(currentvals, '02x'))

    def sw3Click(self):
	global sw3val
	global sw3
	global currentvals
	sw3val = vals[sw3val]
        currentvals = currentvals ^ int("0x0080", 16)
	sw3.config(image=swvals[sw3val])
        comms.send(format(currentvals, '02x'))

    def shutDown(self):
        comms.close()
        self.destroy()

def signal_handler(signal, frame):
	print('peripheral.py: Closing down')
	sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)

    app = simpleapp_tk(None)
    app.title('LEDs and Switches')
    print('Starting mainloop')
    app.mainloop()

