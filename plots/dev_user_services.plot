set terminal png size 600,800
set output 'out/dev_user_services.png'

set multiplot layout 3, 1 title ""

set title "Growth of Developers"
plot "../logs/forplots/developer_count" using 1:2 title "" with lines

set title "Growth of Users"
plot "../logs/forplots/user_count" using 1:2 title "" with lines

set title "Growth of Services"
plot "../logs/forplots/service_count" using 1:2 title "" with lines

