# Wifi-Hacking

WiFi hacking with aircrack-ng support scripts.

In order to hack any WiFi APs you need a chip that supports *promiscuous* mode. There are various WiFi USB adapters if your chip doesn't support this mode. However, if you want to find out if your internal card is supported by aircrack-ng, you can check out [this](https://www.aircrack-ng.org/doku.php?id=compatible_cards) tutorial.

```bash
# 1) Clone this repo
# 2) Make scripts executable
# 3) Have fun!
git clone https://github.com/nrkramer/Wifi-Hacking.git WifiHacking
cd WifiHacking
chmod +x *.sh
./wpa_crack.sh
```
