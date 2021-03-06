+++
date = "2016-02-10"
title = "Building a Blog with Docker and Hugo"
tags = ["Development", "Hugo", "Docker"]
+++

After hearing and reading about [Docker](https://www.docker.com), I decided to try building a static blog on my own as a learning experience. 

I decided to use [Hugo](https://gohugo.io) to generate and serve my blog, and I used a short script with git to automatically post updates. Due to its compact size, [Alpine Linux](www.alpinelinux.org) was a good base for my docker image. 

You can check out the Dockerfile I developed on [github](https://github.com/LEMarshall/blog).
