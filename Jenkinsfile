pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C:\\Maven\\bin\\mvn"
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
                bat '%MAVEN_PATH% clean package'
            }
        }

        stage('Verify JAR File') {
            steps {
                bat 'dir target\\*.jar'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                docker.withRegistry('', 'dockerhub_cred') {
                    bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
                }
            }
        }

        stage('Deploy') {
            steps {
                bat 'ansible-playbook -i inventory deploy.yml'
            }
        }
    }
}
