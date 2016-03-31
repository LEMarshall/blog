+++
date = "2016-03-30"
title = "Hosting my Hugo Blog on Github Pages"
tags = ["Hugo", "Github"]
+++

After initially hosting my blog on a virtual machine instance on Google Cloud, I got busy with other things and took my time getting around to finding an alternative hosting solution. The virtual machine instance was a bit too expensive for just hosting a blog when cheaper (or free!) options exist, considering my free trial on Google Cloud ran out. Since I still don't have a whole lot of time for this project, I decided to try [Github Pages](https://pages.github.com), it sounded pretty simple, and in fact it is.

Github Pages is a free service for hosting static sites, all you really need to do is create a repository and upload your site. Since I wanted to use [Hugo](https://gohugo.io) to generate my site, I roughly followed their [tutorial](https://gohugo.io/tutorials/github-pages-blog/) for hosting on Github Pages. I didn't go as far with configuring Git workflow, and at some point I may still want to make this more automated. At the moment I'm updating by running Hugo to generate pages for new content and pushing the files to my github repository. 

Github Pages seems like a good way to go, it's free, and fairly easy to use. 
