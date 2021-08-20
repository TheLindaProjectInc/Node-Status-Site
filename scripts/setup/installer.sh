#!/usr/bin/env bash

#############################

# Coin Name Info
coin="metrixcoin"
name="metrix"

# User to run as..
user="root"

# Coin File Paths for install
url_github="https://github.com/TheLindaProjectInc/Metrix/releases/download/4.0.7.0/"
update_file="metrix-linux-x64.tar.gz"
update_path="./"

# Node Site app github repo
app_git="https://github.com/TheLindaProjectInc/Node-Status-Site.git"


#############################
#############################

site="node.metrix.tips"

app="nodesite"
homeDir="/var/www/${app}/"

rpc_name="tips"
conf="${name}.conf"

# Executable Names
coinDaemon="${name}d"
coinCli="${name}-cli"

# Pathing Variables
rootDir=""
dataDir=".${coin}"
coinPathDae="${dataDir}/${coinDaemon}"
coinPathCli="${dataDir}/${coinCli}"

# Server Host Info
installer="node-install/"
server="http://gir.sqdmc.net/dev/${coin}/"

# Nginx setup
nginxConf="scripts/setup/${app}.nginx"

# Needs these packages
libZip="unzip"
libTmux="tmux"
libPip3="python3-pip"

#############################
#DO NOT EDIT BELOW THIS LINE#
#############################

#Colors
nc='\033[0m'
black='\033[0;30m'
dark_gray='\033[1;30m'
red='\033[1;31m'
dark_red='\033[0;31m'
green='\033[1;32m'
dark_green='\033[0;32m'
gold='\033[0;33m'
yellow='\033[1;33m'
blue='\033[0;34m'
light_blue='\033[1;34m'
purple='\033[0;35m'
magenta='\033[1;35m'
cyan='\033[0;36m'
light_cyan='\033[1;36m'
gray='\033[0;37m'
white='\033[1;37m'

# Console message functions
function msg {
    echo -e "${1}${nc}"
}
function msgc {
    echo -e "${2}${1}${nc}"
}

#############################

# tmux shell commands
function sendk {
    sudo -u $user tmux -S $tmuxFile send-keys -t $tmuxName $1
}

function send {
    sudo -u $user tmux -S $tmuxFile send -t $tmuxName $1
}

#############################

# Gets the platform we are running on.
function getPlt {
  if [ "$(uname)" == "Darwin" ]; then
      echo 1
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      echo 0
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
      echo 1
  elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
      echo 1
  elif [ "$(expr substr $(uname -s) 1 6)" == "CYGWIN" ]; then
      echo 1
  fi
}

############

