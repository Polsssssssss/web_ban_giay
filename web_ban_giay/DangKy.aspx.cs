using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace web_ban_giay
{
    public partial class DangKy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
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
            }
        }


        protected void btnDangKy_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["TokoDBConnectionString"].ConnectionString;

            string hoTen = txtHoTen.Text.Trim();
            string email = txtEmail.Text.Trim();
            string mk = txtMatKhau.Text.Trim();
            string mk2 = txtMatKhau2.Text.Trim();

            if (string.IsNullOrEmpty(hoTen) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mk) || string.IsNullOrEmpty(mk2))
            {
                lblThongBao.Text = "Vui lòng nhập đầy đủ thông tin.";
                return;
            }

            if (mk != mk2)
            {
                lblThongBao.Text = "Mật khẩu xác nhận không khớp.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    
                    string checkQuery = "SELECT COUNT(*) FROM TaiKhoan WHERE Email = @em";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@em", email);
                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblThongBao.Text = "Email này đã tồn tại!";
                        return;
                    }

                  
                    string insertQuery = "INSERT INTO TaiKhoan (HoTen, Email, MatKhau) VALUES (@ten, @em, @mk)";
                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@ten", hoTen);
                    cmd.Parameters.AddWithValue("@em", email);
                    cmd.Parameters.AddWithValue("@mk", mk);
                    cmd.ExecuteNonQuery();

                   
                    string script = "alert('Đăng ký thành công! Mời bạn đăng nhập.');" +
                                    "setTimeout(function(){ window.location='DangNhap.aspx'; }, 800);";
                    ClientScript.RegisterStartupScript(this.GetType(), "registerSuccess", script, true);
                }
            }
            catch (Exception ex)
            {
                lblThongBao.Text = "Lỗi: " + ex.Message;
            }
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
