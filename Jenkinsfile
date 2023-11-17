pipeline {
    agent {
        label 'awsDeploy'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('morenodoesinfra-dockerhub')
        AWS_EKS_CLUSTER_NAME = 'Dep9Cluster'
        AWS_EKS_REGION = 'us-east-1'
        KUBE_MANIFESTS_DIR = '/agent2/workspace/e-commerce-pipeline_main/KUBE_MANIFEST'
        SLACK_WEBHOOK_CREDENTIALS = credentials('SLACK_WEBHOOK_CREDENTIALS')
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
                sh 'docker build -t morenodoesinfra/d8-frontend:v3 -f Dockerfile.frontend .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push morenodoesinfra/d8-frontend:v3'
                }
            }
        

        stage('Deploy to EKS') {
            agent {
                label 'awsDeploy2'
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
                    withCredentials([string(credentialsId: SLACK_WEBHOOK_CREDENTIALS, variable: 'slackWebhookUrl')]) {
                        sh """
                            curl -X POST -H 'Content-type: application/json' \
                            --data '{"text":"Jenkins Pipeline Complete!"}' \
                            ${slackWebhookUrl}
                        """
                    }
                }
            }
        }
    }
}
