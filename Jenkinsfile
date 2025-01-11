@Library("Jenkins-Shared-Library") _

pipeline {
    agent { label "dhruv" }

    stages {
        stage('Cloning') {
            steps {
                clone("https://github.com/singhaldhruv/Next.js.git","main") 

                echo "Code Cloned Successfully using shared library"
            }
        }

        stage('Check and Install Docker') {
            steps {
                script {
                    if (sh(script: "which docker || echo 'not found'", returnStdout: true).trim() == "not found") {
                        echo "Docker is not installed. Installing Docker..."
                        sh """
                        sudo apt-get update
                        sudo apt-get install -y docker.io
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        """
                        echo "Docker installed successfully."
                    } else {
                        echo "Docker is already installed."
                    }
                }
            }
        }
        
        stage('Building Image') {
            steps {
                docker_build("nextjs-app","latest","dhruv2727")
                echo "Image built successfully using shared library"
            }
        }
        
        stage("Push to Docker Hub"){
            steps{
                echo "Pushing the image to docker hub"
                script{
                    docker_push("nextjs-app","latest","dhruv2727")
                    echo "Image pushed successfully"
                }
            }
        }
        
        stage('Deploy'){
            steps{
                sh "docker-compose down && docker-compose up -d"
                echo "This is deploying the code successfully again"
            }
        }
    }
}
