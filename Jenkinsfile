def manifest

pipeline {
    agent { node { label 'local' } }

    environment {
    VERSION = "${BUILD_NUMBER}"
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
                    sh "mvn versions:set -DnewVersion=${manifest.environment.staging.version}.$VERSION-SNAPSHOT -f Code/pom.xml"
                    sh "mvn clean deploy --settings Code/settings.xml -f Code/pom.xml -DskipTests" 
                }
            }
        }
        stage('Docker build and publish') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker images"
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker build --build-arg VERSION=$VERSION -t quay.io/pablo_galleguillo/journals:$VERSION-SNAPSHOT ."
                    sh "docker push quay.io/pablo_galleguillo/journals:$VERSION-SNAPSHOT"   
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
        stage('url test') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(100) {
                        sh "curl --max-time 60 http://100.109.4.7:8083/"
                    }
                }
            }
        }
        stage('docker prune'){
            steps {
                script {
                    def doc_containers = sh(returnStdout: true, script: 'docker container ps -aq').replaceAll("\n", " ") 
                    if (doc_containers) {
                    sh "docker stop ${doc_containers}"
                    sh "docker rm ${doc_containers}"
                    }
                }
            }
        }
        stage('jar clean') {
            steps {
                script{
                    sh "rm -dr ./Code/target/"
                }
            }
        }
        stage('Maven release') {
            steps {
                script{
                    manifest = readYaml file: 'manifest.yaml'                 
                    sh "mvn versions:set -DnewVersion=${manifest.environment.production.version}.$VERSION -f Code/pom.xml"
                    sh "mvn deploy -DnewVersion=${manifest.environment.production.version}.$VERSION --settings Code/settings.xml -f Code/pom.xml -DskipTests"  
                }
            }
        }
        stage('Docker prod build and publish') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker images"
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker build --build-arg VERSION=$VERSION -t quay.io/pablo_galleguillo/journals:$VERSION ."
                    sh "docker push quay.io/pablo_galleguillo/journals:$VERSION"   
                }       
            }           
        }
        stage('mysql-db prod') {
            steps {
                sh "docker run --name mysql -h mysql --net=bootcamp -e MYSQL_ROOT_PASSWORD=mysqlpass -d -p 3306:3306  mysql:5.7"
            }
        }
        stage('journals-app prod') {
            steps { 
                withCredentials([string(credentialsId: 'quay-pass', variable: 'SECRET')]) { 
                    sh "docker login quay.io -u pablo_galleguillo -p ${SECRET}"
                    sh "docker run -h journals -d --net=bootcamp -p 8083:8080 quay.io/pablo_galleguillo/journals:latest"
                }
            }
        }
        stage('url prod test') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    retry(60) {
                        sh "curl http://100.109.4.7:8083/"
                    }
                }
            }
        }    
        stage('prod docker prune'){
            steps {
                script {
                    def doc_containers = sh(returnStdout: true, script: 'docker container ps -aq').replaceAll("\n", " ") 
                    if (doc_containers) {
                    sh "docker stop ${doc_containers}"
                    sh "docker rm ${doc_containers}"
                    }
                }
            }
        }  
    }      
}    