#!/usr/bin/env bash

# Power menu options
options="Shutdown\nReboot\nSuspend\nLock\nLogout"

# Show menu and get user choice
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme-str 'window {width: 300px;}')

# Execute based on choice
case $chosen in
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Lock)
        i3lock -c 2e3440
        ;;
    Logout)
        i3-msg exit
        ;;
esac
