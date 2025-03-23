#!/bin/bash

echo "Fetching METAR data..."
curl -sL "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json

# If the file is empty, exit
if [ ! -s aviation.json ]; then
  echo "❌ Failed to fetch data. aviation.json is empty."
  exit 1
fi

# Print first 6 receipt times
jq -r '.[].receiptTime' aviation.json | head -n 6

# Compute average temperature
temps=$(jq '.[].temp' aviation.json)
total=0
count=0

for t in $temps; do
  total=$(echo "$total + $t" | bc)
  count=$((count + 1))
done

avg=$(echo "scale=2; $total / $count" | bc)
echo "Average Temperature: $avg"

# Determine mostly cloudy
cloudy=$(jq -r '.[].clouds' aviation.json | grep -v "CLR" | wc -l)
mostly_cloudy=false
if [ "$cloudy" -gt 6 ]; then
  mostly_cloudy=true
fi

echo "Mostly Cloudy: $mostly_cloudy"
