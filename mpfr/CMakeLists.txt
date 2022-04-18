cmake_minimum_required(VERSION 3.10)

project(mpfr VERSION 4.1.0 LANGUAGES C)

include(ProcessorCount)
include(ExternalProject)

ProcessorCount(N)

ExternalProject_Add(
	mpfrlib_ext
	SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}

	CONFIGURE_COMMAND ${CMAKE_CURRENT_LIST_DIR}/configure
		CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER}
		--disable-static --prefix=${CMAKE_CURRENT_BINARY_DIR}/mpfrlib

	PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mpfrlib
	BUILD_COMMAND make -j${N}
)

add_library(mpfrlib SHARED IMPORTED)

add_dependencies(mpfrlib mpfrlib_ext)

set(MPFR_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/mpfrlib/include CACHE STRING "GNU MPFR Include Dirs"  FORCE)
set(MPFR_LIBRARIES mpfrlib CACHE STRING "GNU MPFR Libraries" FORCE)

target_include_directories(mpfrlib INTERFACE ${MPFR_INCLUDE_DIRS})

if(WIN32)
	set_target_properties(
		mpfrlib PROPERTIES
		IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/mpfrlib/lib/mpfr.dll
		IMPORTED_IMPLIB ${CMAKE_CURRENT_BINARY_DIR}/mpfrlib/lib/mpfr.lib
	)
else()
	set_target_properties(
		mpfrlib PROPERTIES
		IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/mpfrlib/lib/libmpfr.so
	)
endif()
