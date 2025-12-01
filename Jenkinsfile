pipeline {
    agent none
    parameters {
string(name: 'cmd', defaultValue: 'default', description: 'A sample string parameter')
booleanParam(name: 'SAMPLE_BOOLEAN', defaultValue: true, description: 'A boolean parameter')
choice(name: 'cmd1', choices: ['install', 'compile'], description: 'Choose one option')
}
    stages {
        stage ( 'hello-world-war' ) {
            parallel {
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
    }
}
