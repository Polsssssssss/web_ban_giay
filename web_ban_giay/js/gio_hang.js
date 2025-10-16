// gio_hang.js - quản lý giỏ hàng theo tài khoản đăng nhập (khách)

// 🟢 Lấy email tài khoản hiện tại
function lay_email_hien_tai() {
    const v = JSON.parse(localStorage.getItem('tai_khoan_dang_nhap') || 'null');
    return v ? v.email : null;
}

// 🟢 Tạo key lưu giỏ hàng riêng cho từng tài khoản
function key_gio(email) {
    return 'gio_hang_' + email;
}

// 🟢 Đọc giỏ hàng hiện tại
function doc_gio_hang() {
    const email = lay_email_hien_tai();
    if (!email) return [];
    return JSON.parse(localStorage.getItem(key_gio(email)) || '[]');
}

// 🟢 Ghi giỏ hàng vào localStorage
function ghi_gio_hang(ds) {
    const email = lay_email_hien_tai();
    if (!email) return;
    localStorage.setItem(key_gio(email), JSON.stringify(ds));
    cap_nhat_hien_thi_gio_hang();
}

// 🟢 Thêm sản phẩm vào giỏ (gồm cả size)
function them_vao_gio(id_sp, size = null) {
    const email = lay_email_hien_tai();
    if (!email) {
        alert('Bạn cần đăng nhập khách để thêm vào giỏ.');
        location.href = 'dangnhap.html';
        return;
    }
    const ds_sp = JSON.parse(localStorage.getItem('du_lieu_giay') || '[]');
    const sp = ds_sp.find(x => x.id === id_sp);
    if (!sp) return;

    const ds = doc_gio_hang();
    const x = ds.find(i => i.id === id_sp && i.size === size);
    if (x) x.so_luong += 1;
    else ds.push({ id: id_sp, ten: sp.ten, gia_tien: sp.gia_tien, anh: sp.anh, size, so_luong: 1 });
    ghi_gio_hang(ds);
    alert(`✅ Đã thêm ${sp.ten}${size ? ' (size ' + size + ')' : ''} vào giỏ!`);
}

// 🟢 Cập nhật số lượng hiển thị trên biểu tượng giỏ hàng
function cap_nhat_hien_thi_gio_hang() {
    const badge = document.getElementById('so_gio_hang');
    if (!badge) return;
    const ds = doc_gio_hang();
    const tong = ds.reduce((s, i) => s + i.so_luong, 0);
    badge.textContent = String(tong);
}

// 🟢 Trang giohang.html
function nap_gio_hang_trang() {
    const email = lay_email_hien_tai();
    if (!email) {
        alert('Bạn cần đăng nhập khách để xem giỏ.');
        location.href = 'dangnhap.html';
        return;
    }

    const ds_sp = JSON.parse(localStorage.getItem('du_lieu_giay') || '[]');
    const ds = doc_gio_hang();
    const tbody = document.getElementById('than_bang_gio');
    const tong_div = document.getElementById('tong_cong');

    function render() {
        tbody.innerHTML = '';
        let tong = 0;
        for (const it of ds) {
            const sp = ds_sp.find(x => x.id === it.id);
            if (!sp) continue;
            const thanh_tien = sp.gia_tien * it.so_luong;
            tong += thanh_tien;
            const tr = document.createElement('tr');
            tr.innerHTML = `
        <td><img src="${sp.anh}" alt="${sp.ten}" style="width:60px; border-radius:6px"></td>
        <td>${sp.ten} <br><small>Size: ${it.size || '-'}</small></td>
        <td>${Number(sp.gia_tien).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</td>
        <td>
          <div style="display:flex; gap:6px; align-items:center">
            <button class="btn_tru">-</button>
            <input class="o_sl" type="number" min="1" value="${it.so_luong}" style="width:60px; text-align:center; background:#0d0d0d; color:#fff; border:1px solid #333; border-radius:6px">
            <button class="btn_cong">+</button>
          </div>
        </td>
        <td>${Number(thanh_tien).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</td>
        <td class="hanh_dong_gio"><button class="btn_xoa">Xóa</button></td>
      `;
            tr.querySelector('.btn_tru').onclick = () => { it.so_luong = Math.max(1, it.so_luong - 1); render(); };
            tr.querySelector('.btn_cong').onclick = () => { it.so_luong += 1; render(); };
            tr.querySelector('.o_sl').onchange = (e) => { it.so_luong = Math.max(1, parseInt(e.target.value || '1')); render(); };
            tr.querySelector('.btn_xoa').onclick = () => {
                const idx = ds.findIndex(x => x.id === it.id && x.size === it.size);
                if (idx >= 0) { ds.splice(idx, 1); render(); }
            };
            tbody.appendChild(tr);
        }
        tong_div.textContent = Number(tong).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
    }

    render();

    document.getElementById('nut_cap_nhat').onclick = () => {
        ghi_gio_hang(ds);
        alert('Đã cập nhật giỏ hàng!');
        render();
    };
    document.getElementById('nut_xoa_tat_ca').onclick = () => {
        if (confirm('Xóa tất cả sản phẩm trong giỏ?')) {
            ghi_gio_hang([]);
            location.reload();
        }
    };
}
