wsl_subnet=$(ip address show dev eth0 | grep -oP 'inet \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{2}' | cut -d ' ' -f 2)

sudo apt install ufw -y
sudo ufw allow 22/tcp
sudo ufw allow from $wsl_subnet
sudo ufw enable
