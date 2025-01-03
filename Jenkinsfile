pipeline{
    agent any
    
    stages{
        stage("Clone Code"){
            steps{
                echo "Cloning the code"
                git url:"https://github.com/singhaldhruv/Next.js.git", branch: "main"
            }  
        }
        stage("build"){
            steps{
                echo "Building the image"
                sh "docker build -t nextjs-app ."
            }
        }
        stage("Push to Docker Hub"){
            steps{
                echo "Pushing the image to docker hub"
                withCredentials([usernamePassword(credentialsId:"DockerHub",passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                sh "docker tag nextjs-app ${env.dockerHubUser}/nextjs-app:latest"
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker push ${env.dockerHubUser}/nextjs-app:latest"
                }
            }
        }
        stage("Deploy"){
            steps{
                echo "Deploying the container"
                sh "docker-compose down && docker-compose up -d"               
            }
        }
    }
}
