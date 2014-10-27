# download software
cd ~
git clone https://github.com/polarity/MyFeed.git

# install dependcies
cd ~/MyFeed/public/
npm install
locally
# install bower locally
npm install -g --prefix=$HOME bower
bower install

# create environment
touch /MyFeed/public/.env

echo "please enter the serverport"
read serverport
echo SERVERPORT = $serverport > ~/MyFeed/public/.env

echo "Whats your domain you running MyFeed under? (example: http://robert-agthe.de) without trailling slash"
read domain
echo DOMAIN_URL="$domain" >> ~/MyFeed/public/.env

echo "Whats your EMail? Used for Gravatars and attached to every post Metadata! Be careful here. (example: mymail@mydomain.com)"
read email
echo USER_EMAIL="$email" >> ~/MyFeed/public/.env

echo "Specify your passwort for authorizing to post content!"
read password
echo USER_PASSWORD="$password" >> ~/MyFeed/public/.env

echo "You´re Name. Used for the header and attached to all postings. (example: Robert Agthe)"
read username
echo USER_NAME="$username" >> ~/MyFeed/public/.env

# create redirect
cd ~/html
touch .htaccess
echo "RewriteEngine On" > ~/html/.htaccess
echo "RewriteRule ^(.*) http://localhost:$serverport/\$1 [P]" >> ~/html/.htaccess

# create Service
test -d ~/service || uberspace-setup-svscan
uberspace-setup-service myfeed node ~/MyFeed/public/index.js