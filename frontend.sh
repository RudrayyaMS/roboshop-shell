echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y

echo -e "\e[35mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[35mDownloading the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[35mExtracting frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[35mCopying the Nginx config for roboshop\e[0m"
cp configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx

echo -e "\e[35mStarting Nginx\e[0m"
systemctl restart nginx

# roboshop config is not copied
# if any command is error or failed , we need stop the script