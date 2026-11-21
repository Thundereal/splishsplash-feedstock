#!/bin/bash
set -euo pipefail

# SPlisHSPlasH's libraries only: no GUI, no simulator, no Python module.
# prepare.cmake and install.cmake do the work that is the same on every
# platform; bld.bat is this file's twin.

case "${target_platform:-$(uname -m)}" in
    *aarch64*|*arm64*) x86=OFF ;;
    *) x86=ON ;;
esac
cmake -DSRC="${SRC_DIR}" -DX86=${x86} -P "${RECIPE_DIR}/prepare.cmake"

# FOUND_AVX, FOUND_AVX2: upstream finds them by running a program on the
#   build machine. A package is not for the build machine: every x86-64
#   build is compiled for AVX2 and FMA, no ARM one is.
# CI_BUILD: the baseline instructions in place of the build machine's own
#   (-march=native).
# USE_THIRD_PARTY_METHODS off: it clones libigl, for one boundary method.
# The bundled Eigen 3.4: the code is C++11 and does not compile against
#   Eigen 5.
if [ ${x86} = ON ]; then
    avx="-DFOUND_AVX=1 -DFOUND_AVX2=1"
else
    avx="-DFOUND_AVX= -DFOUND_AVX2="
fi
mkdir -p build
cd build
cmake ${CMAKE_ARGS:-} -G Ninja "${SRC_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DSPH_LIBS_ONLY=ON \
    -DUSE_PYTHON_BINDINGS=OFF \
    -DUSE_THIRD_PARTY_METHODS=OFF \
    -DCI_BUILD=ON \
    ${avx} \
    -DEIGEN3_INCLUDE_DIR="${SRC_DIR}/extern/eigen"
ninja SPlisHSPlasH

cmake -DSRC="${SRC_DIR}" -DBLD="${PWD}" -DPREFIX="${PREFIX}" -DVERSION="${PKG_VERSION}" \
    -DRECIPE="${RECIPE_DIR}" -P "${RECIPE_DIR}/install.cmake"
