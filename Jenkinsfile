pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: maven
    image: maven:3.9-eclipse-temurin-11
    command: ["cat"]
    tty: true
    resources:
      requests:
        cpu: "200m"
        memory: "512Mi"
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command: ["/busybox/cat"]
    tty: true
    resources:
      requests:
        cpu: "100m"
        memory: "256Mi"
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  - name: tools
    image: dtzar/helm-kubectl:latest
    command: ["cat"]
    tty: true
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
    volumeMounts:
    - name: workspace-volume
      mountPath: /home/jenkins/agent
  volumes:
  - name: kaniko-secret
    secret:
      secretName: dockerhub-secret
      items:
      - key: .dockerconfigjson
        path: config.json
  - name: workspace-volume
    emptyDir: {}
  restartPolicy: Never
'''
        }
    }

    environment {
        DOCKER_IMAGE = "mani2009/hello-world-war"
        IMAGE_TAG    = "${BUILD_NUMBER}"
        HELM_CHART   = "hello-war-chart"
        HELM_VERSION = "0.1.0"
        JFROG_URL    = "https://trial5tqwdi.jfrog.io/artifactory/jenkins-helm"
        KUBE_NS      = "default"
        JFROG_CREDS  = credentials('jfrog-creds')
    }

    stages {

        stage('Maven Build WAR') {
            steps {
                container('maven') {        // ← use maven container
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Docker Build & Push via Kaniko') {
            steps {
                container('kaniko') {
                    sh """
                        /kaniko/executor \
                          --context=dir://${WORKSPACE} \
                          --dockerfile=${WORKSPACE}/dockerfile \
                          --destination=${DOCKER_IMAGE}:${IMAGE_TAG} \
                          --destination=${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

        stage('Helm Package & Push to JFrog') {
            steps {
                container('tools') {
                    sh """
                        helm lint ${HELM_CHART}
                        helm package ${HELM_CHART} --version ${HELM_VERSION}
                        curl -u ${JFROG_CREDS_USR}:${JFROG_CREDS_PSW} \
                            -T ${HELM_CHART}-${HELM_VERSION}.tgz \
                            ${JFROG_URL}/${HELM_CHART}-${HELM_VERSION}.tgz
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('tools') {
                    sh """
                        helm repo add jfrog-helm ${JFROG_URL} \
                            --username ${JFROG_CREDS_USR} \
                            --password ${JFROG_CREDS_PSW} \
                            --force-update
                        helm repo update
                        helm upgrade --install ${HELM_CHART} jfrog-helm/${HELM_CHART} \
                            --version ${HELM_VERSION} \
                            --set image.repository=${DOCKER_IMAGE} \
                            --set image.tag=${IMAGE_TAG} \
                            --namespace ${KUBE_NS} \
                            --wait \
                            --timeout 2m
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                container('tools') {
                    sh """
                        kubectl rollout status deployment/${HELM_CHART} \
                            --namespace ${KUBE_NS} \
                            --timeout=120s
                        kubectl get pods -n ${KUBE_NS} -l app.kubernetes.io/name=${HELM_CHART}
                        kubectl get svc ${HELM_CHART} -n ${KUBE_NS}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ SUCCESS — image tag: ${IMAGE_TAG}"
        }
        failure {
            echo "❌ FAILED — check logs above"
        }
    }
}
