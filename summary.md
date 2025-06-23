# Tóm tắt thay đổi

- Thay phần Latest Posts trong demo/index.md thành <!--LATEST_POSTS--> để tự động chèn danh sách bài viết.
- Thêm script shell scripts/gen_latest_posts.sh để sinh file demo/index.generated.md từ demo/index.md và danh sách bài viết trong posts/.
- Sửa Makefile để build từ demo/index.generated.md thay vì index.md, và thêm bước generate file này trước khi build.
- Tạo thư mục cv để lưu trữ hồ sơ cá nhân (resume) theo chuẩn best practices, giúp dễ dàng cập nhật thông tin cá nhân. 
- Bổ sung trang `/posts` để liệt kê tất cả các bài viết, giúp người đọc dễ dàng tìm kiếm và truy cập nội dung.
- Tạo script `scripts/gen_all_posts.sh` để tự động hóa việc tạo danh sách tất cả các bài viết.
- Cập nhật `Makefile` để tích hợp việc tạo và xây dựng trang `/posts` vào quy trình làm việc chung.
- Cập nhật script `scripts/gen_latest_posts.sh` để lấy các bài viết mới nhất từ cấu trúc thư mục lồng nhau, đảm bảo danh sách luôn chính xác.
- Bổ sung tính năng hiển thị ngày tháng của bài viết, được trích xuất từ đường dẫn file, giúp người đọc dễ dàng xác định thời gian đăng bài. 