# cmake -DSRC=<source> -DX86=<ON|OFF> -P prepare.cmake
#
# SPlisHSPlasH's source made ready for a package build, the same on every
# platform.

# Its build clones Discregrid, GenericParameters and CompactNSearch while
# building. They are sources of this recipe (deps/), and the three
# ExternalProject steps are pointed at them.
file(TO_CMAKE_PATH "${SRC}" SRC)
set(_taken 0)
foreach(_file SetUpExternalProjects NeighborhoodSearch)
    file(READ "${SRC}/CMake/${_file}.cmake" _text)
    foreach(_name Discregrid GenericParameters CompactNSearch)
        set(_from "GIT_REPOSITORY https://github.com/InteractiveComputerGraphics/${_name}.git")
        string(FIND "${_text}" "${_from}" _at)
        if(NOT _at EQUAL -1)
            string(REPLACE "${_from}" "SOURCE_DIR \"${SRC}/deps/${_name}\"" _text "${_text}")
            math(EXPR _taken "${_taken} + 1")
        endif()
    endforeach()
    foreach(_pin ddf20dc0480874bf02e0bdc6ded76c1f101b17fb a4e2744eea526270cfe38b826440d09f66473316
                 b40afcf47fe1963b363eba2371f04b42720fcb1d)
        string(FIND "${_text}" "GIT_TAG \"${_pin}\"" _at)
        if(NOT _at EQUAL -1)
            string(REPLACE "GIT_TAG \"${_pin}\"" "" _text "${_text}")
            math(EXPR _taken "${_taken} + 1")
        endif()
    endforeach()
    file(WRITE "${SRC}/CMake/${_file}.cmake" "${_text}")
endforeach()
# all three took, each with its pin: one moved upstream must fail here, not
# fetch quietly
if(NOT _taken EQUAL 6)
    message(FATAL_ERROR "prepare.cmake: ${_taken} of 6 replacements took; upstream's "
        "ExternalProject steps have changed")
endif()

# CI_BUILD is upstream's switch for a build that is not for the build
# machine alone, and it says -march=x86-64: right for x86-64, an error for
# an ARM compiler, which gets its own baseline by saying nothing.
if(NOT X86)
    file(READ "${SRC}/CMake/Common.cmake" _text)
    string(FIND "${_text}" " -march=x86-64" _at)
    if(_at EQUAL -1)
        message(FATAL_ERROR "prepare.cmake: CI_BUILD's -march=x86-64 is not in Common.cmake")
    endif()
    string(REPLACE " -march=x86-64" "" _text "${_text}")
    file(WRITE "${SRC}/CMake/Common.cmake" "${_text}")
endif()
