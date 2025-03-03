pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = sh(script: 'which mvn', returnStdout: true).trim()
        CONTAINER_IMAGE = "${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
        ANSIBLE_INVENTORY = "/path/to/inventory"  // Update this path as needed
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/cloudpost03/star-agile-banking-finance.git',
                        credentialsId: 'github_cred'
                    ]]
                ])
            }
        }

        stage('Compile with Maven') {
            steps {
                sh '''
                    set -e
                    ${MAVEN_PATH} compile
                '''
            }
        }

        stage('Test with Maven') {
            steps {
                sh '''
                    set -e
                    ${MAVEN_PATH} test
                '''
            }
        }

        stage('Install with Maven') {
            steps {
                sh '''
                    set -e
                    ${MAVEN_PATH} install
                '''
            }
        }

        stage('Package with Maven') {
            steps {
                sh '''
                    set -e
                    ${MAVEN_PATH} clean package -DskipTests
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    set -e
                    docker build -t ${CONTAINER_IMAGE} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'dockerhub_cred', url: 'https://index.docker.io/v1/']) {
                        sh '''
                            set -e
                            docker push ${CONTAINER_IMAGE}
                        '''
                    }
                }
            }
        }

        stage('Deploy Application using Ansible') {
            steps {
                script {
                    sh '''
                        set -e
                        ansible-playbook -i ${ANSIBLE_INVENTORY} ansible/ansible-playbook.yml
                    '''
                }
            }
        }
    }
}
