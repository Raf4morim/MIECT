//Compile: g++ ex4.cpp -o ex4 $(pkg-config --libs --cflags opencv4)

#include <iostream>
#include <opencv2/opencv.hpp>
#include <string.h>

using namespace std;
using namespace cv;

int main(int argc, char *argv[]){
    char *iFile = argv[1];
    char *oFile = argv[2];
    if(argc != 3) throw "Error: Usage sintax is ./p4 <input filename> <output filename>"; // 
    Mat imgInput = imread(iFile);  // Ler a imagem do arquivo de entrada 
    if(imgInput.empty()) throw "Error: Could not open imgInput";     
    Mat copia(imgInput.rows, imgInput.cols, imgInput.type()); // Criar uma imagem com as mesmas dimensões da imagem de entrada
    
    for(int i=0; i < imgInput.rows; i++){
        for(int j=0 ; j < imgInput.cols; j++)
            copia.ptr<Vec3b>(i)[j] = Vec3b(imgInput.ptr<Vec3b>(i)[j][0], imgInput.ptr<Vec3b>(i)[j][1], imgInput.ptr<Vec3b>(i)[j][2]);
    }

    imwrite(oFile ,copia); 

    //Show image on window
    namedWindow("Output image", WINDOW_NORMAL);
    resizeWindow("Output image", 1050, 650);
    imshow("Output image", copia);
    waitKey(0);
    destroyWindow("Output image");   

    return 0;

}