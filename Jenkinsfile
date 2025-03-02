pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = "C://apache-maven-3.9.9/bin/mvn"  // Ensure Maven is correctly referenced
        SSH_PRIVATE_KEY = "C:/path/to/id_rsa"  // Ensure the correct private key for SSH
        REMOTE_HOST = "172.22.215.121"  // Use actual IP instead of hostname
        REMOTE_USER = "root"  
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
                bat "docker build -t %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG% ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: 'https://index.docker.io/v1/']) {
                        bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    bat '''
                        echo y | plink -ssh -i %SSH_PRIVATE_KEY% %REMOTE_USER%@%REMOTE_HOST% ^
                        "ansible-playbook -i /path/to/inventory /path/to/ansible-playbook.yml"
                    '''
                }
            }
        }
    }
}
