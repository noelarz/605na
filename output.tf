tfplan����Plan�� 	Diff�� Module�� State�� Vars�� Targets�� TerraformVersion ProviderSHA256s�� Backend�� Destroy   ��Diff�� Modules��   &��[]*terraform.ModuleDiff�� ��  1���� Path�� 	Resources�� Destroy   ��[]string��   3��"map[string]*terraform.InstanceDiff�� ��  X���� 
Attributes�� Destroy DestroyDeposed DestroyTainted Meta��   7��&map[string]*terraform.ResourceAttrDiff�� ��  o���� Old New NewComputed 
NewRemoved NewExtra RequiresNew 	Sensitive Type   '��map[string]interface {}��   
����   j��State�� Version 	TFVersion Serial Lineage Remote�� Backend�� Modules��   .��RemoteState�� Type Config��   !��map[string]string��   8��BackendState�� Type Config�� Hash   '��[]*terraform.ModuleState�� ��  P���� Path�� Locals�� Outputs�� 	Resources�� Dependencies��   2��!map[string]*terraform.OutputState�� ��  -���� 	Sensitive Type Value   4��#map[string]*terraform.ResourceState�� ��  N���� Type Dependencies�� Primary�� Deposed�� Provider   W��InstanceState�� ID 
Attributes�� 	Ephemeral�� Meta�� Tainted   3��EphemeralState�� ConnInfo�� Type   )��[]*terraform.InstanceState�� ��  "��map[string][]uint8�� 
  �9Z��root)aws_route_table_association.web-public-rtroute_table_id#${aws_route_table.web-public-rt.id} 	subnet_id${aws_subnet.public-subnet.id} id  aws_instance.wbtags.%1 network_interface_id vpc_security_group_ids.# 	user_data(53923cd74b441f21ad56ee9b82f876abe24b1ed8string�� ��#!/bin/sh

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
 private_dns key_name${aws_key_pair.default.id} security_groups.# get_password_datafalse instance_state id primary_network_interface_id 	tags.Nameairflow ephemeral_block_device.# 
private_ip availability_zone tenancy ipv6_address_count volume_tags.% ipv6_addresses.# amiami-925144f2 associate_public_ip_addresstrue network_interface.# source_dest_checkfalse 
public_dns 	public_ip password_data placement_group ebs_block_device.# instance_typet2.small 	subnet_id${aws_subnet.public-subnet.id} root_block_device.# $e2bfb730-ecaa-11e6-8f88-34363bc7c4c0map[string]interface {}��G deleteint64 �.�%� createint64 �e�� updateint64 �e��  aws_vpc.defaultdefault_security_group_id enable_classiclink_dns_support default_route_table_id instance_tenancy tags.%1 ipv6_cidr_block  assign_generated_ipv6_cidr_blockfalse dhcp_options_id enable_classiclink default_network_acl_id 
cidr_block10.60.0.0/16 enable_dns_hostnamestrue enable_dns_supporttrue 	tags.Name605-vpc main_route_table_id id ipv6_association_id  aws_key_pair.default
public_key��ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFeVlePeK3EDwquAXFxMlDOTJlGghhRcC7seLUnTdaqXyQ1StGQ5AO8ezZRVDr0Gfojiom6K0LvS0k0f0wC4VnO1Ob/R60Pf7eVPFzm/g8AmcNzGwEGgGMtL2WQtnTLijsyfEsWbUhaJIUd+hfXRdF7rMspEGDHJUGXARB0KPm6+PhaXKVjjJ4jcvo4QnIlQxHC/qU6vHs0wKmcK1e6STtT28EiKMsyh1vT5s7h64lnN8Oqn1qsdkDWFIW6GQyQfwo7xtnaTbiDOkX8BnpsyBs8IFwrOmi4mwN5BzklLkpa2f1CvvnIslq8YUfg3j8CMqT5xCkFtSGu4yT0xN1cVqT noel.arzadon@605string�� ��ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFeVlePeK3EDwquAXFxMlDOTJlGghhRcC7seLUnTdaqXyQ1StGQ5AO8ezZRVDr0Gfojiom6K0LvS0k0f0wC4VnO1Ob/R60Pf7eVPFzm/g8AmcNzGwEGgGMtL2WQtnTLijsyfEsWbUhaJIUd+hfXRdF7rMspEGDHJUGXARB0KPm6+PhaXKVjjJ4jcvo4QnIlQxHC/qU6vHs0wKmcK1e6STtT28EiKMsyh1vT5s7h64lnN8Oqn1qsdkDWFIW6GQyQfwo7xtnaTbiDOkX8BnpsyBs8IFwrOmi4mwN5BzklLkpa2f1CvvnIslq8YUfg3j8CMqT5xCkFtSGu4yT0xN1cVqT noel.arzadon@605
 fingerprint key_name
