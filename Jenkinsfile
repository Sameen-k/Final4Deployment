pipeline {
    agent any
    stages {
        stage('Build Images') {
            agent {
                label 'agentDocker'
            }
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Login and Push') {
            agent {
                label 'agentDocker'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'dannydee93-dockerhub', usernameVariable: 'DOCKERHUB_CREDENTIALS_USR', passwordVariable: 'DOCKERHUB_CREDENTIALS_PSW')]) {
                    sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh 'docker push dannydee93/eshopwebmvc'
                    sh 'docker push dannydee93/eshoppublicapi'
                }
            }
        }
        stage('Deploy to EKS') {
            agent { label 'agentEKS' }
            steps {
                dir('KUBE_MANIFEST') {
                    script {
                        withCredentials([
                            string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh "aws eks --region us-east-1 update-kubeconfig --name cluster01"
                            sh "kubectl apply -f /home/ubuntu/agent1/workspace/final_Annie-working/KUBE_MANIFEST"
                        }
                    }
                }
            }
        }        
    }
}
