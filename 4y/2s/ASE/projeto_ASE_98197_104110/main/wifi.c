#include "wifi.h"
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_log.h"
#include "esp_http_client.h"
#include "freertos/FreeRTOS.h"
#include "freertos/event_groups.h"

#define WIFI_SSID      "Amorim"
#define WIFI_PASS      "blabla123"
#define MAXIMUM_RETRY  5

static const char *TAG = "WIFI";
EventGroupHandle_t s_wifi_event_group;
static int s_retry_num = 0;

#define WIFI_CONNECTED_BIT BIT0
#define WIFI_FAIL_BIT      BIT1

#define THINGSBOARD_SERVER "http://thingsboard.cloud/api/v1/8afq1xvcvl3npyuhqnib/telemetry"
#define THINGSBOARD_TOKEN  "8afq1xvcvl3npyuhqnib"

static void event_handler(void* arg, esp_event_base_t event_base, int32_t event_id, void* event_data) {
    if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_START) {
        esp_wifi_connect();
    } else if (event_base == WIFI_EVENT && event_id == WIFI_EVENT_STA_DISCONNECTED) {
        if (s_retry_num < MAXIMUM_RETRY) {
            esp_wifi_connect();
            s_retry_num++;
            ESP_LOGI(TAG, "retry to connect to the AP");
        } else {
            xEventGroupSetBits(s_wifi_event_group, WIFI_FAIL_BIT);
        }
        ESP_LOGI(TAG,"connect to the AP fail");
    } else if (event_base == IP_EVENT && event_id == IP_EVENT_STA_GOT_IP) {
        ip_event_got_ip_t* event = (ip_event_got_ip_t*) event_data;
        ESP_LOGI(TAG, "got ip:" IPSTR, IP2STR(&event->ip_info.ip));
        s_retry_num = 0;
        xEventGroupSetBits(s_wifi_event_group, WIFI_CONNECTED_BIT);
    }
}

void wifi_init_sta(void) {
    s_wifi_event_group = xEventGroupCreate();

    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    esp_netif_create_default_wifi_sta();

    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));

    esp_event_handler_instance_t instance_any_id;
    esp_event_handler_instance_t instance_got_ip;
    ESP_ERROR_CHECK(esp_event_handler_instance_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &event_handler, NULL, &instance_any_id));
    ESP_ERROR_CHECK(esp_event_handler_instance_register(IP_EVENT, IP_EVENT_STA_GOT_IP, &event_handler, NULL, &instance_got_ip));

    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASS,
            .threshold.authmode = WIFI_AUTH_WPA2_PSK,
        },
    };
    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
    ESP_ERROR_CHECK(esp_wifi_set_config(WIFI_IF_STA, &wifi_config));
    ESP_ERROR_CHECK(esp_wifi_start());
}

void reconnect_wifi() {
    s_retry_num = 0;
    esp_wifi_connect();
    EventBits_t bits = xEventGroupWaitBits(s_wifi_event_group, WIFI_CONNECTED_BIT | WIFI_FAIL_BIT, pdFALSE, pdFALSE, pdMS_TO_TICKS(10000)); // Wait up to 10 seconds

    if (bits & WIFI_CONNECTED_BIT) {
        ESP_LOGI(TAG, "Reconnected to AP SSID:%s, password:%s", WIFI_SSID, WIFI_PASS);
    } else {
        ESP_LOGI(TAG, "Failed to reconnect to SSID:%s, password:%s", WIFI_SSID, WIFI_PASS);
    }
}

void send_temperature_to_thingsboard(float temperature) {
    char post_data[50];
    snprintf(post_data, sizeof(post_data), "{\"temperature\": %.2f}", temperature);

    esp_http_client_config_t config = {
        .url = THINGSBOARD_SERVER,
        .method = HTTP_METHOD_POST,
        .event_handler = NULL,
        .buffer_size = 1024,
    };

    esp_http_client_handle_t client = esp_http_client_init(&config);

    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_http_client_set_header(client, "X-Authorization", "Bearer " THINGSBOARD_TOKEN);
    esp_http_client_set_post_field(client, post_data, strlen(post_data));

    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK) {
        ESP_LOGI(TAG, "Temperature sent to ThingsBoard successfully");
    } else {
        ESP_LOGE(TAG, "Failed to send temperature to ThingsBoard: %s", esp_err_to_name(err));
    }

    esp_http_client_cleanup(client);
}
