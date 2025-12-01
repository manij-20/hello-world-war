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
                            credentialsId: 'b4d75de9-e9e1-4da6-a7d0-c04178470421',
                            usernameVariable: 'Mani_USER',
                            passwordVariable: 'Mani_PASS'  ),
                     sshUserPrivateKey(
                            credentialsId: 'b4d75de9-e9e1-4da6-a7d0-c04178470421',
                             keyFileVariable: 'Mani_SSH_KEY',
                             usernameVariable: 'Mani_SSH_USER' 
                        )])
            {
               sh "rm -rf hello-world-war_jenkins"
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
               sh "sudo cp /home/slave1/workspace/Jenkins_pipeline/target/hello-world-war-1.0.0.war /opt/apache-tomcat-9.0.112/webapps/"
           }
        }
    }
}
        }
        }
