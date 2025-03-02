pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\apache-maven-3.9.9\\bin\\mvn"
        CONTAINER_IMAGE = "pravinkr11/star-banking:latest"
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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat '''
                            echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                            docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_cred', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        if (isUnix()) {
                            sh '''
                                echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                                docker pull $CONTAINER_IMAGE
                                docker run -itd -p 8084:8081 $CONTAINER_IMAGE
                            '''
                        } else {
                            bat '''
                                echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                                docker pull %CONTAINER_IMAGE%
                                docker run -itd -p 8084:8081 %CONTAINER_IMAGE%
                            '''
                        }
                    }
                }
            }
        }
    }
}
