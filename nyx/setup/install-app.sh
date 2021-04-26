#!/bin/bash -l


# build and install the application
source ./pantheon/env.sh
source $PANTHEON_WORKFLOW_DIR/spack/share/spack/setup-env.sh
PACKAGE="NYX"
# make a lower case version of the package 
PACKAGEDIR=`echo "$PACKAGE" | awk '{print tolower($0)}'`


START_TIME=$(date +"%r")
echo "------------------------------------------------------------"
echo "PTN: Start time: $START_TIME" 
echo "------------------------------------------------------------"

echo "--------------------------------------------------"
echo "PTN: building $PACKAGE"
echo "--------------------------------------------------"

pushd $PANTHEON_WORKFLOW_DIR

# set up spack



#module load gcc/6.4.0
#module load cuda/10.2.89
    # to match spack build of ascent
# module load cuda/10.1.243 
# module load cmake/3.14.2
# module load hdf5/1.8.18

# Commits
#NYX_COMMIT=20.04-494-g694daae
NYX_COMMIT=21.02.1
#AMREX_COMMIT=20.07-45-g6f2e60118
AMREX_COMMIT=21.02

#cmkdir $PACKAGEDIR 
pushd $PACKAGEDIR

# AMREX
git clone --branch development https://github.com/AMReX-Codes/amrex.git
pushd amrex
git checkout $AMREX_COMMIT
popd

# SUNDIALS
git clone --branch develop https://github.com/LLNL/sundials.git
pushd sundials
git checkout v5.6.1
#install sundials
mkdir instdir
mkdir builddir
cd builddir/
spack load cmake@3.20

cmake -DCMAKE_INSTALL_PREFIX=/home/docker/pantheon/ECP-Examples_Nyx-002/nyx/sundials/instdir/ \
    -DEXAMPLES_INSTALL_PATH=/home/docker/pantheon/ECP-Examples_Nyx-002/nyx/sundials/instdir/examples \
    -DCMAKE_C_COMPILER=$(which gcc)  \
    -DCMAKE_CXX_COMPILER=$(which g++)  \
    -DCMAKE_CUDA_HOST_COMPILER=$(which g++) ..
    #-DSUNDIALS_BUILD_PACKAGE_FUSED_KERNELS=ON \
    #-DENABLE_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=sm_86 ..
make
make install
popd

# NYX
git clone --branch development https://github.com/AMReX-Astro/Nyx.git
pushd Nyx
git checkout $NYX_COMMIT
popd

pushd Nyx/Exec/LyA
spack load ascent 
spack load conduit
ASCENT=$(spack find -p ascent)
ASCENT_INSTALL_DIR=${ASCENT##* }
echo "$ASCENT"
echo "$ASCENT_INSTALL_DIR"

CUDA=$(spack find -p cuda)
CUDA_HOME=${CUDA##* }

CONDUIT=$(spack find -p conduit)
CONDUIT_HOME=${CONDUIT##* }
echo "$CONDUIT"
echo "$CONDUIT_HOME"
 #replace the GNUmakefile with a custom one
mv -f /home/docker/nyx/GNUmakefile .

echo "--------------------------------------------------"
echo "PTN: ASCENT_INSTALL_DIR $ASCENT_INSTALL_DIR"
echo "--------------------------------------------------"

make USE_CUDA=FALSE \
        USE_ASCENT_INSITU=TRUE \
        COMP=gnu \
        NO_HYDRO=TRUE \
        USE_HEATCOOL=FALSE \
        ASCENT_HOME=$ASCENT_INSTALL_DIR \
        CONDUIT_DIR=$CONDUIT_HOME
popd
popd
popd

END_TIME=$(date +"%r")
echo "------------------------------------------------------------"
echo "PTN: statistics" 
echo "PTN: start: $START_TIME"
echo "PTN: end  : $END_TIME"
echo "------------------------------------------------------------"
