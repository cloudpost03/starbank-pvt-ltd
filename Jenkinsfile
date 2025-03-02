pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\apache-maven-3.9.9\\bin\\mvn"
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
                ])  
            }
        }

        stage('Build') {
            steps {
                bat "\"%MAVEN_PATH%\" clean package -DskipTests"
            }
        }

        stage('Test') {
            steps {
                bat "\"%MAVEN_PATH%\" test"
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
                    withCredentials([string(credentialsId: 'dockerhub_cred', variable: 'DOCKER_HUB_PASSWORD')]) {
                        if (isUnix()) {
                            sh '''
                                echo $DOCKER_HUB_PASSWORD | docker login -u pravinkr11 --password-stdin
                                docker pull pravinkr11/bank-finance:0.1
                                docker run -itd -p 8084:8081 pravinkr11/bank-finance:0.1
                            '''
                        } else {
                            bat '''
                                echo %DOCKER_HUB_PASSWORD% | docker login -u pravinkr11 --password-stdin
                                docker pull pravinkr11/bank-finance:0.1
                                docker run -itd -p 8084:8081 pravinkr11/bank-finance:0.1
                            '''
                        }
                    }
                }
            }
        }
    }
}
