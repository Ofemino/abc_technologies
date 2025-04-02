pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64"
        MAVEN_HOME = "/usr/bin/mvn"
        PATH = ${MAVEN_HOME}bin${JAVA_HOME}bin${env.PATH}
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch 'main', 
                    credentialsId 'abc_tech', 
                    url 'https://github.com/Ofemino/abc_technologies.git'
            }
        }

        stage('Setup Java & Maven') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
            }
        }

        stage('Build Project') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Code Coverage') {
            steps {
                sh 'mvn jacocoreport'
            }
        }

        stage('Archive Build Artifacts') {
            steps {
                archiveArtifacts artifacts 'target.war', fingerprint true
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed. Check logs for details.'
        }
    }
}
