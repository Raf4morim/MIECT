Lab2

### opencv4
>sudo apt install libopencv-dev python3-opencv

# How to compile:

Go to the diretory with make file -> ./Lab2/opencv-example-src/
### 1:
    Change the CMakeLists.txt 
      -> add_executable(cp_image  ${BASE_DIR}/1/cp_image.cpp)
      -> target_link_libraries(cp_image ${OpenCV_LIBS}) 
    > make
    > ../opencv-example-bin/cp_image input_img output_img
    Exemplo: ../opencv-example-bin/cp_image 1/arial.ppm copia.ppm

### 2:
    Change the CMakeLists.txt
      -> add_executable(menu  ${BASE_DIR}/2/menu.cpp)
      -> target_link_libraries(menu ${OpenCV_LIBS}) 
    > make
    > ../opencv-example-bin/menu input_img
    Exemplo: ../opencv-example-bin/menu 2/baboon.ppm

After this, it will be appear:
    
    *******************************
    1 - Negative version of an image.
    2 - Mirrored version of an image.
    3 - Rotates an image by a multiple of 90º.
    4 - Intensity values of an image.
    5 - Exit.
    Enter your choice and press return:

And then we can choice a option, for each version.
  
### 3:
    Change the CMakeLists.txt
        -> add_executable(testGolomb  ${BASE_DIR}/3/testGolomb.cpp)
        -> target_link_libraries(testGolomb ${OpenCV_LIBS})
    > make
    > ../opencv-example-bin/testGolomb
    
  
### 4 e 5:
    Change the CMakeLists.txt
        -> add_executable(testAudioCodec  ${BASE_DIR}/4e5/testAudioCodec.cpp)
        -> target_link_libraries(testAudioCodec sndfile)
    > make 
    > Usage: ../opencv-example-bin/testAudioCodec <input_file>
    Exemplo: ../opencv-example-bin/testAudioCodec 4e5/smp.wav 
    
### 6:
    Change the CMakeLists.txt
        -> add_executable(dec  ${BASE_DIR}/6/decoder.cpp)
        -> target_link_libraries(dec ${OpenCV_LIBS})

        -> add_executable(enc  ${BASE_DIR}/6/encoder.cpp)
        -> target_link_libraries(enc ${OpenCV_LIBS})

    > make
    > ../opencv-example-bin/enc
    > ../opencv-example-bin/dec
   
