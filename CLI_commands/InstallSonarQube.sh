sudo apt update
sudo apt -y install openjdk-17-jdk
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.7.0.96327.zip
sudo apt install unzip
unzip sonarqube-10.7.0.96327.zip
cd sonarqube-10.7.0.96327
cd bin/
cd linux-x86-64/
./sonar.sh console
