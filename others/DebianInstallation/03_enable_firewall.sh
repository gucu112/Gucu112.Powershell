sudo apt install ufw -y
sudo ufw allow 22/tcp
sudo ufw allow from $(hostname -I | cut -d . -f -2).0.0/12
sudo ufw enable
