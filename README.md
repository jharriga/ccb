# ccbdrvr
containerized COSbench - supports multiple drivers per node

NOTE: due to file size limitations the cosbench release zipfile needs to be seperately downloaded.
Prior to building the container image you will need to download this specific COSbench release
wget 
https://github.com/intel-cloud/cosbench/releases/download/v0.4.2.c4/0.4.2.c4.zip

BUILD the container image following these steps:
1) # git clone <this repo>
2) # cd <this repo dir>
3) # wget https://github.com/intel-cloud/cosbench/releases/download/v0.4.2.c4/0.4.2.c4.zip
4) # docker build -t <imagename> .

RUN the container image in these scenarios:
1) Scenario #1: single container - COSbench controller and driver (single driver)
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=true -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
Connect to COSbench controller GUI    ← http://0.0.0.0:19088/controller/index.html

2) Scenario #2: seperate containers - COSbench controller and (single) driver
Start Controller/Driver - each in one container
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=false -e DRIVER=true \
-e DRIVERS="http://127.0.0.1:18088/driver" -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
$ docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=false \
-e DRIVERS="http://127.0.0.1:18088/driver" -e COSBENCH_PLUGINS="SWIFT,S3" \
<image-name>
$ docker ps              ← two containers

3) Scenario #3: seperate containers - COSbench controller and (multiple) drivers
Specify driver URLs with port numbers
Start drivers:
nuc# docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=false -e DRIVER=true \
-e DRIVERS="http://192.168.0.210:18088/driver http://192.168.0.210:18188/driver http://192.168.0.210:18288/driver" \
-e COSBENCH_PLUGINS="SWIFT,S3" <image-name>
Start controller:
# docker run -dit --restart unless-stopped --net=host \
-e CONTROLLER=true -e DRIVER=false \
-e DRIVERS="http://192.168.0.210:18088/driver http://192.168.0.210:18188/driver http://192.168.0.210:18288/driver" \
-e COSBENCH_PLUGINS="SWIFT,S3" <image-name>
