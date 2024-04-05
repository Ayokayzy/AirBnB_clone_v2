#!/usr/bin/env bash

PACKAGE_NAME="nginx"
FOLDER_PATH="/data/web_static/releases/test/"
FOLDER_PATH2="/data/web_static/shared/"
CONFIG_STR="server {
        listen 80 default_server;
        # server_name _;
	index index.html
        location /hbnb_static {
                alias /data/web_static/current/;
        }
}"
DESTINATION="/etc/nginx/sites-enabled/airbnb.conf"
DESTINATION2="/data/web_static/current"

# Check if the package is installed
if dpkg -s $PACKAGE_NAME &> /dev/null; then
	echo "$PACKAGE_NAME is already installed."
else
	# Install the package
	echo "Installing $PACKAGE_NAME..."
	#apt install nginx -y
fi
# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
	# If the folder does not exist, create it
	echo "Creating folder: $FOLDER_PATH"
	mkdir -p "$FOLDER_PATH"
fi
if [ ! -d "$FOLDER_PATH2" ]; then
	# If the folder does not exist, create it
	echo "Creating folder: $FOLDER_PATH2"
	mkdir -p "$FOLDER_PATH2"
fi
# touch /data/web_static/releases/test/index.html
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html

if [ -L "$DESTINATION2" ]; then
    echo "Symbolic link already exists at $DESTINATION. Deleting..."
    sudo rm "$DESTINATION2"
fi
ln -s "$FOLDER_PATH" /Data/web_static/current
chown -R ubuntu:ubuntu /data/
#add configuration text to /etc/nginx/sites-available/airbnb.conf
echo "$CONFIG_STR" | tee /etc/nginx/sites-available/airbnb.conf
# Check if the destination link already exists
if [ -L "$DESTINATION" ]; then
    echo "Symbolic link already exists at $DESTINATION. Deleting..."
    rm "$DESTINATION"
fi
sudo ln -s /etc/nginx/sites-available/airbnb.conf /etc/nginx/sites-enabled/
service nginx restart
