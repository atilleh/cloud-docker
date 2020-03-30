# Docker-cloud

*This repository intends to submit an easy-to-deploy solution to create our own
cloud service.*

## Stack

* **Syncthing** for file synchronization between multiple devices
* **Filerun** to explore stored files
* **Transmission** and its web UI to download torrents
* **Magnetico[w|d]** to locally index torrents
* **Nginx** to proxify and secure a little bit more the service.

## Deployment

### Requirements

* Docker
* docker-compose (v3 syntax required)
* git
* root permissions
* domain name
* htpasswd binary

### Quick guide

* You need to create a htpasswd that will be used in Nginx container
* You also need to update the domain names attributed to each service, in `nginx.conf`

```
git clone
cd docker-cloud
htpasswd -c htpasswd YOUR_USERNAME  # basic auth user database
vim nginx.conf                      # replace server_name directives
docker-compose build
docker-compose up -d
```

## Configuration

After a first launch, stop the containers and update `opt/cloud-automated/transmission/config/settings.json`
file and its `rpc-host-whitelist` parameter : you need to add the domain used by Nginx
to reverse the container.

```
{
  ...
  "rpc-host-whitelist": "*.cloud.your_domain.tld"
  ...
}
```
Also, please mind you have to configure 4 A/CNAME fields or a domain wildcard
pointing to the cloud server.


```
*.cloud IN A YOUR_IP_ADDRESS
# or
syncthing.cloud IN A YOUR_IP_ADDRESS
transmission.cloud IN A YOUR_IP_ADDRESS
magneticow.cloud IN A YOUR_IP_ADDRESS
filerun.cloud IN A YOUR_IP_ADDRESS
```
