#! /bin/bash
filename=vmOPS1506
reportfile=Report_StartCloud_1506.csv
echo "VM-uuid,VM-name,vcpu (core), RAM capacity (GB),CPU usage (%),RAM usage (%)" >> $reportfile
curl http://localhost:9090/api/v1/query?query=libvirt_domain_info_virtual_cpus | jq . | grep uuid > $filename
sed -i 's/          "uuid": "//g' $filename
sed -i 's/"//g' $filename
cat $filename | while read line
do
vm_name=$(curl -g -s http://localhost:9090/api/v1/query?query=libvirt_domain_info_meta\{uuid=\"$line\"\} | jq . | grep instance_name |awk  'BEGIN {FS = "\""}; {print $4}')
vcpu=$(curl -g -s http://localhost:9090/api/v1/query?query=libvirt_domain_info_virtual_cpus\{uuid=\"$line\"\} | awk 'BEGIN { FS = "value"}; {print $2}' | awk 'BEGIN { FS = "\""}; {print $3}')
nram=$(curl -g -s http://localhost:9090/api/v1/query?query=libvirt_domain_info_maximum_memory_bytes\{uuid=\"$line\"\}\/\(1024^3\) | awk 'BEGIN { FS = "value"}; {print $2}' | awk 'BEGIN { FS = "\""}; {print $3}')
ram_percent=$(curl -g -s http://localhost:9090/api/v1/query?query=avg_over_time\(libvirt_domain_memory_stats_used_percent\{uuid=\"$line\"\}\[7d\]\) | awk 'BEGIN { FS = "value"}; {print $2}' | awk 'BEGIN { FS = "\""}; {printf "%.2f",$3}')
cpu_percent=$(curl -g -s http://localhost:9090/api/v1/query?query=rate\(libvirt_domain_info_cpu_time_seconds_total\{uuid=\"$line\"\}\[7d\]\)*100 | awk 'BEGIN { FS = "value"}; {print $2}' | awk 'BEGIN { FS = "\""}; {printf "%.2f",$3}')
echo "$line, $vm_name, $vcpu, $nram, $cpu_percent,$ram_percent" >> $reportfile
done