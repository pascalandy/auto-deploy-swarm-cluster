#!/usr/bin/env bash
set -u
set -e

# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# 12_ubuntu-configs.sh
# Copy-paste the content of this file in a private https://gist.github.com/
# 2017-05-09_09h23 | is the last script update
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #

echo "checkpoint 101 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
mkdir -p ~/temp; cd ~/temp; ls -la;


# — — — # — — — # — — — #
cat <<- EOF
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#                                                               #
#	Part #1
#	KEYS
#	config-scale.sh
#                                                               #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
EOF
sleep 2


# — — — # — — — # — — — #
echo "checkpoint 102 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
PIK_STD="\e[39mPikwi >\e[39m "
PIK_BLUE="\e[34mPikwi >\e[39m "
PIK_PINK="\e[35mPikwi >\e[39m "
PIK_GREEN="\e[36mPikwi >\e[39m "
PIK_WHITE="\e[97mPikwi >\e[39m "
PIK_DEF="\e[39m"


# — — — # — — — # — — — #
echo "Update root password "
echo "checkpoint 103 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt
# SENSITIVE_DATA
export ENV_PASS="# SENSITIVE_DATA# SENSITIVE_DATA# SENSITIVE_DATA# SENSITIVE_DATA3098fh2o4iub"
echo "root:$ENV_PASS" | chpasswd
unset ENV_PASS


# — — — # — — — # — — — #
echo "Copy the private key so this machine can talk with our private git server" && echo
echo "checkpoint 104 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
mkdir -p ~/.ssh/
# SENSITIVE_DATA
echo "-----BEGIN OPENSSH PRIVATE KEY-----
b3Bl# SENSITIVE_DATA# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATAE_DATAAAAAF2NsdXN0ZXJub2RlcyAyMDE3LTAyLTI0AQID
# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA# SENSITIVE_DATA# SENSITIVE_DATA# SENSITIVE_DATA# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA
# SENSITIVE_DATA# SENSITIVE_DATA
-----END OPENSSH PRIVATE KEY-----" >> ~/.ssh/id_rsa

echo "checkpoint 105 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sudo chmod 600 ~/.ssh/id_rsa

	# Another way to copy the key:
	# wget # SENSITIVE_DATA
	# cp unicorn_2016-11-17_21h07-vate.txt ~/.ssh/id_rsa
	# rm -f unicorn_2016-11-17_21h07-vate.txt
	#sudo chmod 600 ~/.ssh/id_rsa


# — — — # — — — # — — — #
echo "Copy cloudflare keys"
echo "checkpoint 106 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
mkdir -p /root/.cloudflare
# SENSITIVE_DATA
cat > $HOME/.cloudflare/env <<EOF
CF_API_KEY=# SENSITIVE_DATA# SENSITIVE_DATA
CF_API_EMAIL=# SENSITIVE_DATA
EOF


# — — — # — — — # — — — #
cat <<- EOF
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
#                                                               #
# >>> Part #2
# >>> General stuff
#                                                               #
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### #
EOF


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE EDITOR=/usr/bin/nano " && echo
echo "checkpoint 107 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

EDITOR=/usr/bin/nano
DEBIAN_FRONTEND=noninteractive
	#details https://goo.gl/6Sjlbv


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Install system utilities"
echo "checkpoint 108 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

sudo apt-get update -q && apt-get upgrade -y
sudo apt-get install -y \
	apt-transport-https \
	ca-certificates \
	software-properties-common \
	ufw \
	lbzip2 \
	ccrypt \
	tree \
	secure-delete \
	git \
	git-core \
	apt-transport-https \
	ca-certificates \
	unzip \
	denyhosts
		### Potential packages
		# zram-config \
		# expect-dev \
		# expect \


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Install UFW " && echo
echo && echo -e "$PIK_BLUE WARNING - Needed on Scaleway only" && echo
echo "checkpoint 109 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

sed -i -e '/DEFAULT_FORWARD_POLICY="DROP"/ c\DEFAULT_FORWARD_POLICY="ACCEPT"' /etc/default/ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22
sudo ufw allow 997
sudo ufw allow 2376
sudo ufw allow 2377
	#docker machine / docker swarm

# >>> Ensure that 'IPV6=yes' | sudo nano /etc/default/ufw

