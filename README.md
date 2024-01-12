# deSEC-dyndnsupdatescript
A small script to update multiple domains with IPv4 and IPv6 addresses  based on a myfritz domain.

This script gets the IPv4 and IPv6 addresses from your myfritz domain and adds them to multiple (or just one) dyndns records hosted at [deSEC](https://desec.io/).

## Customize
Open the file dyndns-update.sh with your favorite editor and change the following
```
myfritzdomain=<your myfritz subdomain>
desecToken=<deSECToken>
domains=('example.com' 'example.org')
```
Note that there is no comma between the domains in the array!

## Using the script

Mark the script file as executable with ```chmod +x dyndns-update.sh``` and run it with ```./dyndns-update.sh```.

I recommend to automate the process. You can run the script about every 5 minutes and you won't hit any speed limits at deSEC because the script caches the IP addresses and only contacts the deSEC servers when they have changed.

### Automate it!
Here is an example for systemd:

Create the file ```/etc/systemd/system/bash-dyndns-update.service``` and add and adjust the following content:
```
[Unit]
Description=Update dynDNS at deSEC.io

[Service]
Type=oneshot
ExecStart=/path/to/dyndns-update.sh

[Install]
WantedBy=multi-user.target
```

Create the file ```/etc/systemd/system/bash-dyndns-update.timer``` and add the following content:
```
[Unit]
Description=Update dynDNS at deSEC.io

[Timer]
OnUnitActiveSec=5min
Persistent=true
Unit=bash-dyndns-update.service

[Install]
WantedBy=multi-user.target
```

Then activate the .service and the .timer files and start the timer:
```
sudo systemctl enable bash-dyndns-update.service
sudo systemctl enable bash-dyndns-update.timer
sudo systemctl start  bash-dyndns-update.timer
```


Hope you host some great stuff at home!
