#!/bin/bash

myfritzdomain=<your myfritz subdomain>
desecToken=<deSECToken>
domains=('example.com' 'example.org')



IPv4=$(dig @9.9.99 "$myfritzdomain" A +short)
exitcode4=$?

IPv6=$(dig @9.9.9.9 "$myfritzdomain" AAAA +short)
exitcode6=$?

if [ $((exitcode4 + exitcode6)) -ne 0 ]; then
    echo "Fehler bei der Ausführung von dig"
    exit 1
fi

if [ ! -e /tmp/dyndnsv4 ]; then
    echo $IPv4 > /tmp/dyndnsv4
fi

if [ ! -e /tmp/dyndnsv6 ]; then
    echo $IPv6 > /tmp/dyndnsv6
fi


if [ $(cat /tmp/dyndnsv4) != "$IPv4" ] || [ $(cat /tmp/dyndnsv6) != "$IPv6" ]; then
    echo "$(date +"%d.%m.%Y %H:%M") The IP-Adresses have changed"
    echo $IPv4 > /tmp/dyndnsv4
    echo $IPv6 > /tmp/dyndnsv6

    
    for domain in "${domains[@]}"; do

        echo "$(date +"%d.%m.%Y %H:%M") Sende Update für $domain"
          StatusCode=$(curl "https://update6.dedyn.io/?hostname=$domain&myipv4=$IPv4&myipv6=$IPv6" \
          --header "Authorization: Token "$desecToken"" \
          -s \
          -o /dev/null \
          -w "%{http_code}")

            if [ $StatusCode -eq 200 ]; then
                echo "$(date +"%d.%m.%Y %H:%M") Updating the domain $domain was successful (Statuscode: $StatusCode)"
            else
                echo "$(date +"%d.%m.%Y %H:%M") Updating the domain $domain was not successful (Statuscode: $StatusCode)"
            fi

    done
fi



