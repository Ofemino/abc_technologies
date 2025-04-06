pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        MAVEN_HOME = "/usr/share/maven"
        PATH = "${MAVEN_HOME}:${JAVA_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = 'abc-tech-app'
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
                echo "🐳 Building Docker image..."
                script {
                    // Make sure Dockerfile exists and build the image
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "🚀 Running Docker container..."
                script {
                    // Run the Docker container and map Tomcat's 8080 to 8081
                    sh 'docker run -d -p 8081:8080 --name abc-tech-container ${DOCKER_IMAGE}'
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
            echo '🎉 Build, Docker image, and container deployed successfully!'
        }
        failure {
            echo '❌ Build failed. Please check logs.'
        }
    }
}
