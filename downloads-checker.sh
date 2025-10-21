# How this program will work:
# 1) declare where our downloads directory is located
# 2) notify when the downloads directory gets 
# 3) echo the event results

DIRECTORY="/home/$USER/Downloads"
COMMAND="inotifywait -m -r -e modify,attrib,move,create,delete \"$DIRECTORY\""

eval $COMMAND | while read full_path events file_name; do
    echo "[$events] $file_name"
done
