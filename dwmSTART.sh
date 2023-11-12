#!/bin/sh

nitrogen --restore &
picom &
dte(){
  dte="$(date +"%A, %B %d - %H:%M")"
  echo "$dte"
}

mem(){
  mem=`free | awk '/Mem/ {printf "%d Mib\n", $3 / 1024.0 $2 / 1024.0 }'`
  echo "$mem"
}
vol(){
  vol="$( amixer sget Master | awk -F"[][]" '/Left:/ { print $2 }')"
  echo "$vol vol"
}
bat(){
  bat="$(acpi -b | head -n 1 | awk -F'[,:]' '{print $3}' | tr -d '[:space:]')"
  echo "$bat bat"
}
cpu(){
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo "$cpu% cpu"
}
if command -v xkblayout-state print &> /dev/null; then
  KEY="$(xkblayout-state print '%s')"
else
  KEY="??"
fi
while true; do
  xsetroot -name "$(vol) | $(bat) | $(cpu) | $(mem) | $(dte)"
done &
exec xfce4-clipman &
exec dwm 
