// xac_thuc.js - dang ky/dang nhap/dang xuat + header (safe & backend-friendly)

// ====== CẤU HÌNH ĐƯỜNG DẪN (đổi nếu bạn vẫn dùng .html) ======
const PATHS = {
    home: "index.html",
    login: "DangNhap.aspx", // nếu chưa có thì tạm để "dangnhap.html"
};

// ====== TIỆN ÍCH AN TOÀN ======
function safeParse(json, fallback = null) {
    try { return JSON.parse(json); } catch { return fallback; }
}
function $(id) { return document.getElementById(id); }

// Stub để tránh lỗi nếu file giỏ hàng chưa được load
window.cap_nhat_hien_thi_gio_hang = window.cap_nhat_hien_thi_gio_hang || function () {
    // TODO: cập nhật badge số lượng giỏ hàng trên header
};

// ====== LOGIC TÀI KHOẢN LƯU TẠM Ở LOCALSTORAGE (CHO FRONTEND) ======
function getDangNhap() {
    return safeParse(localStorage.getItem("tai_khoan_dang_nhap"), null);
}
function setDangNhap(v) {
    if (v == null) localStorage.removeItem("tai_khoan_dang_nhap");
    else localStorage.setItem("tai_khoan_dang_nhap", JSON.stringify(v));
}
function getDSAdmin() {
    return safeParse(localStorage.getItem("tai_khoan_admin"), []);
}
function getDSKhach() {
    return safeParse(localStorage.getItem("tai_khoan_khach"), []);
}

// ====== HEADER / TRẠNG THÁI ======
function tai_hien_trang_thai_dang_nhap_header() {
    const v = getDangNhap();
    const div = $("hien_thi_tai_khoan");
    const nut_dn = $("nut_dang_nhap");
    const nut_dx = $("nut_dang_xuat");

    // Nếu trang hiện tại không có header thì thôi
    if (!div || !nut_dn || !nut_dx) return;

    if (v) {
        div.textContent = v.vai_tro === "admin" ? `👑 ${v.email}` : `👤 ${v.email}`;
        nut_dn.style.display = "none";
        nut_dx.style.display = "";
        nut_dx.onclick = () => {
            dang_xuat();
            location.href = PATHS.home;
        };
    } else {
        div.textContent = "";
        nut_dn.style.display = "";
        nut_dx.style.display = "none";
        // Có thể gắn click chuyển tới trang đăng nhập nếu muốn
        if (!nut_dn.onclick) {
            nut_dn.onclick = () => { location.href = PATHS.login; };
        }
    }

    // Gọi an toàn, không làm vỡ JS nếu file giỏ hàng chưa có
    if (typeof window.cap_nhat_hien_thi_gio_hang === "function") {
        window.cap_nhat_hien_thi_gio_hang();
    }
}

function dang_xuat() {
    setDangNhap(null);
    if (typeof window.cap_nhat_hien_thi_gio_hang === "function") {
        window.cap_nhat_hien_thi_gio_hang();
    }
}

// ====== ĐĂNG KÝ / ĐĂNG NHẬP (BẢN LOCAL) ======
function dang_ky_khach(ten, email, mat_khau) {
    if (!ten || !email || !mat_khau) { alert("Vui lòng điền đủ thông tin."); return false; }
    const ds = getDSKhach();
    if (ds.some(x => x.email === email)) { alert("Email đã tồn tại."); return false; }
    ds.push({ ten, email, mat_khau });
    localStorage.setItem("tai_khoan_khach", JSON.stringify(ds));
    return true;
}

async function dang_nhap(vai_tro, email, mat_khau) {
    if (!email || !mat_khau) return false;

    if (vai_tro === "admin") {
        const ds = getDSAdmin();
        const ok = ds.find(x => x.email === email && x.mat_khau === mat_khau);
        if (ok) {
            setDangNhap({ vai_tro: "admin", email });
            return true;
        }
    } else {
        const ds = getDSKhach();
        const ok = ds.find(x => x.email === email && x.mat_khau === mat_khau);
        if (ok) {
            setDangNhap({ vai_tro: "khach", email });
            return true;
        }
    }
    return false;
}

// ====== BẢO VỆ TRANG ADMIN ======
function bao_ve_trang_admin() {
    const v = getDangNhap();
    if (!v || v.vai_tro !== "admin") {
        alert("Chỉ quản trị mới được vào trang này.");
        location.href = PATHS.login;
    }
}

// ====== TỰ KHỞI TẠO KHI DOM SẴN SÀNG ======
document.addEventListener("DOMContentLoaded", () => {
    try { tai_hien_trang_thai_dang_nhap_header(); } catch (e) { /* nuốt lỗi để không chặn UI */ }
});

// ====== EXPOSE RA GLOBAL (nếu HTML gắn onclick="...") ======
window.tai_hien_trang_thai_dang_nhap_header = tai_hien_trang_thai_dang_nhap_header;
window.dang_xuat = dang_xuat;
window.dang_ky_khach = dang_ky_khach;
window.dang_nhap = dang_nhap;
window.bao_ve_trang_admin = bao_ve_trang_admin;
