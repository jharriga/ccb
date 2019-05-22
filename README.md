# ccbdrvr
containerized COSbench - supports multiple drivers per node

NOTE: due to file size limitations the cosbench release zipfile needs to be sperately downloaded
Prior to building the container image you will need to download this specific COSbench release
"# wget 
https://github.com/intel-cloud/cosbench/releases/download/v0.4.2.c4/0.4.2.c4.zip"

Build the container image following these steps:
1) # git clone <this repo>
2) cd <this repo dir>
3) # wget https://github.com/intel-cloud/cosbench/releases/download/v0.4.2.c4/0.4.2.c4.zip
4) # docker build -t <imagename> .
Run the container image in these scenarios:
1) Scenario #1: co-located COSbench controller and driver (single driver)

2) Scenario #2: individual COSbench controller and driver containers (single driver)

3) Scenario #3: individual COSbench controller and driver containers (multiple drivers)
