source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing RabbitMQ App User  Password Argument\e[0m"  ##roboshop123
  exit 1
fi

print_head "Setup Erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Setup Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log_file}
status_check $?

print_head "Install Rabbitmq & Erlang"
yum install rabbitmq-server  erlang -y &>>${log_file}
status_check $?

print_head "Enable Rabbitmq service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start Rabbitmq service"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status_check $?

print_head "Configure Permission for App User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?