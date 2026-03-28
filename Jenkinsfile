pipeline {
   agent any
    
    
    environment {
        APP_PATH = '/var/www/tummoc'
        REMOTE_KEY = credentials('ssh_cred')
        DOCKER_KEY = credentials('ghcr_cred')
        DOCKER_HUB= credentials('dockerhub-cred')
        REGISTRY = 'ghcr.io'
        IMAGE_NAME = 'udemy-clone'
        TAG = 'latest-demo'
        VERSION_TAG = "${BUILD_NUMBER}-${JOB_NAME}"
        DOCKER_JENKINS_HOME= credentials('dock_host_path')
        
    }

    stages {
        stage('checkout') {
            steps {
                // repo is not private for assignment view && no dev test, stag, prod branches 
                 cleanWs()
                git branch: 'master',  url: 'https://github.com/vinayhpl/django-udemy-clone.git'
            }
        }
        stage('lint') {
            steps {
                script {
                    def status = sh(
                        script: '''
                        docker run --rm \
                          -v $(pwd):/app \
                          python:3.11-slim \
                          sh -c "
                            pip install flake8 && \
                            flake8 /app --count --select=E9,F63,F7,F82 --show-source --statistics
                          "
                        ''',
                        returnStatus: true
                    )
        
                    if (status != 0) {
                        unstable("Lint issues found")
                    }
                }
            }
        }

       stage('trivy fs scan') {
    steps {
        script {
            sh '''
            echo "=== Running Trivy FS Scan (HTML Report) ==="

            docker run --rm \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v $DOCKER_JENKINS_HOME/workspace/$JOB_NAME:/app \
              -v $DOCKER_JENKINS_HOME/workspace/$JOB_NAME:/output \
              -v /tmp/trivy-cache:/root/.cache/ \
              -w /app \
              aquasec/trivy:0.69.3 fs . \
              --scanners vuln \
              --severity HIGH,CRITICAL \
              --no-progress \
              --format template \
              --template "@contrib/html.tpl" \
              -o /output/trivy-fs-report.html \
              --exit-code 0

            echo "=== Report Details ==="
            ls -lh | grep trivy
            '''
        }
    }
}
       

        stage('docker build') {
            steps {
                script {
                    sh '''
                    echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin
                    DOCKER_BUILDKIT=1 docker build \
                   -t $DOCKER_KEY_USR/$IMAGE_NAME:$TAG \
                   -t $DOCKER_KEY_USR/$IMAGE_NAME:$VERSION_TAG .
                    '''
                }
            }
        }
        
stage('trivy image scan') {
    steps {
        script {
            sh '''
            echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USR --password-stdin

            echo "Workspace (container): $(pwd)"
            echo "Workspace (host): $DOCKER_JENKINS_HOME/workspace/$JOB_NAME"

            docker run --rm \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -v $DOCKER_JENKINS_HOME/workspace/$JOB_NAME:/output \
              -v /tmp/trivy-cache:/root/.cache/ \
              aquasec/trivy:0.69.3 image \
              $DOCKER_KEY_USR/$IMAGE_NAME:$TAG \
              --scanners vuln \
              --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL \
              --no-progress \
              --format template \
              --template "@contrib/html.tpl" \
              -o /output/trivy-image-report.html \
              --exit-code 0

            echo "=== Report Details ==="
            ls -lh | grep trivy
            '''
        }
    }
}

        stage('docker push') {
            steps {
                script {
                    sh '''
                        echo $DOCKER_KEY_PSW | docker login $REGISTRY -u $DOCKER_KEY_USR --password-stdin
                        docker push $DOCKER_KEY_USR/$IMAGE_NAME:$TAG
                        docker push $DOCKER_KEY_USR/$IMAGE_NAME:$VERSION_TAG
                    '''
                }
            }
        }

        stage('docker cleani') {
            steps {
                sh 'docker image prune -f'
            }
        }

     stage('deploy') {
    steps {
        withCredentials([sshUserPrivateKey(
            credentialsId: 'ssh_cred',
            keyFileVariable: 'SSH_KEY',
            usernameVariable: 'SSH_USER'
        )]) {
            sh '''
            ssh -o StrictHostKeyChecking=no -i $SSH_KEY $SSH_USER << EOF
                cd ${APP_PATH}
                echo $DOCKER_KEY_PSW | docker login ${REGISTRY} -u $DOCKER_KEY_USR --password-stdin
                docker compose pull
                docker compose down
                docker compose up -d
                docker image prune -f
          #  EOF
            '''
        }
    }
}
}

post {
    always {
        archiveArtifacts artifacts: 'trivy-*-report.*', fingerprint: true, allowEmptyArchive: true
   //     cleanWs()
    }
}
}
