#!/bin/bash

bundle update && bundle exec jekyll build

if [ $TOKEN != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi

git submodule sync --recursive
git submodule update --remote --init --force --recursive
git commit -am 'submodule update'

cd modules/cgpipe-docs
bundle update && bundle exec jekyll build
cd ../..

cd modules/tabl-docs
bundle update && bundle exec jekyll build

cd ../../_site/
echo "compgen.io" > CNAME

rm cgpipe.html
mkdir cgpipe
cp -R ../modules/cgpipe-docs/_site/* cgpipe/

rm tabl.html
mkdir tabl
cp -R ../modules/tabl-docs/_site/* tabl/


git init
if [ $TOKEN != "" ]; then
git config user.email "noreply@compgen.io"
git config user.name "Deployment/$GITHUB_ACTOR"
fi

# force a temp redirect while troubleshooting
echo "<html><head><meta http-equiv=\"refresh\" content=\"0; URL=https://github.com/compgen-io\" /></head></html>" > index.html

git add index.html .

git commit -m 'deploy'
if [ $TOKEN != "" ]; then
    git remote add origin https://deploy:$TOKEN@github.com/compgen-io/compgen-io-site.git
else
    git remote add origin git@github.com:compgen-io/compgen-io-site.git
fi
git checkout -b gh-pages
git push --force origin gh-pages
cd ..


