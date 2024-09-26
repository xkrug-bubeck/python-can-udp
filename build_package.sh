#!/bin/sh

mkdir -p python-can-udp/opt/python-can-udp
cp caneth_linux.py python-can-udp/opt/python-can-udp/
cp README.md python-can-udp/opt/python-can-udp/

chmod -R 755 python-can-udp/DEBIAN
chmod 755 python-can-udp/usr/lib/systemd/system/*.service
chmod 755 python-can-udp/opt/python-can-udp/*.py

dpkg -b python-can-udp

rm -rf python-can-udp/opt