# >>> Activate UFW
sudo ufw --force enable	
sudo ufw reload
sudo ufw status numbered
    #ie... sudo ufw delete 2

	### Open this port
	#ENV_PORT_ACTION=8083
	#sudo ufw allow $ENV_PORT_ACTION/tcp
	#sudo ufw reload && sudo ufw status verbose

	### Delete this port
	#ENV_PORT_ACTION=22
	#sudo ufw deny $ENV_PORT_ACTION
	#sudo ufw delete deny $ENV_PORT_ACTION
	#sudo ufw reload
	#sudo ufw status numbered
	#echo && echo -e "$PIK_GREEN Freshly deleted - Port $ENV_PORT_ACTION"

	# ufw-rules https://gist.github.com/pascalandy/e4ca1dc7fc225d0950d02c4e40ba1edc


# — — — # — — — # — — — #
echo "Install Docker | Inspired by http://www.bretfisher.com/install-docker-ppa-on-ubuntu-16-04/"
echo "checkpoint 110 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
mkdir -p /etc/apt/sources.list.d
echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#curl -sSL https://get.docker.com/ | sh
#mkdir -p /etc/systemd/system/docker.service.d
#printf '[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:// --userns-remap=default --storage-driver overlay2' > /etc/systemd/system/docker.service.d/docker.conf
#systemctl daemon-reload
#systemctl restart docker.service


### Confirm Docker is running properly
docker run hello-world


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Secure shared memory" && echo
echo "checkpoint 111 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sed -i -e '$a tmpfs     /run/shm     tmpfs     defaults,noexec,nosuid     0     0' /etc/fstab


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Configure apt.conf.d/" && echo
echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
echo 'APT::Get::Assume-Yes;' | sudo tee -a /etc/apt/apt.conf.d/00Do-not-ask
	#detail https://goo.gl/lnLJkV


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Install timedatectl (Time Zone)"
echo && echo -e "$PIK_BLUE Install ntp - Network Time Protocol (NTP)"&& sleep 0 && echo
echo "checkpoint 113 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

sudo apt-get -q update && sudo apt-get -qy upgrade
sudo apt-get -qqy install ntp --no-install-recommends
sudo apt-get -qqy install ntpdate --no-install-recommends
sudo timedatectl set-timezone America/New_York
sudo timedatectl set-ntp yes
echo && echo -e "$PIK_BLUE Verify that the timezone has been set properly"
timedatectl


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Install Fail2Ban" && echo
echo "checkpoint 114 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sudo apt-get -q update && sudo apt-get -qy upgrade
sudo apt-get -qy install fail2ban --no-install-recommends

FAILBAN_URL=https://gist.githubusercontent.com/pascalandy/264e9a38e7bddd90ee5bc9d8b9e4c348/raw/d7c32a0738772633014238c779c19c882cfd9084/fail2ban.local

wget $FAILBAN_URL
echo && cat fail2ban.local 
cp fail2ban.local /etc/fail2ban/fail2ban.local
rm -f fail2ban.local && echo && echo

JAIL_URL=https://gist.githubusercontent.com/pascalandy/4e92a12ea807b4f8b7e6ddddef682289/raw/2e94e4485d45204eefe813f7809033a4d1e292c7/jail.local
wget $JAIL_URL
cp jail.local /etc/fail2ban/jail.local
echo && cat jail.local
rm -f jail.local && echo && echo

sudo fail2ban-client reload
sudo fail2ban-client reload sshd
sudo fail2ban-client status 
sudo fail2ban-client status sshd


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Harden network with sysctl settings " && echo
echo "checkpoint 115 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
echo -e "$PIK_BLUE IP Spoofing protection"
echo -e "$PIK_BLUE Ignore ICMP broadcast requests"
echo -e "$PIK_BLUE Disable source packet routing"
echo -e "$PIK_BLUE Ignore send redirects"
echo -e "$PIK_BLUE Block SYN attacks"
echo -e "$PIK_BLUE Log Martians"
echo -e "$PIK_BLUE Ignore ICMP redirects"
echo -e "$PIK_BLUE Setting gc threshold for Docker Swarm"
echo -e "$PIK_BLUE Setting vm.vfs_cache_pressure"
echo -e "$PIK_BLUE Setting vm.swappiness"

SYSCTL_URL=https://gist.githubusercontent.com/pascalandy/98c181a3d2869b3e40a7db8c879a39e4/raw/608a461e4604006788de9f489a77870bf5c36ce5/sysctl.conf
wget $SYSCTL_URL
cp sysctl.conf /etc/sysctl.conf
echo && cat sysctl.conf
rm -f sysctl.conf
sudo sysctl -p && echo && echo


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Prevent Spoofing " && echo
echo "checkpoint 116 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo

