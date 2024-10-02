#!/bin/bash

# Colors
Purple='\033[0;34m'
Cyan='\033[0;36m'
Yellow='\033[0;33m'
NC='\033[0m'
####################################################
# Get the hostname and current date and time
current_time=$(date '+%Y-%m-%d %H:%M:%S')
hostname=$(hostname)
####################################################
# Get the netstat output and format it
netstat_output=$(sudo netstat -tulpn | awk 'NR>2 {print $1, $4, $7, $5, $6}')
####################################################
# Prepare the table header with fixed column widths
printf "|------------|-------------------|----------------------|---------------------|-----------|------------------------------|\n"
printf "| %-10s | %-17s | %-20s | %-18s | %-10s | %-30s|\n" "Protocol" "Local Address" "PID/Program Name" "Foreign Address" "State" "Location"
printf "|------------|-------------------|----------------------|---------------------|-----------|------------------------------|\n"
####################################################
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
####################################################
#printf "|            |                   |                      |                     |           |                              |                         |\n"
printf "|-------------------------------------------------------------------------------------------------------------------------|\n"
printf "\n"
####################################################
# Print the execution time and hostname in the last row
echo -e "| ||||||| Execution Time : $current_time"
echo -e "| ||||||| Hostname : $hostname"
echo -e "${Cyan}| ||||||| Author : Emad Asefi <emad.asefi@gmail.com>"
echo -e "${NC}"