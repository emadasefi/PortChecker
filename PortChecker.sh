#!/bin/bash

# Colors
Purple='\033[0;34m'
Cyan='\033[0;36m'
Yellow='\033[0;33m'
NC='\033[0m'


# Get the hostname and current date and time
current_time=$(date '+%Y-%m-%d %H:%M:%S')
hostname=$(hostname)
localip=$(hostname -I)


# Print the ASCII art and message
echo -e "${Cyan}
   ___           __  _______           __          
  / _ \___  ____/ /_/ ___/ /  ___ ____/ /_____ ____
 / ___/ _ \/ __/ __/ /__/ _ \/ -_) __/  '_/ -_) __/
/_/   \___/_/  \__/\___/_//_/\__/\__/_/\_\\__/_/   
                                                   
"
echo -e "
  - Port Checker Script
  - The Port Checker Script is a Bash utility that provides an overview of active network connections on a Linux system. 
    It uses the netstat command to gather and format key information about each connection
  - v1.1 / Emad Asefi / @emadasefi / emad.asefi@gmail.com
  ${Yellow}||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  ||| Execution Time : $current_time
  ||| Hostname : $hostname
  ||| Local IP Address : $localip
  ||||||||||||||||||||||||||||||||||||||||||||||||||||||||
${NC}"


# Get the netstat output and format it
netstat_output=$(sudo netstat -tulpn | awk 'NR>2 {print $1, $4, $7, $5, $6}')


# Prepare the table header with fixed column widths
printf "|------------|-------------------|----------------------|---------------------|-----------|------------------------------|\n"
printf "| %-10s | %-17s | %-20s | %-18s | %-10s | %-30s|\n" "Protocol" "Local Address" "PID/Program Name" "Foreign Address" "State" "Location"
printf "|------------|-------------------|----------------------|---------------------|-----------|------------------------------|\n"


# Process each line of the netstat output
while read -r line; do
    # Extract fields using awk
    proto=$(echo "$line" | awk '{print $1}')
    local_addr=$(echo "$line" | awk '{print $2}')
    pid_program=$(echo "$line" | awk '{print $3}' | cut -d'/' -f2)
    foreign_addr=$(echo "$line" | awk '{print $4}')
    state=$(echo "$line" | awk '{print $5}')
    
    # Get the location of the program (assuming it's in /proc)
    location=$(which "$pid_program" 2>/dev/null || echo "Not found")
    
    # Print the formatted output with fixed column widths
    printf "| %-10s | %-17s | %-20s | %-18s | %-10s | %-30s|\n" "$proto" "$local_addr" "$pid_program" "$foreign_addr" "$state" "$location"
done <<< "$netstat_output"


#printf "|            |                   |                      |                     |           |                              |                         |\n"
printf "|-------------------------------------------------------------------------------------------------------------------------|\n"
printf "\n"


