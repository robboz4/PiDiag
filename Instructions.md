Instructions:


Download file and install it in the /boot directory. You can either do this on the SD image before putting
it in the Pi, or add it if you have a network connection to a running Pi.
By adding it to the boot directory the output file will also be stored there, which means if you are having network issues, you can mounthe SD card back inyour comeuter
can read the file on the  SD on your computer and  upload it if requested to do so to the person helping you.

If you rename the output file with the extension  ".xml" a browser will open it
and try to format the tabs. I'm still working on this feature. See the README.md file for more details on that.
to run the file type:

cd /boot
chmod +x diag_info.sh  
sudo ./diag_info.sh

The output file should be something like Diag2016-XX-XXX.txt




