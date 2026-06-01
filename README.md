# SWP391 — HRM System (Task 1: Authentication)

Dự án Java Servlet (Jakarta EE 10) — đăng nhập, Google OAuth, logout, đổi mật khẩu, quên mật khẩu.

## Yêu cầu

- JDK **11+**
- Maven 3.6+
- MySQL 8+
- Tomcat **10+** (hoặc dùng plugin Maven bên dưới)

## Thiết lập

### 1. Database

```sql
-- Chạy file trong MySQL Workbench hoặc CLI
source sql/schema_task1.sql
```

Tài khoản mẫu sau khi chạy script:

| Email | Mật khẩu |
|-------|----------|
| `admin@hrm.local` | `Admin123!` |

### 2. Cấu hình

Copy các file `.example` → bỏ đuôi `.example` (quan trọng: **`db.properties` phải khớp MySQL trên máy bạn**):

```text
src/main/resources/db.properties.example  →  db.properties
```

Ví dụ (MySQL local mặc định):

```properties
db.url=jdbc:mysql://localhost:3306/hrm?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.user=root
db.password=mysql
```

> **Lưu ý:** Nếu deploy lên Tomcat, sau khi sửa `db.properties` cần **restart Tomcat** (class `DBContext` load config một lần khi khởi động). Đồng bộ file vào `webapps/swp391/WEB-INF/classes/db.properties` hoặc deploy lại WAR.

Nếu đã chạy `schema_task1.sql` trước đó mà vẫn không đăng nhập được, chạy thêm:

```sql
source sql/fix_admin_password.sql
```

### 3. Build

```bash
mvn clean package
```

WAR output: `target/swp391.war`

### 4. Chạy

**Quan trọng — deploy lại sau mỗi lần sửa code:**

1. `mvn clean package`
2. Xóa thư mục cũ: `TOMCAT/webapps/swp391` và file `swp391.war` cũ
3. Copy `target/swp391.war` vào `TOMCAT/webapps/`
4. Khởi động Tomcat, đợi giải nén xong
5. Truy cập: `http://localhost:8080/swp391/login`

**Cách A — Tomcat:** deploy `target/swp391.war` như trên.

**Cách B — Maven plugin:**

```bash
mvn clean package tomcat10:run
```

## Endpoints

| Chức năng | URL |
|-----------|-----|
| Login | `/login` |
| Logout | `/logout` |
| Dashboard | `/dashboard` |
| Change password | `/changepassword` |
| Forgot password | `/forgetpassword` |
| Reset password | `/recovery?token=...` |

Chi tiết OAuth / SMTP: [docs/AUTH_SETUP.md](docs/AUTH_SETUP.md)
