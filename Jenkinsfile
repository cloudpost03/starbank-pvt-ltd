pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C://apache-maven-3.9.9/bin//mvn"  // Ensure Maven is correctly referenced
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
                bat '%MAVEN_PATH% clean package -DskipTests'  // Use full Maven path
            }
        }

        stage('Test') {
            steps {
                bat '%MAVEN_PATH% test'  // Use full Maven path
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% ."  // Windows variable syntax
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub_cred') {
                        bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                bat 'wsl ansible-playbook -i /mnt/c/path-to-inventory /mnt/c/path-to-ansible-playbook.yml'
            }
        }
    }
}
