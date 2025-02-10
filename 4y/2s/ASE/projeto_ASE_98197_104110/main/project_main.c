#include "temp_sensor_tc74.h"
#include "wifi.h"
#include "spiffs.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_system.h"
#include <stdio.h>
#include <string.h>
#include <sys/unistd.h>
#include <sys/stat.h>
#include "esp_err.h"
#include "esp_log.h"
#include "esp_spiffs.h"
#include "driver/uart.h"
#include "esp_timer.h"
#include "esp_sleep.h"
#include "nvs_flash.h"

static const char *TAG = "project";

void temperature_task(void *pvParameters) {
    esp_err_t result;
    i2c_master_bus_handle_t busHandle;
    i2c_master_dev_handle_t sensorHandle;
    uint8_t temp;

    // Initialize the sensor
    result = tc74_init(&busHandle, &sensorHandle, 0x49, 1, 0, 50000); 
    if (result != ESP_OK) {
        ESP_LOGE(TAG, "Sensor initialization failed");
        vTaskDelete(NULL);
        return;
    }

    // Wake up the sensor
    result = tc74_wakeup(sensorHandle);
    if (result != ESP_OK) {
        ESP_LOGE(TAG, "Failed to wake up sensor");
        vTaskDelete(NULL);
        return;
    }

    while(1){
        // Read the temperature
        result = tc74_read_temp_after_cfg(sensorHandle, &temp);
        if (result == ESP_OK) {
            // Write the temperature to a file using SPIFFS
            write_temperature_spiffs((int8_t)temp);

            // Send the temperature to ThingsBoard if connected to WiFi
            EventBits_t bits = xEventGroupGetBits(s_wifi_event_group);
            if (bits & WIFI_CONNECTED_BIT) {
                send_temperature_to_thingsboard((int8_t)temp);
            } else {
                ESP_LOGI(TAG, "WiFi not connected. Temperature not sent to ThingsBoard.");
            }

        } else {
            ESP_LOGE(TAG, "Failed to read temperature");
        }

        /*  Energy consuming tests */
        /*int64_t t_before_us = esp_timer_get_time();
        esp_sleep_enable_timer_wakeup(5000000); // 5 seconds
        esp_light_sleep_start();
        int64_t t_after_us = esp_timer_get_time();
        const char* wakeup_reason = "timer";
        printf("Returned from light sleep, reason: %s, slept for %lld ms\n",wakeup_reason, (t_after_us - t_before_us) / 1000);
        // Reconect to WiFi after waking up from sleep
        reconnect_wifi();*/

        // Read the temperature from the file
        read_temperature_spiffs();

        vTaskDelay(pdMS_TO_TICKS(5000));  // Delay for 5 seconds before the next reading
    }
}

void app_main(void) {
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        ESP_ERROR_CHECK(nvs_flash_erase());
        ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    ESP_LOGI(TAG, "ESP_WIFI_MODE_STA");
    wifi_init_sta();

    // Initialize SPIFFS
    ESP_ERROR_CHECK(init_spiffs());

    // Create a task to read temperature and write to file
    xTaskCreate(temperature_task, "temperature_task", 4096, NULL, 5, NULL);
}