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
# Version 2.0.1
# 3/6/16 
# Added paste to pastebin if a working network is detected. 
# 3/13/16 
# Fixed typo
# 
# Bumped   the version  number to 2.0.1
# Altered name for upload to pastebin.com
# Bumped   the version  number to 2.0.2
# Bumped   the version number to 2.0.3 Added PiGMi data collection
# Bumped   the version number to 2.0.4 Added df -h, version string, hostname
# Rearranged the collection of data. Added a parameter to dmesg to keep the output
# smaller. Not all the log gets posted to pastebin, but all data is captured.
# Added CPU info, CPU temp and free mmemory data for the Pi
# Bumped to 2.0.5 1/7/17

# Notes:
# Still working on formatting better for xml output. The links to Tom's file should work.
# 
# pastebin not getting a complete upload...


TODAY=`date +%F%M`
#Used to generate a sudo unique file name
Log="Diagout$TODAY.txt"
PASTEBIN_Name="Diagout$TODAY."
echo "This program can create a large file that might not get fully uploaded to pastebin."
echo "Please keep the file in case the requester needs information that did not get to pastebin."
echo "Starting to collect data to file " $Log

#Creates file with xml head
echo "<?xml version=\"1.0\" ?>" >$Log
echo "<?xml-stylesheet type='text/xsl' href='http://tommilner.org/diagout/diagout.xsl' ?>" >> $Log
#echo "<?xml-stylesheet type='text/xsl' href='Diagout.xsl' ?>" >> $Log

#Opening tag
echo "<log>" >>$Log
echo "Log created on " `date` >>$Log
echo "diag_info version = 2.0.5 " >> $Log

#System name
echo "<system>">> $Log
echo " ON SYSTEM: " >>$Log
uname -a  >> $Log
echo "Known as:" >> $Log
hostname  >> $Log
echo "Pi Details:" >> $Log
cat /proc/cpuinfo >> $Log
echo "CPU Temperature is : " >> $Log
vcgencmd measure_temp >> $Log

echo "Memory free space  table : " >> $Log

free -o -h >> $Log


echo "Octoprint Version:"  `cat /etc/octopi_version`  >> $Log

Python_ver=$(python --version 2>&1) 
echo "Python version: " $Python_ver >> $Log
Apache_ver=$(apache2 -v 2>&1)
echo "Apache version: " $Apache_ver    >> $Log
Php_ver=$(php -v 2>&1)
echo "PHP Version: " $Php_ver  >> $Log
GPIO_ver=$(gpio -v 2>&1 | head -n1)
echo "gpioutility Version: "  $GPIO_ver >> $Log

echo "GPIO Pin settings: "  >> $Log 
echo ""  >> $Log
gpio readall >> $Log
echo "Disk Space:" >> $Log
sudo df -h >> $Log 
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
sleep 5
# Above sleep added for P3.
sudo iwlist wlan0 scan >>$Log
echo "</iwlist>" >>$Log
echo "</wifi>" >>$Log

echo "<SysLog>">> $Log
#SysLog=`tail -100 /var/log/syslog` 
tail -100 /var/log/syslog >> $Log
#echo $SysLog >> $Log
echo "</SysLog>" >> $Log


#dmesg data
echo "<dmesg>" >> $Log
echo " DMESG OUTPUT:  " >>$Log
dmesg -l info >> $Log
echo "</dmesg>" >> $Log

#/var/log/syslog last 100 lines only




echo " End of data captured. " >>$Log

#Closing tag
echo "</log>" >> $Log


# Now seeing if we can send the file to pastebin.com or get the user 
# to manually paste the details in.

Result=$(ping -c 2 -t 30 www.pastebin.com 2>&1)

# Added extra time as pining www.pastebin.com became sluggish during coding.


	
if [ $? -eq 0 ]
then
  	echo "Ping successful we have network! "
  	echo ""

#
# The following code borrowed from https://gist.github.com/hashworks/14b730861c161e36d223
#
    API_DEV_KEY="e02c17d8e1cce421740ecad74e65d5fc"
    API_USER_KEY=""
    EXPIRE_DATE="1M"
# Set to expire in 1 month
    PRIVATE="0"
    INPUT=$(cat ${Log})
    NAME=$PASTEBIN_Name
    FORMAT="xml"

    querystring="api_option=paste&api_dev_key=${API_DEV_KEY}&api_user_key=${API_USER_KEY}&api_paste_expire_date=${EXPIRE_DATE}&api_paste_private=${PRIVATE}&api_paste_code=${INPUT}&api_paste_name=${NAME}${FORMAT}"

    Paste_url=$(curl -d "${querystring}" http://pastebin.com/api/api_post.php )

    echo "Please pass this url to the requester of the information." $Paste_url
    echo " The whole file may not get transmitted to pastebin. So please save it in case the requester needs more information"



else
  	echo "No Network must paste file manually " 
  	echo ""
  	echo "Please cut & paste the file " $Log " to www.pastebin.com and pass the link to the requester."
  	echo "The whole file may not get pasted  to pastebin. So please save it in case the requester needs more information"


  	
fi

# The End.
