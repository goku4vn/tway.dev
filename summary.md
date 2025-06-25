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
- Thêm liên kết "View all posts" ở cuối danh sách "Latest Posts" để người đọc có thể dễ dàng xem toàn bộ bài viết.

# 2024-06-26

- Đã kiểm tra Makefile và scripts/gen_all_posts.sh.
- Script gen_all_posts.sh đã sort -r các file markdown theo ngày (dựa vào cấu trúc YYYY/MM/DD), đảm bảo bài viết mới nhất luôn ở đầu danh sách khi build ra posts/index.generated.md và dist/posts/index.html.
- Makefile đã đúng khi gọi script này để build danh sách bài viết.
- Không cần chỉnh gì thêm, hệ thống đã đáp ứng đúng yêu cầu sắp xếp bài viết theo ngày mới nhất lên đầu.

# 2024-06-26 (bổ sung)

- Đã cập nhật scripts/gen_latest_posts.sh và scripts/gen_all_posts.sh:
  - Thêm bước loại bỏ dấu quote ở đầu/cuối cho title và subtitle (nếu có) khi render HTML.
  - Đảm bảo khi hiển thị ra HTML sẽ không còn dấu quote dư thừa ở hai field này.

Yêu cầu của daddy đã được xử lý xong! :)

## 2024-06-26 (tiếp)

### Đã sửa script:
- `scripts/gen_all_posts.sh`
- `scripts/gen_latest_posts.sh`

**Nội dung:**
- Các bài viết giờ sẽ được sort theo ngày (YYYY-MM-DD) giảm dần, bài mới nhất luôn ở đầu danh sách.
- Áp dụng cho cả All Posts và Latest Posts.

Daddy chỉ cần chạy lại các script này là danh sách sẽ luôn đúng thứ tự ngày tháng nhé! ❤️

## 2024-06-26

### Đã cập nhật hai file workflow:
- `.github/workflows/sync-r2-md.yml`
- `.github/workflows/static.yml`

**Thêm bước gửi thông báo Telegram khi job thành công hoặc thất bại.**
- Sử dụng biến secrets: `TELEGRAM_BOT_TOKEN` và `TELEGRAM_CHAT_ID`.
- Gửi thông báo qua API Telegram Bot.

---

### Hướng dẫn lấy chat_id của group Telegram qua API

1. Tạo bot Telegram qua BotFather, lấy token.
2. Thêm bot vào group cần lấy chat_id.
3. Gửi một tin nhắn bất kỳ vào group.
4. Truy cập đường dẫn sau (thay TOKEN bằng token bot):

```
https://api.telegram.org/bot<TOKEN>/getUpdates
```

5. Tìm trong kết quả trả về, sẽ thấy đoạn:

```json
"chat": { "id": -100xxxxxxxxxx, ... }
```

- Số `id` này chính là chat_id của group (thường bắt đầu bằng dấu `-100`).

---

Nếu cần hướng dẫn chi tiết hơn, daddy cứ hỏi baby nhé! ❤️ 

# Tóm tắt các thay đổi

## 2024-03-26
- Thêm hàm `esc` vào file `test.sh` để escape các ký tự đặc biệt trong Markdown
- Sử dụng hàm `esc` để escape message trước khi in ra
- Các ký tự được escape bao gồm: `_ * [ ] ( ) ~ ` > # + - = | { } . ! /`

- Cập nhật file `.github/workflows/static.yml`:
  - Gộp 2 step thông báo Success và Failure thành 1
  - Thêm biến môi trường `STATUS`
  - Cải thiện format message thông báo:
    + Emoji status (✅/❌)
    + Thông tin job và workflow
    + Link tới repository
    + Link xem chi tiết build
  - Sử dụng hàm `esc` để escape message

- Tối ưu hàm `esc`:
  - Sử dụng character class `[...]` để gộp các ký tự cần escape
  - Giảm từ 18 lần thay thế xuống còn 1 lần
  - Code ngắn gọn và dễ bảo trì hơn
  - Thêm escape ký tự `/` để xử lý đúng tên repository
  - Chỉ escape text, không escape URL

- Cải thiện format message:
  - Sử dụng multi-line string trong `test.sh`
  - Tạo message từng dòng và nối bằng `$'\n'` trong `.github/workflows/static.yml` để tương thích với YAML 

## Telegram Tips & Tricks

### Ngăn chặn URL Preview trong Telegram

Có một số cách để ngăn Telegram hiển thị preview URL:

1. Sử dụng thẻ `<nopreview>`:
```
<nopreview>https://your-url.com</nopreview>
```

2. Thêm kí tự Zero Width Space (‌) vào giữa URL:
```
https://your-url.com‌
```

3. Sử dụng Markdown để format URL:
```
`https://your-url.com`
```

4. Sử dụng HTML entity cho dấu chấm:
```
https://your-url&#46;com
``` 

### Ví dụ sử dụng trong GitHub Actions

Để ngăn preview URL trong tin nhắn Telegram từ GitHub Actions workflow:

```yaml
# Construct message
MESSAGE="\\- Repository: [${REPO_TEXT}](<nopreview>${REPO_URL}</nopreview>)"$'\n'
MESSAGE="${MESSAGE}\\- [${VIEW_MORE}](<nopreview>${ACTION_URL}</nopreview>)"
```

Lưu ý: Cần escape các ký tự đặc biệt trong message bằng `\\` khi sử dụng với MarkdownV2. 