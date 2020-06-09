FROM justkdng/archlinux:latest

COPY entrypoint.sh /entrypoint.sh
COPY makepkg.conf /etc/makepkg.conf

ENTRYPOINT ["/entrypoint.sh"]
