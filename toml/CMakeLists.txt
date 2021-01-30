project(toml)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(toml_parser parser.yy ${CMAKE_CURRENT_BINARY_DIR}/toml_parser.cpp COMPILE_FLAGS "-vd --graph")
FLEX_TARGET(toml_scanner scanner.ll ${CMAKE_CURRENT_BINARY_DIR}/toml_scanner.cpp)
ADD_FLEX_BISON_DEPENDENCY(toml_scanner toml_parser)


include_directories(. ${CMAKE_CURRENT_BINARY_DIR})


add_library(toml
        tomlParser.cc
        tomlParser.hh
        parser.yy
        scanner.hh
        scanner.ll
    ${BISON_toml_parser_OUTPUTS}
    ${FLEX_toml_scanner_OUTPUTS}
)
target_link_libraries(toml common)