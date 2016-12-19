#!/usr/bin/env bash

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xdefaults
xcalib -d :0 -s 0 ~/icc/hplp2475w.icc
xrandr --output DP2 --mode 1920x1200 --rate 60 --dpi 94
xrandr --output HDMI-A-0 --off
xrdb -merge ~/.Xdefaults.external

xset -dpms; xset s off
#xrandr --output DVI-I-2 --right-of DVI-I-1 --mode 1680x1050 --rate 50
unclutter &
#xmodmap ~/.Xmodmap
urxvtd -f -q -o
urxvtc -e mutt &
urxvtc -e mcabber &
~/.fehbg
gtk-redshift &
volumeicon &
setxkbmap -model pc104 -layout us,ru -option ctrl:nocaps,grp:ctrl_shift_toggle,grp_led:scroll &
exec /usr/bin/awesome




#/usr/bin/xscreensaver &
#fetchmail -s -t 20 -d60 --invisible 2>>~/.fetchmailerr
#xrandr --output HDMI-0 --off
#xrandr --output DVI-0 --off
#/usr/bin/skypetab-ng & 
#/usr/bin/urxvtd -f -q -o
#/usr/bin/luakit &
#exec /usr/bin/twm
#exec /usr/bin/xbmc-standalone
