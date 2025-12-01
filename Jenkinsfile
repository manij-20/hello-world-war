pipeline {
    // agent { label 'java' }
    agent none
    parameters {
string(name: 'cmd', defaultValue: 'default', description: 'A sample string parameter')
booleanParam(name: 'SAMPLE_BOOLEAN', defaultValue: true, description: 'A boolean parameter')
choice(name: 'cmd1', choices: ['install', 'compile'], description: 'Choose one option')
}
    stages {
        stage('hello-world-war') {
        parallel {
        stage('checkout') {
            agent { label 'java' }
        steps {
                
                 withCredentials([usernamePassword(
                    credentialsId: '0eec030f-5691-4702-bbd5-42e104f8b43c',
                    usernameVariable: 'admin',
                    passwordVariable: 'admin_password'
                ),
                    sshUserPrivateKey(
    credentialsId: 'b4d75de9-e9e1-4da6-a7d0-c04178470421',
    keyFileVariable: 'KEY_FILE',
    usernameVariable: 'SSH_USER'
               )
    ]) {

               sh "rm -rf hello-world-war"
               sh "https://github.com/manij-20/hello-world-war.git"
           }
        }
        }
        stage('Build') {
            agent { label 'java' }
             steps {
               sh "mvn $cmd $cmd1"
           }
        }
        
        stage('Deploy') {
            agent { label 'java' }
             steps {
               sh "sudo cp /home/slave1/workspace/Hello_world_pipeline/target/hello-world-war-1.0.0.war /opt/apache-tomcat-9.0.112/webapps/"
           }
        }
    }
}
        }
        }
