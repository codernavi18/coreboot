#!/bin/bash

echo "===> Step 1 : Copy the ROM image to raspberry pi"
scp build/coreboot.rom pi@192.168.1.14:~/Downloads/
echo ""
sleep 1

echo "===> Step 2 : Turning power off and getting ready for flashing BIOS"
mpoweroff
sleep 0.5 #for safety, power must be off before connecting the SPI lines for BIOS flash
connect_cs
connect_clock
connect_vcc
echo ""
sleep 1

echo "===> Step 3 : Flashing the BIOS image"
ssh pi@192.168.1.14 'cd Downloads && /usr/sbin/flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=32000 -l mb.layout -i bios -w coreboot.rom'
echo ""
sleep 1

echo "===> Step 4 : Disconnect SPI lines and reboot board"
disconnect_vcc
disconnect_clock
disconnect_cs
sleep 0.5 #for safety, all SPI lines must be disconnected before turning the power on
mpoweron
echo ""
