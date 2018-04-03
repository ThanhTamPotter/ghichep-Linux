# Ghi chép một số lưu ý khi sử dụng lệnh `sed`

### ***Mục lục***

[1. Thay thế chuỗi ](#1)

---

<a name ='1'></a>
## 1. Thay thế chuỗi

- Có thể sử dụng lệnh `sed` để thay thế chuỗi bất kì được bắt đầu với một chuỗi mà mình đã biết trước sử dụng với `.*` ( kí tự `.` thay thế một kí tự bất kì, còn kí tự `*` đại diện cho việc lặp lại kí tự trước đó => chuỗi `.*` có thể thay thế cho chuỗi bất kì có thể khớp)

- Ví dụ: chỉnh sửa file `/etc/network/interfaces` thay thế bất kì dòng nào bắt đầu với `iface ...` sẽ được thay thế thành `IFACE ENS345` (tức là dù trong file ban đầu, đằng sau các dòng bất kì bắt đầu với `iface` sẽ thay thế toàn bộ dòng đó thành `IFACE ENS345`)

    - File gốc:

        ```
        # The loopback network interface
        auto lo
        iface lo inet loopback

        # The primary network interface
        auto ens3
        iface ens3 inet static
        address 10.10.10.11/24

        auto ens4
        iface ens4 inet static
        address 192.168.122.11/24
        gateway 192.168.122.1
        dns-nameservers 8.8.8.8

        auto ens5
        iface ens5 inet static
        address 10.10.20.11/24
        ```
    
    - Kết quả sau khi thực hiện lệnh: `sed -i 's/^iface.*/IFACE ENS345/g' /etc/network/interfaces`

        ```
        # The loopback network interface
        auto lo
        IFACE ENS345

        # The primary network interface
        auto ens3
        IFACE ENS345
        address 10.10.10.11/24

        auto ens4
        IFACE ENS345
        address 192.168.122.11/24
        gateway 192.168.122.1
        dns-nameservers 8.8.8.8

        auto ens5
        IFACE ENS345
        address 10.10.20.11/24
        ```




