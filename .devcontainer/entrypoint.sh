#!/bin/bash

if [ "$DEPLOY" = "1" ]; then
    ./docker-deploy.sh
elif [ "$SERVE" = "1" ]; then
    bundle update && bundle exec jekyll serve -H 0.0.0.0  --livereload
else
    bundle update && bundle exec jekyll build
fi
