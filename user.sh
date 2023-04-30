source common.sh

print_head "Configure nodejs Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop User"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "Create Application Directory"
if [ ! -d /app ]; then
  mkdir /app &>>${log_file}
fi
status_check $?

print_head "Delete old content"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "Downloading App Content"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app
status_check $?

print_head "Extracting App Content"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "Installing Nodejs Dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy Systmed Service File"
cp ${code_dir}/configs/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reload Systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable user Service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Start user Service"
systemctl restart user &>>${log_file}
status_check $?

print_head "Copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host mongodb.devopsm71.online </app/schema/user.js &>>${log_file}
status_check $?