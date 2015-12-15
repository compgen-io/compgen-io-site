#!/bin/bash
hugo -D
cd public
git add -A

if [ "$1" != "" ]; then
    msg="$1"
else
    msg="deploy site $(date)"
fi

git commit -m "$msg"
git push origin master
cd ..
