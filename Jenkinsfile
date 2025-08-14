pipeline {
    agent any

    environment {
        AWS_REGION       = 'ap-southeast-2'
        AWS_ACCOUNT_ID   = '675613596870'
        APP_NAME         = 'meo-stationery'
        ECR_REPOSITORY   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}"
        IMAGE_TAG        = "${BUILD_NUMBER}"
        IMAGE_URI        = "${ECR_REPOSITORY}:${IMAGE_TAG}"
        EC2_SSH_KEY_ID   = 'ec2-ssh-key' // Jenkins credentialsId for SSH private key
        EC2_USER         = 'ec2-user'
        EC2_HOST         = 'your-ec2-public-ip-or-dns'
    }

    tools {
        nodejs '18'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Checking out source code...'
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '📥 Installing Node.js dependencies...'
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running tests...'
                sh 'npm test || true'
            }
        }

        stage('Build App') {
            steps {
                echo '⚙️ Building the application...'
                sh 'npm run build || echo "No build script found"'
            }
        }

        stage('AWS CLI Setup') {
            steps {
                echo '🔑 Configuring AWS CLI...'
                withCredentials([usernamePassword(credentialsId: 'aws-token', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh '''
                        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
                        unzip -o awscliv2.zip
                        ./aws/install --update
                        rm -rf awscliv2.zip aws/
                        export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                        export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
                        export AWS_DEFAULT_REGION=${AWS_REGION}
                        aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image ${IMAGE_URI}..."
                sh """
                    docker build -t ${IMAGE_URI} .
                    docker tag ${IMAGE_URI} ${ECR_REPOSITORY}:latest
                """
            }
        }

        stage('Push to ECR') {
            steps {
                echo '📤 Pushing image to Amazon ECR...'
                withCredentials([usernamePassword(credentialsId: 'aws-token', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
                        docker push ${IMAGE_URI}
                        docker push ${ECR_REPOSITORY}:latest
                    """
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo '🚀 Deploying to EC2 instance...'
                sshagent (credentials: ["${EC2_SSH_KEY_ID}"]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            docker pull ${IMAGE_URI} &&
                            docker stop ${APP_NAME} || true &&
                            docker rm ${APP_NAME} || true &&
                            docker run -d --name ${APP_NAME} -p 80:3000 \\
                                --env-file /home/${EC2_USER}/.env \\
                                ${IMAGE_URI}
                        '
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                echo '🩺 Checking application health...'
                sh """
                    for i in {1..10}; do
                        if curl -s http://${EC2_HOST} > /dev/null; then
                            echo '✅ App is live!'
                            exit 0
                        fi
                        echo '⏳ Waiting for app...'
                        sleep 10
                    done
                    echo '❌ App did not become healthy in time'
                    exit 1
                """
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning up...'
            sh 'docker system prune -f || true'
        }
        success {
            echo '🎉 Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
