#!/bin/bash

# The two gnome desktop supported sizes.
SIZE=256
LOGFILE=/dev/null
RED=233
GRN=84
BLU=32

usage() {
    cat << USAGE
Usage: $0 [flags]

  Generate a thumbnail for *.stl files using OpenSCAD

Flags:

  -i, --in-file      Required, *.stl file you are thumbnailing.

  -o, --out-file     Optional, the rendered *.png file, if omitted png sent to /tmp

  -s, --size         Optional, render image size <=256, default is 256

  -d, --debug        Optional, logs to /tmp/stl_thumbnailer.log if set or else /dev/null

  -c, --colorscheme  Optional, sets openSCAD color scheme - if used with -r -g -b
                     colorscheme will only change the background.

  -r, --red          Optional, RED value for solid; eg Yaru: 10

  -g, --green        Optional, GREEN value for solid; eg Yaru: 71

  -b, --blue         Optional, BLUE value for solid; eg Yaru: 93

  -h, --help         This :)

USAGE
    exit 1
}

while [[ $# -gt 0 ]]; do 
    flag="$1"

    case $flag in
        -i|--in-file)
        INFILE="$2"
        shift; shift
        ;;
        -o|--out-file)
        OUTFILE="$2"
        shift; shift
        ;;
        -s|--size)
        SIZE="$2"
        shift; shift
        ;;
        -r|--red)
        RED="$2"
        shift; shift
        ;;
        -g|--green)
        GRN="$2"
        shift; shift
        ;;
        -b|--blue)
        BLU="$2"
        shift; shift
        ;;
        -d|--debug)
        LOGFILE=/tmp/stl_thumbnailer.log
	DEBUG=1
        shift;
        ;;
        -c|--colorscheme)
        COLORSCHEME="$2"
        shift; shift
        ;;
        -h|--help)
        shift;
        usage
        ;;
        *)
        echo -e "Unknown flag/argument [$1] all options provided from flags\n" 
        usage
        break
        ;;
    esac
done

command -v openscad > /dev/null
if [[ "$?" != "0" ]]; then
    echo "Could not find [openscad], cannot create thumbnail." >> $LOGFILE 2>&1
    exit 1
fi

if [[ "$SIZE" -gt "256" ]]; then
    echo "Image size to big to be thumbnail." >> $LOGFILE 2>&1
    exit 1
fi

if [[ -z "$INFILE" ]]; then
    echo -e "You must supply an input file --in-file somefile.stl\n" >> $LOGFILE 2>&1
    usage
fi

if [[ -z "$OUTFILE" ]]; then
   OUTFILE="/tmp/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)-stl.png"
fi

if [[ -n "$COLORSCHEME" ]]; then
    COLORSCHEME="--colorscheme=$COLORSCHEME"
fi

# arc  82, 148, 226 - Great with --colorscheme 'DeepOcean'
# yaru 10, 71, 93
# matcha purple 146 77 139
# matcha green 22 160 133
# generic yellow 150 60 200
OPENSCAD_COMMAND="color([$RED/255, $GRN/255, $BLU/255]) import(\"$INFILE\");"

if [[ -n "$DEBUG" ]]; then
    echo "Size:    $SIZE" >> $LOGFILE 2>&1
    echo "Infile:  $INFILE" >> $LOGFILE 2>&1
    echo "Outfile: $OUTFILE" >> $LOGFILE 2>&1
fi

# OpenSCAD requires X for OpenGL png rendering
# Can't figure out how to get the user session to work in the thumbnailer shell
Xvfb :5 -screen 0 800x600x24 &
export DISPLAY=:5

# Example: 
# Passing the OPENSCAD_COMMAND var as a file descriptor which contains commands that load the file.
# openscad -o /tmp/gnome-desktop-thumbnailer.png --imgsize=256,256 /dev/fd/23
openscad -o $OUTFILE $COLORSCHEME --imgsize=$SIZE,$SIZE <(echo $OPENSCAD_COMMAND) >> $LOGFILE 2>&1
if [[ "$?" != "0" ]]; then
    echo "Could not thumbnail - $INFILE." >> $LOGFILE 2>&1
    exit 1
fi

