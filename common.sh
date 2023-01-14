script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
if [ $? -eq 0 ]; then
  echo -e "\e[1;32mSUCCESS\e[0m"
else
  echo -e "\e[1;31mFAILURE\e[0m"
  echo "Refer Log file for more information, LOG - ${LOG}"
  exit
fi
}

print_head() {
  echo -e "\e[1m $1 \e[0m"
}

NODEJS() {
print_head "Configuring NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application User"
id roboshop &>>${LOG}
if [ &? -ne 0 ]; then
 useradd roboshop &>>${LOG}
fi
status_check

mkdir -p /app

print_head "Downloading App content"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${LOG}
status_check

print_head "Cleanup Old Content"
rm -rf /app/* &>>${LOG}
status_check

print_head "Extracting App content"
cd /app &>>${LOG}
unzip /tmp/user.zip
status_check

print_head "Installing NodeJS Dependencies"
cd /app
npm install &>>${LOG}
status_check

print_head "Configuring User Service File"
cp ${script_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
status_check

print_head "Reload SystemD"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable User Service"
systemctl enable user &>>${LOG}
status_check

print_head "Start User Service"
systemctl start user &>>${LOG}
status_check

print_head "Configuring Mongo Repo"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

print_head "Install Mongo Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.devops93.online </app/schema/user.js &>>${LOG}
status_check
}





