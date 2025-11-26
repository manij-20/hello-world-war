pipeline {
    agent any
    stages {
        stage('checkout') {
             steps {
               sh "rm -rf hello-world-war_jenkins"
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
               sh "cp /var/lib/jenkins/workspace/hello_world_war/target/hello-world-war-1.0.0.war /opt/apache-tomcat-10.1.49/webapps"
           }
        }
    }
}
