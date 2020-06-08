#!/bin/bash


bundle update && bundle exec jekyll build

if [ $1 != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi

git submodule sync --recursive
git submodule update --remote --init --force --recursive

git commit -am 'submodule update'

cd modules/cgpipe-docs
bundle update && bundle exec jekyll build

cd ../../_site/

echo "compgen.io" > CNAME

rm cgpipe.html
mkdir cgpipe
cd cgpipe
cp -R ../../modules/cgpipe-docs/* .
cd ..


git init
if [ $1 != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi
git add .
git commit -m 'deploy'
if [ $1 != "" ]; then
    git remote add origin https://deploy:$1@github.com/compgen-io/compgen-io-site.git
else
    git remote add origin git@github.com/compgen-io/compgen-io-site.git
fi
git checkout -b gh-pages
git push --force origin gh-pages
cd ..


