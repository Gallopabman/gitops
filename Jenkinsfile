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
                    sh "docker run -d --name app-journals --net=host -p 8083:8080 quay.io/pablo_galleguillo/journals:latest"
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
