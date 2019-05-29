# ccb
containerized COSbench - supports multiple drivers per container

NOTE: repo provides both Dockerfile and docker-compose.yml
# To use docker-compose
## BUILD and RUN w/docker-compose.yml following these steps:
```bash
- # cd dockerCompose
Select deployment type:
1) To build and run the COSbench controller
- # cp docker-compose.CNTRL docker-compose.yml
2) To build and run the COSbench driver(s)  <-- starts 2 drivers
- # cp docker-compose.2DRVRS docker-compose.yml
3) To build and run both COSbench controller and driver
- # cp docker-compose.BOTH docker-compose.yml
Build and Run
- # docker-compose up --build --detach
TO Stop and Remove:
- # docker-compose down --rmi all
```
Edit docker-compose.yml and change these as needed:
- DRIVERS=
- COSBENCH_PLUGINS=
- ports:

# To use: Dockerfile
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
