#!/bin/bash
# Download the latest version of TeamViewer to the Downloads folder
curl -o ~/Downloads/TeamViewer.dmg http://downloadus3.teamviewer.com/download/TeamViewer.dmg

# Mount the .dmg
hdiutil mount ~/Downloads/TeamViewer.dmg

# Insall TeamViewer silently
sudo /usr/sbin/installer -pkg /Volumes/TeamViewer/Install\ TeamViewer.pkg -target "/Volumes/Macintosh HD"

# Unmount the volume when done
umount /Volumes/TeamViewer

# Clean up
rm -f ~/Downloads/TeamViewer.dmg

#pkgutil --expand /Volumes/TeamViewer/Install\ TeamViewer.pkg /tmp/TeamViewer
