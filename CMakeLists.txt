cmake_minimum_required(VERSION 3.13)  # CMake version check
project(game_theory_cw1)              # Create project "simple_example"

# Add main.cpp file of the project root directory as a source file
file (GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "validator/**.c")
file (GLOB_RECURSE HEADERS CONFIGURE_DEPENDS "validator/**.h")

# Add executable target with source files listed in SOURCE_FILES variable
add_executable(validator validator/validator.c validator/window/window.c validator/main.c )
option(BUILD_SHARED_LIBS "Build using shared libraries" ON)
add_library(validator_lib STATIC ${SOURCES} ${HEADERS})