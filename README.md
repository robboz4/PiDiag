# PiDiag
Debug commands for setting up a Pi

I created this script to capture information people ask for when they are asking for help in setting up a Pi or Octoprint.
The output has xml tags to seperate the different commnands and their outputs. 
Download the script and chmod +x for execution and it should run. 
The output file is names DiagoutYEARSECONDS.txt. The YEARSECONDS is automatically appended to give a somewhat unique file name.  
The script will then test to see if there is a working network by pinging www.pastebin.com. If successful
it will upload the file for them If not it will ask them to do it.


The PASTEBIN upload code was leveraged from this program:

https://gist.github.com/hashworks/14b730861c161e36d223

Many thanks to the author for creating it.

The xml stylesheet reference is from a good friend who helps me out with all my programming:

www.tommilner.org






Future:
1) Pass in runtime parameters to select the different or all commands. Probably not needed...

