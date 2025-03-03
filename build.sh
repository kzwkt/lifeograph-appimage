#!/bin/sh
# run
APP=lifeograph
DEBRELEASE=stable
ARCH=x86-64
UPINFO="gh-releases-zsync|$GITHUB_REPOSITORY_OWNER|mpv-debian-multimedia|latest|*$ARCH.AppImage.zsync"

mkdir tmp-$DEBRELEASE;
cd tmp-$DEBRELEASE;

# DOWNLOADING THE DEPENDENCIES
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
url=$(wget -q https://api.github.com/repos/AppImageCommunity/pkg2appimage/releases -O - | grep "pkg2appimage-.*-x86_64.AppImage" | grep browser_download_url | head -n 1 | cut -d '"' -f 4)
wget  "$url" -O pkg2appimage
chmod a+x  ./pkg2appimage ./appimagetool

# CREATING THE APPIMAGE: APPDIR FROM A RECIPE...
DEBRELEASE=stable

./pkg2appimage  --appimage-extract  
mv squashfs-root pkg2
./pkg2/AppRun ../recipe.yml;

./appimagetool  --appimage-extract  
mv squashfs-root pkg1



ARCH=x86_64 ./pkg1/AppRun   --comp zstd \
	--mksquashfs-opt -Xcompression-level --mksquashfs-opt 22 \
	-n  ./$APP/$APP.AppDir -u "$UPINFO" 


