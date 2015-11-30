#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus a window when it is created
# depends on: wew focus.sh

spawn_at_cursor () {
    wid=$1
    w=$(wattr w $wid)
    h=$(wattr h $wid)
    x=$((`wmp | cut -d\  -f1` - w))
    y=$((`wmp | cut -d\  -f2` - h))

    test $x -lt 0 && x=0
    test $y -lt 0 && y=0

    wtp $x $y $w $h $wid
}

# hacky hacky
ignore_cover () {
    # Get cover window id by width/height
    wid=$(wattr iwh $(lsw) | awk '/152 151/ {print $1;}')

    chwb -s 0 "$wid"
    wmv -a 1668 842 "$wid"
    ignw -s "$wid"
}

# watch X events
wew | while IFS=: read ev wid; do
    case $ev in
        # spawn windows at cursor if not overriden
        16) wattr o $wid || spawn_at_cursor $wid; ignore_cover ;;

        # focus windows if not overriden
        19) wattr o $wid || ~/dotfiles/scripts/wmutils/focus.sh $wid ;;

        # focus next window when deleting focused window
        18) wattr $(pfw) || ~/dotfiles/scripts/wmutils/focus.sh prev ;;

        # focus windows where the cursor enters
        7) wattr o $wid || ~/dotfiles/scripts/wmutils/focus.sh $wid ;;
    esac
done
