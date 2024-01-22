VER=$(cat StarlightGTK/version.txt)
rm -r Build
mkdir -p Build/starlightgtk_$VER/usr/share/themes
cp -r StarlightGTK/starlight Build/starlightgtk_$VER/usr/share/themes/
cd Build
SIZE=$(du -sk starlightgtk_$VER | awk '{print $1}')
mkdir starlightgtk_$VER/DEBIAN
echo """Package: StarlightGTK
Version: $VER
Section: base
Priority: optional
Architecture: all
Maintainer: lrdsnow
Installed-Size: $SIZE
Description: Starlight GTK Theme
""" > starlightgtk_$VER/DEBIAN/control
dpkg-deb --build starlightgtk_$VER
rm -r starlightgtk_$VER
rm -r ../Repo
mkdir ../Repo
mv * ../Repo/
cd ..
cp .repo/KEY.gpg Repo/
cp .repo/starlightrepo.list Repo/
rm -r Build
cd Repo
dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release
gpg --default-key "Lrdsnow" -abs -o - Release > Release.gpg
gpg --default-key "Lrdsnow" --clearsign -o - Release > InRelease