HOST_URL=https://gist.githubusercontent.com/pascalandy/4aa0c1450d101e71532ae70db8ea059b/raw/498caf154866f36c1150c467df4fa1cf8baa92c4/host.conf
wget $HOST_URL
cp host.conf /etc/host.conf
echo && cat host.conf
rm -f host.conf && echo && echo


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Setting swap at 4G " && echo
echo "checkpoint 117 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
swapsize="4G"
fallocate -l $swapsize /swapfile;
ls -lh /swapfile
chmod 600 /swapfile;
ls -lh /swapfile
mkswap /swapfile;
swapon /swapfile;
swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Clean Up " && echo
echo "checkpoint 118 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sudo apt-get -q update && sudo apt-get -qy upgrade
sudo apt-get -qy dist-upgrade
sudo apt-get autoclean -y
sudo apt-get autoremove
sudo apt-get purge
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Changing SSH port" && echo
echo "checkpoint 119 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sed -i -e 's/Port 22/Port 997/' /etc/ssh/sshd_config


# — — — # — — — # — — — #
echo && echo -e "$PIK_BLUE Limit root login capacities" && echo
echo "checkpoint 120 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart


# — — — # — — — # — — — #
# clone | deploy-setup
echo "checkpoint 121 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# SENSITIVE_DATA
cd ~ && git clone https://# SENSITIVE_DATA@gitlab.com/# SENSITIVE_DATA# SENSITIVE_DATA.git
ENV_BRANCH="1.9.22";
ENV_NAME="Pascal Andy";
ENV_EMAIL="pascal@firepress.org";
ENV_REPO_NAME="deploy-setup"
echo;
cd ~/$ENV_REPO_NAME; sleep 0.5;
git config --global user.name "$ENV_NAME";
git config --global user.email "$ENV_EMAIL";
git checkout "$ENV_BRANCH"; sleep 1; 
echo;
ENV_BRANCH=""; ENV_NAME=""; ENV_EMAIL="";

# clone | deploy-logs
echo "checkpoint 122 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
#_SENSITIVE_DATA#_SENSITIVE_DATA
cd ~ && git clone https://# SENSITIVE_DATA@gitlab.com/# SENSITIVE_DATA# SENSITIVE_DATA.git
cd deploy-logs
ENV_BRANCH="master";
ENV_NAME="Pascal Andy";
ENV_EMAIL="pascal@firepress.org";
ENV_REPO_NAME="deploy-logs"
echo;
cd ~/$ENV_REPO_NAME; sleep 0.5;
git config --global user.name "$ENV_NAME";
git config --global user.email "$ENV_EMAIL";
git config --global push.default matching;
git checkout "$ENV_BRANCH"; sleep 1; 
echo;
ENV_BRANCH=""; ENV_NAME=""; ENV_EMAIL="";

# — — — # — — — # — — — #
echo "checkpoint 123 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
echo && echo -e "$PIK_BLUE Add the flag:"
touch ~/temp/node-is-configured.txt


# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# Could be usefull in the future

# — — — # — — — # — — — #
# echo && echo -e "$PIK_BLUE Time to reboot "
# echo "checkpoint XYZ $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
# echo && echo -e "$PIK_BLUE Lets reboot: " && echo
# sudo reboot

# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Adjust memory and swap accounting for Docker "
#echo && echo -e "$PIK_BLUE WARNING - not working on Scaleway" && echo
#sed -i -e '/GRUB_CMDLINE_LINUX_DEFAULT=""/ c\GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"' /etc/default/grub
#sudo update-grub

# — — — # — — — # — — — #
# echo && echo -e "$PIK_BLUE Install RKHunter & CHKRootKit (Check for rootkits) " && echo
# sudo apt-get -q update && sudo apt-get -qy upgrade
# sudo apt-get -qy install rkhunter --no-install-recommends
# sudo apt-get -qy install chkrootkit --no-install-recommends
# sudo chkrootkit
	# ¯\_(ツ)_/¯ These 3 cmd needs to be executed manually because it stops our script
	# sudo rkhunter --update --skip-keypress
	# sudo rkhunter --propupd --skip-keypress
	# sudo rkhunter --checkall --skip-keypress

# — — — # — — — # — — — #
#echo && echo -e "$PIK_BLUE Adding user onfire " && echo
#sudo adduser onfire --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
#echo "onfire:#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA#_SENSITIVE_DATA" | sudo chpasswd
#sudo usermod -aG sudo onfire
#sudo usermod -aG docker onfire
#wget https://gist.githubusercontent.com/pascalandy/a9b42d99896d46e7d307a65e3d696fb7/raw/c5966de548943c6217083dd9f21b3f05da53ba16/90-cloud-init-users
#cp 90-cloud-init-users /etc/sudoers.d/90-cloud-init-users
#echo && cat 90-cloud-init-users
#rm -f 90-cloud-init-users && echo && echo

