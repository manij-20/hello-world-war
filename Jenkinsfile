pipeline {
    agent { label 'java' }
    stages {
        stage('checkout') {
             steps {
               sh "rm -rf hello-world-war"
               sh "git clone https://github.com/manij-20/hello-world-war.git"
           }
        }
      stage('build') {
             steps {
               sh "mvn clean package"
           }
        }
        stage('Deploy') {
             steps {
               sh "sudo cp /home/slave1/workspace/Hello_world_pipeline/target/hello-world-war-1.0.0.war /opt/apache-tomcat-9.0.112/webapps"
           }
        }
    }
}
