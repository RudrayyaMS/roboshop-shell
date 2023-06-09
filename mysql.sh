source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing Mysql Root Password Argument\e[0m"  ##RoboShop@1
  exit 1
fi

print_head "Disable mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Copy mysql repo file"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Install mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable mysql"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Start mysql"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Root Password"
echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}
fi
status_check $?