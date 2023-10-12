#include "CircularBuffer.hpp"
#include <cstdlib>

void CircularBuffer::putChar(char character) {
    this->data[this->tail] = character;
    this->tail = (this->tail + 1) % this->size;
}

char CircularBuffer::getLast() {
    int index = this->tail - 1;
    if (index == -1)
        return this->data[this->size - 1];
    else
        return this->data[this->tail - 1];
}

std::string CircularBuffer::readBuffer() {
    std::string out_string;
    int chars_read = 0;
    for (int i = this->head; chars_read < (this->size - 1);) {
        out_string += this->data[i];
        i = (i + 1) % this->size;
        chars_read++;
    }
    this->head = (this->head + 1) % this->size;
    return out_string;
}

void CircularBuffer::resetBuffer() {
    this->head = 0;
    this->tail = 0;
}

int CircularBuffer::bufferSize() { return this->size; }