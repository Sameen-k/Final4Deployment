pipeline {
    agent {
        label 'awsDeploy'
    }



    stages {
        stage('Build Backend') {
            steps {
                sh 'docker build -t dannydee93/api.net_app -f Dockerfile.backend .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push dannydee93/api.net_app'
            }
        }

        stage('Build Frontend') {
            steps {
                dir('src') {
                sh 'docker build -t dannydee93/kestrel_web -f Dockerfile.frontend .'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push dannydee93/kestrel_web'
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

    }
}
