# PiDiag
Debug commands for setting up a Pi

I created this script to capture information people ask for when you are askiing for help in setting up a Pi or Octopi.
The output has xml tags to seperate the different commnands and their outputs. This isn't working on browsers yet
due to a format issue. It scrunches the command output. But looking into that.
Download the script and chmod +x for exuction and it should run. The output file is names DiagoutYEARSECONDS.txt 
THE TEARSECONDS is automatically appended to give a somewhat unique file name. I will probably fix that later
but was in a rush to test and send the output to someone who is helping debug an issue.

To view the xml format try using this web page:
http://www.webtoolkitonline.com/xml-formatter.html

Copy all the output and paste it into the window.




Future:
1) Fix format for browsers. Have an xml stylesheet available but needs linking in or passing along with the file.
2) Pass in runtime parameters to select the different or all commands.
3) Auto paste to pastebin.com
