using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace web_ban_giay
{
    public partial class ChiTiet : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["TokoDBConnectionString"].ConnectionString;
        static string idGiay;

        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (Session["TaiKhoan"] != null)
            {
                pnlDaDangNhap.Visible = true;
                pnlChuaDangNhap.Visible = false;
                lblEmail.Text = Session["TaiKhoan"].ToString();
            }
            else
            {
                pnlDaDangNhap.Visible = false;
                pnlChuaDangNhap.Visible = true;
            }

            idGiay = Request.QueryString["id"];
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(idGiay))
                    LoadChiTiet();
            }

           
            TaoDanhSachSize();
        }

        private void LoadChiTiet()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Giay WHERE Id = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", idGiay);
                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                if (rd.Read())
                {
                    lblTen.Text = rd["Ten"].ToString();
                    lblHang.Text = rd["Hang"].ToString();
                    lblGia.Text = Convert.ToDecimal(rd["GiaTien"]).ToString("N0") + " VND";
                    lblMoTa.Text = rd["MoTa"].ToString();
                    imgGiay.ImageUrl = rd["Anh"].ToString();
                }
            }
        }

        private void TaoDanhSachSize()
        {
            phSize.Controls.Clear();
            for (int size = 36; size <= 46; size++)
            {
                Button btn = new Button();
                btn.Text = size.ToString();
                btn.CssClass = "nut_size";
                btn.CommandArgument = size.ToString();
                btn.Click += BtnSize_Click;

             
                if (ViewState["SizeChon"] != null && ViewState["SizeChon"].ToString() == size.ToString())
                    btn.Style["background"] = "#E30613";
                else
                    btn.Style["background"] = "#222";

                phSize.Controls.Add(btn);
            }
        }

        private void BtnSize_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            ViewState["SizeChon"] = btn.CommandArgument;
            TaoDanhSachSize();
        }

        protected void btnThemGio_Click(object sender, EventArgs e)
        {
            if (ViewState["SizeChon"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng chọn size trước!');", true);
                return;
            }

            if (Session["TaiKhoan"] == null)
            {
                string script = "alert('Vui lòng đăng nhập để thêm vào giỏ hàng!');" +
                                "setTimeout(function(){ window.location='DangNhap.aspx'; }, 800);";
                ClientScript.RegisterStartupScript(this.GetType(), "loginAlert", script, true);
                return;
            }

            string size = ViewState["SizeChon"].ToString();
            string id = idGiay;
            string ten = lblTen.Text;
            string gia = lblGia.Text;
            string anh = imgGiay.ImageUrl;

            var gio = Session["GioHang"] as System.Data.DataTable;
            if (gio == null)
            {
                gio = new System.Data.DataTable();
                gio.Columns.Add("Id");
                gio.Columns.Add("Ten");
                gio.Columns.Add("Gia");
                gio.Columns.Add("Anh");
                gio.Columns.Add("Size");
                gio.Columns.Add("SoLuong", typeof(int));
            }

            var rows = gio.Select($"Id='{id}' AND Size='{size}'");
            if (rows.Length > 0)
                rows[0]["SoLuong"] = (int)rows[0]["SoLuong"] + 1;
            else
            {
                var r = gio.NewRow();
                r["Id"] = id;
                r["Ten"] = ten;
                r["Gia"] = gia;
                r["Anh"] = anh;
                r["Size"] = size;
                r["SoLuong"] = 1;
                gio.Rows.Add(r);
            }

            Session["GioHang"] = gio;
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                $"alert('Đã thêm {ten} (size {size}) vào giỏ hàng!');", true);
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
