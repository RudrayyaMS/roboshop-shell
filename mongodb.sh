source common.sh

print_head "Setup MongoDB Repository"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install mongoDB"
yum install mongodb-org -y &>>${log_file}
status_check $?

print_head "Update MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status_check $?

print_head "Enable MongoDB Service"
systemctl enable mongod &>>${log_file}
status_check $?

print_head "Start MongoDB Service"
systemctl restart mongod &>>${log_file}
status_check $?

#update  /etc/mongod.conf file from 127.0.0.1 with  0.0.0.0