def manifest

pipeline {
    agent { node { label 'local' } }

    environment {
    VERSION = "${BUILD_NUMBER}"
    DEPLOY_PROD = "${manifest.environment.production.deploy}"
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
                    sh "docker build --build-arg VERSION=$VERSION -f docker-snapshot -t quay.io/pablo_galleguillo/journals:${manifest.environment.staging.version}.$VERSION-SNAPSHOT ."
                    sh "docker push quay.io/pablo_galleguillo/journals:${manifest.environment.staging.version}.$VERSION-SNAPSHOT"   
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
                sh "curl http://100.109.4.7:8083/"
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
        stage('Maven release') {
            steps {
                script{
                    manifest = readYaml file: 'manifest.yaml'
                    if ${manifest.environment.production.version}=true {                 
                    sh "mvn versions:set -DnewVersion=${manifest.environment.production.version} -f Code/pom.xml"
                    sh "mvn deploy -DnewVersion=${manifest.environment.production.version} --settings Code/settings.xml -f Code/pom.xml -DskipTests"  
                    }
                }
            }
        }      
    }      
}    