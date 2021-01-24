/ip firewall mangle
add action=mark-packet chain=prerouting new-packet-mark=Netflix passthrough=no src-address-list=NetflixVideo
add action=add-dst-to-address-list address-list=Filmin-Video address-list-timeout=6h chain=prerouting comment=\
    "Filmin - Queue by 410.g0n3" content=test2.filmin in-interface=all-ppp
add action=add-dst-to-address-list address-list=Filmin-Video address-list-timeout=6h chain=prerouting content=\
    filmin.com
add action=mark-packet chain=prerouting new-packet-mark=Filmin passthrough=no src-address-list=Filmin-Video
add action=add-dst-to-address-list address-list=Twitch-Video address-list-timeout=6h chain=prerouting comment=\
    "Twitch - Queue by 410.g0n3" content=hls.ttvnw
add action=mark-packet chain=prerouting new-packet-mark=Twitch passthrough=no src-address-list=Twitch-Video
/queue type
add kind=pcq name=TraficoLimitado pcq-classifier=dst-address pcq-dst-address6-mask=64 pcq-rate=10M \
    pcq-src-address6-mask=64
/queue tree
add name=Filmin packet-mark=Filmin parent=global queue=TraficoLimitado
add name=Twitch packet-mark=Twitch parent=global queue=TraficoLimitado