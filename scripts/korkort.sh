#!/usr/bin/env bash
# magick -size 1772x1181 canvas:grey40 photo_34x45.png -geometry +5+5 -composite photo_34x45.png -geometry +423+5 -composite out.png

canvas_size="1772x1181"
canvas_color="grey40"

magick -size $canvas_size canvas:$canvas_color \
  -verbose \
  $1 -geometry 413x531+0+0 -composite \
  $1 -geometry 413x531+418+0 -composite \
  \( $1 -rotate 90 \) -geometry 831x+0+536 -composite \
  $1 -geometry 936x+835+0 -composite \
  -set Author "Conny Holm" \
  -set Comment "Körkortsfoto 35x45 mm. Ursprungligt filnamn ${1}" \
  -set Website "www.studioholm.se" \
  "${1%.*}_print.png"
