using System;
using System.Data;
using System.Web.UI.WebControls;

namespace web_ban_giay
{
    public partial class GioHang : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["TaiKhoan"] == null)
            {
                string script = "alert('Vui lòng đăng nhập để xem giỏ hàng!');" +
                                "setTimeout(function(){ window.location='DangNhap.aspx'; }, 800);";
                ClientScript.RegisterStartupScript(this.GetType(), "loginAlert", script, true);
                return;
            }

            if (!IsPostBack)
            {
                
                pnlDaDangNhap.Visible = true;
                pnlChuaDangNhap.Visible = false;
                lblEmail.Text = Session["TaiKhoan"].ToString();

                
            }
        }


        private void HienThiGioHang()
        {
            DataTable gio = Session["GioHang"] as DataTable;
            if (gio == null || gio.Rows.Count == 0)
            {
                pnlRong.Visible = true;
                gvGioHang.Visible = false;
                lblTong.Text = "0";
                return;
            }

            gvGioHang.DataSource = gio;
            gvGioHang.DataBind();

          
            decimal tong = 0;
            foreach (DataRow row in gio.Rows)
            {
                string giaStr = row["Gia"].ToString().Replace(" VND", "").Replace(",", "").Trim();
                if (decimal.TryParse(giaStr, out decimal gia))
                    tong += gia * Convert.ToInt32(row["SoLuong"]);
            }
            lblTong.Text = tong.ToString("N0");
        }

        protected void gvGioHang_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Xoa")
            {
                string[] parts = e.CommandArgument.ToString().Split('|');
                string id = parts[0];
                string size = parts[1];

                DataTable gio = Session["GioHang"] as DataTable;
                if (gio != null)
                {
                    foreach (DataRow row in gio.Select($"Id='{id}' AND Size='{size}'"))
                        gio.Rows.Remove(row);
                    gio.AcceptChanges();
                    Session["GioHang"] = gio;
                }

                HienThiGioHang();
            }
        }

        protected void btnThanhToan_Click(object sender, EventArgs e)
        {
            if (Session["GioHang"] == null || ((DataTable)Session["GioHang"]).Rows.Count == 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Giỏ hàng trống, không thể thanh toán!');", true);
                return;
            }

            // giả lập thanh toán
            Session["GioHang"] = null;
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "alert('Thanh toán thành công! Cảm ơn bạn đã mua hàng ❤️'); window.location='Index.aspx';", true);
        }

        protected void btnTim_Click(object sender, EventArgs e)
        {
            string tuKhoa = txtTimKiem.Text.Trim();
            if (!string.IsNullOrEmpty(tuKhoa))
                Response.Redirect("Index.aspx?search=" + tuKhoa);
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Index.aspx");
        }
    }
}
