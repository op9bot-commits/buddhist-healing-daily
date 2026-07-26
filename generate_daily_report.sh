#!/bin/bash
# generate_daily_report.sh
# Generates the Buddhist healing daily report for today
# Usage: ./generate_daily_report.sh [date]  (defaults to today in Asia/Shanghai)
set -euo pipefail

cd "$(dirname "$0")"

TODAY="${1:-$(TZ=Asia/Shanghai date +%Y-%m-%d)}"
REPORT_FILE="日报/${TODAY}.md"
TEMPLATE_FILE="模板.md"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "ERROR: $TEMPLATE_FILE not found" >&2
    exit 1
fi

echo "Generating report for $TODAY..."
echo "Template: $TEMPLATE_FILE"
echo "Output: $REPORT_FILE"
