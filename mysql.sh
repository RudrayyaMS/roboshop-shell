source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing mysql root password argument\e[0m"
  exit 1
fi

print_head "Disable mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Install mysql server"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enable mysql"
systemctl enable mysqld &>>${log_file}
status_check $>

print_head "Start mysql"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Root Password"
mysql_secure_installation --set-root-pass ${mysql_root_password}
status_check $?