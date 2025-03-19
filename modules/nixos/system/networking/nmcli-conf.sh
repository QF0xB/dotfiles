#!/bin/sh

# Usage: bash   easyroam_nmcli.sh

set -e

# check if we are root

if [[ $EUID -ne 0 ]]; then
    echo "You must be root to run easyroam_nmcli.sh." 1>&2
    exit 100
fi

# check for easyroam-cert files

[ -d /etc/easyroam-certs ] && ConfDir=/etc/easyroam-certs || { echo "Aborted, run easyroam_extract.sh first!"; exit 1;  }
[ -f /etc/easyroam-certs/easyroam_client_cert.pem ] ||  { echo "Aborted, client_cert missing."; exit 1;  }
[ -f /etc/easyroam-certs/easyroam_root_ca.pem ] ||  { echo "Aborted, root_ca missing."; exit 1;  }
[ -f /etc/easyroam-certs/easyroam_client_key.pem ] ||  { echo "Aborted, client_key missing."; exit 1;  }
[ -f /etc/easyroam-certs/identity ] && Identity=$(cat "$ConfDir/identity") ||  { echo "Aborted, identity missing"; exit 1;  }

Pwd="pkcs12"
# check for nmcli

if ! type nmcli >/dev/null 2>&1; then
        echo ""
        echo "ERROR: nmcli not found!" >&2
        echo "This wizard assumes that your network connections are NOT managed by NetworkManager." >&2
        echo ""
        exit 1
fi

# check for wifi device

if ! nmcli -g TYPE,DEVICE device | grep wifi >/dev/null; then
        echo ""
        echo "ERROR: Unable to find any wifi device!" >&2
        echo ""
        exit 1
fi


# configure parameters

WIntName=$(iw dev | awk '$1=="Interface"{print $2}')

WOn="GENERAL.STATE:"

WLANName="eduroam"

ALT_SUBJECT="DNS:easyroam.eduroam.de"

# TLS_1.3
TLS_VERSION="0x100"

# Remove existing connections

nmcli connection show | \
        awk '$1==c{ print $2 }' c="$WLANName" | \
        xargs -rn1 nmcli connection delete uuid

# switch wlan on

nmcli dev show "$WIntName" | \
      awk '$1==c{ print $2 }' c="$WOn" | \
      xargs -rn1 nmcli radio wifi on

# Create new connection

nmcli connection add \
        type wifi \
        con-name "$WLANName" \
        ssid "$WLANName" \
        -- \
        wifi-sec.key-mgmt wpa-eap \
        802-1x.eap tls \
        802-1x.altsubject-matches "$ALT_SUBJECT" \
        802-1x.phase1-auth-flags "$TLS_VERSION" \
        802-1x.identity "$Identity" \
        802-1x.ca-cert "$ConfDir/easyroam_root_ca.pem" \
        802-1x.client-cert "$ConfDir/easyroam_client_cert.pem" \
        802-1x.private-key-password "$Pwd" \
        802-1x.private-key "$ConfDir/easyroam_client_key.pem"
