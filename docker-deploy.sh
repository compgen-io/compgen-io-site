#!/bin/bash

hugo --minify

cd public/
echo "compgen.io" > CNAME

git init
if [ "$TOKEN" != "" ]; then
    git config user.email "noreply@compgen.io"
    git config user.name "Deployment/$GITHUB_ACTOR"
fi

git add .
git commit -m 'deploy'

if [ "$TOKEN" != "" ]; then
    git remote add origin https://deploy:$TOKEN@github.com/compgen-io/compgen-io-site.git
else
    git remote add origin git@github.com:compgen-io/compgen-io-site.git
fi

git checkout -b gh-pages
git push --force origin gh-pages
cd ..
