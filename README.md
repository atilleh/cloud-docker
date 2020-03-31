# Docker-cloud

*This repository intends to submit an easy-to-deploy solution to create our own
cloud service.*

## Stack

* **Syncthing** for file synchronization between multiple devices
* **Filerun** to explore downloaded torrents
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
htpasswd -B -c htpasswd YOUR_USERNAME  # basic auth user database
vim nginx.conf                      # replace server_name directives
cp htpasswd ./opt/cloud-automated/magneticow/config/credentials    # requires Bcrypt encryption

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

## How to use

### Download torrents

Transmission front-end is protected by Nginx container and the created `htpasswd` file.
You can access it at `transmission.cloud.your_domain.tld`.
\
When adding a torrent, the two following locations are available:

```
/downloads/complete         # default
/data                       # anything you wanna organize (Music, Movies, Videos, Photos...)
```

#### Potential issues
You could encounter a non-connectivity to the torrents trackers. Please mind you have to add/uncomment `net.ipv4.ip_forward=1` in `/etc/sysctl.conf`.

### Navigate within folders

Downloaded or uploaded using Syncthing, you can navigate within your folders stored in `./data` using Filerun.
Default username and password are `superuser/superuser`. Please mind to update it.
\
Filerun basically replaces a potential Nextcloud to download and view files.

### Search for torrents

Torrents are automatically indexed by Magnetico. Since the exploration and indexing step is based on DHT, it can take several days before having access to most searched torrents. Be patient.

#### Potential issues

Magneticow (web interface of Magnetico) Docker image has a missing package - until it is not resolved on its Github repository (https://github.com/boramalper/magnetico/pull/243), this repository owns a `magneticow.Dockerfile` that must be build to be used by this installation.
