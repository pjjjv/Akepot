#!/bin/bash
#
# Script to generate the appcache.mf.

APPCACHE='../web/appcache.mf'

##
# Manifest
echo 'CACHE MANIFEST' > $APPCACHE
date +'# %Y-%m-%d %H:%M:%S' >> $APPCACHE
echo >> $APPCACHE

##
# Cache

echo 'CACHE:' >> $APPCACHE

# Fixed files used:
cat <<EOF >> $APPCACHE
favicon.ico
index.html

EOF

# Dart and JS code used to make the editor:
find ../build/ | \
  grep -e \\.js$ -e \\.html$ -e \\.css$ -e \\.json$ -e \\.png$ -e \\.jpg$  -e \\.svg$ | \
  grep -v -e unittest | \
  sed 's/^\.\.\/build\/web\///' \
  >> $APPCACHE

##
# Network
cat <<EOF >> $APPCACHE

#NETWORK:
#*
EOF

# Copy manifest to build:
cp $APPCACHE '../build/web/appcache.mf'
