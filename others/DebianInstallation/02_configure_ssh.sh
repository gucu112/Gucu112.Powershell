sudo apt install openssh-client -y

# Use SSH agent from Windows host
message="\e[92mssh-key(s) are now available in your ssh-agent until you lock your windows machine! \n \e[0m"
sudo tee -a ~/.bashrc <<EOF

# enable ssh-agent forwarding from Windows host
alias ssh-add='ssh-add.exe'
alias ssh='ssh-add.exe -l > /dev/null || ssh-add.exe && echo -e "$message" && ssh.exe'
EOF

git config --global core.sshcommand "ssh.exe"
