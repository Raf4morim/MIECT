#ifndef SPIFFS_H
#define SPIFFS_H

#include "esp_err.h"

esp_err_t init_spiffs(void);
void write_temperature_spiffs(int8_t temperature);
void read_temperature_spiffs(void);

#endif // SPIFFS_H
