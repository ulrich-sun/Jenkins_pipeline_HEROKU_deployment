pipeline {
  environment {
    ID_DOCKER = "ulrichnoumsi"
    IMAGE_NAME = "test"
    IMAGE_TAG = "latest"
    STAGING = "${ID_DOCKER}-staging"
    PRODUCTION = "${ID_DOCKER}-production"
  }

  agent none

  stages {
    stage('Build image') {
      agent any
      steps {
        script {
          sh "docker build -t ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Run container based on built image') {
      agent any
      steps {
        script {
          sh """
            echo "Clean Environment"
            docker rm -f ${IMAGE_NAME} || echo "container does not exist"
            docker run --name ${IMAGE_NAME} -d -p 3001:80 ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}
            sleep 5
          """
        }
      }
    }

    stage('Test image') {
      agent any
      steps {
        script {
          sh "curl http://localhost:3001 | grep -q 'Enjoy'"
        }
      }
    }

    stage('Clean Container') {
      agent any
      steps {
        script {
          sh """
            docker stop ${IMAGE_NAME}
            docker rm ${IMAGE_NAME}
          """
        }
      }
    }

    stage('Login and Push Image to Docker Hub') {
      agent any
      environment {
        DOCKERHUB_PASSWORD = credentials('dockerhub')
      }
      steps {
        script {
          sh """
            echo ${DOCKERHUB_PASSWORD_PSW} | docker login -u ${ID_DOCKER} --password-stdin
            docker push ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Push image to staging and deploy it') {
      when {
        expression { GIT_BRANCH == 'origin/main' }
      }
      agent any
      environment {
        HEROKU_API_KEY = credentials('HEROKU_API_KEY')
      }
      steps {
        script {
          sh """
            apk --no-cache add npm
            npm install -g heroku
            ls -l /var/run/docker.sock
            docker ps
            heroku container:login
            heroku create ${STAGING} || echo 'project already exists'
            heroku container:push -a ${STAGING} web
            heroku container:release -a ${STAGING} web
          """
        }
      }
    }

    stage('Push image to production and deploy it') {
      when {
        expression { GIT_BRANCH == 'origin/production' }
      }
      agent any
      environment {
        HEROKU_API_KEY = credentials('heroku_api_key')
      }
      steps {
        script {
          sh """
            apk --no-cache add npm
            npm install -g heroku
            ls -l /var/run/docker.sock
            docker ps
            heroku container:login
            heroku create ${PRODUCTION} || echo 'project already exists'
            heroku container:push -a ${PRODUCTION} web
            heroku
