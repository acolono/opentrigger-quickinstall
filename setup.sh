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

case "$STAGE" in
	dev|development) sudo apt-get install -y opentrigger-dev
	prod|production|"") sudo apt-get install -y opentrigger
	lite) sudo apt-get install -y opentrigger --no-install-recommends
esac

sudo reboot