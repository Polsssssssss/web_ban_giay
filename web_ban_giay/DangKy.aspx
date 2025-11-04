<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DangKy.aspx.cs" Inherits="web_ban_giay.DangKy" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Đăng ký - Toko</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
</head>
<body>
  <form id="form1" runat="server">
  
    <header class="tieu_de">
       
<asp:Panel ID="pnlChuaDangNhap" runat="server">
  <a class="nut_dang_nhap" href="DangNhap.aspx">Đăng nhập</a>
</asp:Panel>


<asp:Panel ID="pnlDaDangNhap" runat="server" Visible="false">
  <asp:Label ID="Label1" runat="server" CssClass="ten_tk" />
  <a class="nut_ho_so" href="HoSo.aspx">Hồ sơ</a>
  <asp:Button ID="Button1" runat="server" Text="Đăng xuất" CssClass="nut_dang_xuat" OnClick="btnDangXuat_Click" />
</asp:Panel>
      <div class="tieu_de_noi_dung">
        <a class="logo_chu" href="Index.aspx">
          <img src="assets/logo/toko.svg" alt="Toko" />
          <div class="ten_web">Toko</div>
        </a>

        <div class="khung_tim">
          <asp:TextBox ID="txtTimKiem" runat="server" CssClass="o_tim" Placeholder="Tìm giày, hãng…" />
          <asp:Button ID="btnTim" runat="server" Text="Tìm" CssClass="nut_tim" OnClick="btnTim_Click" />
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

          <a class="icon_gio_hang" href="GioHang.aspx" title="Giỏ hàng">
            🛒 <span class="so_luong" id="so_gio_hang">0</span>
          </a>
        </div>
      </div>
    </header>

    
    <main class="khung_form">
      <h2>Đăng ký tài khoản</h2>
      <div class="nhom_form">
        <label>Họ và tên</label>
        <asp:TextBox ID="txtHoTen" runat="server" CssClass="o_nhap" Placeholder="Nhập họ tên" />

        <label>Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="o_nhap" TextMode="Email" Placeholder="email@vi.du" />

        <label>Mật khẩu</label>
        <asp:TextBox ID="txtMatKhau" runat="server" CssClass="o_nhap" TextMode="Password" Placeholder="Mật khẩu" />

        <label>Nhập lại mật khẩu</label>
        <asp:TextBox ID="txtMatKhau2" runat="server" CssClass="o_nhap" TextMode="Password" Placeholder="Nhập lại mật khẩu" />

        <asp:Button ID="btnDangKy" runat="server" CssClass="nut_chinh" Text="Đăng ký" OnClick="btnDangKy_Click" />
        <asp:Label ID="lblThongBao" runat="server" CssClass="thong_bao" />
      </div>

      <div class="nho">Đã có tài khoản? <a href="DangNhap.aspx">Đăng nhập</a></div>
    </main>
  </form>
</body>
</html>
