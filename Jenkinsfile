pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']], // Ensure branch name is correct
                    userRemoteConfigs: [[
                        url: 'https://github.com/cloudpost03/star-agile-banking-finance',
                        credentialsId: 'github_cred'
                    ]]
                ])
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'  // Windows uses 'bat' instead of 'sh'
            }
        }

        stage('Test') {
            steps {
                bat 'mvn test'  // Change 'sh' to 'bat' for Windows
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% ."  // Windows variable syntax
            }
        }

        stage('Push Docker Image') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub_cred', url: '']) {
                    bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
                }
            }
        }

        stage('Deploy') {
            steps {
                bat 'ansible-playbook -i inventory deploy.yml'  // Change 'sh' to 'bat'
            }
        }
    }
}
