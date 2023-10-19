<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/672b58d62fa5d424fb7162e33546c67f3bcbebc2/screenshots/jenkins.png" width="50%" height="50%">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/0adec933a113d173feee80d45760aa90133d1969/screenshots/heroku.png" width="50%" height="50%">

</div>
 <br />
<div align="center">

![Static Badge](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)       ![Static Badge](https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white)        ![Static Badge](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)     ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)     ![HTML5](https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white)

</div>


Website containerization + JENKINS pipeline + HEROKU deployment
----------------------

 <br />
<div align="center">

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

</div>
 <br />
Containerization of a website with Docker and NGINX + Build a Jenkins pipeline + Deploying App on HEROKU Cloud Platform<br /><br />


For the installation of the Jenkins Server on your local machine, you can check my repo : <br />

- https://github.com/Tony-Dja/Jenkins_CI-CD_pipeline


<br />


HEROKU deployment constraint
----------------------

When you deploy a web server on HEROKU, you don't have the permission to bind the default port 80.<br />
HEROKU automatically assigns a binding port for your web server and renew it with each new deployment.<br /><br />
To bypass this rule you must create a dynamic environment variable which will retrieve the value that HEROKU returns to you, and insert into your NGINX config file when you launch your App.<br/>
This is what we are going to put in place.


Containerization of your web site
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

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/2ae6577ad323867502813f28217c39b25966acd6/screenshots/jenkins-pipeline.png">

</div>
<br/>

To trigger the launch of our pipeline from an action carried out on GitHub we will create a WebHook.<br/>
For this you need to configure 2 things :

- Enter the URL of your Github repository
- Enable reception of github hook trigger

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/8f62bd61181002c376faef94119a78d8a9f2c3a7/screenshots/trigger.png">

</div>
<br/>

<strong>Install Jenkins plugins : </strong>

We adding 4 plugins to run the pipeline and allow it to perform these actions : 
- Build Docker Image and run containers
- Make a http request to test your image
- Use a Docker agent
- Installing the HEROKU CLI and push to the CLOUD

The 4 plugins you have to install :
- Docker
- Docker build step
- Docker pipeline
- Http request

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/44e36b6df648f593d3fc6b255009fb7cd8b5e720/screenshots/jenkins-plugins.png">

</div>


Public IP address
----------------------

Your local machine does not have a public IP address.<br/>
To link your Github repository and your Jenkins pipeline we need to create a relay with a public IP address and which will redirect Github notifications directly to our local Jenkins server in order to trigger the pipeline.

To make this way, you have to install "NGROK".<br/>
This tool will allow us to have a public IP map directly with our local machine

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock.png">
<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/d3754d6c9259776faa86a09faf651629c385c5fd/screenshots/ngrock2.png">

</div>
<br/>

<strong>1 - First, create your account on ngrok.com :</strong>

- <a href="https://ngrok.com/" target="_blank">https://ngrok.com/</a>
<br/>

<strong>2 - Create a Tunnel Authtokens :</strong>

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/27ab5208a26e08801a3d00a8f597f13a34ddab52/screenshots/ngrock-token.png">

</div>
<br/>

<strong>3 - Install NGROK agent :</strong>

- <a href="https://ngrok.com/docs/getting-started/?os=linux" target="_blank">https://ngrok.com/docs/getting-started/?os=linux</a>

```
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | \
  sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
  echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | \
  sudo tee /etc/apt/sources.list.d/ngrok.list && \
  sudo apt update && sudo apt install ngrok
```
<br/>

<strong>4 - Connect the agent with your NGROK account :</strong>

```
ngrok config add-authtoken <TOKEN>
```
<br/>

<strong>5 - Connect your local machine to NGROK :</strong>

```
ngrok http http://localhost:8080
```

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/27ab5208a26e08801a3d00a8f597f13a34ddab52/screenshots/ngrock-ip.png">

</div>

<br/>

Your public address is the https "Forwarding" address.<br/>
You can check that everything works into your browser. You must arrive on your jenkins server.

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/c7694ba66bf3d8b245a6eb1b24fd21bd0097b630/screenshots/jenkins-server.png">

</div>


Github WebHook
----------------------

<strong>1 - Create a WebHook</strong>

Use the forwarding address from ngrok

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/0b040058be5819e1e61dd1a6d10e215b89f7a2fc/screenshots/webhook.png">

</div>
<br/>

<strong>2 - Check if the WebHook is connected with your Jenkins server</strong>

Now, for each "Push action" on your GitHub repo, the trigger will start automically the execution of the jenkins pipeline.

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/0b040058be5819e1e61dd1a6d10e215b89f7a2fc/screenshots/webhook-check.png">

</div>


HEROKU Cloud Platform
----------------------

To be able to deploy our web server on the Cloud, we have to create an account on HEROKU :

- <a href="https://www.heroku.com/" target="_blank">https://www.heroku.com/</a>

After creating your account, you have to recover and copy you API key, which will allow us to authenticate with the heroku CLI from the Jenkis pipeline.

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/649dc12fad74aa452500865bba8cbe07369d21ef/screenshots/heroku-api.png">

</div>

<strong>Connect your HEROKU account with your Jenkins server</strong>

Now, go to your Jenkins server, and manage credentials.<br/>
Create new credentials with the ID "HEROKU_API_KEY".

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/7670fb0a1d019a217c96c4d4c24e49472a631aa6/screenshots/jenkins-credentials.png">

</div>


Jenkins file
----------------------

