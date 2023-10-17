pipeline {
    environment {
        IMAGE_NAME = "tonydja/static-website"
        IMAGE_TAG = "latest"
        CONTAINER = "website"
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
        stage('Test image') {
            agent any
            steps {
                script {
                    sh 'curl http://$LOCALHOST_DOCKER_NETWORK:3000 | grep -q "Enjoy"'
                }
            } 
        }
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
                    args '-u root:root'
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
                    heroku container:login
                    heroku create $STAGING || echo "project already exist"
                    heroku container:push $STAGING $CONTAINER
                    heroku container:release -a $STAGING $CONTAINER
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
                    args '-u root:root'
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
                    heroku container:login
                    heroku create $PRODUCTION || echo "project already exist"
                    heroku container:push $PRODUCTION $CONTAINER
                    heroku container:release -a $PRODUCTION $CONTAINER
                    '''
                }
            } 
        }
    }
}