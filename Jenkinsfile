pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }

    environment { 
        COURSE = 'Jenkins'
        appVersion = ""
    }

    options {
        timeout(time: 1, unit: 'HOURS') 
        disableConcurrentBuilds()
    }

// this is build section. added comment for just webhook checking
    stages {
        stage('Read Version') {
            steps {
                script {
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "app version : ${appVersion}"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh """
                    npm install
                """
            }
        }

        stage('Build Image') {
            steps {
                sh """
                    docker build -t catalogue:${appVersion} .
                    docker images
                """
            }
        }
        stage('Deploy') {
            when { 
                expression { "$params.DEPLOY" == "true" }
                }

            steps {
                echo "Deploying..."
            }
        }
    }
    post { 
        always { 
            echo 'I will always say Hello again!'
            cleanWs()
        }
        success{
            echo "Build and Test completed successfully!"
        }
        failure{
            echo "Build or Test failed!"
        }
        aborted{
            echo "Build or Test aborted!"
        }
    }
}