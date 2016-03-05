#!/bin/bash

# A script to capture  details to help debug OctoPi ( or other Pi ) related  issues.
# It captures output from:
# uname
# python
# lsusb
# lsmod
# dmesg
# ifconfig
# iwlist 
# wpa_cli
# It outputs the results to an ASCII or text file with  some XML tabs for viewing or searching better
# Dave Robinson 2/15/16
# Version 1.2.0

# Notes:
# Still working on formatting better fro xml output. 
# Added Octoprint version
# Added last 100 lines of syslog
# Trying to add Python version number but for some reason it's not passing it into the output file
# bumped   the version  number to 1.2.0


TODAY=`date +%F%M`
#Used to generate a sudo unique file name
Log="Diagout$TODAY.txt"

#Creates file with xml head
echo "<?xml version=\"1.0\" ?>" >$Log
# echo "<?xml-stylesheet type='text/xsl' href='http://clubrobbo.synology.me:80/Robboz-_Designs/Diagout.xsl' ?>" >> $Log
echo "<?xml-stylesheet type='text/xsl' href='Diagout.xsl' ?>" >> $Log

#Opening tag
echo "<log>" >>$Log
echo "Log created on " `date` >>$Log

#System name
echo "<system>">> $Log
echo " ON SYSTEM: " >>$Log
uname -a  >> $Log

echo "Octprint Version:"  `cat /etc/octopi_version`  >> $Log
Python_ver= `python --version`
 
echo "Python version: " `/home/pi/oprint/bin/python --version` >> $Log
echo "</system>">> $Log

#lsusb data
echo "<usb>" >> $Log
echo "  LSUSB OUPUT:" >> $Log
sudo lsusb >>  $Log
echo "</usb>" >> $Log

#lsmod data
echo "<lsmod>" >> $Log
echo "  LSMOD OUPUT:" >> $Log
sudo lsmod >>  $Log
echo "</lsmod>" >> $Log

#dmesg data
echo "<dmesg>" >> $Log
echo " DMESG OUTPUT:  " >>$Log
dmesg >> $Log
echo "</dmesg>" >> $Log

#/var/log/syslog last 100 lines only

echo "<SysLog>">> $Log
#SysLog=`tail -100 /var/log/syslog` 
tail -100 /var/log/syslog >> $Log
#echo $SysLog >> $Log
echo "</SysLog>" >> $Log

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
