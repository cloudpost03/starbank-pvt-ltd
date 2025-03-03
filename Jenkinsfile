pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\apache-maven-3.9.9\\bin\\mvn"
        CONTAINER_IMAGE = "pravinkr11/star-banking:latest"
        PROMETHEUS_VERSION = "2.37.9"
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

        stage('Setup Prometheus') {
            steps {
                script {
                    bat '''
                        REM Download Prometheus zip
                        curl -L -o prometheus.zip https://github.com/prometheus/prometheus/releases/download/v%PROMETHEUS_VERSION%/prometheus-%PROMETHEUS_VERSION%.windows-amd64.zip
                        
                        REM Extract Prometheus
                        powershell -Command "Expand-Archive -Path prometheus.zip -DestinationPath ."
                        
                        REM Navigate to Prometheus directory
                        pushd prometheus-%PROMETHEUS_VERSION%.windows-amd64
                        
                        REM Start Prometheus in the background
                        start /b prometheus.exe --config.file=prometheus.yml --web.listen-address=":9090"
                        
                        REM Return to previous directory
                        popd
                    '''
                }
            }
        }

        stage('Build with Maven') {
            steps {
                bat "\"%MAVEN_PATH%\" clean package -DskipTests"
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

        stage('Deploy & Monitor') {
            steps {
                script {
                    bat '''
                        docker run -itd -p 8081:8081 %CONTAINER_IMAGE%
                    '''
                }
            }
        }
    }
}
