cmake_minimum_required(VERSION 3.10)

project(gmp VERSION 6.2.1 LANGUAGES C CXX)

include(ProcessorCount)
include(ExternalProject)

ProcessorCount(N)

ExternalProject_Add(
	gmplib_ext
	SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}

	CONFIGURE_COMMAND ${CMAKE_CURRENT_LIST_DIR}/configure
		CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
		--disable-static --enable-cxx --prefix=${CMAKE_CURRENT_BINARY_DIR}/gmplib

	PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gmplib
	BUILD_COMMAND make -j${N}
)

add_library(gmplib SHARED IMPORTED)

add_dependencies(gmplib gmplib_ext)

set(GMP_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/gmplib/include CACHE STRING "GNU MP Include Dirs"  FORCE)
set(GMP_LIBRARIES gmplib CACHE STRING "GNU MP Libraries" FORCE)

target_include_directories(gmplib INTERFACE ${GMP_INCLUDE_DIRS})

if(WIN32)
	set_target_properties(
		gmplib PROPERTIES
		IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/gmplib/lib/gmp.dll
		IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/gmplib/lib/gmp.lib
	)
else()
	set_target_properties(
		gmplib PROPERTIES
		IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/gmplib/lib/libgmp.so
	)
endif()
