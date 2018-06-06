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
#       1) Added sed script to format less-than and ampersand and double ampersand issues
#      obtained from here: http://daemonforums.org/showthread.php?t=4054 
#   2) Changed xml headers and point to a local xsl file instead of a domain file. This
#          works on Safari, but not on Chrome. The file must be in the same directory as the 
#          xml file for it to format nicely. Also change the text (.txt) file to xml (.xml).
# Bumped to 2.0.6 3/20/17 Added error checking to all commands to make the output  look
# more profressional. Also did an check on the lan configuration to see if Wifi  was set up.
# Bumped to 2.0.7 3/26/17 some more formag tidying.
# Bumped to 2.0.8 3/28/17 Added os release version and uptime count.
# Bumped to 2.0.9 6/1/17 Added iwgetid to indicate the WIFI connected to. Fixed upload 
# issue by making double ampersand and less than symbols words instead. The earlier
# fix didn't help the pastebin upload.
# Restructered code into functions  to allow  ease of future mods. Added pass in parameters:
# a = all
# l = logs
# n = network
# s= system  plus software
# h = simple help string.
# This is now version 3.0.0
# Adding Octoprint log 3.0.1
# Fixed Octoprint Version number search 3.0.2
# Below all added on 12/10/17
# Fixed free command. the option -o has been removed.
# Added node version.
# Added homebridge version.
# Added python version which I missed out from the beiggining - duh!
# Added Vers variable for version reference to be used in help and the log file.
# This is now version 3.0.3
# Added support for the MEGAIO board and test for I2C set up
# This is now version 3.0.4
# Added  homebridge config.json file and first 100 lines of the homebridge log can be huge.
# 3/16/18  bumped to 3.0.5
# Gitlab Test from Github desktop client
#
#
#
#




# Notes:
# pastebin not getting a complete upload...  <- fixed 2.0.9!!!


Vers=3.0.5

# A POSIX variable
OPTIND=1 
# Initialize our own variables:







