protected void Page_Load(object sender, EventArgs e)
{
    if (Session["Email"] == null)
    {
        Response.Redirect("DangNhap.aspx");
    }
}
