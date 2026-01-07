pipeline {

    /* Force Jenkins to actually run on built-in node */
    agent { label 'built-in' }

    tools {
        nodejs 'node25'   // must EXACTLY match Jenkins → Manage Jenkins → Tools
    }

    environment {
        IMAGE_NAME = "angular-ui-jenkins"
        CONTAINER_NAME = "angular-ui-jenkins"
        APP_PORT = "9090"   // avoid conflict with Jenkins (8080)
    }

    stages {

        stage('Agent Check') {
            steps {
                bat 'echo Jenkins agent is executing stages'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Lokeshpunwani29/AngularCI'
            }
        }

        stage('Node & NPM Check') {
            steps {
                bat '''
                node -v
                npm -v
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                bat 'npm ci'
            }
        }

        stage('Build Angular') {
            steps {
                bat 'npm run build -- --configuration production'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Deploy') {
            steps {
                bat '''
                docker ps -a -q -f name=%CONTAINER_NAME% > cid.txt
                set /p CID=<cid.txt

                if not "%CID%"=="" (
                    docker stop %CONTAINER_NAME%
                    docker rm %CONTAINER_NAME%
                )

                del cid.txt

                docker run -d -p %APP_PORT%:80 --name %CONTAINER_NAME% %IMAGE_NAME%
                '''
            }
        }
    }

    post {
        success {
            bat 'echo Application deployed successfully'
        }
        always {
            bat 'echo Pipeline finished'
        }
    }
}
