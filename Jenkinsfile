pipeline {
    environnment {
        IMAGE_NAME = "tonydja/static-website"
        IMAGE_TAG = "latest"
        CONTAINER = "website"
        STAGING = "tonydja-staging"
        PRODCUTION = "tonydja-production"
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
                    sh 'curl http://192.168.208.2:3000 | grep -q "Enjoy"'
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
                expression { GET_BRANCH == 'origin/main'}
            }
            agent any
            environnement {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
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
                expression { GET_BRANCH == 'origin/main'}
            }
            agent any
            environnement {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
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