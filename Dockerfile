FROM ubuntu:16.04
MAINTAINER Forrest Collman (forrest.collman@gmail.com)

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

RUN apt-get install -y build-essential 
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
RUN apt-get install -y libopenblas-dev libatlas-base-dev gfortran liblapacke-dev checkinstall build-essential cmake git pkg-config \
 unzip ffmpeg qtbase5-dev python-dev python-numpy libopencv-dev \
 libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev \
 libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev \
 libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev \
 libtbb-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
 libtheora-dev libvorbis-dev libxvidcore-dev v4l-utils
ENV PATH /opt/conda/bin:$PATH
RUN pip install numpy
RUN wget https://github.com/opencv/opencv/archive/3.2.0.zip 
RUN mv 3.2.0.zip opencv-3.2.0.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/3.2.0.zip 
RUN mv 3.2.0.zip opencv-contrib-3.2.0.zip
RUN unzip opencv-3.2.0.zip 
RUN unzip opencv-contrib-3.2.0.zip 
WORKDIR /opencv-3.2.0
RUN mkdir build
WORKDIR build


RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
     -D CMAKE_INSTALL_PREFIX=/usr/local \
     -D INSTALL_PYTHON_EXAMPLES=ON \
     -D INSTALL_C_EXAMPLES=OFF \
     -D PYTHON_LIBRARY=/opt/conda/lib/libpython2.7.so \
     -D PYTHON_INCLUDE_DIR=/opt/conda/include/python2.7 \
     -D PYTHON_EXECUTABLE=/opt/conda/bin/python \
     -D PYTHON2_PACKAGES_PATH=/opt/conda/lib/python2.7/site-packages \
     -D INSTALL_PYTHON_EXAMPLES=ON \
     -D WITH_OPENGL=ON \
     -D PYTHON2_NUMPY_INCLUDE_DIRS=/opt/conda/lib/python2.7/site-packages/numpy/core/include \
     -D OPENCV_ENABLE_NONFREE=ON \
     -D BUILD_opencv_world=OFF \
     -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib-3.2.0/modules \
     -D BUILD_EXAMPLES=ON ..
RUN make -j7
RUN make install
RUN conda install ipython
RUN conda install jupyter
RUN pip install matplotlib
COPY jupyter_notebook_config.py /root/.jupyter/
CMD ["jupyter", "notebook", "--no-browser", "--allow-root"]


#RUN apt-get clean

