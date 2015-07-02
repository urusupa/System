#! ruby -Ku
# encoding: utf-8

require 'rubygems'
require 'win32ole'

shell = WIN32OLE.new("WScript.Shell")
shell.Run("shutdown -r -t 60")


