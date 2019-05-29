# ccb
containerized COSbench - supports multiple drivers per container

NOTE: repo provides both Dockerfile and docker-compose.yml
# docker-compose
## BUILD and RUN w/docker-compose.yml following these steps:
```bash
1) To build and run the COSbench controller
- # cp docker-compose.CNTRL docker-compose.yml
- # docker-compose up --build --detach
2) To build and run the COSbench driver(s)  <-- starts 2 drivers
- # cp docker-compose.2DRVRS docker-compose.yml
- # docker-compose up --build --detach
```
Edit docker-compose.yml to change these environment vars:
- DRIVERS
- COSBENCH_PLUGINS

# Dockerfile
## BUILD w/Dockerfile following these steps:
```bash
1) # git clone <this repo>
2) # cd <this repo dir>
3) # docker build -t <imagename> .
```
$ docker images    ← check for imagename

## RUN the container image in these scenarios:
```bash
Scenario #1: single container - COSbench controller and driver (single driver)
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=true -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
```
Connect to COSbench controller GUI    ← http://0.0.0.0:19088/controller/index.html

```bash
Scenario #2: seperate containers - COSbench controller and (single) driver
Start Controller/Driver - each in one container
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=false -e DRIVER=true \
-e DRIVERS="http://127.0.0.1:18088/driver" -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=false \
-e DRIVERS="http://127.0.0.1:18088/driver" -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
```
$ docker ps              ← two containers

```bash
Scenario #3: seperate containers - COSbench controller and (multiple) drivers
Specify driver URLs with port numbers
Start drivers:
nuc# docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=false -e DRIVER=true \
-e DRIVERS="http://192.168.0.210:18088/driver http://192.168.0.210:18188/driver" \
-e COSBENCH_PLUGINS="SWIFT,S3" <image-name>
Start controller:
# docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=false \
-e DRIVERS="http://192.168.0.210:18088/driver http://192.168.0.210:18188/driver" \
-e COSBENCH_PLUGINS="SWIFT,S3" <image-name>
```
$ netstat -tulpn | grep LISTEN       ← 18088/89; 18188/89; 18288/89
