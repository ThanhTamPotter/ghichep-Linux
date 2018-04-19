# Một số tài liệu tham khảo

### 1) Phân biệt cache và buffers: 

- Link tham khảo: https://kipalog.com/posts/Su-khac-nhau-giua-Buffers-va-Cached

- Một số trích đoạn quan trọng:

    Nếu coi OS như một app to (process id = 1) chuyên quản lý các app con (process) thì OS dùng buffer để move dữ liệu dần dần sang HDD (bản thân HDD cũng có buffer nhé), sang CDROM, printer, ... còn cached để ghi tạm data khi tính toán xong, ..., giúp lấy ra nhanh hơn (nhất là khi OS đa nhiệm, nó phải liên tục làm việc với nhiều app trong 1 khoảng thời gian nào đó). Chính vì thế, buffer thường được ví với cơ chế FIFO vì giống như việc move 1 data stream từ nơi này sang nơi kia, move xong là xoá. 

    Còn cached thì là cơ chế "Most used", nghĩa là dùng nhiều thì còn, dùng ít thì chuyển sang Swap, ít nữa hoặc k dùng thì clear. Thế nên, nói tới cached là phải nói tới TTL (Time to live, thời gian sống), cache hit/miss (khi cần dữ liệu, nó sẽ tìm RAM trước, xong Swapp, xong mới là ổ cứng. Cache hit càng cao chứng tỏ cache càng hiệu quả và nhanh. Nói tới cached là nói tới việc miss, mất sync) và random access (truy cập ngẫu nhiên qua offset)

    OS đa nhiệm sẽ cấp phát / thu hồi 1 Virtual Memory mà app yêu cầu, giống như cách mà app trong OS đơn nhiệm làm với Real Memory. Cái này giúp isolate môi trường chạy, giúp việc đa nhiệm dễ dàng hơn và data trên RAM bảo toàn được tính consistent.