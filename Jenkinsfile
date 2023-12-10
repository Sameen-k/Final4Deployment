pipeline {

    agent { 
        label 'agentDocker'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dannydee93-dockerhub')
        AWS_EKS_CLUSTER_NAME = 'clusterdd'
        AWS_EKS_REGION = 'us-east-1' 
        KUBE_MANIFESTS_DIR = '/home/ubuntu/Final4Deployment/KUBE_MANIFEST'
    }

    stages {

        stage('Build API') {
            
            steps {
                dir('src/PublicApi') {
                    sh 'docker-compose build -t dannydee93/eshoppublicapi -f Dockerfile' 
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh 'docker push dannydee93/eshoppublicapi'
                    sh 'docker-compose up'
                }
            }
            
        }

        stage('Build WEB') {
            
            steps {
                dir('src/Web') {
                    sh 'docker-compose build -t dannydee93/eshopwebmvc -f Dockerfile'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin' 
                    sh 'docker push dannydee93/eshopwebmvc'
                    sh 'docker-compose up'
                }
            }
            
        }

        stage('Deploy to EKS') {

            agent { 
                label 'agentEKS'
            }
            
            steps {
                dir('KUBE_MANIFEST') {
                    script {
                        withCredentials([
                            string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                            string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')
                        ]) {
                            sh "aws eks --region $AWS_EKS_REGION update-kubeconfig --name $AWS_EKS_CLUSTER_NAME"
                            sh "kubectl apply -f $KUBE_MANIFESTS_DIR"
                        }
                    }
                }
            }
            
        }

    }
    
}





