#!/bin/bash

find .

bundle update && bundle exec jekyll build

if [ $TOKEN != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi

echo "one"
git submodule sync --recursive
echo "two"
git submodule update --remote --init --force --recursive
echo "three"

find .
echo "four"

git commit -am 'submodule update'
echo "five"

cd modules/cgpipe-docs
pwd
bundle update && bundle exec jekyll build
echo "six"
ls -las

ls -l _site

cd ../../_site/
pwd

echo "compgen.io" > CNAME

rm cgpipe.html
mkdir cgpipe
ls -las
ls -las ..
ls -las ../modules
ls -las ../modules/cgpipe-docs
ls -las ../modules/cgpipe-docs/_site

cp -R ../modules/cgpipe-docs/_site/* cgpipe/
cd ..


git init
if [ $TOKEN != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi
git add .
git commit -m 'deploy'
if [ $TOKEN != "" ]; then
    git remote add origin https://deploy:$TOKEN@github.com/compgen-io/compgen-io-site.git
else
    git remote add origin git@github.com:compgen-io/compgen-io-site.git
fi
git checkout -b gh-pages
git push --force origin gh-pages
cd ..


