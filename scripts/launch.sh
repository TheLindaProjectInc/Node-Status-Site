#!/usr/bin/env bash

user="root"
daemonDir="/var/www/nodesite/scripts"

#Does not need to change per server
tmuxFile="/tmp/mrxc"

#Must be unique per server
tmuxName="mrxsite"

pyFile="daemon.py"
pyArgs="-m prod"


#############################
#DO NOT EDIT BELOW THIS LINE#
#############################

function sendk {
    sudo -u $user tmux -S $tmuxFile send-keys -t $tmuxName $1
}

function send {
    sudo -u $user tmux -S $tmuxFile send -t $tmuxName $1
}

case "$1" in
start)
#echo "If you have added any new files Ctrl-C NOW and run fixpermissions first!"
#sleep 2
echo "Starting Daemon..."
$0 fixpermissions
sleep 1
sudo -u $user tmux -S $tmuxFile new-session -s $tmuxName -d "cd $daemonDir; python3 $pyFile $pyArgs"
sleep 1
echo "Daemon Started."
;;
stop)
stat=$(sudo -u $user ps -ef | grep "daemon.py" | grep -v grep | awk '{print $2}')
echo "Stopping.. $stat"
sudo -u $user ps -ef | grep "daemon.py" | grep -v grep | awk '{print $2}' | sudo -u $user xargs kill
sleep 1
echo "Daemon Stopped."
;;
restart)
$0 stop
echo "Waiting 5 seconds..."
sleep 5
$0 start
echo "Daemon Restarted."
;;
attach)
echo "Attaching..."
echo "Press CTRL-b then d to detach"
sleep 1
sudo -u $user tmux -S $tmuxFile attach -t $tmuxName
;;
fixpermissions)
chown -R $user:$user $daemonDir
chown $user:$user $tmuxFile
chmod -R g+rw $daemonDir
;;
*)
echo "Command Arguments: start,stop,restart,attach,fixpermissions"
;;
esac
