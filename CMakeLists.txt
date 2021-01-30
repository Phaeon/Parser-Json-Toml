cmake_minimum_required(VERSION 3.13.4)
project(projet-compil-2021)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED on)
set(CMAKE_CXX_EXTENSIONS off)
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    add_compile_options(-Wall -Wpedantic)
endif()


include_directories(common)

add_subdirectory(common)
add_subdirectory(json)
add_subdirectory(toml)

add_executable(comparator main.cc)
target_link_libraries(comparator common json toml)
target_include_directories(comparator
        PUBLIC toml
        PUBLIC json)
