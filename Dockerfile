#FROM nvidia/cuda:11.2.1-devel-ubuntu20.04
FROM nvidia/cuda:11.2.1-devel-ubuntu20.04 

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-l", "-c"]
ENV NVIDIA_DISABLE_REQUIRE=1 
RUN useradd -ms /bin/bash docker
RUN chmod 777 /home/docker

RUN apt-get update && apt-get upgrade -y && apt-get -y install \
    autoconf \
    git \
    wget \
    curl \
    cmake \
    build-essential \
    gfortran \
    python2.7 python-dev \
    libopenmpi-dev openmpi-bin \
    libpthread-stubs0-dev \
    unzip \
    dos2unix \
    nano \ 
    environment-modules \
    tcl \
    nginx

USER docker
ENV PANTHEON_BASE_PATH=/home/docker
ENV COMPUTE_ALLOCATION=Nyx
# copy the required folders before each step
RUN mkdir /home/docker/nyx
COPY nyx/sbang.sh /home/docker/nyx
COPY nyx/pantheon/ /home/docker/nyx/pantheon/
COPY nyx/inputs/ /home/docker/nyx/inputs/
WORKDIR /home/docker/nyx/

# install first the dependencies and then the app itself
COPY nyx/setup/install-deps.sh /home/docker/nyx/setup/
COPY node.patch /home/docker/nyx/
RUN ./sbang.sh setup/install-deps.sh

RUN mkdir /home/docker/pantheon/ECP-Examples_Nyx-002/nyx; chmod 777 /home/docker/pantheon/ECP-Examples_Nyx-002/nyx;
#COPY amrex/ /home/docker/pantheon/ECP-Examples_Nyx-002/nyx/amrex
COPY nyx/setup/install-app.sh /home/docker/nyx/setup/
COPY GNUmakefile /home/docker/nyx/
RUN ./sbang.sh setup/install-app.sh

# run the app
COPY nyx/run/ /home/docker/nyx/run/
RUN ./sbang.sh run/run.sh
# RUN source /home/docker/pantheon/ECP-Examples_Nyx-002/spack/share/spack/setup-env.sh; \
#     CUDA=$(spack find -p cuda); CUDA_HOME=${CUDA##* }; \
#     cd /home/docker/pantheon/ECP-Examples_Nyx-002/nyx/amrex/Tutorials/Basic/HelloWorld_C; \
#     make -j COMP=gnu USE_CUDA=TRUE CUDA_HOME=$CUDA_HOME CUDA_ARCH=86;
#RUN ./sbang.sh run/wait_for_completion.sh

COPY nyx/postprocess/ /home/docker/nyx/postprocess/
RUN ./sbang.sh postprocess/postprocess.sh
RUN ./sbang.sh postprocess/timestamp.sh


COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
ENTRYPOINT ["nginx","-g","daemon off;"]