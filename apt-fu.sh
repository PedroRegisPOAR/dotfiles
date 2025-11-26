
#  --no-install-recommends --no-install-suggests
sudo apt-get update --assume-yes \
&& sudo apt-get install --assume-yes ubuntu-desktop

sudo rm -frv -- /var/cache/apt/archives/* \
&& sudo apt-get autoremove

echo 'If both are enable, disable one of them!' \
&& sudo systemctl is-enabled NetworkManager-wait-online.service \
&& sudo systemctl is-enabled systemd-networkd-wait-online.service \
&& sudo systemctl disable systemd-networkd.service
