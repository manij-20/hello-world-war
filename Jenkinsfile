pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "mani2009/hello-war"
        TAG = "latest"
        DOCKER_CREDENTIALS = "dockerhub-creds"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git 'https://github.com/manij-20/hello-world-war.git'
            }
        }

        stage('Build WAR with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$TAG .'
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: "$DOCKER_CREDENTIALS",
                usernameVariable: 'DOCKER_USER',
                passwordVariable: 'DOCKER_PASS')]) {

                    sh '''
                    docker login -u $DOCKER_USER -p $DOCKER_PASS
                    docker push $DOCKER_IMAGE:$TAG
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes with Helm') {
            steps {
                sh 'helm upgrade --install hello-war ./hello-war-chart'
            }
        }
    }
}
