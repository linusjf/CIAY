#!/usr/bin/env bash

######################################################################
# @author      : Linus Fernandes (linusfernandes at gmail dot com)
# @file        : vidmd
# @created     : Wednesday Feb 08, 2023 18:45:15 IST
#
# @description :
######################################################################

usagevidmd() {
  echo "$0 vidid vidurl caption"
  echo "vid - video id"
  echo "vidurl - video url"
  echo "caption - video title"
  exit 1
}

usagevidmdloc() {
  echo "$0 vidid vidurl caption doy"
  echo "vid - video id"
  echo "vidurl - video url"
  echo "caption - video title"
  echo "doy - day of year"
  exit 1
}

playiconurl() {
  ((doy = 10#$1))
  doy="$(printf "%03d" "$doy")"
  month="$(mfromdoy "$doy")"
  echo "https://raw.githubusercontent.com/fernal73/CIAY/main/${month}/jpgs/Day${doy}.jpg"
}

thumbnailurl() {
  urls=("https://img.youtube.com/vi/${1}/maxresdefault.jpg"
    "https://img.youtube.com/vi/${1}/hqdefault.jpg"
    "https://img.youtube.com/vi/${1}/hq1.jpg"
    "https://img.youtube.com/vi/${1}/hq2.jpg"
    "https://img.youtube.com/vi/${1}/hq3.jpg"
    "https://img.youtube.com/vi/${1}/hq720.jpg"
    "https://img.youtube.com/vi/${1}/mqdefault.jpg"
    "https://img.youtube.com/vi/${1}/mq1.jpg"
    "https://img.youtube.com/vi/${1}/mq2.jpg"
    "https://img.youtube.com/vi/${1}/mq3.jpg"
    "https://img.youtube.com/vi/${1}/sddefault.jpg"
    "https://img.youtube.com/vi/${1}/sd1.jpg"
    "https://img.youtube.com/vi/${1}/sd2.jpg"
    "https://img.youtube.com/vi/${1}/sd3.jpg"
    "https://img.youtube.com/vi/${1}/default.jpg"
    "https://img.youtube.com/vi/${1}/0.jpg"
    "https://img.youtube.com/vi/${1}/1.jpg"
    "https://img.youtube.com/vi/${1}/2.jpg"
    "https://img.youtube.com/vi/${1}/3.jpg")
  for url in "${urls[@]}"; do
    if test 200 -eq "$(curl -o /dev/null --silent -Iw '%{http_code}' "${url}")"; then
      echo "$url"
      return 0
    fi
  done
  return 1
}

vidmd() {
  if test $# -lt 3; then
    usagevidmd
  fi
  vidid="$1"
  vidurl="$2"
  caption="$3"
  if imgurl="$(thumbnailurl "$vidid")"; then
    printf "[![%s](%s)](%s \"%s\")\n" "$caption" "$imgurl" "$vidurl" "$caption"
  else
    echo >&2 "Thumbnails unverifiable,invalid or absent."
    return 1
  fi
}

vidmdloc() {
  if test $# -lt 4; then
    usagevidmdloc
  fi
  vidid="$1"
  vidurl="$2"
  caption="$3"
  doy="$4"
  imgurl="$(playiconurl "$doy")"
  printf "[![%s](%s)](%s \"%s\")\n" "$caption" "$imgurl" "$vidurl" "$caption"
}

isnumeric() {
  (($1)) &>/dev/null
}

usagemfromdoy() {
  echo "mfromdoy dayofyear"
  echo "dayofyear - day of year"
  exit 1
}

mfromdoy() {
  isnumeric "$1" || usagemfromdoy
  ((day = $1 - 1))
  date --date="jan 1 + $day days" +%B
}
