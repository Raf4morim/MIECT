cmake_minimum_required(VERSION 3.16)
project(fcm-example)

find_package(OpenCV REQUIRED)

SET(CMAKE_BUILD_TYPE "Release")

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++17 -pthread")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3")
SET(CMAKE_CXX_FLAGS_DEBUG "-g3 -fsanitize=address")

SET(BASE_DIR ${CMAKE_SOURCE_DIR})
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BASE_DIR}/fcm-example-bin)
add_library(fcm ${BASE_DIR}/fcm-example-src/part1/fcm.cpp)
add_library(cb ${BASE_DIR}/fcm-example-src/part1/circularBuffer.cpp)
add_library(lang ${BASE_DIR}/fcm-example-src/part2/exc2/lang.cpp)
add_library(findlang ${BASE_DIR}/fcm-example-src/part2/exc3/findlang.cpp)
# exc1
add_executable(test_fcm  ${BASE_DIR}/fcm-example-src/part1/test_fcm.cpp)
target_link_libraries(test_fcm fcm cb)
# exc2
add_executable(test_lang  ${BASE_DIR}/fcm-example-src/part2/exc2/test_lang.cpp)
target_link_libraries(test_lang fcm cb)
# exc3
add_executable(test_findlang  ${BASE_DIR}/fcm-example-src/part2/exc3/test_findlang.cpp)
target_link_libraries(test_findlang findlang lang fcm cb)
