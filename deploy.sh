#!/bin/bash
hugo -D -d public

if [ "$1" != "" ]; then
    msg="$1"
else
    msg="deploy site $(date)"
fi

git commit -am "$msg"
git push origin master
cd public
git commit -am "$msg"
git push
cd ..

#git subtree push --prefix=public git@github.com:compgen-io/compgen-io-site.git gh-pages
