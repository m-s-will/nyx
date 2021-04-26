#!/bin/bash

source ./pantheon/env.sh > /dev/null 2>&1

echo "----------------------------------------------------------------------"
echo "PTN: Post-processing" 
echo "     packaging up cinema database to:" 
echo "     $PANTHEON_DATA_DIR" 

# install cinema viewer
TARNAME=cinema_databases
cp -rf inputs/cinema/* $PANTHEON_RUN_DIR/$TARNAME

pushd $PANTHEON_RUN_DIR/ascent_out > /dev/null 2>&1

tar -czvf ${TARNAME}.tar.gz $TARNAME > /dev/null 2>&1
mv ${TARNAME}.tar.gz $PANTHEON_DATA_DIR

popd > /dev/null 2>&1

echo "----------------------------------------------------------------------"

