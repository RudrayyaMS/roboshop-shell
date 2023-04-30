source common.sh

print_head "Install redis repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "Enable redis 6.2 file"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "Install redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "Update redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "Enable redis service"
systemctl enable redis
status_check $?

print_head "Start redis service"
systemctl restart redis
status_check $?
