docker build -t floydhub/dl-docker:gpu -f Dockerfile.gpu .
docker kill opencv
docker rm opencv
nvidia-docker run -w /usr/local/newfeature -p 8888:8888 -v /pipeline/ml-pointmatch:/usr/local/newfeature --name opencv -t floydhub/dl-docker:gpu  jupyter notebook --allow-root
 
