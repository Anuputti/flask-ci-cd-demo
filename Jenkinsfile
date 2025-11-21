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
                    docker run -d --network jenkins-net --name test_app flask-ci-cd-demo:latest
                    sleep 8
                    docker logs test_app
                    docker exec $(docker ps -q -f name=test_app) curl -f http://localhost:5000/ || (docker ps && exit 1)
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

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    echo "Applying Kubernetes manifests..."
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml

                    echo "Waiting for rollout..."
                    kubectl rollout status deployment/flask-ci-cd-demo
                    '''
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

