using System;
using System.Web.Script.Serialization;

namespace web_ban_giay
{
    public partial class KiemTraDangNhap : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentType = "application/json";
            bool loggedIn = Session["TaiKhoan"] != null;
            var json = new JavaScriptSerializer().Serialize(new { isLoggedIn = loggedIn });
            Response.Write(json);
            Response.End();
        }
    }
}