All the pipeline is configured in the Jenkins file.
<br/>
<br/>
We make 6 stages :
- Image Build
- Run docker container based on build image
- Test build image
- Clean containers before deployment
- Deploy on HEROKU Staging
- Deploy on HEROKU Production

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/649dc12fad74aa452500865bba8cbe07369d21ef/screenshots/jenkins-stage.png">

</div>

```
pipeline {
    environment {
        IMAGE_NAME = "tonydja/static-website"
        IMAGE_TAG = "latest"
        CONTAINER = "website"
        CONTAINER_DYNOS_HEROKU = "web"
        STAGING = "tonydja-staging"
        PRODCUTION = "tonydja-production"
        LOCALHOST_DOCKER_NETWORK = "192.168.208.3"
    }
    agent none
    
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
                }
            } 
        }
        stage('Run docker container based on build image') {
            agent any
            steps {
                script {
                    sh '''
                    docker run -d -p 3000:80 --name $CONTAINER ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 5
                    '''
                }
            } 
        }
        /* Just Replace the IP address of ENV var "LOCALHOST_DOCKER_NETWORK" with your own local Docker container IP
        stage('Test image') {
            agent any
            steps {
                script {
                    sh 'curl http://$LOCALHOST_DOCKER_NETWORK:3000 | grep -q "Enjoy"'
                }
            } 
        }
        */
        stage('Clean container') {
            agent any
            steps {
                script {
                    sh '''
                    docker container stop $CONTAINER
                    docker container rm $CONTAINER
                    '''
                }
            } 
        }
        stage('Push image in STAGING and Deploy') {
            when {
                expression { GIT_BRANCH == 'origin/main'}
            }
            agent {
                docker {
                    image 'franela/dind'
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
            }
            environment {
                HEROKU_API_KEY = credentials('HEROKU_API_KEY')
            }
            steps {
                script {
                    sh '''
                    apk --no-cache add npm
                    npm install -g heroku
                    ls -l /var/run/docker.sock
                    docker ps
                    heroku container:login
                    heroku create $STAGING || echo "project already exist"
                    heroku container:push -a $STAGING $CONTAINER_DYNOS_HEROKU
                    heroku container:release -a $STAGING $CONTAINER_DYNOS_HEROKU
                    '''
                }
            } 
        }
        stage('Push image in PRODUCTION and Deploy') {
            when {
                expression { GIT_BRANCH == 'origin/main'}
            }
            agent {
                docker {
                    image 'franela/dind'
                    args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
                    }
            }
            environment {
                HEROKU_API_KEY = credentials('HEROKU_API_KEY')
            }
            steps {
                script {
                    sh '''
                    apk --no-cache add npm
                    npm install -g heroku
                    ls -l /var/run/docker.sock
                    docker ps
                    heroku container:login
                    heroku create $PRODCUTION || echo "project already exist"
                    heroku container:push -a $PRODCUTION $CONTAINER_DYNOS_HEROKU
                    heroku container:release -a $PRODCUTION $CONTAINER_DYNOS_HEROKU
                    '''
                }
            } 
        }
    }
}
```

<strong>Local Docker network IP</strong>

Before testing your image with a http request you have to put your own local Docker network IP into the environnement variable "LOCAL_DOCKER_NETWORK".<br/>
To retrieve this address on your local machine, you just have to inspect your docker container :

```
docker ps
docker inspect <name of container where the Docker daemon is running>"
```

After doing this action, you can uncomment the "Test image" stage.


<strong>Heroku dynos</strong>

Never change the value "web" of the variable "CONTAINER_DYNOS_HEROKU"<br/><br/>
The dynos is in fact a special name for naming containers on HEROKU Cloud platform. And "web" is a type of container that launching a web process. We need it for making NGINX working correctly.


<strong>Other environnement variables</strong>

You can change the other environnement variables as you wish.


<strong>STAGING and PRODUCTION deployment</strong>

Just an important step. For deploy our App in these 2 stages, we use a Docker agent with a franela/dind image.<br/>
We must run the stages into a Docker container to be able to install the HEROKU CLI, log in and push.
<br />

To deploy the container you must log in to root user and mouting a volume to map the Docker socket on the host machine to the container

```
args '-u root:root -v /var/run/docker.sock:/var/run/docker.sock'
```

Installing HEROKU CLI

```
apk --no-cache add npm
npm install -g heroku
```

Add traces to log to check the Docker socket is connected
```
ls -l /var/run/docker.sock
docker ps
```

Login to HEROKU and Deploy App

```
heroku container:login
heroku create $STAGING || echo "project already exist"
heroku container:push -a $STAGING $CONTAINER_DYNOS_HEROKU
heroku container:release -a $STAGING $CONTAINER_DYNOS_HEROKU
```


Run the pipeline and deploy
----------------------

Make a push on GitHub repository or run the pipeline manually into Jenkins.

You can check the Stage view into Jenkins

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/649dc12fad74aa452500865bba8cbe07369d21ef/screenshots/jenkins-stage.png">

</div>

When the pipeline is finished, go to your HEROKU account and check that your 2 applications STAGING and PRODUCTION are well deployed.

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/9b6e3bd78628b7540782098caf9b472513828b09/screenshots/heroku-stage.png">

</div>

Click on it and check that your web Dyno is ON.

Click on the "open App" button.

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/9b6e3bd78628b7540782098caf9b472513828b09/screenshots/heroku-stage.png">

</div>

Enjoy !

<div align="center">

<img src="https://github.com/Tony-Dja/Jenkins_pipeline_HEROKU_deployment/blob/9b6e3bd78628b7540782098caf9b472513828b09/screenshots/heroku-stage.png">

</div>