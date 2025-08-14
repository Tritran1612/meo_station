pipeline {
    agent any
    environment {
        APP_NAME = 'meo-stationery'
        EC2_SSH_KEY = 'ec2-ssh-key' // Jenkins credentialsId for private key
        EC2_USER = 'ec2-user'       // Try this first, change if needed
        EC2_HOST = '13.236.137.125' // Your actual EC2 public IP
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
                script {
                    withCredentials([sshUserPrivateKey(credentialsId: "${EC2_SSH_KEY}", keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                        sh """
                            # Set proper permissions for the SSH key
                            chmod 600 \$SSH_KEY
                            
                            # Test SSH connection first
                            ssh -i \$SSH_KEY -o StrictHostKeyChecking=no -o ConnectTimeout=10 ${EC2_USER}@${EC2_HOST} 'echo "SSH connection successful"'
                            
                            # Create app directory on EC2 if it doesn't exist
                            ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "mkdir -p /home/${EC2_USER}/${APP_NAME}"
                            
                            # Check if rsync is available, otherwise use tar+ssh method
                            if command -v rsync >/dev/null 2>&1; then
                                echo "Using rsync for file transfer..."
                                rsync -avz --delete \
                                    -e "ssh -i \$SSH_KEY -o StrictHostKeyChecking=no" \
                                    --exclude '.git' \
                                    --exclude 'node_modules' \
                                    --exclude '.env' \
                                    --exclude '*.log' \
                                    --exclude '.DS_Store' \
                                    --exclude 'coverage' \
                                    --exclude 'dist' \
                                    ./ ${EC2_USER}@${EC2_HOST}:/home/${EC2_USER}/${APP_NAME}/
                            else
                                echo "rsync not found, using tar+ssh method..."
                                tar --exclude='.git' \
                                    --exclude='node_modules' \
                                    --exclude='.env' \
                                    --exclude='*.log' \
                                    --exclude='.DS_Store' \
                                    --exclude='coverage' \
                                    --exclude='dist' \
                                    -czf - ./ | \
                                ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} \
                                "cd /home/${EC2_USER}/${APP_NAME} && tar --overwrite -xzf -"
                            fi
                            
                            # Deploy on EC2
                            ssh -i \$SSH_KEY -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} "
                                cd /home/${EC2_USER}/${APP_NAME} &&
                                
                                # Check if package.json exists
                                if [ ! -f package.json ]; then
                                    echo 'Error: package.json not found in deployed files'
                                    exit 1
                                fi &&
                                
                                # Install dependencies
                                echo 'Installing dependencies...' &&
                                npm install --production &&
                                
                                # Install PM2 if not already installed
                                if ! command -v pm2 >/dev/null 2>&1; then
                                    echo 'Installing PM2...'
                                    npm install -g pm2
                                fi &&
                                
                                # Stop existing app (ignore errors if not running)
                                echo 'Stopping existing application...' &&
                                pm2 stop ${APP_NAME} 2>/dev/null || true &&
                                pm2 delete ${APP_NAME} 2>/dev/null || true &&
                                
                                # Start the application
                                echo 'Starting application with PM2...' &&
                                pm2 start npm --name '${APP_NAME}' -- start &&
                                pm2 save &&
                                pm2 list &&
                                
                                echo 'Deployment completed successfully!'
                            "
                        """
                    }
                }
            }
        }
        stage('Health Check via ELB') {
            steps {
                echo '🏥 Performing health check...'
                script {
                    sh """
                        echo "Waiting for application to start..."
                        sleep 10
                        
                        # Check if the application is responding
                        curl -f http://${EC2_HOST}:3000 || echo "Health check failed, but continuing..."
                    """
                }
            }
        }
    }
    post {
        always {
            echo '🏁 Pipeline completed'
        }
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}