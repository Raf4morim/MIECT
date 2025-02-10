#include "temp_sensor_tc74.h"
#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "esp_err.h"
#include "driver/i2c_master.h"


// Define the logging tag
static const char* TAG = "TC74_SENSOR";


// Initialize the I2C bus and add TC74 sensor
esp_err_t tc74_init(i2c_master_bus_handle_t* pBusHandle, i2c_master_dev_handle_t* pSensorHandle,uint8_t sensorAddr, int sdaPin, int sclPin, uint32_t clkSpeedHz){
    i2c_master_bus_config_t i2cMasterCfg = {
        .clk_source = I2C_CLK_SRC_DEFAULT,
        .i2c_port = I2C_NUM_0,
        .scl_io_num = sclPin,
        .sda_io_num = sdaPin,
        .glitch_ignore_cnt = 7,
        .flags.enable_internal_pullup = true,
    };   

   esp_err_t err = i2c_new_master_bus(&i2cMasterCfg, pBusHandle);
   if(err != ESP_OK){
    return err;
   }

    i2c_device_config_t sensor_cfg = {
        .dev_addr_length = I2C_ADDR_BIT_LEN_7,
        .device_address = sensorAddr,
        .scl_speed_hz = clkSpeedHz,
    };

    err = i2c_master_bus_add_device(*pBusHandle, &sensor_cfg, pSensorHandle);
    if(err != ESP_OK){
    return err;
   }

   return ESP_OK;

}

// Wakes up the TC74 sensor from standby mode
esp_err_t tc74_wakeup(i2c_master_dev_handle_t deviceHandle) {
    // need to send command to wake sensor
    // need to send data to sensor
    
    uint8_t buffer[2] = {0x01,0x00};  // Command to wake up the sensor
    // uint8_t buffer2[1] = {0x00};  // Command to read temperature
    esp_err_t err = i2c_master_transmit(deviceHandle, buffer, sizeof(buffer), -1);  // Send the wake-up command
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to wake up the sensor, error: %s", esp_err_to_name(err));  // Log the error
    }
    return err;
}




// Verifica se a temperatura está pronta para ser lida
bool tc74_is_temperature_ready(i2c_master_dev_handle_t deviceHandle) {
    uint8_t txBuf[1] = {0x01};  // Command to read status register
    uint8_t rxBuf[1] = {0};     // Initialize the receive buffer with zero
    esp_err_t err = i2c_master_transmit_receive(deviceHandle, txBuf, sizeof(txBuf), rxBuf, sizeof(rxBuf), -1);
    if (err != ESP_OK) {
        return false;
    }
    // Assuming the ready bit is the LSB of the status register
    return (rxBuf[0] & 0x01) != 0;
}


// Read temperature from the TC74 sensor, interpreting the temperature correctly

esp_err_t tc74_read_temp_after_cfg(i2c_master_dev_handle_t deviceHandle, uint8_t* pTemp) {
    uint8_t txBuf[1] = {0x00};  // Command to read temperature
    uint8_t rxBuf[1] = {0};     // Initialize buffer to zero
    esp_err_t err = i2c_master_transmit_receive(deviceHandle, txBuf, sizeof(txBuf), rxBuf, sizeof(rxBuf), -1);
    
    if (err != ESP_OK) {
        ESP_LOGE(TAG, "Failed to read temperature, error: %s", esp_err_to_name(err));
        return err;
    }

    //ESP_LOGI(TAG, "Raw temperature read: 0x%02X", rxBuf[0]);

    // Interpret the byte as signed
    *pTemp = rxBuf[0];
    int8_t tempSigned = (int8_t) *pTemp;  // Cast to signed byte
    //ESP_LOGI(TAG, "Interpreted temperature: %d°C", tempSigned);

    return ESP_OK;
}



// Coloca o sensor em modo standby
esp_err_t tc74_standby(i2c_master_dev_handle_t deviceHandle) {
    uint8_t buffer[1] = {0x01};  //  command for standby
    esp_err_t err = i2c_master_transmit(deviceHandle, buffer, sizeof(buffer), -1);
    return err;
}


// // Libera recursos do sensor TC74
// esp_err_t tc_74_free(i2c_master_bus_handle_t busHandle,i2c_master_dev_handle_t sensorHandle) {
//     i2c_driver_delete(gI2CPortNum);
//     return ESP_OK;
// }