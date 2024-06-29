#!/usr/bin/env sh

set -eux

export VER="0.41.2"

mkdir /build
cd /build

git clone https://github.com/hyprwm/hyprland.git --branch=v$VER --recursive --depth=1 hyprland-$VER
cd hyprland-$VER

cp -r /shared/debian /build/hyprland-$VER/debian
sed -i "s/VERSION_TEMPLATE/$VER/g" /build/hyprland-$VER/debian/changelog
sed -i "s/VERSION_TEMPLATE/$VER/g" /build/hyprland-$VER/debian/control

dpkg-buildpackage -us -uc

cd /build
ls -l

cp hyprland_$VER\_amd64.deb /shared

cd /shared
dpkg-deb -c hyprland_$VER\_amd64.deb
dpkg -I hyprland_$VER\_amd64.deb