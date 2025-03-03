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

        stage('Compile with Maven') {
            steps {
                bat "\"${MAVEN_PATH}\" compile"
            }
        }

        stage('Test with Maven') {
            steps {
                bat "\"${MAVEN_PATH}\" test"
            }
        }

        stage('Install with Maven') {
            steps {
                bat "\"${MAVEN_PATH}\" install"
            }
        }

        stage('Package with Maven') {
            steps {
                bat "\"${MAVEN_PATH}\" clean package -DskipTests"
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: '']) {
                        bat "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy Application using Ansible') {
            steps {
                script {
                    bat '''
                        ansible-playbook -i ${ANSIBLE_INVENTORY} ansible/ansible-playbook.yml
                    '''
                }
            }
        }
    }
}
