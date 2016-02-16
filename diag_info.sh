#!/bin/bash

# A script to caputure  details to help debug OctoPi ( or other Pi ) related  issues.
# It captures output from:
# lsusb
# dmesg
# ifconfig
# iwlist 
# wpa_cli
# It outputs the results to an ASCII or text file with  some XML tabs for viewing or searching better
# Dave Robinson 2/15/16
# Version 1.0.0

#Notes:
# Works but xml output doesn't format output in browsers. It does in this
# free onlne XMl viewer http://www.webtoolkitonline.com/xml-formatter.html
# Looking into that.


TODAY=`date +%F%M`
#Used to generate a sudo unique file name
Log="Diagout$TODAY.txt"

#Creates file with xml head
echo "<?xml version=\"1.0\" ?>" >$Log

#Opening tag
echo "<log>" >>$Log
echo "Log created on " `date` >>$Log

#System name
echo "<system>">> $Log
echo " ON SYSTEM: " >>$Log
uname -a  >> $Log
echo "</system>">>$Log

#lsusb data
echo "<usb>" >> $Log
echo "  LSUSB OUPUT:" >> $Log
sudo lsusb >>  $Log
echo "</usb>" >> $Log

#dmesg data
echo "<dmesg>" >> $Log
echo " DMESG OUTPUT:  " >>$Log
dmesg >> $Log
echo "</dmesg>" >> $Log

#wifi data
echo "<wifi>" >>$Log
echo  " WIFI OUTPUT: " >>$Log
echo "<ifconfig>" >>$Log
ifconfig >> $Log
echo "</ifconfig>" >>$Log
echo "<wpa_cli>" >> $Log
sudo wpa_cli scan >> $Log && sudo wpa_cli scan_results >> $Log
echo "</wpa_cli>" >>$Log
echo "<iwlist>" >>$Log
sudo iwlist wlan0 scan >>$Log
echo "</iwlist>" >>$Log
echo "</wifi>" >>$Log

echo " End of data captured. " >>$Log

#Closing tag
echo "</log>" >> $Log
