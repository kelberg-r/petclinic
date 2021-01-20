#!/usr/bin/env bash

set -e -x

CWD=$(pwd)

JAR=$(readlink -f $1)
VERSION=$2
START_SCRIPT=$(readlink -f petclinic_start.sh)

DIR=$(mktemp -d)

function cleanup {
    rm -rf ${DIR}
}
trap cleanup EXIT

cd ${DIR}
mkdir -v -p control data/{etc/systemd/system,usr/share/petclinic}

cp "${JAR}" data/usr/share/petclinic/petclinic.jar
cp "${START_SCRIPT}" data/usr/share/petclinic/
cat > data/etc/systemd/system/petclinic.service << EOF
[Unit]
Description=petclinic

[Service]
ExecStart=/bin/bash /usr/share/petclinic/petclinic_start.sh
Type=simple

[Install]
WantedBy=multi-user.target
EOF

echo "/etc/systemd/system/petclinic.service" > control/conffiles

cat > control/control << EOF
Package: petclinic
Version: ${VERSION}
Architecture: all
Maintainer: Oleh Palii <oleh_palii@epam.com>
Installed-Size: $(du -ks data/usr/share/petclinic/petclinic.jar | cut -f 1)
Depends: default-jre
Description: petclinic
Section: devel
Priority: extra
EOF

cd data
md5sum usr/share/petclinic/petclinic.jar > ../control/md5sums
cd -

cat > control/postinst << "EOF"
#!/bin/sh

set -e

if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
    systemctl --system daemon-reload
	systemctl enable petclinic
    systemctl start petclinic
fi

exit 0
EOF

cat > control/prerm << "EOF"
#!/bin/sh

set -e

systemctl stop petclinic || exit 1
EOF

cat > control/postrm << "EOF"
#!/bin/sh

set -e

if [ "$1" = "purge" ] ; then
	systemctl disable petclinic >/dev/null
fi

systemctl --system daemon-reload >/dev/null || true
systemctl reset-failed

exit 0
EOF


cd control
tar czf ../control.tar.gz .
cd -

cd data
tar czf ../data.tar.gz .
cd -

echo "2.0" > debian-binary

ar r ${CWD}/petclinic.deb debian-binary control.tar.gz data.tar.gz
cd ${CWD}

