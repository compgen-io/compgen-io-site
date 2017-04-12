#!/bin/bash
hugo -D -d docs

if [ "$1" != "" ]; then
    msg="$1"
else
    msg="deploy site $(date)"
fi

git commit -am "$msg"
git push origin master

#git subtree push --prefix=public git@github.com:compgen-io/compgen-io-site.git gh-pages
