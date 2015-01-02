#!/bin/bash
#
#My script to uglify js and css and html files.
# find ../build/ -iname "*.js" | \
#  while read I; do
#   uglifyjs "$I" -o "$I.uglified" --screw-ie8 -m -c
#   mv -v "$I.uglified" "$I"
#   #rm "$I.uglified"
#  done


# find ../build/ -iname "*.css" | \
#  while read I; do
#   java -jar minifying/yuicompressor-2.4.8.jar -v "$I" -o "$I.minified"
#   mv -v "$I.minified" "$I"
#   #rm "$I.minified"
#  done

 find ../build/ -iname "*.html" | \
  while read I; do
   java -jar minifying/htmlcompressor-1.5.3.jar "$I" -o "$I.minified" --remove-intertag-spaces --remove-quotes --remove-style-attr --remove-link-attr --remove-script-attr --remove-form-attr --remove-input-attr --simple-bool-attr --remove-js-protocol --remove-http-protocol --remove-https-protocol --remove-surrounding-spaces max
# --compress-js --compress-css
   mv -v "$I.minified" "$I"
   #rm "$I.minified"
  done
