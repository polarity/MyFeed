# download software
printf "\n\nDownloading MyFeed to ~/MyFeed\n------------------------------\n"
cd ~
git clone https://github.com/polarity/MyFeed.git

# install dependencies
printf "\n\nInstalling all npm dependencies ...\n-----------------------------------\n"
cd ~/MyFeed/public/
npm install
locally

# install bower locally
printf "\n\nInstalling bower locally!\n-------------------------\n"
npm install -g --prefix=$HOME bower
bower install

# create environment
printf "\n\nCreating .env file. Please answer some questions!\n-------------------------------------------------\n"
touch ~/MyFeed/public/.env

printf "\n\nPlease enter the serverport you want the service to use:\n--------------------------------------------------------\n"
read serverport
echo SERVERPORT = $serverport > ~/MyFeed/public/.env

printf "\n\nWhats your domain you running MyFeed under? (example: http://robert-agthe.de) without trailling slash:\n------------------------------------------------------------------------------------------------------\n"
read domain
echo DOMAIN_URL="$domain" >> ~/MyFeed/public/.env

printf "\n\nWhats your EMail? Used for Gravatars and attached to every post Metadata! Be careful here. (example: mymail@mydomain.com):\n--------------------------------------------------------------------------------------------------------------------------\n"
read email
echo USER_EMAIL="$email" >> ~/MyFeed/public/.env

printf "\n\nSpecify your passwort for authorizing to post content:\n------------------------------------------------------\n"
read password
echo USER_PASSWORD="$password" >> ~/MyFeed/public/.env

printf "\n\nYou´re Name. Used for the header and attached to all postings. (example: Robert Agthe):\n---------------------------------------------------------------------------------------\n"
read username
echo USER_NAME="$username" >> ~/MyFeed/public/.env

printf "\n\nCreating a secret for authentification ...\n------------------------------------------\n"
SECRET="$(date | md5sum)"
echo "SECRET=$SECRET" >> ~/MyFeed/public/.env

# create redirect
printf "\n\nCreating a .htaccess file in ~/html to redirect all webserver requests to the MyFeed service ...\n------------------------------------------------------------------------------------------------\n"
cd ~/html
touch .htaccess
echo "RewriteEngine On" > ~/html/.htaccess
echo "RewriteRule ^(.*) http://localhost:$serverport/\$1 [P]" >> ~/html/.htaccess

# create Service
printf "\n\nCreating MyFeed service ...\n---------------------------\n"
test -d ~/service || uberspace-setup-svscan
uberspace-setup-service myfeed node ~/MyFeed/public/index.js