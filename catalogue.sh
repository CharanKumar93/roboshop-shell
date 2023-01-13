source common.sh

print_head "Configuring NodeJS Repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add Application User"
useradd roboshop &>>${LOG}
status_check

mkdir -p /app

echo -e "\e[35m Downloading App content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}
status_check

echo -e "\e[35m Cleanup Old Content\e[0m"
rm -rf /app/* &>>${LOG}
status_check

echo -e "\e[35m Extracting App content\e[0m"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip
status_check

echo -e "\e[35m Installing NodeJS Dependencies\e[0m"
cd /app
npm install &>>${LOG}
status_check

echo -e "\e[35m Configuring Catalogue Service File\e[0m"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

echo -e "\e[35m Reload SystemD\e[0m"
systemctl daemon-reload &>>${LOG}
status_check

echo -e "\e[35m Enable Catalogue Service\e[0m"
systemctl enable catalogue &>>${LOG}
status_check

echo -e "\e[35m Start Catalogue Service\e[0m"
systemctl start catalogue &>>${LOG}
status_check

echo -e "\e[35m Configuring Mongo Repo\e[0m"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
status_check

echo -e "\e[35m Install Mongo Client\e[0m"
yum install mongodb-org-shell -y &>>${LOG}
status_check

echo -e "\e[35m Load Schema\e[0m"
mongo --host mongodb-dev.devops93.online </app/schema/catalogue.js &>>${LOG}
status_check







