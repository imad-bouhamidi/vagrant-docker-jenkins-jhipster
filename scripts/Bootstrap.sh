# script to resolve SSH connection problem
# Set up sudo
echo "==== check for ubuntu update ===="
sudo apt-get update
echo "==== Set up sudoers problem ===="
sudo echo %vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant
sudo chmod 0440 /etc/sudoers.d/vagrant

# Setup sudo to allow no-password sudo for "sudo"
sudo usermod -a -G sudo vagrant

# setup ssh passphrase to authenticate to vagrant VM from cmd prompt via "vagrant ssh" using passphrase "vagrant" and "yes" as default answer in argument
echo "==== Adding ssh passphrase ===="
ssh-keygen -b 4096 -t rsa -f ~/.ssh/id_rsa -N '' <<< 'y'

# installing zip and unzip needed for jenkins plugin script
echo "======= Installing Zip & Unzip ======"
sudo apt-get install zip unzip
echo "======= Installing sshpass ======"
sudo apt-get install sshpass
