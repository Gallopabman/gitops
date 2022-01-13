pipeline {
    agent any
    
    environment {
    VERSION = "${BUILD_NUMBER}"

    }
    stages {
        stage('docker run') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker run -d quay.io/pablo_galleguillo/journals"
                }       
            }           
        }
        stage('curl') {
            steps {
                sh "curl http://localhost:8083"
            }
        }
    }    
}
