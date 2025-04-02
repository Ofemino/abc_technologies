pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64"
        MAVEN_HOME = "/usr/bin"
        PATH = "${MAVEN_HOME}:${JAVA_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = 'abc_technologies'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    credentialsId: 'abc_tech', 
                    url: 'https://github.com/Ofemino/abc_technologies.git'
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
                echo 'Building the project using Maven...'
                sh 'mvn clean package -X'
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
                script {
                    sh 'ls -l target'
                    if (fileExists('target/abctech.war')) {
                        echo "WAR file found, archiving..."
                        archiveArtifacts artifacts: 'target/abctech.war', fingerprint: true
                    } else {
                        echo "WAR file NOT found!"
                        error "WAR file does not exist. Build may have failed."
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credential') {
                        docker.image(DOCKER_IMAGE).push('latest')
                    }
                }
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
