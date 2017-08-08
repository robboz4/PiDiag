Instructions:


Download file and install it in the /boot directory. You can either do this on the SD 
image before puttingit in the Pi, or add it if you have a network connection to a running
Pi. By adding it to the boot directory the output file will also be stored there, which 
means if you are having network issues, you can mount the SD card back in your computer 
and upload it if requested to do so by the person helping you. The script will attempt to 
auto paste to www.pastebin.com. If successful it will return the url of that paste. You 
will need to send the URL to the person helping you, probably pasting it into the text of
the  thread where you requested help on if using a support thread or help blog. Sometimes
the whole does not get upload, so please keep the file in case the requester needs more 
information.

The file contains xml formatting tags. If you want to see the formatted output, download 
the diagout.xsl file to the same directory as the output file; change the .txt to .xml
as the filename extension and have a browser open the file. It works in Safari and might 
work in other browsers, but not Chrome. 





To run the file type:

cd /boot ( or wherever the file was downloaded to )
chmod +x diag_info.sh  
sudo ./diag_info.sh (-ahsinl)

The output file should be something like Diag201X-XX-XXX.txt






