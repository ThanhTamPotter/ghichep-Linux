# Một số tài liệu tham khảo

### 1) Phân biệt cache và buffers: 

- Link tham khảo: https://kipalog.com/posts/Su-khac-nhau-giua-Buffers-va-Cached

- Một số trích đoạn quan trọng:

    Nếu coi OS như một app to (process id = 1) chuyên quản lý các app con (process) thì OS dùng buffer để move dữ liệu dần dần sang HDD (bản thân HDD cũng có buffer nhé), sang CDROM, printer, ... còn cached để ghi tạm data khi tính toán xong, ..., giúp lấy ra nhanh hơn (nhất là khi OS đa nhiệm, nó phải liên tục làm việc với nhiều app trong 1 khoảng thời gian nào đó). Chính vì thế, buffer thường được ví với cơ chế FIFO vì giống như việc move 1 data stream từ nơi này sang nơi kia, move xong là xoá. 

    Còn cached thì là cơ chế "Most used", nghĩa là dùng nhiều thì còn, dùng ít thì chuyển sang Swap, ít nữa hoặc k dùng thì clear. Thế nên, nói tới cached là phải nói tới TTL (Time to live, thời gian sống), cache hit/miss (khi cần dữ liệu, nó sẽ tìm RAM trước, xong Swapp, xong mới là ổ cứng. Cache hit càng cao chứng tỏ cache càng hiệu quả và nhanh. Nói tới cached là nói tới việc miss, mất sync) và random access (truy cập ngẫu nhiên qua offset)

    OS đa nhiệm sẽ cấp phát / thu hồi 1 Virtual Memory mà app yêu cầu, giống như cách mà app trong OS đơn nhiệm làm với Real Memory. Cái này giúp isolate môi trường chạy, giúp việc đa nhiệm dễ dàng hơn và data trên RAM bảo toàn được tính consistent.


### 2) `/dev/null` thùng rác vô tận trong Linux

- Link tham khảo: http://forum.gocit.vn/threads/tim-hiu-v-dev-null.424/

- Trích đoạn thú vị: 

     Ứng dụng của file `/dev/null`
    Dựa vào trong những đặt điểm trên của file `/dev/null`, nó được ứng dụng rộng rãi kể cả trong bảo mật (thậm chí mục tiêu bảo mật là chính), một vài ứng dụng của nó trong bảo mật là:
    - Các gói tin nào không phù hợp thường được firewall chuyển vào trong `/dev/null​`
    - Các email server cũng thường được config để chuyển các email spam vào trong `/dev/null` giúp không bị đầy hdd​
    - Trong các chương trình bắt buộc phải có đầu ra dữ liệu, nhưng vì bảo mật bạn không muốn nó xuất hiện các thông tin đầu ra ví dụ `.bash_history` của root thì cũng có thể dùng `/dev/null​`
    - Ngoài ra các bạn còn có thể tạo các file rỗng bằng cách lấy dữ liệu trong `/dev/null` ra.​
    - … và còn nhiều thứ nữa.​

    Vậy ta có thể kết luận: `/dev/null` là một cái thùng rác vô tận và rất có ích. :D

### 3) ` 2>&1` là gì?

- Link tham khảo: https://viblo.asia/p/mot-vai-luu-y-khi-su-dung-shell-script-phan-1-6BAMYV2AGnjz

- Cần nhớ: lấy đầu ra ở 2 (stderr) ghi vào vị trí có cùng địa chỉ của 1 (stdout). Nói chung là ghi lại lỗi sai vào đúng file lưu đầu ra. 

### 4) Promiscuous Mode 

- Link tham khảo: http://www.hvaonline.net/hvaonline/posts/list/2548.hva

- Là chế độ hoạt động của NIC cho phép chập nhận mọi packet không phải của nó, và nó vẫn xử lý rồi gửi tiếp lên trên. 