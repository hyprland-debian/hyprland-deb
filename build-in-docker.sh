#!/usr/bin/env sh

set -eux

if [[ ! -v BUILD_VERSION ]]; then
    echo "BUILD_VERSION is not set"
    exit 1
fi

mkdir /build
cd /build

git clone https://github.com/hyprwm/hyprland.git --branch=v$BUILD_VERSION --recursive --depth=1 hyprland-$BUILD_VERSION
cd hyprland-$BUILD_VERSION

cp -r /shared/debian /build/hyprland-$BUILD_VERSION/debian
sed -i "s/VERSION_TEMPLATE/$BUILD_VERSION/g" /build/hyprland-$BUILD_VERSION/debian/changelog
sed -i "s/VERSION_TEMPLATE/$BUILD_VERSION/g" /build/hyprland-$BUILD_VERSION/debian/control

dpkg-buildpackage -us -uc

cd /build
ls -l

cp hyprland_$BUILD_VERSION\_amd64.deb /shared

cd /shared
dpkg-deb -c hyprland_$BUILD_VERSION\_amd64.deb
dpkg -I hyprland_$BUILD_VERSION\_amd64.deb
