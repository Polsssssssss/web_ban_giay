<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GioHang.aspx.cs" Inherits="web_ban_giay.GioHang" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <title>Giỏ hàng - Toko</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
  <style>
    main {
      color: #fff;
      padding: 20px;
      max-width: 900px;
      margin: auto;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: #141414;
      border-radius: 10px;
      overflow: hidden;
    }

    th, td {
      padding: 12px;
      text-align: center;
      border-bottom: 1px solid #333;
    }

    th {
      background: #222;
      font-weight: bold;
    }

    img {
      width: 80px;
      height: 80px;
      border-radius: 8px;
      object-fit: cover;
    }

    .nut {
      background: #E30613;
      color: white;
      padding: 6px 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
    }

    .nut:hover {
      background: #ff1a20;
    }

    .tong {
      text-align: right;
      margin-top: 20px;
      font-size: 18px;
      font-weight: bold;
    }

    .rong {
      text-align: center;
      padding: 60px 0;
      font-size: 20px;
      color: #aaa;
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

    <!-- NỘI DUNG -->
    <main>
      <h2>🛍️ Giỏ hàng của bạn</h2>
      <asp:Panel ID="pnlRong" runat="server" CssClass="rong" Visible="false">
        Giỏ hàng trống. <a href="Index.aspx" style="color:#E30613;text-decoration:none;">Tiếp tục mua sắm</a>
      </asp:Panel>

      <asp:GridView ID="gvGioHang" runat="server" AutoGenerateColumns="False" CssClass="bang_giohang" OnRowCommand="gvGioHang_RowCommand">
        <Columns>
          <asp:TemplateField HeaderText="Ảnh">
            <ItemTemplate>
              <img src='<%# Eval("Anh") %>' alt="Giày" />
            </ItemTemplate>
          </asp:TemplateField>

          <asp:BoundField DataField="Ten" HeaderText="Tên giày" />
          <asp:BoundField DataField="Size" HeaderText="Size" />
          <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" />
          <asp:BoundField DataField="Gia" HeaderText="Giá" />

          <asp:TemplateField HeaderText="Thao tác">
            <ItemTemplate>
              <asp:Button runat="server" Text="Xóa" CommandName="Xoa" CommandArgument='<%# Eval("Id") + "|" + Eval("Size") %>' CssClass="nut" />
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>
      </asp:GridView>

      <div class="tong">
        Tổng tiền: <asp:Label ID="lblTong" runat="server" Text="0" /> VND
      </div>

      <div style="text-align:right;margin-top:20px;">
        <asp:Button ID="btnThanhToan" runat="server" Text="Tiến hành thanh toán" CssClass="nut" OnClick="btnThanhToan_Click" />
      </div>
    </main>
  </form>
</body>
</html>
