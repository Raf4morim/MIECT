#include <iostream>
#include <opencv2/opencv.hpp>
#include <string.h>

// a
#include <opencv2/core/core.hpp>

// c
#include "rotate.hpp"
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

// d
#include "opencv2/imgcodecs.hpp"

using namespace cv;
using namespace std;

int main(int argc, char *argv[])
{
    int choice;
    char *iFile = argv[1];
    bool gameOn = true;
    Mat src = imread(iFile); // reading image file in mat object
    Mat dst, sub_mat;        // Mat object for output image file
    double alpha = 1.0;
    int beta = 0;

    if (src.empty()){
        cout << "Could not open or find the image!\n"
             << endl;
        cout << "Usage: " << argv[0] << " <Input image>" << endl;
        return -1;
    }

    while (gameOn){
        cout << "*******************************\n";
        cout << " 1 - Negative version of an image.\n";
        cout << " 2 - Mirrored version of an image.\n";
        cout << " 3 - Rotates an image by a multiple of 90º.\n";
        cout << " 4 - Intensity values of an image.\n";
        cout << " 5 - Exit.\n";
        cout << " Enter your choice and press return: ";

        cin >> choice;

        switch (choice){
        case 1:
            cout << "Negative Version\n";

            // inicializar a matriz de saída com zeros
            dst = Mat::zeros(src.size(), src.type());
            // cria uma matriz com todos os elementos iguais a 255 para subtrair
            sub_mat = Mat::ones(src.size(), src.type()) * 255;
            // subtraia a matriz original pela sub_mat para dar a saída negativa 
            subtract(sub_mat, src, dst);
            // write the output image
            imwrite("./2/imgNegative.ppm", dst);
            break;

        case 2:
            cout << "Mirrored Version\n";
            char direction;
            if (argc != 2)
                throw "Error: Usage sintax is ../opencv-example-bin/menu <input img>";
            cout << "Choose the diretion to do a mirrored version of image (h/H or v/V): \n";
            cin >> direction;
            if (direction == 'h' || direction == 'H'){
                flip(src, dst, 0); // eixo xx
                imwrite("./2/imgHorizontal.ppm", dst);
            }else if (direction == 'v' || direction == 'V'){
                flip(src, dst, 1); // eixo yy
                imwrite("./2/imgVertical.ppm", dst);
            }else{
                cout << "Invalid option!\n";
            }
            break;

        case 3:
            char side;
            if (argc != 2)
                throw "Error: Usage sintax is ../opencv-example-bin/menu <input img>";
            cout << "Choose the side to Rotate an image by a multiple of 90º (left or right): \n";
            cin >> side;
            if (side == 'l' || side == 'L'){
                dst = rotate(src, 90); // rotating image with 90 degree angle
                imwrite("./2/rotateLeft.ppm", dst);
            }else if (side == 'r' || side == 'R'){
                dst = rotate(src, -90); // rotating image with 30 degree angle
                imwrite("./2/rotateRight.ppm", dst);
            }else{
                cout << "Invalid option!\n";
            }
            break;
        case 4:
            cout << "Intensity values of an image.\n";

            dst = Mat::zeros(src.size(), src.type());

            cout << "* Enter the alpha value [1.0-3.0] (more light) and [-3;-1]: (Less light): ";
            cin >> alpha;
            cout << "* Enter the beta value [0-100]: ";
            cin >> beta;
            for (int y = 0; y < src.rows; y++){
                for (int x = 0; x < src.cols; x++){
                    for (int c = 0; c < src.channels(); c++){
                        dst.at<Vec3b>(y, x)[c] = saturate_cast<uchar>(alpha * src.at<Vec3b>(y, x)[c] + beta);
                    }
                }
            }
            imwrite("./2/imgIntensity.ppm", dst);
            break;
        case 5:
            cout << "Program terminated\n";
            gameOn = false;
            break;
        default:
            cout << "Not a Valid Choice. \n";
            cout << "Choose again.\n";
            cin >> choice;
            break;
        }
    }
    waitKey(0); // Wait until user press some key

    return 0;
}