# Data Processing Pipeline (Bash + Cron)

This project implements a simple data processing pipeline using Linux commands and Bash scripts.  
It covers file manipulation, automation, permissions management, scheduling with cron, and logging.  

---

## Project Structure

data_pipeline/
├── input/        # Raw data files
├── output/       # Cleaned data output
├── logs/         # Logs of preprocessing and monitoring
├── preprocess.sh # Script to clean data
├── monitor.sh    # Script to check logs for errors

---

## 1. Environment Setup

Connected to a Linux VM and created directories for pipeline organization:

mkdir -p ~/data_pipeline/input
mkdir -p ~/data_pipeline/output
mkdir -p ~/data_pipeline/logs

---

## 2. Data Ingestion & Preprocessing

### Preprocessing Script: preprocess.sh

The script does the following:

Removes the last column (extra_col)  
Filters out rows where status = Failed  
Saves cleaned data as:
~/data_pipeline/output/cleaned_sales_data.csv

- Logs actions in:
- ~/data_pipeline/logs/preprocess.log
- Prints a success message

### Example "preprocess.sh" content

#!/bin/bash

INPUT = ~/data_pipeline/input/sales_data.csv
OUTPUT = ~/data_pipeline/output/cleaned_sales_data.csv
LOG = ~/data_pipeline/logs/preprocess.log

awk -F',' 'BEGIN{OFS=","} 
NR==1 {print \$1,\$2,\$3,\$4,\$5,\$6; next} 
\$6!="Failed" {print \$1,\$2,\$3,\$4,\$5,\$6}' "\$INPUT" > "\$OUTPUT" 2>> "\$LOG"

echo "Data preprocessing completed. Clean file saved to \$OUTPUT" | tee -a "\$LOG"

### Make script executable
chmod +x preprocess.sh

---

## 3. Automate with Cron Jobs

Scheduled the preprocessing job to run daily at 12AM.

Open cron editor:

crontab -e

Add this line:
0 0 * * * /home/<user>/data_pipeline/preprocess.sh >> /home/<user>/data_pipeline/logs/preprocess.log 2>&1


Confirm scheduled jobs:
crontab -l

---

## 4. Logging & Monitoring

### Monitoring Script: "monitor.sh"

The script scans logs for "error" or "failed".  
If found, it prints them to the terminal and writes them to a summary log.

#!/bin/bash

LOG_DIR=~/data_pipeline/logs
SUMMARY_LOG="\$LOG_DIR/summary.log"

grep -i -E "error|failed" "\$LOG_DIR"/*.log > "\$SUMMARY_LOG"

if [ -s "\$SUMMARY_LOG" ]; then
    echo "Errors found! See \$SUMMARY_LOG:"
    cat "\$SUMMARY_LOG"
else
    echo "No errors detected in logs."
fi

Make executable:

chmod +x monitor.sh

### Schedule monitoring job (daily at 12:05AM)

5 0 * * * /home/<user>/data_pipeline/monitor.sh >> /home/<user>/data_pipeline/logs/monitor.log 2>&1

---

## 5. Permissions & Security

- Restrict input folder: writable only by the current user
  
chmod 700 ~/data_pipeline/input


- Restrict logs: readable only by authorized users  

chmod 600 ~/data_pipeline/logs/*.log


---

## Summary

This pipeline demonstrates:
Organizing data workflows with Linux directories
Data preprocessing using awk
Automation using cron
Logging and error monitoring with Bash
Securing files with Linux permissions

A simple yet practical example of a data engineer’s daily toolkit.
