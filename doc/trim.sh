#!/bin/sh

# Trims the jungle repository by moving the website to its own repository and
# removing it from jungle. It also removes big pdf files and kernel
# configurations so the jungle repository is small.

set -e

if [ -e oldjungle -o -e newjungle -o -e website ]; then
  echo "remove oldjungle/, newjungle/ and website/ first"
  exit 1
fi

# Clone the old jungle repo
git clone gitea@tent:rarias/jungle.git oldjungle

# First split the website into a new repository
mkdir website && git -C website init -b master
git-filter-repo \
  --path web \
  --subdirectory-filter web \
  --source oldjungle \
  --target website

# Then remove the website, pdf files and big kernel configs
mkdir newjungle && git -C newjungle init -b master
git-filter-repo \
  --invert-paths \
  --path web \
  --path-glob 'doc*.pdf' \
  --path-glob '**/kernel/configs/lockdep' \
  --path-glob '**/kernel/configs/defconfig' \
  --source oldjungle \
  --target newjungle

set -x

du -sh oldjungle newjungle website
#  57M  oldjungle
# 2,3M  newjungle
# 6,4M  website

du -sh --exclude=.git oldjungle newjungle website
#  30M  oldjungle
# 700K  newjungle
# 3,5M  website
