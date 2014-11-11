set terminal png size 800,600
set ylabel "In thousands"

set output 'out/dev_user_service_download.png'

set multiplot layout 2, 2 title ""

set title "Growth of Developers"
plot "../logs/forplots/dev_user_service_download" using 1:($2/1000) title "" with lines

set title "Growth of Users"
plot "../logs/forplots/dev_user_service_download" using 1:($3/1000) title "" with lines

set title "Growth of Services"
plot "../logs/forplots/dev_user_service_download" using 1:($4/1000) title "" with lines

set title "Growth of Downloads"
plot "../logs/forplots/dev_user_service_download" using 1:($5/1000) title "" with lines