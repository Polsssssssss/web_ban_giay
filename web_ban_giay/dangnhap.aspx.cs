using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace web_ban_giay
{
    public partial class DangNhap : System.Web.UI.Page
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


        protected void btnDangNhap_Click(object sender, EventArgs e)
        {
            string connStr = WebConfigurationManager.ConnectionStrings["TokoDBConnectionString"].ConnectionString;
            string email = txtEmail.Text.Trim();
            string mk = txtMatKhau.Text.Trim();
            bool laAdmin = rdoAdmin.Checked;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mk))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Vui lòng nhập đầy đủ thông tin!');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = laAdmin
                    ? "SELECT * FROM TaiKhoan WHERE Email=@Email AND MatKhau=@MatKhau AND LaAdmin=1"
                    : "SELECT * FROM TaiKhoan WHERE Email=@Email AND MatKhau=@MatKhau AND LaAdmin=0";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@MatKhau", mk);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    Session["TaiKhoan"] = email;
                    Session["Ten"] = reader["HoTen"].ToString();
                    Session["VaiTro"] = laAdmin ? "Admin" : "Khach";

                    string script = "alert('Đăng nhập thành công!');" +
                                    "setTimeout(function(){ window.location='Index.aspx'; }, 800);";
                    ClientScript.RegisterStartupScript(this.GetType(), "loginSuccess", script, true);
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert",
                        "alert('Sai email hoặc mật khẩu!');", true);
                }
            }
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Index.aspx");
        }
    }
}
