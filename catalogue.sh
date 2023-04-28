source common.sh

print_head "Configure nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}

print_head "Create Roboshop User"
useradd roboshop &>>${log_file}

print_head "Create Application Directory"
mkdir /app &>>${log_file}

print_head "Delete old content"
rm -rf /app/* &>>${log_file}

print_head "Downloading App Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "Installing Nodejs Dependencies"
npm install &>>${log_file}

print_head "Copy Systmed Service File"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "Reload Systemd"
systemctl daemon-reload &>>${log_file}

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${log_file}

print_head "Start Catalogue Service"
systemctl restart catalogue &>>${log_file}

print_head "Copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}

print_head "Load Schema"
mongo --host mongodb.devopsm71.online </app/schema/catalogue.js &>>${log_file}