source common.sh

component=payment
schema_load=false

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is missing"
  exit
fi

PYTHON