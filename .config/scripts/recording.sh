#!/usr/bin/env bash
rofi_command="rofi -markup -markup-rows -steal-focus -hover-select"

datetime=$(date +"%Y-%m-%d %I-%M-%S")
dir="$HOME/Videos/Screen-Recordings"
#file="Screen Recording from ${date} ${time}.png"

screen="   Record Desktop"
area="󰋫  Record Area"
window="  Record Window"
infivearea="  Record Area in 5s"
infive="  Record in 5s"

# Notify and view screenshot
notify_view () {
	dunstify -u low --replace=699  "Copied to clipboard."
	if [[ -e "$dir/Screen Recording from ${datetime}.mp4" ]]; then
		echo "$dir/Screen Recording from ${datetime}.mp4"
		action=$(dunstify --action="default,openss" -u low --replace=699 "Screen Recording Saved.")
		case "$action" in
		"default")
		    xdg-open "$dir/Screen Recording from ${datetime}.mp4"
		    ;;
		esac		
	else
		dunstify -u low --replace=699 "Screen Recording Deleted."
	fi
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		dunstify -t 1000 --replace=699 "Recording in : $sec"
		sleep 1
	done
}

# take shots
recordnow () {
	resolution=$(xrandr --current | grep '*' | uniq | awk '{print $1}')
	width=$(echo $resolution | cut -d 'x' -f1)
	height=$(echo $resolution | cut -d 'x' -f2)
	sleep 0.5 && wl-screenrec -g "0,0 $width""x"$height"" -f "$dir/Screen Recording from ${datetime}".mp4
	wl-copy < $dir/"Screen Recording from ${datetime}".mp4
	notify_view
}

record5 () {
	countdown '5'
	sleep 1 &&  wf-recorder -g "0,0 1920x1080" -f $dir/"Screen Recording from ${datetime}".mp4
	wl-copy < $dir/"Screen Recording from ${datetime}".mp4
	notify_view
}

record5area () {
	countdown '5'
	sleep 1 &&  wl-screenrec -g "$(slurp -b#0f0f0f78 -c#cc7765 -w4)" -f $dir/"Screen Recording from ${datetime}".mp4
	wl-copy < $dir/"Screen Recording from ${datetime}".mp4
	notify_view
}

recordwin () {
	hyprvars=$(hyprctl activewindow -j | cut -d' ' -f2- | head -n -1 | tail -n +4)
	jqvars=$(echo -e "{\n$hyprvars\n}" |  jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"')
	sleep 1 & wl-screenrec -g "${jqvars}" -f $dir/"Screen Recording from ${datetime}".mp4
	wl-copy < $dir/"Screen Recording from ${datetime}".mp4
	notify_view
}

recordarea () {
	wl-screenrec -g "$(slurp -b#0f0f0f78 -c#cc7765 -w4)" -f $dir/"Screen Recording from ${datetime}".mp4
	wl-copy < $dir/"Screen Recording from ${datetime}".mp4
	notify_view
}

if [[ ! -d "$dir/" ]]; then
	mkdir -p "$dir/"
fi

# Variable passed to rofi
options="$screen\n$area\n$window\n$infivearea\n$infive"

chosen="$(echo -e "$options"| $rofi_command -p 'Screen Recording' -dmenu -selected-row 0)"
case $chosen in
    $screen)
		recordnow
        ;;
    $area)
		recordarea
        ;;
    $window)
		recordwin
		;;
    $infive)
		record5
		;;
    $infivearea)
		record5area
        ;;
esac
