pipeline {
    agent any

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'prppoomw/rps-game-logic-api', description: 'Docker image name')
        string(name: 'EC2_HOST', description: 'Target server to deploy docker image e.g. ec2-user@your-ec2-public-ip')
    }

    environment {
        IMAGE_TAG = "${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    def image = docker.build("${params.IMAGE_NAME}:${IMAGE_TAG}", "--platform=linux/amd64 .")
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        // stage('Deploy to EC2') {
        //     steps {
        //         sshagent(credentials: ['ec2-ssh-credentials']) {
        //             sh """
        //                 ssh -o StrictHostKeyChecking=no ${params.EC2_HOST} '
        //                     docker pull ${params.IMAGE_NAME}:${IMAGE_TAG} &&
        //                     docker stop \$(docker ps -q --filter ancestor=${params.IMAGE_NAME}:${IMAGE_TAG}) || true &&
        //                     docker rm \$(docker ps -a -q --filter ancestor=${params.IMAGE_NAME}:${IMAGE_TAG}) || true &&
        //                     docker run -d -p 8088:8088 ${params.IMAGE_NAME}:${IMAGE_TAG}
        //                 '
        //             """
        //         }
        //     }
        // }
    }
}