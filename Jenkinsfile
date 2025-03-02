pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:/apache-maven-3.9.9/bin/mvn"  // Ensure correct Maven path
        CONTAINER_IMAGE = "pravinkr11/bank-finance:0.1"  // Define the container image
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
                bat '"%MAVEN_PATH%" clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                bat '"%MAVEN_PATH%" test'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: '']) {
                        bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
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
                            docker run -itd -p 8084:8081 $CONTAINER_IMAGE
                        '''
                    } else {
                        // Running on Windows Jenkins (WSL)
                        bat '''
                            wsl sudo apt-get update &&
                            wsl sudo apt-get install -y docker.io &&
                            wsl sudo systemctl start docker &&
                            wsl docker run -itd -p 8084:8081 %CONTAINER_IMAGE%
                        '''
                    }
                }
            }
        }
    }
}
