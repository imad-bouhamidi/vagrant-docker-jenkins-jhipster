echo "++++++ docker ssh ++++"
cat ~/.ssh/id_rsa.pub | sshpass -p "jhipster" ssh -oStrictHostKeyChecking=no -p 4022 jhipster@localhost 'mkdir ~/.ssh && cat >> ~/.ssh/authorized_keys'
#sshpass -p "jhipster" ssh -oStrictHostKeyChecking=no -p 4022 jhipster@localhost
#cd /jhipster
#sudo yo jhipster