<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DangNhap.aspx.cs" Inherits="web_ban_giay.DangNhap" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Đăng nhập - Toko</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
</head>
<body>
  <header class="tieu_de">
      <!-- Nếu chưa đăng nhập -->
<asp:Panel ID="pnlChuaDangNhap" runat="server">
  <a class="nut_dang_nhap" href="DangNhap.aspx">Đăng nhập</a>
</asp:Panel>

<!-- Nếu đã đăng nhập -->
<asp:Panel ID="pnlDaDangNhap" runat="server" Visible="false">
  <asp:Label ID="Label1" runat="server" CssClass="ten_tk" />
  <a class="nut_ho_so" href="HoSo.aspx">Hồ sơ</a>
  <asp:Button ID="Button1" runat="server" Text="Đăng xuất" CssClass="nut_dang_xuat" OnClick="btnDangXuat_Click" />
</asp:Panel>
    <div class="tieu_de_noi_dung">
      <a class="logo_chu" href="index.aspx" title="Về trang chủ">
        <img src="assets/logo/toko.svg" alt="Toko" />
        <div class="ten_web">Toko</div>
      </a>
      <div class="khung_tim">
        <input id="o_tim_kiem" class="o_tim" placeholder="Tìm giày, hãng…" />
        <button id="nut_tim_kiem" class="nut_tim">Tìm</button>
      </div>
      <div class="khu_tai_khoan">
  <asp:Panel ID="pnlDangNhap" runat="server">
    <a class="nut_dang_nhap" href="DangNhap.aspx">Đăng nhập</a>
  </asp:Panel>

  <asp:Panel ID="pnlTaiKhoan" runat="server" Visible="false">
    <img src="assets/icon/avatar.png" alt="Avatar" class="avatar" style="width:32px;height:32px;border-radius:50%;vertical-align:middle;" />
    <asp:Label ID="lblEmail" runat="server" CssClass="ten_tk" />
    <a class="nut_ho_so" href="HoSo.aspx">Hồ sơ</a>
    <asp:Button ID="btnDangXuat" runat="server" Text="Đăng xuất" CssClass="nut_dang_xuat" OnClick="btnDangXuat_Click" />
  </asp:Panel>
        <a class="icon_gio_hang" href="javascript:void(0);" onclick="kiemTraDangNhap()" title="Giỏ hàng">
  🛒 <span class="so_luong" id="so_gio_hang">0</span>
</a>

      </div>
    </div>
  </header>

  <form id="form1" runat="server" defaultbutton="btnDangNhap">
    <main class="khung_form">
      <h2>Đăng nhập</h2>

      <div class="nhom_form">
        <label><input type="radio" name="vai_tro" value="khach" checked runat="server" id="rdoKhach"> Đăng nhập khách</label>
        <label><input type="radio" name="vai_tro" value="admin" runat="server" id="rdoAdmin"> Đăng nhập admin</label>
      </div>

      <div class="nhom_form">
        <label>Email</label>
        <asp:TextBox ID="txtEmail" ClientIDMode="Static" runat="server" CssClass="o_nhap" TextMode="Email" placeholder="email@vi.du" />
        <label>Mật khẩu</label>
        <asp:TextBox ID="txtMatKhau" ClientIDMode="Static" runat="server" CssClass="o_nhap" TextMode="Password" placeholder="Mật khẩu" />
      </div>

      <asp:Button ID="btnDangNhap" runat="server"
                  CssClass="nut_chinh"
                  Text="Đăng nhập"
                  OnClick="btnDangNhap_Click" />

      <asp:Label ID="lblThongBao" runat="server" CssClass="thong_bao" ForeColor="Red" />

      <div class="nho">Chưa có tài khoản? <a href="DangKy.aspx">Đăng ký khách</a></div>
    </main>
  </form>

  <script src="js/du_lieu.js"></script>
  <script src="js/xac_thuc.js"></script>
    <script>
function kiemTraDangNhap() {
    fetch('KiemTraDangNhap.aspx')
        .then(res => res.json())
        .then(data => {
            if (data.isLoggedIn) {
                window.location.href = "GioHang.aspx";
            } else {
                alert("Vui lòng đăng nhập để thêm vào giỏ hàng!");
                setTimeout(() => {
                    window.location.href = "DangNhap.aspx";
                }, 800);
            }
        })
        .catch(() => {
            alert("Không thể kết nối đến máy chủ!");
        });
}
    </script>
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const btn = document.getElementById("nut_tim_kiem");
            const input = document.getElementById("o_tim_kiem");
            if (btn && input) {
                btn.addEventListener("click", () => {
                    const tuKhoa = input.value.trim();
                    if (tuKhoa) {
                        // chuyển sang Index.aspx với query string
                        window.location.href = "Index.aspx?search=" + encodeURIComponent(tuKhoa);
                    }
                });

                // bấm Enter cũng search
                input.addEventListener("keypress", e => {
                    if (e.key === "Enter") {
                        e.preventDefault();
                        btn.click();
                    }
                });
            }
        });
    </script>

</body>
</html>
