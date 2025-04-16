require 'win32ole'

def notify(title, message)
  shell = WIN32OLE.new('WScript.Shell')
  shell.popup(message, 5, title, 64)
  print "\a"
end
