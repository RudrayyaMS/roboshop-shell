code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

echo -e "\e[35mInstalling Nginx\e[0m"
yum install nginx -y &>>${log_file}

echo -e "\e[35mRemoving old content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "\e[35mDownloading the frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

echo -e "\e[35mExtracting frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

echo -e "\e[35mCopying the Nginx config for roboshop\e[0m"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

echo -e "\e[35mEnabling Nginx\e[0m"
systemctl enable nginx &>>${log_file}

echo -e "\e[35mStarting Nginx\e[0m"
systemctl restart nginx &>>${log_file}


# if any command is error or failed , we need stop the script