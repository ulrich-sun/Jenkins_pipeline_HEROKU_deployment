<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/672b58d62fa5d424fb7162e33546c67f3bcbebc2/screenshots/jenkins.png" width="50%" height="50%">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/0adec933a113d173feee80d45760aa90133d1969/screenshots/heroku.png" width="50%" height="50%">

</div>
 <br />
<div align="center">

![Static Badge](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)       ![Static Badge](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white)        ![Static Badge](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)     ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)     ![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)

</div>


Website contenerization + JENKINS pipeline + HEROKU deployment
----------------------

 <br />
<div align="center">

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

</div>
 <br />
Containerization of a website with Docker and NGINX + Create a Jenkins pipeline + Deploying App on HEROKU<br /><br />


For the installation of the Jenkins Server on your local machine, you can check my repo : <br />

- https://github.com/Tony-Dja/Jenkins_CI-CD_pipeline


<br />


HEROKU deployment constraint
----------------------

When you deploy a web server on HEROKU, you don't have the permission to bind the default port 80.<br />
HEROKU automatically assigns a binding port for your web server and renew it with each new deployment.<br /><br />
To bypass this rule you must create a dynamic environment variable which will retrieve the value that HEROKU returns to you, and insert into your NGINX config file when you launch your App.<br/>
This is what we are going to put in place.


Contenerization of your web site
----------------------

To deploy your HTML web site in a Docker container, we are going to follow these steps :<br />

- Create a Dockerfile with an Ubuntu image
- Install NGINX server
- Edit the NGINX config file to add an environnement variable
- Replace the default NGINX config file
- Retrieve the value of the environnement variable "PORT" return by HEROKU and insert into your config file


Dockerfile
----------------------

Here is the dockerfile with which we create our container embedding the NGINX server and the website files :

```
FROM ubuntu
LABEL org.opencontainers.image.authors="Tony DJA"

RUN apt-get update
RUN apt install -y nginx

ENV PORT=80

RUN rm -R /etc/nginx/sites-available/*
RUN rm -R /var/www/html/*

COPY ./website/ /var/www/html/
COPY default /etc/nginx/sites-available/

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default && nginx -g 'daemon off;'
```

# Docker image
FROM ubuntu
LABEL org.opencontainers.image.authors="Tony DJA"

# NGINX installation
RUN apt-get update
RUN apt install -y nginx

# Create the "PORT" environnement variable and assign a default value
ENV PORT=80

# Delete the NGINX default configuration file
RUN rm -R /etc/nginx/sites-available/*

# Delete all default files in the root folder of the web server
RUN rm -R /var/www/html/*

# Add you HTML files into the root folder of the web server
COPY ./website/ /var/www/html/

# Add your new NGINX default configuration file including the "PORT" environnement variable
COPY default /etc/nginx/sites-available/

# Launch your Web server => Inserting the value of "PORT" that HEROKU returns and insert it into your NGINX configuration file
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default && nginx -g 'daemon off;'