pipeline {
    agent any

    tools {
        nodejs 'node25'
    }

    environment {
        IMAGE_NAME = "angular-ui-jenkins"
        CONTAINER_NAME = "angular-ui-jenkins"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Lokeshpunwani29/AngularCI'
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
                docker ps -a -q -f name=%CONTAINER_NAME% > temp.txt
                set /p CID=<temp.txt
                if not "%CID%"=="" (
                    docker stop %CONTAINER_NAME%
                    docker rm %CONTAINER_NAME%
                )
                del temp.txt

                docker run -d -p 8080:80 --name %CONTAINER_NAME% %IMAGE_NAME%
                '''
            }
        }
    }
}