id_rsa_605 id  aws_internet_gateway.gwtags.%01 	tags.Name605 VPC IGW id vpc_id${aws_vpc.default.id}  aws_subnet.public-subnet
map_public_ip_on_launchfalse assign_ipv6_address_on_creationfalse id tags.%1 ipv6_cidr_block_association_id ipv6_cidr_block 	tags.Name605 Web Pub Subnet vpc_id${aws_vpc.default.id} 
cidr_block10.60.1.0/24 availability_zone
us-west-1b  aws_route_table.web-public-rt+route.~2599208424.vpc_peering_connection_id route.#1 route.~2599208424.gateway_id${aws_internet_gateway.gw.id} (route.~2599208424.egress_only_gateway_id vpc_id${aws_vpc.default.id} route.~2599208424.instance_id 	tags.Name605 Pub Subnet RT propagating_vgws.# &route.~2599208424.network_interface_id route.~2599208424.cidr_block	0.0.0.0/0  route.~2599208424.nat_gateway_id tags.%1 id !route.~2599208424.ipv6_cidr_block  aws_security_group.sgweb0ingress.2541437006.selffalse ingress.2541437006.from_port22 ingress.2541437006.to_port22 id ingress.2617001939.selffalse egress.482069346.from_port0 ingress.2617001939.protocoltcpstring tcp $ingress.516175195.ipv6_cidr_blocks.#0 egress.482069346.to_port0 tags.%1 	tags.Name605 Web Server SG description#Allow HTTP connections & SSH access $ingress.2617001939.security_groups.#0 owner_id ingress.516175195.cidr_blocks.#1 ingress.516175195.to_port8080 egress.482069346.protocol-1string -1 arn ingress.516175195.protocoltcpstring tcp ingress.2617001939.description ingress.2617001939.from_port443 %ingress.2541437006.ipv6_cidr_blocks.#0 ingress.2541437006.description revoke_rules_on_deletefalse 	ingress.#3 ingress.516175195.from_port8080 ingress.516175195.cidr_blocks.0	0.0.0.0/0 %ingress.2617001939.ipv6_cidr_blocks.#0 #egress.482069346.ipv6_cidr_blocks.#0  ingress.2617001939.cidr_blocks.0	0.0.0.0/0 ingress.2617001939.to_port443 #ingress.516175195.security_groups.#0 egress.482069346.selffalse egress.482069346.cidr_blocks.0	0.0.0.0/0 "egress.482069346.security_groups.#0 name605_vpc_web egress.482069346.description ingress.516175195.selffalse ingress.2541437006.protocoltcpstring tcp vpc_id${aws_vpc.default.id}  ingress.2541437006.cidr_blocks.#1 $ingress.2541437006.security_groups.#0 egress.482069346.cidr_blocks.#1  ingress.2617001939.cidr_blocks.#1 ingress.516175195.description "egress.482069346.prefix_list_ids.#0 egress.#1  ingress.2541437006.cidr_blocks.0	0.0.0.0/0 $e2bfb730-ecaa-11e6-8f88-34363bc7c4c0map[string]interface {}��0 deleteint64 �e�� createint64 �e��    �|B��treeGob�� Config�� Children�� Name Path��   ����Config�� 	Dir 	Terraform�� Atlas�� Modules�� ProviderConfigs�� 	Resources�� 	Variables�� Locals�� Outputs��   8��	Terraform�� RequiredVersion Backend��   6��Backend�� Type 	RawConfig�� Hash   
����   '��map[string]interface {}��   ����   ����   <��AtlasConfig�� Name Include�� Exclude��   ��[]string��   ��[]*config.Module�� ��  J���� Name Source Version 	Providers�� 	RawConfig��   !��map[string]string��   '��[]*config.ProviderConfig�� ��  :���� Name Alias Version 	RawConfig��   !��[]*config.Resource�� ��  ������ 	Mode Name Type RawCount�� 	RawConfig�� Provisioners�� Provider 	DependsOn�� 	Lifecycle��   $��[]*config.Provisioner�� ��  I���� Type 	RawConfig�� ConnInfo�� When 	OnFailure   ]��ResourceLifecycle�� CreateBeforeDestroy PreventDestroy IgnoreChanges��   !��[]*config.Variable�� ��  B���� Name DeclaredType Default Description   ��[]*config.Local�� ��  $���� Name 	RawConfig��   ��[]*config.Output�� ��  Q���� Name 	DependsOn�� Description 	Sensitive 	RawConfig��   (��map[string]*module.Tree�� ��  
����   ����"/Users/noel.arzadon/Projects/605naaws}+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   (��regionstring ${var.aws_region}  defaultaws_vpcs+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 ��+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   s��
cidr_blockstring ${var.vpc_cidr}enable_dns_hostnamesbool tags[]map[string]interface {}���� ��  �� Namestring	 605-vpc   public-subnet
aws_subnets+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 �-+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   0��tags[]map[string]interface {}���� ��  ����% Namestring 605 Web Pub Subnetvpc_idstring ${aws_vpc.default.id}
cidr_blockstring ${var.public_subnet_cidr}availability_zonestring 
us-west-1b   gwaws_internet_gateways+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 ��+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   W��vpc_idstring ${aws_vpc.default.id}tags[]map[string]interface {}���� ��  "�� Namestring 605 VPC IGW   web-public-rtaws_route_tables+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 �N+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   X��vpc_idstring ${aws_vpc.default.id}route[]map[string]interface {}���� ��  ����U 
cidr_blockstring 	0.0.0.0/0
gateway_idstring ${aws_internet_gateway.gw.id}tags[]map[string]interface {}��$ Namestring 605 Pub Subnet RT   web-public-rtaws_route_table_associations+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 ��+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   u��	subnet_idstring  ${aws_subnet.public-subnet.id}route_table_idstring% #${aws_route_table.web-public-rt.id}   sgwebaws_security_groups+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 �F+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   m��descriptionstring% #Allow HTTP connections & SSH accessingress[]map[string]interface {}���� ��  ����g 	from_portint �? to_portint �? protocolstring tcpcidr_blocks[]interface {}����   ���� string 	0.0.0.0/0cidr_blocks[]interface {}�� string 	0.0.0.0/0	from_portint �vto_portint �vprotocolstring tcp	from_portint ,to_portint ,protocolstring tcpcidr_blocks[]interface {}�� string 	0.0.0.0/0egress[]map[string]interface {}��o cidr_blocks[]interface {}�� string 	0.0.0.0/0	from_portint  to_portint  protocolstring -1vpc_idstring ${aws_vpc.default.id}tags[]map[string]interface {}��$ Namestring 605 Web Server SGnamestring 605_vpc_web   defaultaws_key_pairs+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 ��+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   S��key_namestring 
id_rsa_605
public_keystring ${file("${var.key_path}")}   wbaws_instances+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   ��countcountstring 1 �+��gobRawConfig�� Key Raw��   '��map[string]interface {}��   i��		subnet_idstring  ${aws_subnet.public-subnet.id}vpc_security_group_ids[]interface {}����   ���+ string  ${aws_security_group.sgweb.id}source_dest_checkbool  key_namestring ${aws_key_pair.default.id}instance_typestring
 t2.smallassociate_public_ip_addressbool 	user_datastring ${file("userdata.sh")}tags[]map[string]interface {}���� ��  7�� Namestring	 airflowamistring 
${var.ami}   
aws_regionstring 	us-west-1Region for the VPC vpc_cidrstring 10.60.0.0/16CIDR for the VPC public_subnet_cidrstring 10.60.1.0/24CIDR for the public subnet private_subnet_cidrstring 10.60.2.0/24CIDR for the private subnet amistring ami-925144f2Amazon Linux AMI key_pathstring) '/Users/noel.arzadon/.ssh/id_rsa_605.pubSSH Public Key path    0.11.7$a0836828-37b1-056b-fd48-8c77cde92f82root    
aws_regionstring 	us-west-1vpc_cidrstring 10.60.0.0/16public_subnet_cidrstring 10.60.1.0/24private_subnet_cidrstring 10.60.2.0/24amistring ami-925144f2key_pathstring) '/Users/noel.arzadon/.ssh/id_rsa_605.pub0.11.7aws C�C4�TK���Ur�_���z#z4���ץz67 