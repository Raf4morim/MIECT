#include <iostream>
#include "../3/Golomb.cpp"
#include <opencv2/opencv.hpp>
#include <string.h>

using namespace std;
using namespace cv;

int get_x(int i, int j, Mat image, int plane)
{
    int a = image.ptr<Vec3b>(i)[j - 1][plane];
    int b = image.ptr<Vec3b>(i - 1)[j][plane];
    int c = image.ptr<Vec3b>(i - 1)[j - 1][plane];
    int local_max = max(a, b);
    int local_min = min(a, b);

    if (c >= local_max)
        return local_min;
    else if (c <= local_min)
        return local_max;
    else
        return (a + b - c);
}

int main(void)
{
    char *inputfile = (char *)"6/bike3.txt";
    Golomb golomb{inputfile, 'd', 1920};

    int planeB, planeG, planeR;
    int rows = golomb.decode();
    int cols = golomb.decode();
    int imgType = golomb.decode();
    int currentValB, currentValG, currentValR;

    Mat output_img(rows, cols, imgType);

    for (int i = 0; i < rows; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            currentValB = golomb.decode();
            currentValG = golomb.decode();
            currentValR = golomb.decode();

            if (i == 0 && j == 0){
                planeB = currentValB;
                planeG = currentValG;
                planeR = currentValR;
            }else if (i == 0 && j != 0){
                planeB = output_img.ptr<Vec3b>(0)[j - 1][0] + currentValB;
                planeG = output_img.ptr<Vec3b>(0)[j - 1][1] + currentValG;
                planeR = output_img.ptr<Vec3b>(0)[j - 1][2] + currentValR;
            }else if (i != 0 && j == 0){
                planeB = output_img.ptr<Vec3b>(i - 1)[0][0] + currentValB;
                planeG = output_img.ptr<Vec3b>(i - 1)[0][1] + currentValG;
                planeR = output_img.ptr<Vec3b>(i - 1)[0][2] + currentValR;
            }else{
                planeB = currentValB + get_x(i, j, output_img, 0);
                planeG = currentValG + get_x(i, j, output_img, 1);
                planeR = currentValR + get_x(i, j, output_img, 2);
            }
            output_img.ptr<Vec3b>(i)[j] = Vec3b(planeB, planeG, planeR);
        }
    }
    golomb.close();

    imwrite("6/bike3_decoded.ppm", output_img);
    waitKey(0);

    return 0;
}