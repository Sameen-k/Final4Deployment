pipeline {
        agent any


    stages {
        stage('build images') {
            agent { label 'agentDocker' }
            steps {
                    sh 'docker-compose build'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh 'docker push dannydee93/kestrel_web'
            }
        }

        stage('Deploy to EKS') {
            agent { label 'awsDeploy3' } // or use 'awsDeploy3' if intended
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh "aws eks --region $AWS_EKS_REGION update-kubeconfig --name $AWS_EKS_CLUSTER_NAME"
                        sh "kubectl apply -f $KUBE_MANIFESTS_DIR"
                    }
                }
            }
        }
    }
}
