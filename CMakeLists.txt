cmake_minimum_required(VERSION 3.10)

project(gnumath VERSION 0.1 LANGUAGES C CXX)

add_subdirectory(gmp)
add_subdirectory(mpfr)

add_library(gnumath::gmp ALIAS gmplib)
add_library(gnumath::gmpxx ALIAS gmpxxlib)
add_library(gnumath::mpfr ALIAS mpfrlib)
