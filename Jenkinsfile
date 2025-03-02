pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\apache-maven-3.9.9\\bin\\mvn"  // Corrected backslashes for Windows
        CONTAINER_IMAGE = "pravinkr11/bank-finance:0.1"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/cloudpost03/star-agile-banking-finance',
                        credentialsId: 'github_cred'
                    ]]
                ]])
            }
        }

        stage('Build') {
            steps {
                bat "\"${env.MAVEN_PATH}\" clean package -DskipTests"
            }
        }

        stage('Test') {
            steps {
                bat "\"${env.MAVEN_PATH}\" test"
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE}:${env.DOCKER_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: '']) {
                        bat "docker push ${env.DOCKER_REGISTRY}/${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    if (isUnix()) {
                        // Running on Linux Jenkins
                        sh '''
                            sudo apt-get update &&
                            sudo apt-get install -y docker.io &&
                            sudo systemctl start docker &&
                            docker run -itd -p 8084:8081 ${env.CONTAINER_IMAGE}
                        '''
                    } else {
                        // Running on Windows Jenkins
                        bat '''
                            docker run -itd -p 8084:8081 ${env.CONTAINER_IMAGE}
                        '''
                    }
                }
            }
        }
    }
}
