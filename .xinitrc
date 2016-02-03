#!/usr/bin/env bash

xrdb -merge ~/.Xresources
xrdb -merge ~/.Xdefaults
if ( xrandr | grep -q "DP2 connected" ); then
        xcalib -d :0 -s 0 ~/icc/hplp2475w.icc
        xrandr --output DP2 --mode 1920x1200 --rate 60 --dpi 94
        xrandr --output eDP1 --off
        ln -sf ~/.config/awesome/themes/default ~/.config/awesome/themes/current
        xrdb -merge ~/.Xdefaults.external
else
        xrandr --output eDP1 --mode 2560x1700 --dpi 236
        ln -sf ~/.config/awesome/themes/hidpi ~/.config/awesome/themes/current
        xrdb -merge ~/.Xdefaults.internal
        xmodmap ~/.Xmodmap &
fi

xset -dpms; xset s off
#xrandr --output DVI-I-2 --right-of DVI-I-1 --mode 1680x1050 --rate 50
/usr/bin/unclutter &
#xmodmap ~/.Xmodmap
/usr/bin/urxvtd -f -q -o
/usr/bin/urxvtc -e mutt &
/usr/bin/urxvtc -e mcabber &
/usr/bin/urxvtc -e mcabber -f ~/.mcabber/gmail &
/opt/HipChat/bin/hipchat &
~/.fehbg
setxkbmap -model pc104 -layout us,ru -option grp:caps_toggle,grp_led:scroll &
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
