#!/bin/bash

echo "updating system"
sudo apt update -y

echo "installing utilities"
sudo apt install -y zip unzip

echo "installing nginx web server"
sudo apt install -y nginx

echo "remove sample pages"
sudo rm -rf /var/www/html

echo "clone login app"
sudo git clone https://github.com/rahulsantosh2/login-page.git /var/www/html

echo "script execution completed"


