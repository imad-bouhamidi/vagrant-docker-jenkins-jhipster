# Script for installing Jenkins, jenkins and dependencies
echo "======= Disable firewall ======"
sudo ufw disable

echo "======= Get jenkins ======"
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

echo "======= jenkins.list ======"
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

echo "======= apt-get update ======"
sudo apt-get update

echo "======= install jenkins ======"
sudo apt-get install jenkins -y

echo "======= apt-get update ======"
sudo apt-get update

echo "======= update jenkins ======"
sudo apt-get install jenkins -y

echo "======= read/write jenkins file ======"
sudo chmod 777 /etc/default/jenkins

echo "======= forward jenkins port to 8081 ======"
sudo sed -i '/HTTP_PORT=8080/c\HTTP_PORT=8081' /etc/default/jenkins

echo "======= read/write permission to jenkins_plugins script ======"
sudo chmod 777 /home/scripts/jenkins_plugins.sh 

echo "======= redirect to /home/scripts/ ======"
cd /home/scripts/

echo "======= jenkins_plugins scripts ======"
sudo ./jenkins_plugins.sh gitlab-plugin

echo "======= Restart Jenkins service ======"
sudo service jenkins restart
