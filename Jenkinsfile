pipeline {
    agent {
        label 'awsDeploy'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('z0sun-dockerhub')
        AWS_EKS_CLUSTER_NAME = 'Final4Cluster'
        AWS_EKS_REGION = 'us-east-1'
        KUBE_MANIFESTS_DIR = '/home/ubuntu//agent2/workspace/e-commerce-pipeline_main/KUBE_MANIFEST'
    }          

    stages {
        stage('Build Backend') {
            steps {
                sh 'docker build -t morenodoesinfra/d8-backend:v1 -f Dockerfile.backend .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push morenodoesinfra/d8-backend:v1'
            }
        }

        stage('Build Frontend') {
            steps {
                sh 'docker build -t morenodoesinfra/d8-frontend:v4 -f Dockerfile.frontend .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push morenodoesinfra/d8-frontend:v4'
            }
        }



         stage('Init Terraform') {
            agent {
                label 'awsDeploy2'
            }
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                    string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')
                ]) {
                    dir('intTerraform') {
                        sh 'terraform init'
                        sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                        sh 'terraform apply plan.tfplan'
                    }
                }
            }
        }
    }
}
        
        stage('Deploy to EKS') {
            agent {
                label 'awsDeploy3'
            }
            steps {
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

        stage('Slack Notification') {
            steps {
                 script {
                    withCredentials([string(credentialsId: 'slack-webhook-url', variable: 'SLACK_WEBHOOK')]) {
                        echo "Sending Slack notification"

                        def message = '{"text": "Pipeline completed successfully!"}'

                        sh "curl -X POST -H 'Content-type: application/json' --data '${message}' ${SLACK_WEBHOOK}"
                    }
                }
            }
        }
    }
}
