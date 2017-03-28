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
# Bumped to 2.0.6 3/5/17 - fixed xml formatting issues. 
#	1) Added sed script to format less-than and ampersand and double ampersand issues
#      obtained from here: http://daemonforums.org/showthread.php?t=4054 
#   2) Changed xml headers and point to a local xsl file instead of a domain file. This
#	   works on Safari, but not on Chrome. The file must be in the same directory as the 
#	   xml file for it to format nicely. Also change the text (.txt) file to xml (.xml).
# Bumped to 2.0.6 3/20/17 Added error checking to all commands to make the output  look
# more profressional. Also did an check on the lan configuration to see if Wifi  was set up.
# Bumped to 2.0.7 3/26/17 some more formag tidying.
# Bumoed to 2.0.8 3/28/17 Added os release version and uptime count.

# Notes:
# pastebin not getting a complete upload...


TODAY=`date +%F%M`
#Used to generate a sudo unique file name
Log="Diagout$TODAY.xml"
PASTEBIN_Name="Diagout$TODAY."
echo "This program can create a large file that might not get fully uploaded to pastebin."
echo "Please keep the file in case the requester needs information that did not get to pastebin."
echo "Starting to collect data to file " $Log

#Creates file with xml head

echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" >$Log
echo "<?xml-stylesheet type=\"text/xsl\" href=\"diagout.xsl\"?>" >>$Log




#Opening tag
echo "<log>" >>$Log
echo "Log created on " `date` >>$Log
echo "diag_info version = 2.0.8 " >> $Log

#System name
echo "<system>">> $Log
echo -n " ON SYSTEM: " >>$Log
uname -a  >> $Log
echo -n "Known as: " >> $Log
hostname  >> $Log
echo -n "OS Version : " >>$Log
cat /etc/os-release | grep PRETTY | cut -c14-43 >>$Log

echo -n "Uptime: " >>$Log
uptime >>$Log
echo "Pi Details:" >> $Log
cat /proc/cpuinfo >> $Log

echo -n "CPU  " >> $Log
CPU_temp=$(vcgencmd measure_temp 2>&1) 
echo $CPU_temp  >> $Log
echo >> $Log

echo "Memory free space  table : " >> $Log

free -o -h >> $Log
ls /etc/octopi_version 2>&1

if [ $? -eq 0 ]
   then

    echo "Octoprint Version:"  `cat /etc/octopi_version`  >> $Log
    else

   echo "Octoprint not installed." >> $Log 

fi


Python_ver=$(python --version 2>&1)

if [ $? -eq 0 ]
   then
 
    echo "Python version: " $Python_ver >> $Log

   else
   echo "Python not installed." >>$Log


fi
Apache_ver=$(apache2 -v 2>&1)

if [ $? -eq 0 ] 
   then
   echo "Apache version: " $Apache_ver    >> $Log
   else
   echo "Apache not installed. " >>$Log

fi

Php_ver=$(php -v 2>&1)
if [ $? -eq 0 ] 
   then
   echo "PHP Version: " $Php_ver  >> $Log
   else
   echo "PHP not installed." >>$Log

fi


# GPIO_ver=$(gpio -v 2>&1 | head -n1)
gpio -v 2>&1
if [ $? -ne 0 ] 
   then
    echo "gpio Utility not installed." >>$Log
   else
    GPIO_ver=$(gpio -v 2>&1 | head -n1)
    echo "gpioutility Version: "  $GPIO_ver >> $Log

    echo "GPIO Pin settings: "  >> $Log
    gpio readall >> $Log 
    echo ""  >> $Log
#    else
#    echo "gpio Utility not installed." >>$Log
#     gpio readall >> $Log

fi

echo "Disk Space:" >> $Log
sudo df -h >> $Log 
echo "</system>">> $Log

#lsusb data
echo "<usb>" >> $Log
#echo "  LSUSB OUPUT:" >> $Log
sudo lsusb >>  $Log
echo "</usb>" >> $Log

#lsmod data
echo "<lsmod>" >> $Log
#echo "  LSMOD OUPUT:" >> $Log
sudo lsmod >>  $Log
echo "</lsmod>" >> $Log

#wifi data
echo "<wifi>" >>$Log
#echo  " NETWORK OUTPUT: " >>$Log
echo "<ifconfig>" >>$Log
ifconfig >> $Log
echo "</ifconfig>" >>$Log

ifconfig | grep wlan0
if [ $? -eq 0 ]
   then
   echo "<wpa_cli>" >> $Log
   sudo wpa_cli scan >> $Log && sudo wpa_cli scan_results >> $Log
   echo "</wpa_cli>" >>$Log
   echo "<iwlist>" >>$Log
   sleep 5
# Above sleep added for P3.
   sudo iwlist wlan0 scan >>$Log
   else
   echo "No wlan0 configured. " >>$Log
fi

echo "</iwlist>" >>$Log
echo "</wifi>" >>$Log

echo "<SysLog>">> $Log
 
# sed command to strip out lt and & issues
tail -100 /var/log/syslog  | sed -e 's~&~\&amp;~g' -e 's~<~\&lt;~g' >> $Log
#echo $SysLog >> $Log
echo "</SysLog>" >> $Log


#dmesg data
echo "<dmesg>" >> $Log
echo " DMESG OUTPUT:  " >>$Log
dmesg -l info | sed -e 's~&~\&amp;~g' -e 's~<~\&lt;~g'  >> $Log
echo "</dmesg>" >> $Log

#/var/log/syslog last 100 lines only




echo " End of data captured. " >>$Log

#Closing tag
echo "</log>" >> $Log


# Now seeing if we can send the file to pastebin.com or get the user 
# to manually paste the details in.

Result=$(ping -c 2 -t 30 www.pastebin.com 2>&1)

# Added extra time as pinging www.pastebin.com became sluggish during coding.


	
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
