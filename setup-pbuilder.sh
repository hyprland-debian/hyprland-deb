#!/usr/bin/env bash

echo "deb http://deb.debian.org/debian unstable main" > /etc/apt/sources.list
rm -f /etc/apt/sources.list.d/debian.sources

apt update
apt -y upgrade
apt install -y pbuilder jq curl

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

get_url_of_deb () {
        local username_repo="$1"
        local release_url="https://api.github.com/repos/$username_repo/releases/latest"
        local release_json="$(curl -s $release_url)"
        local deb_url="$(echo $release_json | jq -r '[ .assets[] | select( .name | endswith(".deb")) ][0].browser_download_url')"
        echo $deb_url
}

download_deb () {
        wget "$(get_url_of_deb "$1")"
}

download_deb "iliabylich/hyprcursor-deb"
download_deb "iliabylich/hyprwayland-scanner-deb"
ls -l

if [ ! -f /var/cache/pbuilder/base.tgz ]; then
    pbuilder create --distribution sid
fi
