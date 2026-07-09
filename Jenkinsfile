pipeline {
    agent {
        node {
            label 'AGENT-1'
        }
    }

    environment { 
        COURSE = 'Jenkins'
        appVersion = ""
        ACC_ID = "367012942501"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
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

        stage('Unit Test') {
            steps {
                sh """
                    npm test
                """
            }
        }

        stage('Build Image') {
            steps {
                script{
                    withAWS(region:'us-east-1',credentials:'aws-creds') {
                        sh """
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                            docker images
                            docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                        """
                    }
                }
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