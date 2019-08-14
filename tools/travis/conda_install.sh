#!/usr/bin/env bash

set -ev # exit on first error, print commands

if [ "${PYTHON_ARCH}" == "32" ]; then
  set CONDA_FORCE_32BIT=1
fi
if [ -n "${TEST_RUN}" ]; then
    TEST_NAME="test-${TEST_RUN}-python-${PYTHON_VERSION}_${PYTHON_ARCH}bit"
else
    TEST_NAME="test-python-${PYTHON_VERSION}_${PYTHON_ARCH}bit"
fi
export TEST_NAME
#conda config --add channels conda-forge
#conda config --set channel_priority strict
PACKAGING_DEPS="pip setuptools wheel "
# split dependencies into separate packages
IFS=" " TEST_DEPS=(${PACKAGING_DEPS}${TEST_DEPS})
echo "Creating environment ${TEST_NAME} with packages ${TEST_DEPS[@]}..."
conda create -q -n "${TEST_NAME}" "${TEST_DEPS[@]}" python="${PYTHON_VERSION}"

set +v # we dont want to see commands in the conda script

source activate "${TEST_NAME}"
conda info -a
conda list
