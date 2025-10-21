# What this program does:
# it simply logs whenever the downloads folder has been changed

# How this program will work:
# 1) declare  our directory
# 2) notify when the directory gets updated
# 3) echo the event results

DIRECTORY="/home/$USER/Downloads"
COMMAND="inotifywait -m -r -e modify,attrib,move,create,delete \"$DIRECTORY\""

eval $COMMAND | while read full_path events file_name; do
    echo "[$events] $file_name"
done
