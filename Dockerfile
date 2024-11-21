# Use an official Ubuntu as a parent image
FROM ubuntu:24.04

# Set environment variables to avoid user interaction during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    openjdk-11-jdk \
    wget \
    unzip \
    docker.io \
    curl \
    gnupg2 \
    software-properties-common

# Install Jenkins
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add - && \
    sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt-get install -y jenkins

# Install SonarQube
RUN wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.0.43852.zip && \
    unzip sonarqube-8.9.0.43852.zip && \
    mv sonarqube-8.9.0.43852 /opt/sonarqube && \
    useradd -r -s /bin/false sonarqube && \
    chown -R sonarqube:sonarqube /opt/sonarqube && \
    chmod -R 775 /opt/sonarqube

# Expose necessary ports
EXPOSE 8080 9000 2375

# Start Jenkins and SonarQube
CMD service jenkins start && \
    su - sonarqube -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start" && \
    tail -f /var/log/jenkins/jenkins.log /opt/sonarqube/logs/sonar.log