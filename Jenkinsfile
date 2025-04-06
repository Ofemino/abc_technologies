pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-21-openjdk-amd64"
        MAVEN_HOME = "/usr/share/maven"
        PATH = "${MAVEN_HOME}:${JAVA_HOME}/bin:${env.PATH}"
        DOCKER_IMAGE = 'ofemino/abc-tech-app'  // Update this with your Docker Hub username and image name
        DOCKER_TAG = 'latest'  // Tag for your Docker image
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
                    // Build Docker image using the Dockerfile in the repo
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo "🔐 Logging into Docker Hub..."
                script {
                    // Login to Docker Hub with Jenkins credentials
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credential') {
                        echo "Successfully logged into Docker Hub"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "🚀 Pushing Docker image to Docker Hub..."
                script {
                    // Push Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credential') {
                        docker.image(DOCKER_IMAGE).push(DOCKER_TAG)
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
            echo '🎉 Build, Docker image, and container deployed successfully!'
        }
        failure {
            echo '❌ Build failed. Please check logs.'
        }
    }
}
