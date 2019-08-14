# Example of IRIS with mirroring in docker-compose

Docker compose environment with demo IRIS configured with Mirroring

## Requirements

- docker
- docker-compose
- IRIS image version 2019.3.0.302.0
- iris.key in your home directory

## Usage

```shell
docker-compose build
docker-compose up
```

After start, master node should be available by URL
http://localhost:81/csp/sys/op/%25CSP.UI.Portal.Mirror.Monitor.zen
![master](https://raw.githubusercontent.com/daimor/iris-mirror-with-docker/master/images/master.png)

and backup node by URL
http://localhost:82/csp/sys/op/%25CSP.UI.Portal.Mirror.Monitor.zen
![backup](https://raw.githubusercontent.com/daimor/iris-mirror-with-docker/master/images/backup.png)

Any changes in DEMO database in master will appear in backup node, in a while