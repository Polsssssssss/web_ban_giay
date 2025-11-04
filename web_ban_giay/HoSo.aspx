<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HoSo.aspx.cs" Inherits="web_ban_giay.HoSo" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <title>Hồ sơ cá nhân - Toko</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
  <style>
    body { background: #000; color: #fff; font-family: Segoe UI, sans-serif; }
    .khung_form {
      max-width: 600px; margin: 40px auto; background: #141414;
      padding: 24px; border-radius: 12px; border: 1px solid #333;
    }
    .khung_form h2 { text-align: center; margin-bottom: 20px; }
    .o_nhap {
      width: 100%; padding: 8px; border: 1px solid #444;
      border-radius: 6px; background: #1c1c1c; color: #fff;
    }
    .nut_chinh {
      background: #E30613; color: #fff; border: none;
      padding: 10px 16px; border-radius: 6px; font-weight: bold; cursor: pointer;
    }
    .nut_chinh:hover { background: #ff1c22; }
    .nut_phu {
      background: #333; color: #fff; border: 1px solid #555;
      padding: 8px 14px; border-radius: 6px; cursor: pointer;
    }
    .nut_phu:hover { background: #444; }
    .anh_dai_dien {
      display: block; margin: 0 auto 10px; width: 100px;
      height: 100px; border-radius: 50%; object-fit: cover;
      border: 2px solid #444;
    }
    hr { margin: 30px 0; border-color: #333; }
    label { font-weight: 600; margin-top: 10px; display: block; }
  </style>
</head>
<body>
  <form id="form1" runat="server">

    <!-- HEADER -->
    <header class="tieu_de">
      <div class="tieu_de_noi_dung">
        <a class="logo_chu" href="Index.aspx">
          <img src="assets/logo/toko.svg" alt="Toko">
          <div class="ten_web">Toko</div>
        </a>

        <div class="khung_tim">
          <asp:TextBox ID="txtTimKiem" runat="server" CssClass="o_tim" Placeholder="Tìm giày, hãng…" />
          <asp:Button ID="btnTim" runat="server" Text="Tìm" CssClass="nut_tim" OnClick="btnTim_Click" />
        </div>

        <div class="khu_tai_khoan">
          <!-- Nếu chưa đăng nhập -->
          <asp:Panel ID="pnlChuaDangNhap" runat="server">
            <a class="nut_dang_nhap" href="DangNhap.aspx">Đăng nhập</a>
          </asp:Panel>

          <!-- Nếu đã đăng nhập -->
          <asp:Panel ID="pnlDaDangNhap" runat="server" Visible="false">
            <asp:Label ID="lblEmail" runat="server" CssClass="ten_tk" />
            <a class="nut_ho_so" href="HoSo.aspx">Hồ sơ</a>
            <asp:Button ID="btnDangXuat" runat="server" Text="Đăng xuất"
                        CssClass="nut_dang_xuat" OnClick="btnDangXuat_Click" />
          </asp:Panel>

          <a class="icon_gio_hang" href="GioHang.aspx" title="Giỏ hàng">
            🛒 <span class="so_luong" id="so_gio_hang">0</span>
          </a>
        </div>
      </div>
    </header>

    <!-- HỒ SƠ -->
    <main class="khung_form">
      <h2>Hồ sơ cá nhân</h2>

      <!-- ẢNH ĐẠI DIỆN -->
      <asp:Image ID="imgAvatar" runat="server" CssClass="anh_dai_dien"
                 ImageUrl="assets/avatar/default.jpg" />
      <asp:FileUpload ID="uploadAvatar" runat="server" CssClass="chon_anh" Visible="false" />
      <asp:Button ID="btnDoiAnh" runat="server" Text="Đổi ảnh đại diện"
                  CssClass="nut_phu" OnClick="btnDoiAnh_Click" />

      <!-- CHẾ ĐỘ XEM -->
      <asp:Panel ID="pnlThongTin" runat="server">
        <p><b>Họ và tên:</b> <asp:Label ID="lblHoTen" runat="server" /></p>
        <p><b>Email:</b> <asp:Label ID="lblEmailHienThi" runat="server" /></p>
        <p><b>Số điện thoại:</b> <asp:Label ID="lblSDT" runat="server" /></p>
        <p><b>Địa chỉ:</b> <asp:Label ID="lblDiaChi" runat="server" /></p>
        <asp:Button ID="btnChinhSua" runat="server" Text="Chỉnh sửa"
                    CssClass="nut_chinh" OnClick="btnChinhSua_Click" />
      </asp:Panel>

      <!-- CHẾ ĐỘ SỬA -->
      <asp:Panel ID="pnlSuaThongTin" runat="server" Visible="false">
        <label>Họ và tên</label>
        <asp:TextBox ID="txtHoTen" runat="server" CssClass="o_nhap" />
        <label>Số điện thoại</label>
        <asp:TextBox ID="txtSDT" runat="server" CssClass="o_nhap" />
        <label>Địa chỉ</label>
        <asp:TextBox ID="txtDiaChi" runat="server" CssClass="o_nhap" />
        <asp:Button ID="btnLuuThongTin" runat="server" Text="Lưu thông tin"
                    CssClass="nut_chinh" OnClick="btnLuuThongTin_Click" />
      </asp:Panel>

      <hr />

      <!-- ĐỔI MẬT KHẨU -->
      <h3>Đổi mật khẩu</h3>
      <asp:Panel ID="pnlDoiMK" runat="server">
        <label>Mật khẩu mới</label>
        <asp:TextBox ID="txtMatKhauMoi" runat="server"
                     CssClass="o_nhap" TextMode="Password" />
        <asp:Button ID="btnDoiMatKhau" runat="server" Text="Đổi mật khẩu"
                    CssClass="nut_phu" OnClick="btnDoiMatKhau_Click" />
      </asp:Panel>
    </main>

  </form>
</body>
</html>
