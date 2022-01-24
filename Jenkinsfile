pipeline {
    agent any
    
    environment {
    VERSION = "${BUILD_NUMBER}"

    }
    stages {
        stage('mysql-db') {
            steps {
                sh "docker run --name mysql -h mysql --net=bootcamp -e MYSQL_ROOT_PASSWORD=mysqlpass -d -p 3306:3306  mysql:5.7"
            }
        }
        stage('journals-app') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker run -h journals -d --net=bootcamp -p 8083:8080 quay.io/pablo_galleguillo/journals:latest"
                }       
            }           
        }
    }    
}
