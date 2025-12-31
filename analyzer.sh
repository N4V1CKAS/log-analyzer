#!/bin/bash
# Exit on error..
set -euo pipefail

# Variables!!
CHOICE=""
LOG=""
ACCESS_LOG="/var/log/nginx/access.log"
ERROR_LOG="/var/log/nginx/error.log"
RESULTS=""
CUSTOM_LOG=""

# Interactive Menu :D
echo "=================================================================="
echo "	Quick & Easy Log Analyzer - Danielius Navickas"
echo "			Ubuntu - Dec 2025"
echo "=================================================================="
echo

# What to check??
echo "Pick a log to analyze"
echo "1) /var/log/syslog (system messages)"
echo "2) /var/log/auth.log (login attempts)"
echo "3) Nginx server access/error (web server logs)"
echo "4) Custom path"
echo
read -p "Please enter your choice [1-4]: " CHOICE

# Actual log check process here
# Using -f with zcat makes sure that both plain and compressed logs (.gz) are all handled seamlessly!
# -iah with zgrep avoids "binary file matches" errors and removes filename headers
case $CHOICE in
1)
	# Syslog option
	clear
	LOG="/var/log/syslog"
	echo "Analyzing $LOG..."
	echo

	# Show last 50 lines of syslog, including rotated logs
	echo "Last 50 lines:"
	zcat -f ${LOG}* | tail -n 50
	echo

	# Highlight errors, warnings and failure in logs
	echo "Errors/Warnings (last 20 lines):"
	zgrep -iah --color=always -E "error|warn|failed|critical" ${LOG}* | tail -n 20
	echo

	# Show top 10 most repeated messages for easier recognition
	echo "The top 10 most repeating messages:"
	zcat -f ${LOG}* | tail -n 1000 | cut -d' ' -f5- | sort | uniq -c | sort -nr | head -10
	;;

2)
	# Auth log option
	clear
	LOG="/var/log/auth.log"
	echo "Analyzing $LOG..."
	echo

	echo "Failed login attempts (last 50)"
	zgrep -iah "Failed password" ${LOG}* | tail -n 50
	echo

	echo "Invalid users tried:"
	RESULTS=$(zgrep -iah "invalid user" ${LOG}* | awk '{print $8}' | sort | uniq -c | sort -nr | head -10)
	if [[ -z "$RESULTS" ]]; then
		echo "No invalid user attempts found."
	else
		echo "$RESULTS"
	fi

	echo "Top IP addresses (failed logins):"
        zgrep -iah "Failed password" ${LOG}* | awk '{print $11}' | sort | uniq -c | sort -nr | head -10
	;;

3)
	# Nginx log option
	clear
	echo "Analyzing Nginx logs..."
	echo

	if [[ -f "$ACCESS_LOG" ]]; then
		echo "Access log, last 30 messages"
		tail -n 30 "$ACCESS_LOG"
		echo

		echo "Top 10 IPs accessing the server:"
		RESULTS=$(awk '{print $1}' "$ACCESS_LOG" | sort | uniq -c | sort -nr | head -10)
		if [[ -z "$RESULTS" ]]; then
    			echo "No IPs found"
		else
			echo "$RESULTS"
		fi
	else
		echo "No access.log found!"
		read -p "Press Enter to exit.."
		exit 1
	fi

	echo

	if [[ -f "$ERROR_LOG" ]]; then
		echo "Error log, last 20 messages"
		tail -n 20 "$ERROR_LOG"
	else
		echo "No error.log found!"
		read -p "Press Enter to exit.."
		exit 1
	fi
	;;

4)
	# The custom log option
	clear
	read -p "Enter your full path to your desired log file: " CUSTOM_LOG
	if [[ ! -f "$CUSTOM_LOG" ]]; then
		echo "File not found"
		read -p "Press Enter to exit..."
		exit 1
	fi

	echo "Analyzing $CUSTOM_LOG"
	echo
	tail -n 50 "$CUSTOM_LOG"
	echo

	RESULTS=$(grep -iah --color=always -E "error|warn|fail|critical" "$CUSTOM_LOG" 2>/dev/null | tail -n 20)
	if [[ -z "$RESULTS" ]]; then
		echo "No warnings found"
		read -p "Press Enter to exit.."
		exit 1
	else
		echo "$RESULTS"
	fi
	;;

*)
	# Invalid option...
	echo "Invalid choice!"
	read -p "Press Enter to exit.."
	exit 1
esac

# Finishing message
echo
echo "Analysis has been completed!"
echo
read -p "Press Enter to exit.."
exit 1

