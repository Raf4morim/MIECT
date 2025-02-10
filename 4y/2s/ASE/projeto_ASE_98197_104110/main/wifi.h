#ifndef WIFI_H
#define WIFI_H

#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"
#include "esp_err.h"
#include "esp_event.h"

#define WIFI_SSID      "Amorim"
#define WIFI_PASS      "blabla123"
#define MAXIMUM_RETRY  5

extern EventGroupHandle_t s_wifi_event_group;

#define WIFI_CONNECTED_BIT BIT0
#define WIFI_FAIL_BIT      BIT1

void wifi_init_sta(void);
void reconnect_wifi(void);
void send_temperature_to_thingsboard(float temperature);

#endif // WIFI_H
