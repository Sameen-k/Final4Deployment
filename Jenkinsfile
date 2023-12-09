pipeline {
    agent any

    stages {
        stage('Deploy to EKS') {
            agent { label 'agentEKS' }
            steps {
                dir('KUBE_MANIFEST') {
                    script {
                        withCredentials([
                            string(credentialsId: 'AWS_ACCESS_KEY', variable: 'AWS_ACCESS_KEY_ID'),
                            string(credentialsId: 'AWS_SECRET_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                        ]) {
                            sh "kubectl apply -f $KUBE_MANIFESTS_DIR"
                        }
                    }
                }
            }
        }
    }
}
