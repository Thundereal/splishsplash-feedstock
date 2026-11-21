@echo on
rem SPlisHSPlasH's libraries only; build.sh is this file's twin and says why
rem each option is what it is.

cmake -DSRC="%SRC_DIR%" -DX86=ON -P "%RECIPE_DIR%\prepare.cmake"
if errorlevel 1 exit 1

mkdir build
cd build
cmake %CMAKE_ARGS% -G Ninja "%SRC_DIR%" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DSPH_LIBS_ONLY=ON ^
    -DUSE_PYTHON_BINDINGS=OFF ^
    -DUSE_THIRD_PARTY_METHODS=OFF ^
    -DCI_BUILD=ON ^
    -DFOUND_AVX=1 -DFOUND_AVX2=1 ^
    -DEIGEN3_INCLUDE_DIR="%SRC_DIR%\extern\eigen"
if errorlevel 1 exit 1

ninja SPlisHSPlasH
if errorlevel 1 exit 1

cmake -DSRC="%SRC_DIR%" -DBLD="%CD%" -DPREFIX="%LIBRARY_PREFIX%" -DVERSION="%PKG_VERSION%" ^
    -DRECIPE="%RECIPE_DIR%" -P "%RECIPE_DIR%\install.cmake"
if errorlevel 1 exit 1