function packageCheck() {
    if [ `getPlt` == 0 ]; then
      #msgc "Running on Linux.." $gold
      msgc "> Package '${libZip}' Check..." $gold
      if [ $(dpkg-query -W -f='${Status}' $libZip 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
          msgc "> Package '$libZip' is Required!" $yellow
          msgc ">> Attempting to install.." $gold
          sudo apt-get update && sleep 1
          sudo apt-get install -y $libZip
      fi
      if [ $(dpkg-query -W -f='${Status}' $libZip 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
          msgc "> Package '$libZip' Found." $dark_green
          echo ""
      else
          echo ""
          msgc "> Package '$libZip' install failed!" $red
          sleep 1
          msgc "Install Aborted!" $yellow
          exit 1
      fi
    fi

    if [ `getPlt` == 0 ]; then
      #msgc "Running on Linux.." $gold
      msgc "> Package '${libTmux}' Check..." $gold
      if [ $(dpkg-query -W -f='${Status}' $libTmux 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
          msgc "> Package '$libTmux' is Required!" $yellow
          msgc ">> Attempting to install.." $gold
          sudo apt-get update && sleep 1
          sudo apt-get install -y $libTmux
      fi
      if [ $(dpkg-query -W -f='${Status}' $libTmux 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
          msgc "> Package '$libTmux' Found." $dark_green
          echo ""
      else
          echo ""
          msgc "> Package '$libTmux' install failed!" $red
          sleep 1
          msgc "Install Aborted!" $yellow
          exit 1
      fi
    fi

    if [ `getPlt` == 0 ]; then
      #msgc "Running on Linux.." $gold
      msgc "> Package '${libPip3}' Check..." $gold
      if [ $(dpkg-query -W -f='${Status}' $libPip3 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
          msgc "> Package '$libPip3' is Required!" $yellow
          msgc ">> Attempting to install.." $gold
          sudo apt-get update && sleep 1
          sudo apt-get install -y $libPip3
      fi
      if [ $(dpkg-query -W -f='${Status}' $libPip3 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
          msgc "> Package '$libPip3' Found." $dark_green
          echo ""
      else
          echo ""
          msgc "> Package '$libPip3' install failed!" $red
          sleep 1
          msgc "Install Aborted!" $yellow
          exit 1
      fi
    fi
}

############

function installNode() {
  if [ `getPlt` == 0 ]; then
    cd /var/www/
  else
    cd /c/
    mkdir -p var/www/
    cd /c/var/www/
  fi
  if [ -d "${app}" ]; then
    msgc "-- Node Install Found --" $green
  else
    msgc "-- Node Install Not Found --" $red

    mkdir -p ${app}
    cd ${app}

    git clone ${app_git} ${app}
    msgc "> NodeSite Installed!" $green
    sleep 1

    pip3 install cherrypy
    msgc "> Cherrypy Installed!" $green

    cd "scripts/"
    chmod 555 launch

    #./launch start
    python3 daemon.py -m debug
    sleep 3

    msgc "> Setup Defaults!" $green

    cd /var/www/${app}/.env
    #sed -i 's/var=.*/var=new_value/' conf.json

    sed -i "s/RPC_USERNAME/${rpc_name}/g" conf.json
    sed -i "s/RPC_PASSWORD/${pass}/g" conf.json

    sleep 1

    msgc "> Node Setup Complete!" $green

  fi
}

############

function setupNginx() {
  if [ -d "/var/www/" ]; then
    msgc "> Found nginx!" $green
    if [ -f "/etc/nginx/sites-enabled/nodesite" ]; then
      msgc "> Already Setup nginx!" $green
    else
      cd ${homeDir}

      mv ${nginxConf} /etc/nginx/sites-enabled/${app}
      sed -i "s/SERVER_NAME/${site}/g" /etc/nginx/sites-enabled/${app}

      sleep 1
      nginx -s reload
      msgc "> Setup nginx for nodesite!" $green
    fi
  else
    msgc "> Unable to find nginx!" $red

    apt install nginx -y

    cd ${homeDir}

    mv ${nginxConf} /etc/nginx/sites-enabled/${app}
    sed -i "s/SERVER_NAME/${site}/g" /etc/nginx/sites-enabled/${app}

    sleep 1
    nginx -s reload

    msgc "> Setup nginx!" $green

  fi
}

################################################

echo ""
msgc "-------------------------" $dark_green
msgc "-------- READY ----------" $green
msgc "-------------------------" $dark_green

pass=$(< /dev/urandom tr -dc A-Za-z0-9_ | head -c17)
msgc "- RPC Password Generated " $green
sleep 2

############

msgc "> Do you wish to check & setup nginx? (Y/n)" $magenta
read -p '> Setup nginx: ' setup_nginx

if [${setup_nginx} == "y"] || [${setup_nginx} == "Y"]; then
    echo ""
    msgc "-------------------------" $dark_green
    msgc "-------------------------" $dark_green
    msgc "> Pleaes enter site FQDN" $magenta
    read -p '> Site: ' site

    msgc ">> NodeSite FQDN: '${cyan}${site}${green}'" $green
    sleep 1

    setupNginx
    sleep 1
fi

############

packageCheck
msgc "> Packages Installed" $green
sleep 1

installNode
sleep 1

############

msgc "-------------------------" $dark_green
msgc "- NodeSite Install Done -" $green
msgc "-------------------------" $dark_green
exit 0
