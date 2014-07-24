#!/usr/bin/python

import Tkinter
import socket
import tkMessageBox

TCP_IP = '127.0.0.1'
TCP_PORT = 5005
BUFFER_SIZE = 1024

class simpleapp_tk(Tkinter.Tk):
    def __init__(self,parent):
        global comms
        comms = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        comms.connect((TCP_IP, TCP_PORT))
        Tkinter.Tk.__init__(self,parent)
        self.parent = parent
        self.initialize()

    def initialize(self):
        self.grid()
        buttonx = Tkinter.Button(self,text=u"Red",command=self.OnButtonXClick)
        buttonx.grid(column=0,row=0)
        buttony = Tkinter.Button(self,text=u"Green",command=self.OnButtonYClick)
        buttony.grid(column=1,row=0)
        buttonz = Tkinter.Button(self,text=u"Blue",command=self.OnButtonZClick)
        buttonz.grid(column=2,row=0)

        self.protocol("WM_DELETE_WINDOW", self.shutDown)
        self.resizable(False,False)

    def OnButtonXClick(self):
        comms.send("buttonX")

    def OnButtonYClick(self):
        comms.send("buttonY")

    def OnButtonZClick(self):
        comms.send("buttonZ")

    def shutDown(self):
        if tkMessageBox.askokcancel("Quit", "Do you really wish to quit?"):
            comms.close()
            self.destroy()

if __name__ == "__main__":
    app = simpleapp_tk(None)
    app.title('Vista Control')
    app.mainloop()

