# PiDiag
Debug commands for setting up a Pi

I created this script to capture information people ask for when they are asking for help 
in setting up a Pi or Octoprint. The output has xml tags to seperate the different 
commands and their outputs. Download the script and chmod +x for execution and it should
run. The output file is names DiagoutYEARSECONDS.xml. The YEARSECONDS is automatically 
appended to give a somewhat unique file name.  The script will then test to see if there
is a working network by pinging www.pastebin.com. If successful it will upload the file.
If not it will ask for you to do it. Sometimes not the  whole file gets upload, so 
keep the file as it might be needed by the person asking for the informations.

Currently collects info on the Pi (HW & SW), various applications (PHP, Apache2, wiringPi)
network data, syslog (last 100 entires) and the dmesg output.

To use the xml formatting download the diagout.xsl file to the same directory as the 
output fileand have a browser (Safari works) open it.
You should see each section highlighted. If the format file is not there, then some
browsers will diaplay the file with handles that allow the various sections to
be collapsed for easier viewing.


The PASTEBIN upload code was leveraged from this program:

https://gist.github.com/hashworks/14b730861c161e36d223

Many thanks to the author for creating it.

The xml stylesheet reference is from a good friend who helps me out with all my 
programming:

www.tommilner.org

Had to handle less than and ampersand characters in the log file output so they
wouldn't screw up the xml formatting. The link below helped with  a sed command to do
this:

http://daemonforums.org/showthread.php?t=4054


(Thanks once again to  Tom!)



Future:
1) Pass in runtime parameters to select the different or all commands. 


