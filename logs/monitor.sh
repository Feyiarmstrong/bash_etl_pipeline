#!/bin/bash

LOG_DIR=~/data_pipeline/logs
SUMMARY_LOG=$LOG_DIR/monitor_summary.log

# Search for errors in preprocess.log
if grep -i -E "ERROR|failed" $LOG_DIR/preprocess.log > /tmp/error_check.txt; then
    echo "$(date): Errors found in preprocessing log:" >> $SUMMARY_LOG
    cat /tmp/error_check.txt >> $SUMMARY_LOG
    echo "----" >> $SUMMARY_LOG
    echo "Errors detected. Check $SUMMARY_LOG for details."
else
    echo "$(date): No errors found." >> $SUMMARY_LOG
    echo "No errors found in preprocessing."
fi



# cleanup temp
rm -f /tmp/error_check.txt
