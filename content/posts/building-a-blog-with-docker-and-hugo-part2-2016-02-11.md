+++
date = "2016-02-11"
title = "Building a Block with Docker & Hugo, Part2"
tags = ["Development", "Hugo", "Docker"]
+++

I got started with Linux about a year ago when a colleague recommended trying Ubuntu as an alternative to Windows. So far, I've gained basic competency in the terminal, and a few other things. I've experimented quite a bit with different Linux distributions in Virtual Box (installing Arch is probably the single most effective learning experience I could reccomend). But I think working at an IT company (my role is not technical) and constantly being around web developers and devops engineers was what really got me interested in computing, and pushed me to do a lot more than I otherwise would have - like studying Python, and deploying this site.


#### Settling on a solution

There are a lot of ways to host a static site, but I wanted to do it with Docker. Docker has a few advantages that make it very attractive for many different applications, but most importantly, container-ized services are really easy to deploy in different environments. For my purposes this means I can easily launch my site on any Linux environment using a simple Dockerfile as long as Docker installed:

```
$ docker build .

$ docker run -d -p 80:80 image_name
```

The first command builds a docker image using instructions from a Dockerfile, the second launches a pre-configured container serving my site the instant it goes up.

###### Building the site

I don't really know my way around html, css, or javascript, so there was no way I was going to build my own site from scratch in a reasonable amount of time. I decided to use a static site generator. There are a lot of them out there at the moment, so I sort of arbitrarily picked Hugo. It's written in go, generates pages very quickly, and has it's own web server (no need for Nginx or Apache, unless you want some more advanced features). 

Hugo uses a config file like this:

And generates pages from text files with a .toml, .json, or .yaml header. You only need markdwon to format the rest of your post:

```
+++
date = "2016-02-10"
title = "Title"
tags = ["Hugo", "Docker"]
+++

Your text here.
```

All you need to do is set up a directory tree of folders with the pages you want, and put your content in them; Hugo does the rest. 

#### Building a Docker image

Docker uses what is called a Dockerfile to create images with pre-installed and configured software. I decided to base mine on Alpine Linux, since it's quite compact. Here is the Dockerfile I developed:

```
# Inspired by ilkka.io/blog/static-sites-with-docker/ 
# and www.mrsinham.net/create-a-blog-in-2-min/

FROM alpine

MAINTAINER Laurent Marshall

# Install necessary packages:

RUN apk --no-cache add git

# The following packages are only necessary to build the docker image and 
# will be purged later:

RUN apk --no-cache add --virtual build-dependencies curl

# If you want more advanced text features you can use the following commands to install pygments:

#RUN apk --no-cache add python git
#RUN apk --no-cache add --virtual build-dependencies python-dev py-pip build-base curl
#RUN pip install pygments

ENV HUGO_VERSION 0.15
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux_amd64
ENV HUGO_BASEURL http://localhost/

RUN mkdir /blog
WORKDIR /blog

RUN curl -L https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz > /usr/local/${HUGO_BINARY}.tar.gz \
	&& tar -xzf /usr/local/${HUGO_BINARY}.tar.gz -C /usr/local/ \
	&& ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
	&& rm /usr/local/${HUGO_BINARY}.tar.gz

RUN apk del build-dependencies

RUN hugo new site .

RUN rm -rf ./content config.toml
RUN git init
RUN git remote add origin https://github.com/LEMarshall/blog.git
RUN git pull origin master

RUN git clone https://github.com/allnightgrocery/hugo-theme-blueberry-detox.git /blog/themes/detox

EXPOSE 80

# start.sh script from www.mrsinham.net/create-a-blog-in-2-min/ - syncs site content with github repository
# and launches hugo server:

ADD start.sh /start.sh

RUN chmod +x /start.sh

ENTRYPOINT /start.sh
```

If you're interested in reading more about Hugo and Docker, and taking a look at the Dockerfiles which I based mine on, have a look at [this](ilkka.io/blog/static-sites-with-docker/) and [this](www.mrsinham.net/create-a-blog-in-2-min/).

Basically, my Dockerfile borrows an Alpine Linux + Hugo configuration from the first source, and automatic updates using git and github from the second.

The following script launches Hugo Server, and sets it to watch the file system for changes. Meanwhile, git pulls changes from the repository every 60 seconds, and Hugo will rebuild the site and incorporating anything new:

```
#!/bin/sh

hugo server -t detox -b=$HUGO_BASEURL -s /blog -p 80 --bind=0.0.0.0 --watch --disableLiveReload &

cd /blog/
while true; do
    git pull origin master
    sleep 60
done
```

#### Deployment

I haven't decided if I will permanently host this blog anywhere yet, but I have deployed it on a CoreOS instance (has Docker pre-installed) on google cloud. Once I had a working docker image, hosting the site itself was super easy - "docker build ." "docker run ..." and that was all there was to it. To add content I only need to push new posts to my github repository and they appear on the site within a minute.

I next steps would include getting a domain name and leaving the Docker container with the site running on a server. I also need to get a handle on markdown language and learn about more about Hugo and the features available with my chosen theme. 
