#!/bin/bash

# Remove column 7, filter out Failed rows, and save as CSV
awk '{$7=""; print $0}' ~/data_pipeline/input/sales_data.csv \
| awk '$5 != "Failed"' \
| awk 'BEGIN{OFS=","} {$1=$1; print}' \
> ~/data_pipeline/output/cleaned_sales_data.csv

# Print success message
echo "Preprocessing complete. Cleaned data saved to ~/data_pipeline/output/cleaned_sales_data.csv"

# Log action
echo "$(date): Preprocessing completed successfully" >> ~/data_pipeline/logs/preprocess.log
