# Tóm tắt thay đổi

- Thay phần Latest Posts trong demo/index.md thành <!--LATEST_POSTS--> để tự động chèn danh sách bài viết.
- Thêm script shell scripts/gen_latest_posts.sh để sinh file demo/index.generated.md từ demo/index.md và danh sách bài viết trong posts/.
- Sửa Makefile để build từ demo/index.generated.md thay vì index.md, và thêm bước generate file này trước khi build. 