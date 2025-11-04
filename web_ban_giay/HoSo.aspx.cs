using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace web_ban_giay
{
    public partial class HoSo : System.Web.UI.Page
    {
        string connStr = WebConfigurationManager.ConnectionStrings["TokoDBConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (Session["TaiKhoan"] == null)
            {
                string script = "alert('Vui lòng đăng nhập để xem hồ sơ!');" +
                                "setTimeout(function(){ window.location='DangNhap.aspx'; }, 800);";
                ClientScript.RegisterStartupScript(this.GetType(), "loginAlert", script, true);
                return;
            }

            if (!IsPostBack)
            {
                pnlDaDangNhap.Visible = true;
                pnlChuaDangNhap.Visible = false;
                lblEmail.Text = Session["TaiKhoan"].ToString();

                LoadThongTin();
            }
        }


        private void LoadThongTin()
        {
            string email = Session["TaiKhoan"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT HoTen, Email, SDT, DiaChi, ISNULL(Anh, 'assets/avatar/default.jpg') AS Anh FROM TaiKhoan WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                SqlDataReader rd = cmd.ExecuteReader();
                if (rd.Read())
                {
                    lblHoTen.Text = rd["HoTen"].ToString();
                    lblEmailHienThi.Text = rd["Email"].ToString();
                    lblSDT.Text = rd["SDT"].ToString();
                    lblDiaChi.Text = rd["DiaChi"].ToString();
                    imgAvatar.ImageUrl = rd["Anh"].ToString();
                }
            }
        }

        protected void btnChinhSua_Click(object sender, EventArgs e)
        {
            pnlThongTin.Visible = false;
            pnlSuaThongTin.Visible = true;

            
            txtHoTen.Text = lblHoTen.Text;
            txtSDT.Text = lblSDT.Text;
            txtDiaChi.Text = lblDiaChi.Text;
        }

        protected void btnLuuThongTin_Click(object sender, EventArgs e)
        {
            string email = Session["TaiKhoan"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE TaiKhoan SET HoTen=@HoTen, SDT=@SDT, DiaChi=@DiaChi WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@HoTen", txtHoTen.Text.Trim());
                cmd.Parameters.AddWithValue("@SDT", txtSDT.Text.Trim());
                cmd.Parameters.AddWithValue("@DiaChi", txtDiaChi.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", email);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            
            lblHoTen.Text = txtHoTen.Text.Trim();
            lblSDT.Text = txtSDT.Text.Trim();
            lblDiaChi.Text = txtDiaChi.Text.Trim();
            pnlSuaThongTin.Visible = false;
            pnlThongTin.Visible = true;

            Session["Ten"] = txtHoTen.Text.Trim();

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Cập nhật thông tin thành công!');", true);
        }

        protected void btnDoiMatKhau_Click(object sender, EventArgs e)
        {
            string email = Session["TaiKhoan"].ToString();
            string mkMoi = txtMatKhauMoi.Text.Trim();

            if (string.IsNullOrEmpty(mkMoi))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Vui lòng nhập mật khẩu mới!');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE TaiKhoan SET MatKhau=@mk WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@mk", mkMoi);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Đổi mật khẩu thành công!');", true);
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Index.aspx");
        }

        protected void btnTim_Click(object sender, EventArgs e)
        {
            string tuKhoa = txtTimKiem.Text.Trim();
            if (!string.IsNullOrEmpty(tuKhoa))
                Response.Redirect("Index.aspx?search=" + tuKhoa);
        }

        protected void btnDoiAnh_Click(object sender, EventArgs e)
        {
            if (uploadAvatar.HasFile)
            {
                string fileName = System.IO.Path.GetFileName(uploadAvatar.FileName);
                string savePath = Server.MapPath("~/assets/avatar/" + fileName);
                uploadAvatar.SaveAs(savePath);

                string email = Session["TaiKhoan"].ToString();
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE TaiKhoan SET Anh=@Anh WHERE Email=@Email";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Anh", "assets/avatar/" + fileName);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                imgAvatar.ImageUrl = "assets/avatar/" + fileName;
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Cập nhật ảnh đại diện thành công!');", true);
            }
        }
    }
}
