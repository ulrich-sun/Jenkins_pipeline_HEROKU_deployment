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
<br />

HEROKU deployment constraint
----------------------

When you deploy a web server App on HEROKU, you don't have the permission to bind the default port 80.<br />
HEROKU automatically assigns a binding port for your web server and renews it with each new deployment.<br /><br />
To bypass this rule you must create a dynamic environment variable which will retrieve the value that HEROKU returns to you, and insert into your NGINX config file when you launch your App.<br/>
This is what we are going to put in place.


Contenerization of your web site
----------------------

To deploy your HTML web site in a Docker container, we are going to follow these steps :<br />

- Create a Dockerfile with an Ubuntu image
- Install NGINX server
- Edit the NGINX config file to add an environnement variable