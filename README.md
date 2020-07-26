# README

![Before and After][banda]

_[Or view the Yaru example][yaru]_

## Install

I'm running this on Manjaro so the instructions are for that.

### Skip steps with Make...

Next headings are for manual, but you can.

```
make install-all
```

### Deps

You need `openscad` (CAD software), and `Xvfb-run` (virtual X)

```
sudo pacman -Syu openscad xorg-server-xvfb
```

### Install

I only need to move these for it to work:

```
sudo cp stl.thumbnailer /usr/share/thumbnailers/
sudo cp stl_thumbnailer.sh /usr/local/bin/
```

### Extra Install

I don't need to do this, you might.

```
sudo update-mime-database /usr/share/mime
sudo xdg-mime install --novendor stl.xml
```

## Colors

If you wanted to customize with `-r`, `-g`, `-b` and `--colorcheme`. Make those
changes to the `stl.thumbnailer`

If you wanted to use the arc theme (default is Yaru):

```
Exec=/usr/local/bin/stl_thumbnailer.sh --in-file %i --out-file %o --size %s -r 82 -g 148 -b 226 --colorscheme DeepOcean
```

| Theme         | RGB                                                    |
|---------------|--------------------------------------------------------|
| Yaru          | `233, 84, 32` Great with `--colorscheme` 'Tomorrow'    |
| Arc           | `82, 148, 226` Great with `--colorscheme` 'DeepOcean'  |
| Matcha Green  | `46 179 152`                                           |

## Debugging

I find that if you do `--debug` in the `stl.thumbnailer`

### Clear out thumbnails

If you want to wipe out the thumbnails to rerender them. This is useful if you need to rerun the script after changing color values.

```
rm -rf ~/.cache/thumbnails
```

This of course whipes out everything. Maybe you care about some thumbnails. (Most will regenerate on next view)

## Misc

* Models in screens are from: https://www.thingiverse.com/thing:1911808

## TODO

* OpenSCAD is great but needing X is a little tough. Maybe find a better solution than `Xvfb-run`
* Get ambitious write in a compiled language as a real tool covering more file types
* Fetch current theme colors from Gnome would be cool.

[banda]: ./assets/before-after.png
[yaru]: ./assets/yaru.png
