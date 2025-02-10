#include <stdio.h>
#include "esp_log.h"
#include "driver/gpio.h"

void app_main(void)
{
    gpio_config_t io_conf = {};                     //zero-initialize the config structure.
    io_conf.intr_type = GPIO_INTR_DISABLE;          //disable interrupt
    io_conf.mode = GPIO_MODE_OUTPUT;                //set as output mode
    io_conf.pin_bit_mask = (1ULL << GPIO_NUM_8);    //bit mask of the pins that you want to set,e.g.GPIO2
    io_conf.pull_down_en = 0;                       //disable pull-down mode
    io_conf.pull_up_en = 0;                         //disable pull-up mode
    gpio_config(&io_conf);                          //configure GPIO with the given settings

    io_conf.mode = GPIO_MODE_INPUT;                 // Configure GPIO3 (switch pin) as input mode
    io_conf.pin_bit_mask = (1ULL << GPIO_NUM_2);    // Bit mask of the pins that you want to set, GPIO3 in this case
    for the switc io_conf.pull_up_en = 1;                         // Enable pull-up mode for GPIO3 (internal pull-up resistor) 
    gpio_config(&io_conf);                          // Configure GPIO with the given settings

    while (1) {
        int switch_state = gpio_get_level(GPIO_NUM_2);  // Read the state of the switch (GPIO3)
        gpio_set_level(GPIO_NUM_8, switch_state);       // Set the LED state based on the switch state
    }

}