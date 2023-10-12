#pragma once
#include <iostream>
#include <memory>
using namespace std;

class CircularBuffer {
  private:
    unique_ptr<char[]> data;
    int head = 0;
    int tail = 0;
    int size;

  public:
    CircularBuffer(int size) : data(unique_ptr<char[]>(make_unique<char[]>(size))), size(size){};
    void putChar(char character);
    void resetBuffer();
    char getLast();
    string readBuffer();
    int bufferSize();
};