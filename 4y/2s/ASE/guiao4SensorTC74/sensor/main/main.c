#include "TempSensorTC74.h"
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "esp_err.h"
#include "driver/i2c_master.h"
#include "esp_timer.h"

#define I2C_MASTER_SCL_IO           15
#define I2C_MASTER_SDA_IO           13
#define I2C_MASTER_FREQ_HZ          50000
#define TC74_SENSOR_ADDR            0x4D

static const char *TAG = "TC74_API";

void main(void)
{
    i2c_master_bus_handle_t busHandle = NULL;
    i2c_master_dev_handle_t sensorHandle = NULL;
    uint8_t temp = 0;
    esp_err_t ret = ESP_OK;

    ret = tc74_init(&busHandle, &sensorHandle, TC74_SENSOR_ADDR, I2C_MASTER_SDA_IO, I2C_MASTER_SCL_IO, I2C_MASTER_FREQ_HZ);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize TC74 sensor: %d", ret);
        return;
    }
    ESP_LOGI(TAG, "TC74 sensor initialized");

    ret = tc74_wakeup_and_read_temp(sensorHandle, &temp);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to read temperature from TC74 sensor: %d", ret);
        return;
    }

    ESP_LOGI(TAG, "Temperature: %d", temp);

    ret = tc_74_free(busHandle, sensorHandle);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to free TC74 sensor: %d", ret);
        return;
    }
}
#include "TempSensorTC74.h"
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "esp_err.h"
#include "driver/i2c_master.h"
#include "esp_timer.h"

#define I2C_MASTER_SCL_IO           15
#define I2C_MASTER_SDA_IO           13
#define I2C_MASTER_FREQ_HZ          50000
#define TC74_SENSOR_ADDR            0x4D

static const char *TAG = "TC74_API";

void main(void)
{
    i2c_master_bus_handle_t busHandle = NULL;
    i2c_master_dev_handle_t sensorHandle = NULL;
    uint8_t temp = 0;
    esp_err_t ret = ESP_OK;

    ret = tc74_init(&busHandle, &sensorHandle, TC74_SENSOR_ADDR, I2C_MASTER_SDA_IO, I2C_MASTER_SCL_IO, I2C_MASTER_FREQ_HZ);
    if (ret != ESP_OK) {
        ESP_LOGE(TAG, "Failed to initialize TC74 sensor: %d", ret);
        return;
    }
    ESP_LOGI(TAG, "TC74 sensor initialized");
}
