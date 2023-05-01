code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
  echo -e "\e[36m$1\e[0m"
}
status_check() {
if [ $1 -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Read the log file ${log_file} for more information about error"
  exit 1
fi
}

systemd_setup () {
    print_head "Copy Systmed Service File"
    cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    print_head "Reload Systemd"
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "Enable ${component} Service"
    systemctl enable ${component} &>>${log_file}
    status_check $?

    print_head "Start ${component} Service"
    systemctl restart ${component} &>>${log_file}
    status_check $?
}

schema_setup() {
  if [ "$schema_type" == "mongo" ]; then
    print_head "Copy MongoDB Repo File"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    status_check $?

    print_head "Install Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb.devopsm71.online </app/schema/${component}.js &>>${log_file}
    status_check $?
  elif [ "${schema_type}" == "mysql" ]; then
    print_head "Install mysql client"
    yum install mysql -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mysql -h mysql.devopsm71.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status_check $?
  fi
}

app_prereq_setup () {
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
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
    cd /app
    status_check $?

    print_head "Extracting App Content"
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?
}

nodejs() {
  print_head "Configure nodejs Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Install nodejs"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Installing Nodejs Dependencies"
  npm install &>>${log_file}
  status_check $?

  # Schema Setup Function
  schema_setup

  # Systemd Function
  systemd_setup
}

java () {

  print_head "Install maven"
  yum install maven -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Install Dependencies and package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status_check $?

  # Schema Setup Function
  schema_setup

  # Systemd Function
  systemd_setup
}