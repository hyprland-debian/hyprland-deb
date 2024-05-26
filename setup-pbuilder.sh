#!/usr/bin/env bash

echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list
rm -f /etc/apt/sources.list.d/debian.sources

apt update
apt -y upgrade
apt install -y pbuilder

mkdir -p /var/cache/pbuilder/deps

cat >> /etc/pbuilderrc <<EOF
HOOKDIR="\$HOME/.pbuilder/hooks"
if [ -n "\$DEPS" ] ; then
        export DEPSBASE=/var/cache/pbuilder/deps
        BINDMOUNTS=\$DEPSBASE
fi
EOF

mkdir -p $HOME/.pbuilder/hooks

cat > $HOME/.pbuilder/hooks/D05deps <<EOF
DEPSPATH="\$DEPSBASE/\$DEPS"
if [ -n "\$DEPS" ] && [ -d "\$DEPSPATH" ] ; then
        apt-get install --assume-yes apt-utils
        ( cd "\$DEPSPATH"; apt-ftparchive packages . > Packages )
        echo "deb [trusted=yes] file://\$DEPSPATH ./" >> /etc/apt/sources.list
        apt-get update
fi
EOF
chmod +x $HOME/.pbuilder/hooks/D05deps

mkdir -p /var/cache/pbuilder/deps/hyprland
cd /var/cache/pbuilder/deps/hyprland
wget https://github.com/iliabylich/hyprcursor-deb/releases/download/latest/hyprcursor_0.1.9_amd64.deb
wget https://github.com/iliabylich/hyprwayland-scanner-deb/releases/download/latest/hyprwayland-scanner_0.3.8_amd64.deb

if [ ! -f /var/cache/pbuilder/base.tgz ]; then
    pbuilder create --distribution sid
fi
