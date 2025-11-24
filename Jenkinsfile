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
                    sh '''
                       # run the container and publish port so we can curl from host (Jenkins)
                       docker run -d --name test_app -p 5000:5000 ${DOCKERHUB_USER}/${IMAGE_NAME}:latest

                       # wait for app to start (increase if your app needs more time)
                       sleep 5

                       # try to curl the health/root endpoint; on failure print logs and fail
                       if ! curl -fsS http://localhost:5000/ ; then
                       echo "App did not respond. Container logs:"
                       docker logs test_app || true
                       docker stop test_app || true
                       docker rm -f test_app || true
                       exit 1
      		       fi

                       # cleanup
		       docker stop test_app || true
     		       docker rm -f test_app || true
                    '''
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
