pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
        MAVEN_PATH = sh(script: 'which mvn', returnStdout: true).trim()
        CONTAINER_IMAGE = "${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}"
        ANSIBLE_INVENTORY = "/var/lib/jenkins/workspace/star-banking-pipeline/inventory.ini"
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/cloudpost03/star-agile-banking-finance.git',
                        credentialsId: 'github_cred'
                    ]]]
                )
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                script {
                    sh """
                        cat <<EOF > ${ANSIBLE_INVENTORY}
                        [k8s_master]
                        172.31.15.176 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/assign-key-mumbai.pem ansible_connection=ssh

                        [k8s_worker]
                        172.31.0.42 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/assign-key-mumbai.pem ansible_connection=ssh

                        [monitoring]
                        172.31.34.38 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/assign-key-mumbai.pem ansible_connection=ssh

                        [jenkins]
                        172.31.47.191 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/assign-key-mumbai.pem ansible_connection=ssh

                        [all:vars]
                        ansible_ssh_common_args='-o StrictHostKeyChecking=no'
                        EOF
                    """
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
