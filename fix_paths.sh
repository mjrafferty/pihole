#! /bin/bash

PREFIX="/opt/pihole"

IFS="
"


_changePaths() {

  while read file; do

    sed -i "s_\([ :\"']\)/usr/local/bin_\1${PREFIX}/usr/bin_g" "$file"; 
    sed -i "s_\([ :\"']\)/etc/pihole_\1${PREFIX}/etc/pihole_g" "$file"; 
    sed -i "s_\([ :\"']\)/var_\1${PREFIX}/var_g" "$file"; 
    sed -i "s_\([ :\"']\)/run_\1${PREFIX}/var/run_g" "$file"; 
    sed -i -r "s_/opt/pihole(/?[^/]*( |:|\"|'|;|\$))_${PREFIX}/usr/bin\1_g" "$file"; 
    sed -i "s_sudo pihole_pihole_g" "$file"; 

  done
}

_gatherFiles() {

  find AdminLTE Core \
    \( -path AdminLTE/img \
    -o -path AdminLTE/style \
    -o -path AdminLTE/.git \
    -o -path AdminLTE/.github \
    -o -path 'Core/test' \
    -o -path 'Core/automated install' \
    -o -name '*.gif' \
    -o -name '*.png' \
    -o -name '*.jpg' \
    -o -name '*.svg' \
    -o -name '*.ttf' \
    -o -name '*.woff' \
    -o -name '\.*' \
    -o -name '*.md' \
    -o -name 'LICENSE' \
    \) -prune -o -type f -print

}

_makeDirs() {

  mkdir -p "${PREFIX}"/usr/bin
  mkdir -p "${PREFIX}"/etc/pihole
  mkdir -p "${PREFIX}"/var/{run,log}

}

_linkBin() {

  for bin in "${PREFIX}"/Core/advanced/Scripts/* "${PREFIX}"/Core/{pihole,gravity.sh}; do
    ln -sf "${bin}" "${PREFIX}"/usr/bin/
  done

}


main() {

  _gatherFiles \
    | _changePaths

  _makeDirs

  _linkBin

}


main;
