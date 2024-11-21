pipeline {
    agent any

    environment {
        registry = '637423326087.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo-group12' // AWS ECR registry
        awsRegion = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/DevOps-NT548/microservices-ci-cd-using-jenkins-HW2']])
            }
        }


        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building image for webapp deployment..'
                    dockerImage = docker.build registry 
                    dockerImage.tag("$BUILD_NUMBER")
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    echo 'Pushing image to AWS ECR..'
                    // Login to AWS ECR
                    sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 767397928267.dkr.ecr.us-east-1.amazonaws.com'
                    // Push the Docker image to ECR
                    sh 'docker push 767397928267.dkr.ecr.us-east-1.amazonaws.com/my-docker-repo-group12:$BUILD_NUMBER'
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                echo 'Deploying webapp with Helm..'
                sh "helm upgrade first --install helmchart --namespace model-serving --set image.tag=$BUILD_NUMBER"  // Deploy using Helm
            }
        }
    }
}