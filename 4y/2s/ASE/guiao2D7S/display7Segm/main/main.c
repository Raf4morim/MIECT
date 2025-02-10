#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"


                        // a, b, c, d, e, f, g, dp
const int segmentPins[] = {2, 3, 10, 5, 4, 7, 6, 8};
const int mosfetPins[] = {0, 1};

const int displayCodes[][8] = {
    {1, 1, 1, 1, 1, 1, 0, 0},  // 0
    {0, 1, 1, 0, 0, 0, 0, 0},  // 1
    {1, 1, 0, 1, 1, 0, 1, 0},  // 2
    {1, 1, 1, 1, 0, 0, 1, 0},  // 3
    {0, 1, 1, 0, 0, 1, 1, 0},  // 4
    {1, 0, 1, 1, 0, 1, 1, 0},  // 5
    {1, 0, 1, 1, 1, 1, 1, 0},  // 6
    {1, 1, 1, 0, 0, 0, 0, 0},  // 7
    {1, 1, 1, 1, 1, 1, 1, 0},  // 8
    {1, 1, 1, 1, 0, 1, 1, 0},  // 9
    {1, 1, 1, 0, 1, 1, 1, 0},  // A
    {0, 0, 1, 1, 1, 1, 1, 0},  // B
    {1, 0, 0, 1, 1, 1, 0, 0},  // C
    {0, 1, 1, 1, 1, 0, 1, 0},  // D
    {1, 0, 0, 1, 1, 1, 1, 0},  // E
    {1, 0, 0, 0, 1, 1, 1, 0}   // F
};


void setup_segments(void) {
    for (int i = 0; i < 8; i++) {
        gpio_reset_pin(segmentPins[i]);
        gpio_set_direction(segmentPins[i], GPIO_MODE_OUTPUT);
    }
}

void setup_mosfets(void) {
    gpio_reset_pin(mosfetPins[0]);
    gpio_set_direction(mosfetPins[0], GPIO_MODE_OUTPUT);
    gpio_reset_pin(mosfetPins[1]);
    gpio_set_direction(mosfetPins[1], GPIO_MODE_OUTPUT);
}


void send2Displays(int value, int base) {
    static char displayFlag = 0;
    int digit1 = value / base;
    int digit2 = value % base;

    if (displayFlag == 0) { // right display
        gpio_set_level(mosfetPins[0], 0);
        gpio_set_level(mosfetPins[1], 1);

        for (int i = 0; i < 8; i++) {
            gpio_set_level(segmentPins[i], displayCodes[digit2][i]);
        }
        
    } else { // left displays
        gpio_set_level(mosfetPins[0], 1);
        gpio_set_level(mosfetPins[1], 0);

        for (int i = 0; i < 8; i++) {
            gpio_set_level(segmentPins[i], displayCodes[digit1][i]);
        }
        
    }
    displayFlag = !displayFlag; 
}



void app_main(void)
{
    setup_segments();
    setup_mosfets();

    int aux = 0;
    int counter = 0;

    while(1) {  
        if (aux == 100) { // 10 hz * 100 = 1000 hz = 1 sec
            counter = (counter + 1) % 256;
            aux = 0;
        } else {
            aux += 1;
        }

        send2Displays(counter, 16);
        vTaskDelay(10 / portTICK_PERIOD_MS);    // 100 hz = 10ms
    }
}