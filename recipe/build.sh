#!/bin/bash
set -euo pipefail

# SPlisHSPlasH's libraries only: no GUI, no simulator, no Python module.
#
# Its build clones Discregrid, GenericParameters and CompactNSearch while
# building. They are sources of this recipe (deps/), and the three
# ExternalProject steps are pointed at them.
for name in Discregrid GenericParameters; do
    sed -i "s|GIT_REPOSITORY https://github.com/InteractiveComputerGraphics/${name}.git|SOURCE_DIR \"${SRC_DIR}/deps/${name}\"|" \
        CMake/SetUpExternalProjects.cmake
done
sed -i "s|GIT_REPOSITORY https://github.com/InteractiveComputerGraphics/CompactNSearch.git|SOURCE_DIR \"${SRC_DIR}/deps/CompactNSearch\"|" \
    CMake/NeighborhoodSearch.cmake
for pin in ddf20dc0480874bf02e0bdc6ded76c1f101b17fb a4e2744eea526270cfe38b826440d09f66473316 \
           b40afcf47fe1963b363eba2371f04b42720fcb1d; do
    sed -i "/GIT_TAG \"${pin}\"/d" CMake/SetUpExternalProjects.cmake CMake/NeighborhoodSearch.cmake
done
# all three took: a pin moved upstream must fail here, not fetch quietly
test "$(grep -c 'SOURCE_DIR "' CMake/SetUpExternalProjects.cmake)" = 2
test "$(grep -c 'SOURCE_DIR "' CMake/NeighborhoodSearch.cmake)" = 1

mkdir -p build
cd build
# CI_BUILD: the baseline x86-64 instructions and what USE_AVX adds, not the
#   build machine's own (-march=native).
# USE_THIRD_PARTY_METHODS off: it clones libigl, for one boundary method.
# The bundled Eigen 3.4: the code is C++11 and does not compile against
#   Eigen 5.
cmake ${CMAKE_ARGS} -G Ninja "${SRC_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DSPH_LIBS_ONLY=ON \
    -DUSE_PYTHON_BINDINGS=OFF \
    -DUSE_THIRD_PARTY_METHODS=OFF \
    -DCI_BUILD=ON \
    -DEIGEN3_INCLUDE_DIR="${SRC_DIR}/extern/eigen"
ninja SPlisHSPlasH

# Installed by hand: the project has no install rules for its libraries.
lib="${PREFIX}/lib/splishsplash"
inc="${PREFIX}/include/splishsplash"
mkdir -p "${lib}" "${inc}/eigen" "${PREFIX}/lib/cmake/SPlisHSPlasH"
cp lib/libSPlisHSPlasH.a lib/libUtilities.a lib/libtinyexpr.a lib/libpartio.a lib/libzlib.a \
    lib/libMD5.a "${lib}/"
cp extern/install/NeighborhoodSearch/lib/libCompactNSearch.a \
    extern/install/Discregrid/lib/libDiscregrid.a "${lib}/"
(cd "${SRC_DIR}" && find SPlisHSPlasH Utilities extern/tinyexpr extern/md5 \
    \( -name '*.h' -o -name '*.hpp' -o -name '*.inl' \) -print0 \
    | xargs -0 cp --parents -t "${inc}/")
cp -r extern/install/GenericParameters/include/. "${inc}/"
cp -r extern/install/NeighborhoodSearch/include/. "${inc}/"
cp -r extern/install/Discregrid/include/. "${inc}/"
cp -r "${SRC_DIR}/extern/eigen/Eigen" "${inc}/eigen/"

# What the library was compiled with, read back from the build: a program
# using its headers must be compiled the same.
defines=$(grep -m1 -A6 'SPlisHSPlasH.dir/Simulation.cpp.o:' build.ninja | sed -n 's/^ *DEFINES = //p' \
    | sed 's/-D//g; s/  */;/g')
flags=$(grep -m1 -A6 'SPlisHSPlasH.dir/Simulation.cpp.o:' build.ninja | sed -n 's/^ *FLAGS = //p' \
    | tr ' ' '\n' | grep -E '^-m(arch=x86-64|avx|avx2|fma|sse[0-9.]*)$' | sort -u | tr '\n' ';' \
    | sed 's/;$//')
sed -e "s|@SPLISH_VERSION@|${PKG_VERSION}|" -e "s|@SPLISH_DEFINES@|${defines}|" \
    -e "s|@SPLISH_FLAGS@|${flags}|" "${RECIPE_DIR}/SPlisHSPlasHConfig.cmake.in" \
    > "${PREFIX}/lib/cmake/SPlisHSPlasH/SPlisHSPlasHConfig.cmake"
cat "${PREFIX}/lib/cmake/SPlisHSPlasH/SPlisHSPlasHConfig.cmake"
