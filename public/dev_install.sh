touch .env
echo SERVERPORT = 8000 > .env
echo DOMAIN_URL="localhost/" >> .env
echo USER_EMAIL="robert@scriptshit.de" >> .env
echo USER_PASSWORD="test" >> .env
echo USER_NAME="robert" >> .env
SECRET="$(date | md5sum)"
echo "SECRET=$SECRET" >> .env