# — — — # — — — # — — — #
# Infinit Storage

	#echo && echo -e "$PIK_BLUE Install infinit storage (Plan A)" # https://infinit.sh/documentation/docker/volume-plugin
	#echo "checkpoint 113 BYPASS $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#
	#### Installation https://infinit.sh/get-started/linux
	#
	#### Export the user we would like to use
	#export INFINIT_USER=#_SENSITIVE_DATA#_SENSITIVE_DATA
	#
	#sudo apt-get -y update
	#sudo apt-get install -qy fuse
	#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D2C3B0B
	#sudo apt-get install -qy software-properties-common apt-transport-https
	#sudo apt-add-repository -y "deb https://debian.infinit.sh/ trusty main"
	#sudo apt-get -y update
	#sudo apt-get install -qy infinit
	#
	#### Removing PPA (it mess around apt-get udpate)
	#sudo add-apt-repository --remove "deb https://debian.infinit.sh/ trusty main"
	#
	#### Install psmisc so that we have the `killall` command
	#sudo apt-get install -qy psmisc
	#
	#### Update the `PATH` to include the Infinit binaries
	#export PATH=/opt/infinit/bin:$PATH
	#
	## Permanently set $PATH
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### ### ### ### ### ### ### ### ### ###" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### Adding infinit in our PATH" >> ~/.profile
	#echo "PATH=$PATH:/opt/infinit/bin" >> ~/.profile
	#
	#### Test the installation
	#cd /opt/infinit/bin && ls -la
	#echo "Unit-test. We should see infinit version here:"
	#infinit-user -v
	#
	# ---
	#
	#echo && echo -e "$PIK_BLUE Install infinit storage (Plan B)" # https://infinit.sh/documentation/docker/volume-plugin
	#echo "checkpoint 112 $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#
	#APP_DIR=infinit
	#INSTALL_VERSION=0.7.2
	#INSTALL_URL="https://storage.googleapis.com/sh_infinit_releases/linux64/Infinit-x86_64-linux_debian_oldstable-gcc4-$INSTALL_VERSION.tbz"
	#INSTALL_PACKAGE="Infinit-x86_64-linux_debian_oldstable-gcc4-$INSTALL_VERSION"
	#
	## /usr/local/bin/$DIRECTORY_NAME/bin
	#
	#sudo apt-get -q update && sudo apt-get -qy upgrade
	#rm -rf /tmp && mkdir /tmp && cd /tmp
	#wget $INSTALL_URL
	#tar xjvf $INSTALL_PACKAGE.tbz
	#
	#mv /tmp/$INSTALL_PACKAGE /tmp/$APP_DIR/
	#mv /tmp/$APP_DIR/ /bin/$APP_DIR
	#
	## Add infinit into our PATH
	#export PATH=$PATH:/bin/$APP_DIR/bin
	#
	## Permanently set $PATH
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### ### ### ### ### ### ### ### ### ###" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "" >> ~/.profile
	#echo "### Adding infinit in our PATH" >> ~/.profile
	#echo "PATH=$PATH:/bin/$APP_DIR/bin" >> ~/.profile
	#
	## Testing installation
	#cd /bin/$APP_DIR/bin && ls -la
	#infinit-user -v && echo
	#echo "The version shall match with: $INSTALL_VERSION" && echo
	#
	## Activate Docker Plugin
	## echo "user_allow_other" >> /etc/fuse.conf
	## echo "more config are required ..."
	#
	## Clean up
	#rm -rf /tmp && mkdir /tmp && cd /tmp
	#cd ~
	#
	# ---
	#
	#echo && echo -e "$PIK_BLUE Install Go"
	#echo "checkpoint 113A $(date +%Y-%m-%d_%Hh%Mm%S)" >> ~/temp/provisionninglogs.txt && echo
	#wget https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz
	#tar -C ${HOME} -xzf go1.7.4.linux-amd64.tar.gz
	#
	#export GOROOT=${HOME}/go
	#export GOPATH=${HOME}/work
	#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
	#
	#source ~/.bashrc
	#
	#go env
	#go version

# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #
# 12_server_config_script.sh
# — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — # — — — #

# Run the bash script
# cd ~/temp; ls -la; sleep 1; chmod +x ./$THIS_SCRIPT; ./$THIS_SCRIPT;
