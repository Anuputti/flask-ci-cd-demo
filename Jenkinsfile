pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask-ci-cd-demo"
        DOCKERHUB_USER = "ananya777"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Anuputti/flask-ci-cd-demo.git'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME:latest .'
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    sh '''
                    docker run -d -p 5000:5000 --name test_app $IMAGE_NAME:latest
                    sleep 5
                    curl -f http://localhost:5000/
                    docker stop test_app
                    '''
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh '''
                        echo "$PASS" | docker login -u "$USER" --password-stdin
                        docker tag $IMAGE_NAME:latest $DOCKERHUB_USER/$IMAGE_NAME:latest
                        docker push $DOCKERHUB_USER/$IMAGE_NAME:latest
                        docker logout
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -af || true'
        }
    }
}
