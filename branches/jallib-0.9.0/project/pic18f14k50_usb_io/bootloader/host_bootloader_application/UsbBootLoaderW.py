#!/usr/bin/python
#
#
# Title: jallib USB bootloader (auto start) GUI application
# Author: Albert Faber, Copyright (c) 2009, all rights reserved.
# Adapted-by:
# Compiler:
#
# This file is part of jallib (http://jallib.googlecode.com)
# Released under the BSD license (http://www.opensource.org/licenses/bsd-license.php)
#
# Sources:
#
# Description: USB loader command line tool, see help for options and usage
#
# Dependencies: you'll need to install the LIBUSB and WxWidget (2.8) package in order to use the application
#
# Notes: based on Vascoboot, needs more work
#

import wx
import sys
import os
import usb
import time

from array import array

import intelhex
from intelhex import IntelHex

import UsbBootLoader
from UsbBootLoader import UsbBootLoader

SetGUI=0



class UsbBootLoaderGUI(wx.Frame):
	 filename=""
	 
	 usb_bootloader = UsbBootLoader()
		  
	 def __init__(self, *args, **kwds):
		  if sys.platform=="win32":
				self.fileseparator="\\"
		  else:
				self.fileseparator="/"
		  if SetGUI==1:
				kwds["style"] = wx.CAPTION|wx.CLOSE_BOX|wx.SYSTEM_MENU
				wx.Frame.__init__(self, *args, **kwds)
				self.frame_1_statusbar = self.CreateStatusBar(1, 0)
				self.filefield = wx.TextCtrl(self, -1, "")
				self.loadbutton = wx.Button(self, -1, "LoadFile...")
				self.log = wx.TextCtrl(self, -1, "", style=wx.TE_MULTILINE)
				self.WriteButton = wx.Button(self, -1, "Write")
				self.quitbutton = wx.Button(self, -1, "Quit")
				self.radio_btn_1 = wx.RadioButton(self, -1, "Microchip", style=wx.RB_GROUP)
				self.radio_btn_2 = wx.RadioButton(self, -1, "Vasco")
				self.radio_btn_3 = wx.RadioButton(self, -1, "Custom")
				self.label_1 = wx.StaticText(self, -1, "Vendor ID")
				self.vid = wx.TextCtrl(self, -1, "")
				self.label_2 = wx.StaticText(self, -1, "Product ID")
				self.pid = wx.TextCtrl(self, -1, "")

				self.__set_properties()
				self.__do_layout()

				self.Bind(wx.EVT_BUTTON, self.Load, self.loadbutton)
				self.Bind(wx.EVT_BUTTON, self.Write, self.WriteButton)
				self.Bind(wx.EVT_BUTTON, self.Quit, self.quitbutton)
				self.Bind(wx.EVT_RADIOBUTTON, self.SetMicrochip, self.radio_btn_1)
				self.Bind(wx.EVT_RADIOBUTTON, self.SetVasco, self.radio_btn_2)
				self.Bind(wx.EVT_RADIOBUTTON, self.SetCustom, self.radio_btn_3)
				self.vid.AppendText("04D8")
				self.pid.AppendText("000B")

	 def __set_properties(self):
		  self.SetTitle("JALLIB USB Bootloader")
		  _icon = wx.EmptyIcon()
		  # this line is used for py2exe compilation
		  #_icon.CopyFromBitmap(wx.Bitmap("connec9.ico", wx.BITMAP_TYPE_ANY))
		  _icon.CopyFromBitmap(wx.Bitmap(sys.path[0]+self.fileseparator+"connec9.ico", wx.BITMAP_TYPE_ANY))
		  self.SetIcon(_icon)        
		  self.SetSize((428, 450))
		  self.SetBackgroundColour(wx.Colour(216, 216, 191))
		  self.frame_1_statusbar.SetStatusWidths([-1])
		  frame_1_statusbar_fields = ["USB Bootloader version 1.0"]
		  for i in range(len(frame_1_statusbar_fields)):
				self.frame_1_statusbar.SetStatusText(frame_1_statusbar_fields[i], i)
		  self.filefield.SetMinSize((250, 21))
		  self.log.SetMinSize((340,180))

	 def __do_layout(self):
		  sizer_1 = wx.BoxSizer(wx.VERTICAL)
		  sizer_2 = wx.BoxSizer(wx.VERTICAL)
		  sizer_5 = wx.BoxSizer(wx.HORIZONTAL)
		  sizer_7 = wx.BoxSizer(wx.VERTICAL)
		  sizer_9 = wx.BoxSizer(wx.HORIZONTAL)
		  sizer_8 = wx.BoxSizer(wx.HORIZONTAL)
		  sizer_6 = wx.BoxSizer(wx.VERTICAL)
		  sizer_4 = wx.BoxSizer(wx.HORIZONTAL)
		  sizer_3 = wx.BoxSizer(wx.HORIZONTAL)
		  sizer_3.Add(self.filefield, 0, wx.LEFT|wx.ALIGN_CENTER_VERTICAL, 15)
		  sizer_3.Add(self.loadbutton, 0, wx.LEFT|wx.RIGHT|wx.ALIGN_CENTER_VERTICAL, 40)
		  sizer_2.Add(sizer_3, 1, wx.EXPAND, 0)
		  sizer_2.Add(self.log, 0, wx.LEFT|wx.RIGHT|wx.EXPAND, 14)
		  sizer_4.Add(self.WriteButton, 0, wx.LEFT|wx.RIGHT|wx.ALIGN_CENTER_VERTICAL, 69)
		  sizer_4.Add(self.quitbutton, 0, wx.LEFT|wx.RIGHT|wx.ALIGN_CENTER_VERTICAL, 50)
		  sizer_2.Add(sizer_4, 1, wx.EXPAND, 0)
		  sizer_6.Add(self.radio_btn_1, 0, wx.LEFT|wx.ALIGN_CENTER_HORIZONTAL, 20)
		  sizer_6.Add(self.radio_btn_2, 0, wx.LEFT|wx.TOP|wx.BOTTOM|wx.ALIGN_CENTER_HORIZONTAL, 5)
		  sizer_6.Add(self.radio_btn_3, 0, wx.LEFT|wx.ALIGN_CENTER_HORIZONTAL, 13)
		  sizer_5.Add(sizer_6, 1, wx.EXPAND, 0)
		  sizer_8.Add(self.label_1, 0, wx.LEFT|wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 1)
		  sizer_8.Add(self.vid, 0, wx.LEFT|wx.ALIGN_CENTER_VERTICAL, 5)
		  sizer_7.Add(sizer_8, 1, wx.EXPAND, 0)
		  sizer_9.Add(self.label_2, 0, wx.ALIGN_CENTER_HORIZONTAL|wx.ALIGN_CENTER_VERTICAL, 7)
		  sizer_9.Add(self.pid, 0, wx.LEFT|wx.ALIGN_CENTER_VERTICAL, 4)
		  sizer_7.Add(sizer_9, 1, wx.EXPAND, 0)
		  sizer_5.Add(sizer_7, 1, wx.EXPAND, 0)
		  sizer_2.Add(sizer_5, 1, wx.EXPAND, 0)
		  sizer_1.Add(sizer_2, 1, wx.EXPAND, 0)
		  self.SetSizer(sizer_1)
		  self.Layout()
		  self.Centre()

	 def Load(self, event):
	 
		  opendlg = wx.FileDialog(
				self, message="Choose a file",
				defaultDir=os.getcwd(), 
				defaultFile="",
				wildcard="Hex file (*.hex)|*.hex",
				style=wx.OPEN  | wx.CHANGE_DIR
				)
		  if opendlg.ShowModal() == wx.ID_OK:
				paths = opendlg.GetPaths()
				for path in paths:
					 self.log.AppendText(os.path.basename(path)+' opened\n')
					 self.filefield.Clear()
					 self.filefield.AppendText(path)
				self.filename=path
				self.usb_bootloader.LoadHexFile( self.filename )

	 def Write(self, event):
		pic_name = self.usb_bootloader.GetPICName()
		device_id = self.usb_bootloader.GetPICDeviceID()
		
		if ( pic_name != None ) :
			self.usb_bootloader.WriteFlash(0x800, 0x3FFF, False, False, False)


	 def Quit(self, event):
		  sys.exit()
		  
	 def SetMicrochip(self, event):
		  print "remove"

	 def SetVasco(self, event):
		  print "remove"

	 def SetCustom(self, event):
		  print "remove"


	
if __name__ == "__main__":	  

	SetGUI=1
	app = wx.PySimpleApp(0)
	wx.InitAllImageHandlers()
	frame_1 = UsbBootLoaderGUI(None, -1, "")
	app.SetTopWindow(frame_1)
	frame_1.Show()
	app.MainLoop()
