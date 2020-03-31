#!/usr/bin/env bash
set -u

SEPARATOR="----------------------"

create_password_file () {
  if [[ ! -f "./htpasswd" ]] ;
  then
    echo "Creating password file for Basic Auth mechanism
This password will protect your web interfaces."
    echo -n "Username: "
    read username
    htpasswd -B -c ./htpasswd $username
  fi
}

update_domain () {
  echo "What is the domain for $1 ?"
  read domain

  sed -i "s/$1.localhost/$domain/g" nginx.conf
  echo "Nginx configuration for $1 updated."
}

select_domains () {
echo $SEPARATOR
  echo "4 domains are required to deploy this cloud.
All domains must point to this server IP."

  update_domain 'magneticow'
  update_domain 'filerun'
  update_domain 'syncthing'
  update_domain 'transmission'

  echo "server_name directives should be fine now: "
  grep "server_name" nginx.conf
}

check_dependencies () {
  echo $SEPARATOR
  echo "Checking software dependencies..."
  for software in docker docker-compose htpasswd ;
  do
    which $software
    if [[ "$?" -ne 0 ]] ;
    then
      echo "$software not found. Path is updated ?"
      exit 1
    fi
  done
}

start_stop_containers () {
  echo $SEPARATOR
  echo "We create containers to keep the structure and default files."
  echo "Please wait..."
  docker-compose build
  docker-compose up -d
  docker-compose stop
}

update_magneticow () {
  echo $SEPARATOR
  echo "Copying htpasswd to Magneticow..."
  sudo cp ./htpasswd ./opt/cloud-automated/magneticow/config/credentials
}

update_transmission () {
  echo $SEPARATOR
  configPath='./opt/cloud-automated/transmission/config/settings.json'
  echo "Update Transmission RPC configuration : "
  echo "What is transmission domain ? :"
  read domain

  sed -i "s/\"jq \": \"\",/\"rpc-host-whitelist\": \"$domain\",/g" $configPath
  echo "Should be fine: let's check that!"
  grep "rpc-host-whitelist" $configPath
}

check_dependencies
create_password_file
select_domains
start_stop_containers
update_magneticow
update_transmission

docker-compose up --force-recreate -d
docker-compose ps
echo "Installation completed! Your cloud should now be running."
