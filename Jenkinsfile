pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "star-banking"
        DOCKER_TAG = "latest"
        DOCKER_REGISTRY = "pravinkr11"
    }
		
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
			
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/cloudpost03/star-agile-banking-finance'
            }
        }
	}
	
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
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
                script {
                    docker.withRegistry('', 'dockerhub_cred') {
                        bat "docker push %DOCKER_REGISTRY%/%DOCKER_IMAGE%:%DOCKER_TAG%"
                    }
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
