#!/bin/bash

## wget -qO- https://acolono.github.io/opentrigger-quickinstall/setup.sh | bash
## wget -qO- https://get.opentrigger.com/setup.sh | bash

set -e

export DEBIAN_FRONTEND=noninteractive

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list

sudo wget -O /etc/apt/sources.list.d/mosquitto.list http://repo.mosquitto.org/debian/mosquitto-jessie.list
wget -qO- http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key | sudo apt-key add -

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "deb http://dl.bintray.com/ao/opentrigger jessie main" | sudo tee /etc/apt/sources.list.d/opentrigger.list

sudo apt-get update
sudo apt-get -y dist-upgrade

aptinstall (){
	sudo apt-get install -y -o Dpkg::Options::="--force-confnew" $*
}

enablenodered (){
	sudo systemctl enable nodered.service
}

askforreboot (){
	unset DEBIAN_FRONTEND
	echo "Your raspberry has to be disconnected from the power source to finish installation."
	read -p "Shutdown now (y/n)? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		echo "Some services will not be available..."
	else
		sudo poweroff
	fi
}

case "$STAGE" in
	dev|development) 
		aptinstall opentrigger-dev
		enablenodered
		askforreboot
		;;
	lite) 
		echo "available packages:"
		apt-cache pkgnames | grep '^opentrigger'
		;;
	prod|production|*) 
		aptinstall opentrigger
		enablenodered
		askforreboot
		;;
esac
