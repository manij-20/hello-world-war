pipeline {
    agent any

    environment {
        IMAGE_NAME = "hello-world-app"
        CONTAINER_NAME = "hello-world-container"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/manij-20/hello-world-war.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Stop Old Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker run -d -p 8081:8080 \
                --name $CONTAINER_NAME \
                $IMAGE_NAME
                '''
            }
        }
    }
}
