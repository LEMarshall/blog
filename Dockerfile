# Inspired by ilkka.io/blog/static-sites-with-docker/ 
# and www.mrsinham.net/create-a-blog-in-2-min/

FROM alpine

MAINTAINER Laurent Marshall

RUN apk --no-cache add curl git

ENV HUGO_VERSION 0.15
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux_amd64
ENV HUGO_BASEURL http://localhost/

RUN mkdir /blog
WORKDIR /blog

RUN curl -L https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz > /usr/local/${HUGO_BINARY}.tar.gz \
	&& tar -xzf /usr/local/${HUGO_BINARY}.tar.gz -C /usr/local/ \
	&& ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
	&& rm /usr/local/${HUGO_BINARY}.tar.gz

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



 