if [[ $# -eq 0 ]]; then
       echo "diag_info takes parameters: h = help; a = all; n = network; s = system ; i = hardware info; l = logs" 
       echo "Example diag_info  -s  would grab system and software information only." 
       echo "Version: " $Vers
      exit 0
fi
# Start of functions:

function system {
	echo "system"
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
	echo "Memory free space  table : " >> $Log
	free  >> $Log
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

#check for I2C
    echo "<I2C>" >> $Log
    sudo i2cdetect -y 1 2>&1
    if [ $? -ne 0 ]
    then
            echo "I2C utilities not installed or I2C not set up." >> $Log
    else
           sudo i2cdetect -y 1  >> $Log
    fi
    echo "</I2C>" >> $Log
		
    echo "<software>" >> $Log
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
	
#Check for megaio software  installation
    echo "<megaio>" >> $Log
    megaio -v 2>&1
    if [ $? -ne 0 ]
    then
          echo "megaio software not installed" >> $Log
    else
          megaio -v >> $Log
#Four boards maximum      
          for ((i=0; i <4 ; i++))
            do
#             echo "Number $i:"
             megaio  $i  board >> $Log
         done      
       
       
       
       
    fi
    echo "</megaio>" >> $Log
       
       
	
	

#	ls /etc/octopi_version 2>&1
        ls ~/oprint/local/bin/octoprint 
	if [ $? -eq 0 ]
   	then

#    		echo "Octoprint Version:"  `cat /etc/octopi_version`  >> $Log
                echo "Octoprint Version: " `tail -2 ~/oprint/local/bin/octoprint | cut -c38-42` >> $Log
#                echo " Current Octoprint Log: " >>$Log    
                cat /home/pi/.octoprint/logs/octoprint.log >> $Log
                echo "===End of Octoprint Log===" >> $Log


    	else

   		echo "Octoprint not installed." >> $Log 

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

        Node_ver=$(node --version 2>&1)
	if [ $? -eq 0 ] 
        then
                echo "Node  Version: " $Node_ver  >> $Log
        else
                echo "node not installed." >>$Log

        fi

        HB_ver=$(homebridge --version)
        if [ $? -eq 0 ] 
        then
                echo "Homebridge  Version: " $HB_ver  >> $Log
        else
                echo "homebridge  not installed." >>$Log

        fi

        ls /home/pi/.homebridge/config.json 2>&1
        if [ $? -eq 0 ]
        then
                echo " Homebridge Config file found:" >> $Log
                cat /home/pi/.homebridge/config.json >>  $Log
                echo "===End of Homebridge config file ===" >> $Log
        fi

        Python_ver=$(python --version 2>&1 )
        if [ $? -eq 0 ] 
        then
                echo "Python   Version: " $Python_ver  >> $Log
        else
                echo "Python  not installed." >>$Log

        fi

	echo "</software>" >>$Log
}

function network  {
	echo "network"

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
   		echo -n "Currently connected to WIFI: " >>$Log
   		sudo  iwgetid  -r  >> $Log
   	else
   		echo "No wlan0 configured. " >>$Log
	fi

	echo "</iwlist>" >>$Log
	echo "</wifi>" >>$Log

}

function hardware {
	echo "<hardware>" >> $Log
	echo "Pi Details:" >> $Log
	cat /proc/cpuinfo >> $Log

	echo -n "CPU  " >> $Log
	CPU_temp=$(vcgencmd measure_temp 2>&1) 
	echo $CPU_temp  >> $Log
	echo >> $Log
	echo "</hardware>" >> $Log
}

function logs {
#	echo "Logs" >> $Log
# Adding Octoprint to Log section if Octoprint is present
	ls /etc/octopi_version 2>&1

        if [ $? -eq 0 ]
        then

                echo "Octoprint Version:"  `cat /etc/octopi_version`  >> $Log
                echo " Current Octoprint Log: " >>$Log    
                cat /home/pi/.octoprint/logs/octoprint.log >> $Log
                echo "===End of Octoprint Log===" >> $Log
        fi
        
	ls /home/pi/homebridge.log 2>&1
	if [ $? -eq 0 ]
	then
		echo " Homebridge Config file found copying first 100 lines:" >> $Log
                head  -n100 /home/pi/homebridge.log >>  $Log
               echo "===End of Homebridge config file ===" >> $Log
        fi
        echo "<SysLog>">> $Log
 
# sed command to strip out lt and & issues
	tail -100 /var/log/syslog  | sed -e 's~&~\AND~g' -e 's~<~\LESSTHAN~g' >> $Log
#echo $SysLog >> $Log
	echo "</SysLog>" >> $Log


#dmesg data
	echo "<dmesg>" >> $Log
	echo " DMESG OUTPUT:  " >>$Log
	dmesg -l info | sed -e 's~&~\AND~g' -e 's~<~\LESSTHAN~g'  >> $Log
	echo "</dmesg>" >> $Log


}



# Main code starts here:


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
echo $Vers  >> $Log



while getopts "h?ansil" opt; do
    case "$opt" in
    h|\?)
        echo "diag_info takes parameters: a = all; n= network; s= system ; i= hardware info, l = logs" 
        exit 0
        ;;
    a)  system
	hardware
	network
	logs
        echo " Option = a; Collecting all information."  >>$Log
        ;;
    n)  network
        echo " Option = n; Collecting network  information."  >>$Log
        ;;
    i)  hardware
        echo " Option = h; Collecting Pi hardware  information."  >>$Log
        ;;
    s)  system
        echo " Option = s; Collecting Pi system and software information."  >>$Log
        ;;
    l)  logs
        echo " Option = l; Collecting log  information."  >>$Log
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

#echo "all=$all, network=$network, system=$system, hardware=$hardware, logs=$logs"

echo " End of data captured. " >> $Log

#Closing tag
echo "</log>" >> $Log
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
 	echo " The whole file may not get transmitted to pastebin. So please save it in case the requester needs more information"



fi






# End of file
