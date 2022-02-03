def manifest

pipeline {
    agent any

    }
    stages {
        stage('gitlab') {
          steps {
             echo 'Notify GitLab'
             updateGitlabCommitStatus name: 'build', state: 'pending'
             updateGitlabCommitStatus name: 'build', state: 'success'
            }
        }
        stage('Maven test') {
            steps {
                sh "mvn clean test --file Code/pom.xml -DskipTests" 
            }
        }
        stage('Maven snapshot') {
            steps {
                script{
                    manifest = readYaml file: 'manifest.yaml'
                    sh "mvn versions:set -DnewVersion=${manifest.environment.staging.version}-SNAPSHOT -f Code/pom.xml"
                    sh "mvn clean deploy --settings Code/settings.xml -f Code/pom.xml -DskipTests" 
                }
            }
        }
        stage('Maven release') {
            steps {
                script{
                    manifest = readYaml file: 'manifest.yaml'
                    sh "mvn versions:set -DnewVersion=${manifest.environment.production.version} -f Code/pom.xml"
                    sh "mvn deploy -DnewVersion=$VERSION --settings Code/settings.xml -f Code/pom.xml -DskipTests"  
                }
            }
        }
        stage('Docker build and publish') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker build --build-arg VERSION=$VERSION -t quay.io/pablo_galleguillo/journals:$VERSION ."
                    sh "docker push quay.io/pablo_galleguillo/journals:$VERSION"   
                }       
            }           
        }
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
           