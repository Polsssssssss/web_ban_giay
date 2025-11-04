<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="web_ban_giay.Index" %>
<!DOCTYPE html>
<html lang="vi">
<head runat="server">
  <meta charset="utf-8" />
  <title>Toko - Trang chủ</title>
  <link rel="stylesheet" href="css/kieu_dang.css" />
  <style>
    /* ----- Bố cục tổng thể ----- */
    .khung_trang {
      display: grid;
      grid-template-columns: 260px 1fr;
      gap: 20px;
      padding: 16px;
    }

    /* ----- Sidebar hãng giày ----- */
    .muc_trai {
      background: #141414;
      border-radius: 12px;
      padding: 12px;
    }

    .muc_trai h3 {
      margin-bottom: 10px;
      color: #fff;
    }

    .hang-checkbox-list {
      display: flex;
      flex-direction: column;
      gap: 6px;
      background: #111;
      padding: 10px 14px;
      border-radius: 10px;
      border: 1px solid #333;
    }

    .hang-checkbox-list span {
      display: flex;
      align-items: center;
      gap: 8px;
      color: #eee;
      font-size: 15px;
      cursor: pointer;
    }

    .hang-checkbox-list input[type="checkbox"] {
      width: 16px;
      height: 16px;
    }

    /* ----- Lưới sản phẩm ----- */
    .luoi_giay {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 16px;
    }

    .the_giay {
      background: #141414;
      border-radius: 12px;
      overflow: hidden;
      border: 1px solid #2a2a2a;
      transition: transform 0.2s ease;
    }

    .the_giay:hover {
      transform: translateY(-4px);
      border-color: #e30613;
    }

    .the_giay img {
      width: 100%;
      height: 180px;
      object-fit: cover;
      display: block;
    }

    .thong_tin_giay {
      padding: 10px;
    }

    .ten_giay {
      font-weight: 700;
      margin: 4px 0;
    }

    .hang_giay {
      opacity: 0.7;
      font-size: 14px;
    }

    .gia_tien {
      font-weight: 800;
      margin-top: 6px;
      color: #e30613;
    }

    .nut_nhom {
      display: flex;
      gap: 8px;
      margin-top: 10px;
    }

    .nut_chi_tiet {
      display: inline-block;
      padding: 6px 10px;
      border: 1px solid #333;
      border-radius: 6px;
      text-decoration: none;
      color: #fff;
      background: #222;
      font-size: 14px;
    }

    .nut_chi_tiet:hover {
      background: #e30613;
      border-color: #e30613;
    }

    /* ----- Phân trang ----- */
    .phan_trang {
      margin-top: 18px;
      display: flex;
      gap: 8px;
    }

    .phan_trang a, .phan_trang span {
      padding: 6px 10px;
      border: 1px solid #333;
      border-radius: 6px;
      text-decoration: none;
      color: #fff;
    }

    .phan_trang .active {
      background: #e30613;
      border-color: #e30613;
      color: #fff;
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
        <a class="icon_gio_hang" href="javascript:void(0);" onclick="kiemTraDangNhap()" title="Giỏ hàng">
  🛒 <span class="so_luong" id="so_gio_hang">0</span>
</a>

      </div>
    </div>
  </header>

  <!-- MAIN -->
  <main class="khung_trang">
    <!-- SIDEBAR LỌC HÃNG -->
    <aside class="muc_trai">
      <h3>Hãng giày</h3>
      <asp:CheckBoxList ID="cblHang"
                        runat="server"
                        RepeatDirection="Vertical"
                        RepeatLayout="Flow"
                        CssClass="hang-checkbox-list" />

      <div style="margin-top:10px; display:flex; gap:8px;">
        <asp:Button ID="btnApDungLoc" runat="server" Text="Áp dụng lọc" OnClick="btnApDungLoc_Click" />
        <asp:Button ID="btnXoaLoc" runat="server" Text="Xóa lọc" OnClick="btnXoaLoc_Click" />
      </div>
    </aside>

    <!-- LƯỚI SẢN PHẨM -->
    <section>
      <div class="luoi_giay">
        <asp:Repeater ID="rptGiay" runat="server">
          <ItemTemplate>
            <div class="the_giay">
              <img src='<%# ResolveUrl(Eval("Anh").ToString()) %>' alt='<%# Eval("Ten") %>' />
              <div class="thong_tin_giay">
                <div class="ten_giay"><%# Eval("Ten") %></div>
                <div class="hang_giay"><%# Eval("Hang") %></div>
                <div class="gia_tien"><%# String.Format("{0:N0} VND", Eval("GiaTien")) %></div>
                <div class="nut_nhom">
                  <a class="nut_chi_tiet" href='ChiTiet.aspx?id=<%# Eval("Id") %>'>👁 Xem chi tiết</a>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>
      </div>

      <!-- PHÂN TRANG (tùy chọn, nếu cần) -->
      <div class="phan_trang">
        <asp:Literal ID="litPaging" runat="server" />
      </div>
    </section>
  </main>

</form>
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
</body>
</html>
