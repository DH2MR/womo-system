# ESP32-S3 Zero Pin Planning

Standard-Pinbelegung für WoMo Nodes.

## Reservierte Pins

GPIO21  
Onboard WS2812 LED

GPIO0  
Boot Mode

GPIO43 / GPIO44  
UART0

## Nicht nutzbar

GPIO33–37  
PSRAM

## Bevorzugte GPIOs

1–14  
17–20  
38–42

## Standard Busse

I2C

SDA: GPIO8  
SCL: GPIO9

SPI

SCK: GPIO12  
MOSI: GPIO11  
MISO: GPIO13  
CS: GPIO10

UART1

TX: GPIO17  
RX: GPIO18

Optional WS2812

GPIO20
