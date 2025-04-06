# Use Tomcat base image with JDK 21
FROM tomcat:10.1-jdk21-temurin

# Remove default Tomcat webapps (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat's webapps directory
COPY target/ABCtechnologies-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat's default port
EXPOSE 8080
