Tham khảo: 

[1] https://www.linode.com/docs/tools-reference/tools/find-files-in-linux-using-the-command-line/

[2] https://www.tecmint.com/35-practical-examples-of-linux-find-command/

[3] http://man7.org/linux/man-pages/man1/find.1.html

Một số ví dụ:

- Tìm file có theo chính xác tên, sử dụng tùy chọn '-name'. Ví dụ: Tìm tất các file có tên logstash:

    `find / -name logstash`

- Tìm các file trong tên có chứa chuỗi "logsta" :

    `find / -name logsta*`

- Tìm file bin lệnh logstash:

    ```
    root@tia-lab2:/etc/logstash/conf.d# find / -wholename *bin*logstash*
    find: ‘/proc/3358/task/3358/net’: Invalid argument
    find: ‘/proc/3358/net’: Invalid argument
    /usr/share/logstash/bin/logstash
    /usr/share/logstash/bin/logstash-keystore.bat
    /usr/share/logstash/bin/logstash-plugin.bat
    /usr/share/logstash/bin/logstash.lib.sh
    /usr/share/logstash/bin/logstash-keystore
    /usr/share/logstash/bin/logstash-plugin
    /usr/share/logstash/bin/logstash.bat
    root@tia-lab2:/etc/logstash/conf.d#
    ```


