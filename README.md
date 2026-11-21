# splishsplash-feedstock

SPlisHSPlasH's simulation libraries as a conda package, for the Fluid
workbench of ThunderealCAD: `FluidSplish`, the program that runs the
solver for it, is built against this.

Not on conda-forge. The recipe pins SPlisHSPlasH and the three libraries
its own build clones (Discregrid, GenericParameters, CompactNSearch) as
sources, builds the libraries only, and installs them with a CMake
package (`find_package(SPlisHSPlasH CONFIG)`).

Linux only so far.
