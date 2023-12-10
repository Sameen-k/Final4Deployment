pipeline {
    agent any

    environment {
        AWS_EKS_CLUSTER_NAME = 'cluster4v4'
        AWS_EKS_REGION = 'us-east-1'
        KUBE_MANIFESTS_DIR = '/home/ubuntu/Final4Deployment/KUBE_MANIFEST'
    }

    stages {
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
                            sh "kubectl apply -f deployment.yaml && kubectl apply -f service.yaml && kubectl apply -f ingress.yaml"
                        }
                    }
                }
            }
        }
    }
}

