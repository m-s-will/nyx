# AMREX_HOME defines the directory in which we will find all the AMReX code
AMREX_HOME  ?= ../../../amrex
#ASCENT_HOME ?=/project/projectdirs/alpine/software/ascent/gnu/7.3.0/ascent-install/

#This install location assumes modules: pgi/19.10 cuda/10.1.243
USE_FUSED = TRUE
ifeq ($(USE_FUSED),TRUE)
INSTALL_PREFIX ?= /home/docker/pantheon/ECP-Examples_Nyx-002/nyx/sundials/instdir
else
INSTALL_PREFIX ?= /home/docker/pantheon/ECP-Examples_Nyx-002/nyx/sundials/instdir
endif
#CVODE_LIB_DIR ?= $(CVODE_LIB)
CVODE_LIB_DIR ?= $(INSTALL_PREFIX)/lib/
BOOST_INLUDE_DIR ?= ${OLCF_BOOST_ROOT}/include/boost
HDF5_HOME ?= ${OLCF_HDF5_ROOT}

# TOP defines the directory in which we will find Source, Exec, etc
TOP = ../..

# compilation options
COMP    = gnu
USE_MPI = TRUE
# Use with Async IO
MPI_THREAD_MULTIPLE = FALSE
USE_OMP = TRUE
USE_CUDA ?= FALSE

USE_SENSEI_INSITU = FALSE
USE_HENSON = FALSE
REEBER = FALSE

USE_HDF5 ?= FALSE
USE_HDF5_ASYNC ?= FALSE

USE_ASCENT_INSITU = TRUE

ifeq ($(USE_ASCENT_INSITU),TRUE)
  ASCENT_HOME ?= NOT_SET
  ifneq ($(ASCENT_HOME),NOT_SET)
    include $(ASCENT_HOME)/share/ascent/ascent_config.mk
  endif
  USE_CONDUIT = TRUE
  USE_ASCENT = TRUE
endif

PROFILE       = FALSE
TRACE_PROFILE = FALSE
COMM_PROFILE  = FALSE
TINY_PROFILE  = TRUE

PRECISION = DOUBLE
USE_SINGLE_PRECISION_PARTICLES = TRUE
DEBUG     = FALSE

# physics
DIM      = 3
USE_GRAV = TRUE
#USE_HEATCOOL = TRUE
USE_AGN = FALSE
USE_CVODE = FALSE
NEUTRINO_PARTICLES = FALSE
NEUTRINO_DARK_PARTICLES = FALSE

ifeq ($(USE_CUDA),TRUE)
	USE_SUNDIALS_3x4x = TRUE
	USE_SUNDIALS = TRUE
	COMP = gnu
	USE_OMP = FALSE
  CUDA_ARCH = 70
ifeq ($(USE_ASCENT_INSITU), TRUE)
	NVCC_CCBIN=/usr/bin/g++
	LIBRARY_LOCATIONS += /usr/lib/
        LIBRARIES += -Wl,-rpath,/usr/lib/
endif
endif

USE_OWN_BCS = FALSE

Bpack := ./Make.package
Blocs := .

ifeq ($(USE_FUSED),TRUE)
ifeq ($(USE_CUDA),TRUE)
     LIBRARIES += -L$(CVODE_LIB_DIR) -lsundials_cvode_fused_cuda
endif
endif

ifeq ($(USE_ASCENT_INSITU),TRUE)
#ifneq ($(USE_CUDA),TRUE)
     XTRAOBJS += $(ASCENT_DEVICE_OBJECT_MPI)
#     LIBRARIES += $(ASCENT_MPI_LIB_FLAGS)
      LIBRARIES += -L $(ASCENT_DIR)/lib \
                       -lascent_mpi \
                       -lascent_flow \
                       -lascent_lodepng \
                       -lrover_mpi $(DRAY_LINK_RPATH) $(DRAY_LIB_FLAGS) $(ASCENT_VTKH_MPI_LIB_FLAGS) $(ASCENT_VTKM_LIB_FLAGS) $(ASCENT_CONDUIT_MPI_LIB_FLAGS) $(ASCENT_MFEM_LIB_FLAGS) $(ASCENT_PYTHON_LIBS) $(ASCENT_OPENMP_LINK_FLAGS) -L $(ASCENT_CUDA_LIB_FLAGS)
#endif
endif

ifeq ($(USE_HDF5), TRUE)
DEFINES += -DAMREX_USE_HDF5
INCLUDE_LOCATIONS += $(HDF5_HOME)/include
LIBRARIES         += -L$(HDF5_HOME)/lib -lhdf5 -lz -ldl -Wl,-rpath,$(HDF5_HOME)/lib
endif

# To use HDF5 asynchronous I/O VOL connector, follow the instructions at https://bitbucket.hdfgroup.org/projects/HDF5VOL/repos/async/browse
ifeq ($(USE_HDF5_ASYNC), TRUE)
DEFINES   	  += -DAMREX_USE_HDF5_ASYNC -DAMREX_MPI_THREAD_MULTIPLE
INCLUDE_LOCATIONS += $(ABT_HOME)/include $(ASYNC_HOME)
LIBRARIES 	  += -L$(ABT_HOME)/lib -L$(ASYNC_HOME) -lh5async -labt -Wl,-rpath,$(ABT_HOME)/lib -Wl,-rpath,$(ASYNC_HOME)
endif

include $(TOP)/Exec/Make.Nyx

