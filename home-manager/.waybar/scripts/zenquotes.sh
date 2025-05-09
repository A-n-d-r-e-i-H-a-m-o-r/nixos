
quote_data=$(curl -s "https://zenquotes.io/api/today")

if [ -n "$quote_data" ]; then
    echo "$quote_data"
else
    echo '[{"q":"Connection error. Wisdom pending.", "a":"Unknown"}]'
fi
