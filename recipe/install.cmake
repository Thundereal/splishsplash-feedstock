# cmake -DSRC=<source> -DBLD=<build tree> -DPREFIX=<prefix> -DVERSION=<version>
#       -DRECIPE=<recipe folder> -P install.cmake
#
# The libraries, their headers and a CMake package into the prefix, the
# same on every platform. Done here because the project has no install
# rules for its libraries.
foreach(_var SRC BLD PREFIX RECIPE)
    file(TO_CMAKE_PATH "${${_var}}" ${_var})
endforeach()
set(_lib "${PREFIX}/lib/splishsplash")
set(_inc "${PREFIX}/include/splishsplash")
file(MAKE_DIRECTORY "${_lib}" "${_inc}/eigen" "${PREFIX}/lib/cmake/SPlisHSPlasH")

# The libraries, in the order a static link wants them.
set(SPLISH_LIBS)
foreach(_entry
        lib/SPlisHSPlasH lib/Utilities lib/tinyexpr lib/partio lib/zlib lib/MD5
        extern/install/NeighborhoodSearch/lib/CompactNSearch
        extern/install/Discregrid/lib/Discregrid)
    get_filename_component(_dir "${BLD}/${_entry}" DIRECTORY)
    get_filename_component(_name "${_entry}" NAME)
    set(_found)
    foreach(_file "lib${_name}.a" "${_name}.lib")
        if(EXISTS "${_dir}/${_file}")
            set(_found "${_file}")
        endif()
    endforeach()
    if(NOT _found)
        file(GLOB _there "${_dir}/*")
        message(FATAL_ERROR "install.cmake: no library ${_name} in ${_dir}: ${_there}")
    endif()
    file(COPY "${_dir}/${_found}" DESTINATION "${_lib}")
    list(APPEND SPLISH_LIBS "${_found}")
endforeach()

# The headers, each where an #include of the source tree finds it.
foreach(_dir SPlisHSPlasH Utilities extern/tinyexpr extern/md5)
    file(GLOB_RECURSE _headers RELATIVE "${SRC}"
        "${SRC}/${_dir}/*.h" "${SRC}/${_dir}/*.hpp" "${SRC}/${_dir}/*.inl")
    foreach(_header ${_headers})
        get_filename_component(_to "${_inc}/${_header}" DIRECTORY)
        file(COPY "${SRC}/${_header}" DESTINATION "${_to}")
    endforeach()
endforeach()
foreach(_name GenericParameters NeighborhoodSearch Discregrid)
    file(COPY "${BLD}/extern/install/${_name}/include/" DESTINATION "${_inc}")
endforeach()
file(COPY "${SRC}/extern/eigen/Eigen" DESTINATION "${_inc}/eigen")

# What the library was compiled with, read back from the build: a program
# using its headers must be compiled the same.
file(READ "${BLD}/build.ninja" _ninja)
string(FIND "${_ninja}" "SPlisHSPlasH.dir/Simulation.cpp.o" _at)
if(_at EQUAL -1)
    message(FATAL_ERROR "install.cmake: Simulation.cpp's rule is not in build.ninja")
endif()
# the rule's own lines: up to the next rule
string(SUBSTRING "${_ninja}" ${_at} -1 _rule)
string(FIND "${_rule}" "\nbuild " _end)
if(NOT _end EQUAL -1)
    string(SUBSTRING "${_rule}" 0 ${_end} _rule)
endif()
string(REGEX MATCH "\n *DEFINES = ([^\n]*)" _line "${_rule}")
separate_arguments(_defines UNIX_COMMAND "${CMAKE_MATCH_1}")
set(SPLISH_DEFINES)
foreach(_define ${_defines})
    string(REGEX REPLACE "^[-/]D" "" _define "${_define}")
    list(APPEND SPLISH_DEFINES "${_define}")
endforeach()
string(REGEX MATCH "\n *FLAGS = ([^\n]*)" _line "${_rule}")
separate_arguments(_flags UNIX_COMMAND "${CMAKE_MATCH_1}")
set(SPLISH_FLAGS)
foreach(_flag ${_flags})
    # the vector instructions only: the rest is the program's own business
    if(_flag MATCHES "^(-march=x86-64|-mavx|-mavx2|-mfma|-msse[0-9.]*|[-/]arch:AVX2?)$")
        list(APPEND SPLISH_FLAGS "${_flag}")
    endif()
endforeach()
list(REMOVE_DUPLICATES SPLISH_FLAGS)
set(SPLISH_VERSION "${VERSION}")
configure_file("${RECIPE}/SPlisHSPlasHConfig.cmake.in"
    "${PREFIX}/lib/cmake/SPlisHSPlasH/SPlisHSPlasHConfig.cmake" @ONLY)
file(READ "${PREFIX}/lib/cmake/SPlisHSPlasH/SPlisHSPlasHConfig.cmake" _made)
message("${_made}")
