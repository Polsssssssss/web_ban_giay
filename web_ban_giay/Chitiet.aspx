<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChiTiet.aspx.cs" Inherits="web_ban_giay.ChiTiet" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Chi tiết giày - Toko</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
  <style>
    .khung_chi_tiet {
      display: grid;
      grid-template-columns: 340px 1fr;
      gap: 24px;
      margin: 24px;
      color: #fff;
    }

    .nut_size {
      padding: 6px 10px;
      margin: 4px;
      background: #222;
      color: #fff;
      border: 1px solid #444;
      border-radius: 6px;
      cursor: pointer;
    }

    .nut_size:hover {
      background: #E30613;
    }

    .nut_chinh {
      padding: 10px 16px;
      margin-top: 12px;
      background: #E30613;
      border: none;
      color: white;
      font-weight: bold;
      border-radius: 6px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <!-- HEADER -->
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

    <!-- NỘI DUNG CHI TIẾT -->
    <main class="khung_chi_tiet">
      <asp:Image ID="imgGiay" runat="server" Width="100%" Style="border-radius:12px; height:auto;" />

      <div>
        <h2><asp:Label ID="lblTen" runat="server" /></h2>
        <div>Hãng: <strong><asp:Label ID="lblHang" runat="server" /></strong></div>
        <div style="margin:6px 0;">
          <asp:Label ID="lblGia" runat="server" CssClass="gia_tien" />
        </div>
        <p><asp:Label ID="lblMoTa" runat="server" /></p>

        <div style="margin-top:16px;">
          <label><strong>Chọn size:</strong></label>
          <asp:PlaceHolder ID="phSize" runat="server" />
        </div>

        <asp:Button ID="btnThemGio" runat="server" Text="🛒 Thêm vào giỏ hàng" CssClass="nut_chinh" OnClick="btnThemGio_Click" />
      </div>
    </main>
  </form>
</body>
</html>
