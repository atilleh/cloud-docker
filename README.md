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
