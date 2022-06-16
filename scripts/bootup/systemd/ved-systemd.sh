#!/bin/bash
#
# Systemd installation script for VED (main branch)
#
# Author:
#  - Adam 'pi3' Zabrocki (http://pi3.com.pl)
##

P_SYSCTL_DIR="/etc/sysctl.d"
P_SYSTEMD_DIR="/etc/systemd/system"


P_RED='\033[0;31m'
P_GREEN='\033[0;32m'
P_WHITE='\033[1;37m'
P_YL='\033[1;33m'
P_NC='\033[0m' # No Color

echo -e "  ${P_GREEN}[+] ${P_WHITE}Systemd detected${P_NC}"

if [ "$1" == "install" ]; then
	if [ -e "$P_SYSTEMD_DIR/ved.service" ]; then
		echo -e "       ${P_RED}ERROR! ${P_YL}ved.service${P_RED} already exists under ${P_YL}$P_SYSTEMD_DIR${P_RED} directory${P_NC}"
		exit 1
	else
		echo -e "       ${P_GREEN}Installing ${P_YL}ved.service${P_GREEN} file under ${P_YL}$P_SYSTEMD_DIR${P_GREEN} directory${P_NC}"
		install -pm 644 -o root -g root scripts/bootup/systemd/ved.service "$P_SYSTEMD_DIR/ved.service"
		echo -e "       ${P_GREEN}To start ${P_YL}ved.service${P_GREEN} please use: ${P_YL}systemctl start ved${P_NC}"
		echo -e "       ${P_GREEN}To enable ${P_YL}ved.service${P_GREEN} on bootup please use: ${P_YL}systemctl enable ved.service${P_NC}"
	fi
	if [ -e "$P_SYSCTL_DIR/01-ved.conf" ]; then
		echo -e "       ${P_YL}01-ved.conf${P_GREEN} is already installed, skipping${P_NC}"
	else
		echo -e "       ${P_GREEN}Installing ${P_YL}01-ved.conf${P_GREEN} file under ${P_YL}$P_SYSCTL_DIR${P_GREEN} directory${P_NC}"
		install -pm 644 -o root -g root scripts/bootup/ved.conf "$P_SYSCTL_DIR/01-ved.conf"
	fi
elif [ "$1" == "uninstall" ]; then
	echo -e "       ${P_GREEN}Stopping ${P_YL}ved.service${P_NC}"
	systemctl stop ved.service
	echo -e "       ${P_GREEN}Disabling ${P_YL}ved.service${P_GREEN} on bootup${P_NC}"
	systemctl disable ved.service
	echo -e "       ${P_GREEN}Deleting ${P_YL}ved.service${P_GREEN} file from ${P_YL}$P_SYSTEMD_DIR${P_GREEN} directory${P_NC}"
	rm "$P_SYSTEMD_DIR/ved.service"
	if cmp -s "$P_SYSCTL_DIR/01-ved.conf" scripts/bootup/ved.conf; then
		echo -e "       ${P_GREEN}Deleting unmodified ${P_YL}01-ved.conf${P_GREEN} file from ${P_YL}$P_SYSCTL_DIR${P_GREEN} directory${P_NC}"
		rm "$P_SYSCTL_DIR/01-ved.conf"
	elif [ -e "$P_SYSCTL_DIR/01-ved.conf" ]; then
		echo -e "       ${P_YL}$P_SYSCTL_DIR/01-ved.conf${P_GREEN} was modified, preserving it as ${P_YL}$P_SYSCTL_DIR/01-ved.conf.saved${P_NC}"
		echo -e "       ${P_GREEN}If you do not need it anymore, delete it manually${P_NC}"
		mv "$P_SYSCTL_DIR/01-ved.conf"{,.saved}
	fi
else
	echo -e "      ${P_RED}ERROR! Unknown option!${P_NC}"
	exit 1
fi


echo -e "  ${P_GREEN}[+] ${P_WHITE}Done!${P_NC}"
