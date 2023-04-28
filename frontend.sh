code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[35m$1\e[0m"
}
print_head "Installing Nginx"
yum install nginx -y &>>${log_file}

print_head "Removing old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Downloading the frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_head "Extracting frontend content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying the Nginx config for roboshop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling Nginx"
systemctl enable nginx &>>${log_file}

print_head "Starting Nginx"
systemctl restart nginx &>>${log_file}


# if any command is error or failed , we need stop the script