pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\apache-maven-3.9.9\\bin\\mvn"
        CONTAINER_IMAGE = "pravinkr11/bank-finance:0.1"
        PROMETHEUS_VERSION = "2.37.9"  // Set Prometheus version
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
                    if (isUnix()) {
                        sh '''
                            wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
                            tar xvf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
                            cd prometheus-${PROMETHEUS_VERSION}.linux-amd64
                            ./prometheus --config.file=prometheus.yml --web.listen-address=":9090" &
                        '''
                    } else {
                        bat '''
                            curl -o prometheus.zip https://github.com/prometheus/prometheus/releases/download/v%PROMETHEUS_VERSION%/prometheus-%PROMETHEUS_VERSION%.windows-amd64.zip
                            tar -xf prometheus.zip
                            cd prometheus-%PROMETHEUS_VERSION%.windows-amd64
                            start prometheus --config.file=prometheus.yml --web.listen-address=":9090"
                        '''
                    }
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
                        docker run -itd -p 8084:8081 %CONTAINER_IMAGE%
                    '''
                }
            }
        }
    }
}
