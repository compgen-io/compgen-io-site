#!/bin/bash
rm -rf _site
#docker run -p 35729:35729 -p 4000:4000 -it --rm -v $(PWD)/mysite:/data jtd-docker:latest /bin/bash -c "bundle update && bundle exec just-the-docs rake search:init && bundle exec jekyll serve -H 0.0.0.0 --incremental --livereload"
docker run -it --rm -v $(PWD):/data -w /data compgen/jtd-docker:latest 
