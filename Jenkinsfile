pipeline {
    agent any

    environment {
        APP_NAME     = 'meo-stationery'
        EC2_SSH_KEY  = 'ec2-ssh-key' // Jenkins credentialsId for private key
        EC2_USER     = 'ec2-user'
        EC2_HOST     = '13.236.137.125'
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
                echo '📥 Installing dependencies...'
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
                echo '⚙️ Building application...'
                sh 'npm run build || echo "No build script found"'
            }
        }

        stage('Deploy to EC2') {
            steps {
                echo '🚀 Deploying application to EC2...'
                sshagent (credentials: ["${EC2_SSH_KEY}"]) {
                    sh """
                        rsync -avz --delete \
                            --exclude '.git' \
                            --exclude 'node_modules' \
                            ./ ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/${APP_NAME}

                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            cd /home/${EC2_USER}/${APP_NAME} &&
                            npm install --production &&
                            pm2 stop ${APP_NAME} || true &&
                            pm2 start npm --name "${APP_NAME}" -- start
                        '
                    """
                }
            }
        }

        stage('Health Check via ELB') {
            steps {
                echo '🩺 Checking application health through ELB...'
                script {
                    def ELB_DNS = 'your-elb-dns.amazonaws.com'
                    sh """
                        for i in {1..10}; do
                            if curl -fs http://${ELB_DNS} > /dev/null; then
                                echo '✅ App is live on ELB!'
                                exit 0
                            fi
                            echo '⏳ Waiting for app on ELB...'
                            sleep 10
                        done
                        echo '❌ App not responding via ELB'
                        exit 1
                    """
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
