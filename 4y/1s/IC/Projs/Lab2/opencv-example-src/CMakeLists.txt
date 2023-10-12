cmake_minimum_required(VERSION 3.16)
project(open-example)

find_package(OpenCV REQUIRED)

SET(CMAKE_BUILD_TYPE "Release")
#SET (CMAKE_BUILD_TYPE "Debug")

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -std=c++17 -pthread")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3")
SET(CMAKE_CXX_FLAGS_DEBUG "-g3 -fsanitize=address")

SET(BASE_DIR ${CMAKE_SOURCE_DIR})
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BASE_DIR}/../opencv-example-bin)


# add_library(bitstream ${BASE_DIR}/BitStream.cpp)
add_library(golomb ${BASE_DIR}/3/Golomb.cpp)

add_executable(cp_image  ${BASE_DIR}/1/cp_image.cpp)
target_link_libraries(cp_image ${OpenCV_LIBS})

add_executable(menu  ${BASE_DIR}/2/menu.cpp)
target_link_libraries(menu ${OpenCV_LIBS})

add_executable(testGolomb  ${BASE_DIR}/3/testGolomb.cpp)
target_link_libraries(testGolomb ${OpenCV_LIBS})

add_executable(testAudioCodec  ${BASE_DIR}/4e5/testAudioCodec.cpp)
target_link_libraries(testAudioCodec sndfile)

add_executable(dec  ${BASE_DIR}/6/decoder.cpp)
target_link_libraries(dec ${OpenCV_LIBS})

add_executable(enc  ${BASE_DIR}/6/encoder.cpp)
target_link_libraries(enc ${OpenCV_LIBS})

