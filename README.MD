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

- <strong>Docker image</strong><br/>
FROM ubuntu
LABEL org.opencontainers.image.authors="Tony DJA"

- <strong>NGINX installation</strong><br/>
RUN apt-get update
RUN apt install -y nginx

- <strong>Create the "PORT" environnement variable and assign a default value</strong><br/>
ENV PORT=80

- <strong>Delete the NGINX default configuration file</strong><br/>
RUN rm -R /etc/nginx/sites-available/*

- <strong>Delete all default files in the root folder of the web server</strong><br/>
RUN rm -R /var/www/html/*

- <strong>Add you HTML files into the root folder of the web server</strong><br/>
COPY ./website/ /var/www/html/

- <strong>Add your new NGINX default configuration file including the "PORT" environnement variable</strong><br/>
COPY default /etc/nginx/sites-available/

- <strong>Launch your Web server => Inserting the value of "PORT" that HEROKU returns and insert it into your NGINX configuration file</strong><br/>
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default && nginx -g 'daemon off;'



Jenkins pipeline
----------------------

Now create a new Jenkins pipeline :

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/2ae6577ad323867502813f28217c39b25966acd6/screenshots/jenkins-pipeline.png">

To trigger the launch of our pipeline from an action carried out on GitHub we will create a WebHook.<br/>
For this you need to configure 2 things :

- Enter the URL of your Github repository
- Enable reception of github hook trigger

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/8f62bd61181002c376faef94119a78d8a9f2c3a7/screenshots/trigger.png">


Public IP address
----------------------

Your local machine does not have a public IP address.<br/>
To link your Github repository and your Jenkins pipeline we need to create a relay with a public IP address and which will redirect Github notifications directly to our local Jenkins server in order to trigger the pipeline.

To make this way, you have to install "NGROCK".<br/>
This tool will allow us to have a public IP map directly with our local machine

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock.png">
<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock2.png">

</div>


1 - First, create a account on ngrock.com:

- <a href="https://ngrok.com/" target="_blank">https://ngrok.com/</a>

2 - Create a Tunnel Authtokens :

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock.png">

</div>

3 - Install NGROK agent :

- <a href="https://ngrok.com/docs/getting-started/?os=linux" target="_blank">https://ngrok.com/docs/getting-started/?os=linux</a>

```
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok
```

4 - Connect the agent with your NGROCK account :

```
ngrok config add-authtoken <TOKEN>
```

5 - Connect your local machine to NGROCK :

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock.png">

</div>