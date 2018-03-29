#! /bin/bash
echo "## Lay ten cua interface dau tien va show ra dia chi IP cua interface do: ##"
#echo " ^2 la interface thu 2 sau interface lo"
ip_link=`/sbin/ip l | awk '/^2:/ {print $2}' | cut -f1 -d ":" `
ip_address=`/sbin/ifconfig $ip_link | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `

echo " $ip_link : $ip_address"