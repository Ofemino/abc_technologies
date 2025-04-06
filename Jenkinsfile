pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        MAVEN_HOME = "/usr/share/maven"
        PATH = "${MAVEN_HOME}:${JAVA_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = "ofemino/abc-tech-app"
        DOCKER_TAG = "latest"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Checking out code from repository..."
                git branch: 'main',
                    credentialsId: 'abc_tech',
                    url: 'https://github.com/Ofemino/abc_technologies.git'
                echo "✅ Code checked out successfully!"
            }
        }

        stage('Verify Java & Maven') {
            steps {
                echo "⚙️ Verifying environment..."
                sh 'java -version'
                sh 'mvn -version'
            }
        }

        stage('Compile Project') {
            steps {
                echo "🛠️ Compiling the project..."
                sh 'mvn clean compile -X'
            }
        }

        stage('Run Unit Tests') {
            steps {
                echo "🧪 Running unit tests..."
                sh 'mvn test'
            }
        }

        stage('Package Application') {
            steps {
                echo "📦 Packaging application..."
                sh 'mvn package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🐳 Building Docker image..."
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "⬆️ Pushing Docker image to Docker Hub..."
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                        docker.push("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    }
                }
            }
        }

        stage('Archive WAR File') {
            steps {
                script {
                    echo "📁 Checking for WAR file to archive..."
                    if (fileExists('target/ABCtechnologies-1.0.war')) {
                        echo "✅ WAR file found. Archiving..."
                        archiveArtifacts artifacts: 'target/ABCtechnologies-1.0.war'
                    } else {
                        echo "❌ WAR file NOT found!"
                        error "Build may have failed. WAR not generated."
                    }
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Build and Docker push completed successfully!'
        }
        failure {
            echo '❌ Build failed. Please check logs.'
        }
    }
}
