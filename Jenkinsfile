pipeline {
    agent any
    
    environment {
    VERSION = "${BUILD_NUMBER}"

    }
    stages {
        stage('docker run') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker network create --driver bridge journals-net"
                    sh "docker run --name bd-mysql --network journals-net -e MYSQL_ROOT_PASSWORD=mysqlpass -d -p 3306:3306  mysql:5.7"
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker run --name app-journals --network journals-net -d quay.io/pablo_galleguillo/journals"
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
