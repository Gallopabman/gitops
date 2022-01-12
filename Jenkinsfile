pipeline {
    agent any

    }
    stages {
        stage('Docker build and publish') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker run -p 8083:8080 -d quay.io/pablo_galleguillo/journals:1.0.33"
                }       
            }           
        }
         stage('Maven snapshot') {
            steps {
                sh "curl http://100.109.4.7:8083"
            }
        }
    }    
}
