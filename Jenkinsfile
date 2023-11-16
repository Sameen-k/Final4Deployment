pipeline {
    agent {
        label 'awsDeploy'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('username-dockerhub')
        AWS_EKS_CLUSTER_NAME = ''
        AWS_EKS_REGION = 'US-East-1'
        KUBE_MANIFESTS_DIR = 'path to manifest files'
        SLACK_WEBHOOK_URL = 'https://hooks.slack.com/services/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'
    }          


    stages {
        stage('Build Backend') {
            steps {
                sh 'docker build -t user/image.'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push user/image'
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'docker build -t user/image .'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh 'docker push user/image'
                }
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
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')
                    ]) {
                        sh """
                            curl -X POST -H 'Content-type: application/json' \
                            --data '{"text":"Jenkins Pipeline Complete!"}' \
                            ${SLACK_WEBHOOK_URL}
                        """
                    }
                }
            }
        }
    }
}
