docker build -t fcollman/opencv .
docker kill opencv
docker rm opencv
docker run -w /usr/local/newfeature -v ~/newfeature:/usr/local/newfeature -p 8888:8888 --name opencv -t fcollman/opencv 