#!/bin/bash

source ./pantheon/env.sh

RUN_CLEAN=true

if $RUN_CLEAN; then
    echo "----------------------------------------------------------------------"
    echo "PTN: cleaning results directory ..." 
    echo "----------------------------------------------------------------------"

    rm -rf $PANTHEON_RUN_DIR
    mkdir $PANTHEON_RUN_DIR
fi

# --------------------------------------------------------------------
# BEGIN: EDIT THIS SECTION
# copy executable and support files to the result directory
#     this step will vary, depending on the application requirements

# copy executable and support files
cp -rf $PANTHEON_WORKFLOW_DIR/nyx/Nyx/Exec/LyA/* $PANTHEON_RUN_DIR

# copy input files and overwrite input files
cp inputs/ascent/* $PANTHEON_RUN_DIR
cp inputs/nyx/* $PANTHEON_RUN_DIR
#cp run/submit.sh $PANTHEON_RUN_DIR

mkdir $PANTHEON_RUN_DIR/ascent_out

# END: EDIT THIS SECTION
# --------------------------------------------------------------------

# go to run dir and update the submit script
#pushd $PANTHEON_RUN_DIR
#sed -i "s/<pantheon_workflow_jid>/${PANTHEON_WORKFLOW_JID}/" submit.sh
#sed -i "s#<pantheon_workflow_dir>#${PANTHEON_WORKFLOW_DIR}#" submit.sh
#sed -i "s#<pantheon_run_dir>#${PANTHEON_RUN_DIR}#" submit.sh
#sed -i "s#<compute_allocation>#${COMPUTE_ALLOCATION}#" submit.sh

# submit the job
echo "----------------------------------------------------------------------"
echo "PTN: starting run ..." 
echo "----------------------------------------------------------------------"
pushd ${PANTHEON_RUN_DIR}

# #mpiexec -n 6 ./Nyx3d.gnu.TPROF.MPI.CUDA.ex inputs_nohydro.64.cuda  insitu.int=1 max_step=3 amr.max_grid_size=32 amr.regrid_on_restart=1
# ./Nyx3d.gnu.TPROF.MPI.CUDA.ex inputs_nohydro.64.cuda  insitu.int=1 max_step=3 amr.max_grid_size=32 amr.regrid_on_restart=1
time ./Nyx3d.gnu.TPROF.MPI.OMP.ex inputs_nohydro.rt insitu.int=1 max_step=3 amr.max_grid_size=32 amr.regrid_on_restart=1
