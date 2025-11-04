using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;

namespace web_ban_giay
{
    public partial class Index : System.Web.UI.Page
    {
     
        string connectionString = ConfigurationManager.ConnectionStrings["TokoDBConnectionString"].ConnectionString;

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

               
                string tuKhoa = Request.QueryString["search"];
                LoadHang();

                if (!string.IsNullOrEmpty(tuKhoa))
                {
                    txtTimKiem.Text = tuKhoa;
                    LoadGiay(tuKhoa);
                }
                else
                {
                    LoadGiay();
                }
            }
        }


       
        private void LoadHang()
        {
            cblHang.Items.Clear();
            List<string> hangList = new List<string>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT DISTINCT Hang FROM Giay ORDER BY Hang";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    hangList.Add(reader.GetString(0));
                }
            }

            foreach (var h in hangList)
            {
                cblHang.Items.Add(h);
            }
        }

        
        private void LoadGiay(string tuKhoa = "", List<string> hangChon = null)
        {
            string query = "SELECT * FROM Giay WHERE 1=1";

            if (!string.IsNullOrEmpty(tuKhoa))
                query += " AND (Ten LIKE @kw OR Hang LIKE @kw)";

            if (hangChon != null && hangChon.Count > 0)
            {
                string inClause = string.Join(",", hangChon.ConvertAll(x => $"'{x}'"));
                query += $" AND Hang IN ({inClause})";
            }

            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                if (!string.IsNullOrEmpty(tuKhoa))
                    cmd.Parameters.AddWithValue("@kw", "%" + tuKhoa + "%");

                conn.Open();
                rptGiay.DataSource = cmd.ExecuteReader();
                rptGiay.DataBind();
            }
        }

        protected void btnTim_Click(object sender, EventArgs e)
        {
            LoadGiay(txtTimKiem.Text.Trim());
        }

       
        protected void btnApDungLoc_Click(object sender, EventArgs e)
        {
            List<string> hangChon = new List<string>();
            foreach (var item in cblHang.Items)
            {
                var i = (System.Web.UI.WebControls.ListItem)item;
                if (i.Selected)
                    hangChon.Add(i.Text);
            }
            LoadGiay(txtTimKiem.Text.Trim(), hangChon);
        }

        
        protected void btnXoaLoc_Click(object sender, EventArgs e)
        {
            cblHang.ClearSelection();
            txtTimKiem.Text = "";
            LoadGiay();
        }

        protected void btnDangXuat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Index.aspx");
        }
    }
}
