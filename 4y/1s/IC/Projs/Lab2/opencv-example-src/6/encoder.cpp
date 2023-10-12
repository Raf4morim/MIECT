#include <iostream>
#include "../3/Golomb.cpp"
#include <opencv2/opencv.hpp>
#include <string.h>

using namespace std;
using namespace cv;

int get_x(int i, int j, Mat image, int plane)
{
    int im1 = image.ptr<Vec3b>(i)[j - 1][plane];
    int im2 = image.ptr<Vec3b>(i - 1)[j][plane];
    int im3 = image.ptr<Vec3b>(i - 1)[j - 1][plane];
    int l_max = max(im1, im2);
    int l_min = min(im1, im2);

    if (im3 >= l_max)
        return l_min;
    else if (im3 <= l_min)
        return l_max;
    else
        return (im1 + im2 - im3);
    
}

int main(){
    char *iFile =(char *) "6/bike3.ppm";
    char *oFile = (char *) "6/bike3.txt";
    Golomb golomb{oFile, 'e', 1920};
    Mat image = imread(iFile);
    if (image.empty()){
        cout << "\033[1;31mError: Could not open image\033[0m" << endl;
        return 0;
    }

    // BGR format
    int pB, pG, pR, rB, rG, rR;

    // Create header with image rows, columns and type
    golomb.encode(image.rows);
    golomb.encode(image.cols);
    golomb.encode(image.type());

    for (int i = 0; i < image.rows; i++)
    {
        for (int j = 0; j < image.cols; j++)
        {
            if (i == 0 && j == 0)
            {
                pB = 0;
                pG = 0;
                pR = 0;
            }
            else if (i == 0 && j != 0)
            {
                pB = image.ptr<Vec3b>(0)[j - 1][0];
                pG = image.ptr<Vec3b>(0)[j - 1][1];
                pR = image.ptr<Vec3b>(0)[j - 1][2];
            }
            else if (j == 0 && i != 0)
            {
                pB = image.ptr<Vec3b>(i - 1)[0][0];
                pG = image.ptr<Vec3b>(i - 1)[0][1];
                pR = image.ptr<Vec3b>(i - 1)[0][2];
            }
            else
            {
                pB = get_x(i, j, image, 0);
                pG = get_x(i, j, image, 1);
                pR = get_x(i, j, image, 2);
            }

            rB = image.ptr<Vec3b>(i)[j][0] - pB;
            rG = image.ptr<Vec3b>(i)[j][1] - pG;
            rR = image.ptr<Vec3b>(i)[j][2] - pR;

            golomb.encode(rB);
            golomb.encode(rG);
            golomb.encode(rR);
        }
    }
    golomb.close();
    return 0;
}