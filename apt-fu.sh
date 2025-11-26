
#  --no-install-recommends --no-install-suggests
sudo apt-get update --assume-yes \
&& sudo apt-get install --assume-yes ubuntu-desktop

sudo rm -frv -- /var/cache/apt/archives/* \
&& sudo apt-get autoremove \

echo 'If both are enable, disable one of them!' \
&& systemctl is-enabled NetworkManager-wait-online.service \
&& systemctl is-enabled systemd-networkd-wait-online.service \
&& systemctl disable systemd-networkd.service
