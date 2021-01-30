project(json)

cmake_minimum_required(VERSION 3.1.0)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(json_parser parser.yy ${CMAKE_CURRENT_BINARY_DIR}/json_parser.cpp VERBOSE)
FLEX_TARGET(json_scanner scanner.ll ${CMAKE_CURRENT_BINARY_DIR}/json_scanner.cpp)
ADD_FLEX_BISON_DEPENDENCY(json_scanner json_parser)


include_directories(. ${CMAKE_CURRENT_BINARY_DIR})


add_library(json
    jsonParser.hh
    jsonParser.cc
    parser.yy
    scanner.hh
    scanner.ll
    ${BISON_json_parser_OUTPUTS}
    ${FLEX_json_scanner_OUTPUTS})
target_link_libraries(json common)
