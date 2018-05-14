#!/bin/sh

# installing PostgreSQL and preparing the database / VERSION 9.5 (or higher)
#apt-get -y install postgresql postgresql-contrib libpq-dev postgresql-client postgresql-client-common

#echo "CREATE USER airflow PASSWORD 'airflow'; CREATE DATABASE airflow; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;" | sudo -u postgres psql
#sudo -u postgres sed -i "s|#listen_addresses = 'localhost'|listen_addresses = '*'|" /etc/postgresql/9.5/main/postgresql.conf
#sudo -u postgres sed -i "s|127.0.0.1/32|0.0.0.0/0|" /etc/postgresql/9.5/main/pg_hba.conf
#sudo -u postgres sed -i "s|::1/128|::/0|" /etc/postgresql/9.5/main/pg_hba.conf
#service postgresql restart


# installing Redis and setting up the configurations
apt-get -y install redis-server

sed -i "s|bind |#bind |" /etc/redis/redis.conf
sed -i "s|protected-mode yes|protected-mode no|" /etc/redis/redis.conf
sed -i "s|supervised no|supervised systemd|" /etc/redis/redis.conf
service redis restart


# installing python 3.x and dependencies
sudo apt-get update
apt-get -y install python3 python3-dev python3-pip python3-wheel
apt install python3-pip
pip3 install --upgrade pip
pip install futures pandas SQLAlchemy psycopg2 celery redis flower flask-bcrypt boto3 ldap3 pymssql azure-servicebus flask_cache


# create airflow user with sudo capability
adduser airflow --gecos "airflow,,," --disabled-password
echo "airflow:airflow" | chpasswd
usermod -aG sudo airflow 
echo "airflow ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


# install Airflow 1.9.0rc8
mkdir /usr/local/airflow
curl -L -o /usr/local/airflow/1.9.0rc8.tar.gz https://dist.apache.org/repos/dist/dev/incubator/airflow/1.9.0rc8/apache-airflow-1.9.0rc8+incubating-bin.tar.gz
pip install /usr/local/airflow/1.9.0rc8.tar.gz


# create a log folder for airflow
mkdir /var/log/airflow
chown airflow /var/log/airflow


# create a persistent varable for AIRFLOW_HOME across all users env
echo export AIRFLOW_HOME=/home/airflow/airflow > /etc/profile.d/airflow.sh


# setting up Airflow
# following commands should be run under airflow user
su - airflow 

ip4addr="$(ip route get 8.8.8.8 | awk '{print $NF; exit}')"
AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@$ip4addr:5432/airflow
export AIRFLOW__CORE__SQL_ALCHEMY_CONN
airflow initdb

sed -i "s|sql_alchemy_conn = .*|sql_alchemy_conn = $AIRFLOW__CORE__SQL_ALCHEMY_CONN|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|executor = .*|executor = CeleryExecutor|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|broker_url = .*|broker_url = redis://$ip4addr:6379/0|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|celery_result_backend = .*|celery_result_backend = redis://$ip4addr:6379/0|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|base_log_folder = .*|base_log_folder = /var/log/airflow|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|child_process_log_directory = .*|child_process_log_directory = /var/log/airflow/scheduler|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|web_server_host = .*|web_server_host = $ip4addr|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|flower_host = .*|flower_host = $ip4addr|g" "$AIRFLOW_HOME"/airflow.cfg
sed -i "s|localhost|$ip4addr|" "$AIRFLOW_HOME"/airflow.cfg

# upgradedb airflow upgradedb and start airflow
airflow upgradedb
airflow webserver -p 8080
