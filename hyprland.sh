#!/usr/bin/env bash

VER=0.40.0

apt install -y git
git clone https://github.com/hyprwm/Hyprland.git --recursive
mv Hyprland hyprland-$VER
cd hyprland-$VER
git reset --hard ec092bd601d9d351ff6ca34bd97f12055b2a4dd9

mkdir debian

cat > debian/changelog <<EOF
hyprland ($VER) unstable; urgency=low

  * Release

 -- John Doe <john@doe.org>  Wed, 22 May 2024 17:54:24 +0000
EOF

cat > debian/rules <<EOF
#!/usr/bin/make -f
export DH_VERBOSE = 1

%:
	dh \$@ --buildsystem=cmake
EOF
chmod +x debian/rules

cat > debian/control <<EOF
Source: hyprland
Section: utils
Priority: extra
Maintainer: John Doe <john@doe.org>
Build-Depends: debhelper (>= 0.0.0), cmake (>= 3.27.0), pkg-config (>= 0.0.0), ninja-build (>= 0.0.0), libgles-dev (>= 0.0.0), libxkbcommon-dev (>= 0.0.0), librust-wayland-server-dev (>= 0.0.0), wayland-protocols (>= 0.0.0), libpango1.0-dev (>= 0.0.0), libdrm-dev (>= 0.0.0), libinput-dev (>= 0.0.0), hwdata (>= 0.0.0), libseat-dev (>= 0.0.0), libdisplay-info-dev (>= 0.0.0), libliftoff-dev (>= 0.0.0), libgbm-dev (>= 0.0.0), libhyprlang-dev (>= 0.0.0), xwayland (>= 0.0.0), libxcb-util-dev (>= 0.0.0), libxcb-xfixes0-dev (>= 0.0.0), libxcb-icccm4-dev (>= 0.0.0), libxcb-composite0-dev (>= 0.0.0), libxcb-res0-dev (>= 0.0.0), libxcb-ewmh-dev (>= 0.0.0), meson (>= 0.0.0), libtomlplusplus-dev (>= 0.0.0), hyprwayland-scanner (>= 0.0.0), hyprcursor (>= 0.0.0)
Standards-Version: $VER

Package: hyprland
Section: utils
Priority: extra
Architecture: amd64
Depends: \${shlibs:Depends}, kitty (>= 0.0.0), hyprwayland-scanner (>= 0.0.0)
Description: Hyprland is a highly customizable dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
EOF

echo 10 > debian/compat

dpkg-buildpackage -S -nc

cd ..

DEPS=hyprland pbuilder build hyprland_$VER.dsc

dpkg -I /var/cache/pbuilder/result/hyprland_$VER\_amd64.deb
