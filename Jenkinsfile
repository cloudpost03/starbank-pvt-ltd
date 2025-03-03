pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
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

        stage('Compile with Maven') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Test with Maven') {
            steps {
                sh "mvn test"
            }
        }

        stage('Install with Maven') {
            steps {
                sh "mvn install"
            }
        }

        stage('Package with Maven') {
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: '']) {
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Deploy Application using Ansible') {
            steps {
                script {
                    sh '''
                        ansible-playbook -i inventory.ini ansible/ansible-playbook.yml
                    '''
                }
            }
        }
    }
}
