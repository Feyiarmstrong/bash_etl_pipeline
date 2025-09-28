#!/bin/bash

# Paths
INPUT=~/data_pipeline/input/sales_data.csv
OUTPUT=~/data_pipeline/output/cleaned_sales_data.csv
LOG=~/data_pipeline/logs/preprocess.log

# Preprocess: remove last column, filter out Failed rows
awk -F',' 'BEGIN{OFS=","}
NR==1 {print $1,$2,$3,$4,$5,$6; next}
$6!="Failed" {print $1,$2,$3,$4,$5,$6}' "$INPUT" > "$OUTPUT" 2>> "$LOG"

# Success message
echo "Data preprocessing completed. Clean file saved to $OUTPUT" | tee -a "$LOG"
