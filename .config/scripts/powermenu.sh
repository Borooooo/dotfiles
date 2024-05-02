#!/usr/bin/env bash
rofi_command="rofi"

uptime=$(uptime -p | sed -e 's/up //g')

# Icons from Nerd Fonts
shutdown="    Shutdown"
reboot="    Reboot"
lock="    Lock"
suspend="󰒲    Suspend"
logout="󰈆    Logout"

# Variable passed to rofi
options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

# Ask for confirmation
rdialog () {
rofi -dmenu\
    -i\
    -no-fixed-num-lines\
    -p "Are You Sure? : "
}

# Display Help
show_msg() {
    rofi -e "Options : yes / no / y / n"
}

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
        ans=$(rdialog &)
        if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
            systemctl poweroff
        elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
            exit
        else
            show_msg
        fi
        ;;
    $reboot)
        ans=$(rdialog &)
        if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
            systemctl reboot
        elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
            exit
        else
            show_msg
        fi
        ;;
    $lock)
        hyprlock
        ;;
    $suspend)
        ans=$(rdialog &)
        if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
            mpc -q pause
            amixer set Master mute
            sh $HOME/.local/bin/lock
            systemctl suspend
        elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
            exit
        else
            show_msg
        fi
        ;;
    $logout)
        ans=$(rdialog &)
        if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
      pkill -9 -u m4xshen
        elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
            exit
        else
            show_msg
        fi
        ;;
esac