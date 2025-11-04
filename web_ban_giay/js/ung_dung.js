

let du_lieu_bo_nho = {
    tu_khoa: '',
    hang_chon: new Set(),
    trang: 1,
    kich_thuoc_trang: 20
};


function doc_ds_hang(ds) {
    const tap = new Set(ds.map(x => x.hang));
    return Array.from(tap).sort();
}


// 📌 Tạo danh sách hãng (lọc theo hãng) hiển thị ngang
function lap_bo_loc_hang(ds) {
    const div = document.getElementById('bo_loc_hang');
    if (!div) return;

    const danh_sach_hang = doc_ds_hang(ds);

    div.innerHTML = `
      <h3 style="color:#fff; margin-bottom:8px;">Hãng giày</h3>
      <div class="ds_hang_grid" style="
          display:flex;
          flex-wrap:wrap;
          gap:8px 14px;
          align-items:center;
          justify-content:flex-start;
          background:#111;
          padding:10px 14px;
          border-radius:10px;
          border:1px solid #333;
      "></div>
  `;

    const container = div.querySelector('.ds_hang_grid');
    for (const hang of danh_sach_hang) {
        const id = 'hang_' + hang.toLowerCase().replace(/\s+/g, '_');

        const item = document.createElement('label');
        item.style = `
        display:inline-flex;
        align-items:center;
        gap:6px;
        cursor:pointer;
        color:#eee;
        font-size:15px;
        background:#222;
        padding:4px 8px;
        border-radius:6px;
        border:1px solid #444;
        white-space:nowrap;
    `;
        item.innerHTML = `
        <input type="checkbox" id="${id}" value="${hang}" style="width:15px;height:15px;">
        <span>${hang}</span>
    `;

        const checkbox = item.querySelector('input');
        checkbox.onchange = () => {
            if (checkbox.checked) {
                du_lieu_bo_nho.hang_chon.add(hang);
                item.style.background = '#E30613';
                item.style.color = '#fff';
                item.style.border = '1px solid #E30613';
            } else {
                du_lieu_bo_nho.hang_chon.delete(hang);
                item.style.background = '#222';
                item.style.color = '#eee';
                item.style.border = '1px solid #444';
            }
            du_lieu_bo_nho.trang = 1;
            render_danh_sach();
        };

        container.appendChild(item);
    }
}





// 📦 Hàm lọc và tìm kiếm theo từ khóa + hãng
function loc_tim(ds) {
    const tu = du_lieu_bo_nho.tu_khoa.toLowerCase().trim();
    const chon = du_lieu_bo_nho.hang_chon;
    return ds.filter(x => {
        const ten_ok = !tu || x.ten.toLowerCase().includes(tu) || x.hang.toLowerCase().includes(tu);
        const hang_ok = chon.size === 0 || chon.has(x.hang);
        return ten_ok && hang_ok;
    });
}

// 📦 Render danh sách sản phẩm 5x4 + phân trang
function render_danh_sach() {
    const ds = JSON.parse(localStorage.getItem('du_lieu_giay') || '[]');
    const ket_qua = loc_tim(ds);
    const batdau = (du_lieu_bo_nho.trang - 1) * du_lieu_bo_nho.kich_thuoc_trang;
    const cat = ket_qua.slice(batdau, batdau + du_lieu_bo_nho.kich_thuoc_trang);

    const luoi = document.getElementById('luoi_giay');
    if (!luoi) return;
    luoi.innerHTML = '';

    for (const sp of cat) {
        const el = document.createElement('div');
        el.className = 'the_giay';
        el.innerHTML = `
      <img src="${sp.anh}" alt="${sp.ten}">
      <div class="thong_tin_giay">
        <div class="ten_giay">${sp.ten}</div>
        <div class="hang_giay">${sp.hang}</div>
        <div class="gia_tien">${Number(sp.gia_tien).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' })}</div>
        <div class="nut_nhom">
          <button class="nut_them_gio">🛒 Thêm vào giỏ</button>
          <button class="nut_chi_tiet" data-id="${sp.id}">👁 Xem chi tiết</button>
        </div>
      </div>
    `;

        // 🛒 Thêm vào giỏ hàng
        el.querySelector('.nut_them_gio').onclick = () => them_vao_gio(sp.id);

        // 👁 Xem chi tiết sản phẩm
        el.querySelector('.nut_chi_tiet').onclick = (e) => {
            const id = e.target.getAttribute('data-id');
            localStorage.setItem('giay_dang_xem', id);
            window.location.href = 'chitiet.html?id=' + id;
        };

        luoi.appendChild(el);
    }

    // 📑 Phân trang
    const tong_trang = Math.max(1, Math.ceil(ket_qua.length / du_lieu_bo_nho.kich_thuoc_trang));
    const pt = document.getElementById('phan_trang');
    if (!pt) return;
    pt.innerHTML = '';

    const btn_truoc = document.createElement('button');
    btn_truoc.textContent = 'Trang trước';
    btn_truoc.onclick = () => {
        if (du_lieu_bo_nho.trang > 1) {
            du_lieu_bo_nho.trang--;
            render_danh_sach();
        }
    };
    pt.appendChild(btn_truoc);

    for (let i = 1; i <= tong_trang; i++) {
        const b = document.createElement('button');
        b.textContent = i;
        if (i === du_lieu_bo_nho.trang) b.classList.add('dang_chon');
        b.onclick = () => {
            du_lieu_bo_nho.trang = i;
            render_danh_sach();
        };
        pt.appendChild(b);
    }

    const btn_sau = document.createElement('button');
    btn_sau.textContent = 'Trang sau';
    btn_sau.onclick = () => {
        if (du_lieu_bo_nho.trang < tong_trang) {
            du_lieu_bo_nho.trang++;
            render_danh_sach();
        }
    };
    pt.appendChild(btn_sau);
}

// 📦 Khởi động trang chủ — đảm bảo gọi đúng thời điểm ASP.NET đã load xong
function khoi_dong_trang_chu() {
    // Đợi toàn bộ trang load xong (vì ASP.NET có form)
    window.addEventListener('load', async () => {
        await khoi_tao_du_lieu_co_ban();
        const ds = JSON.parse(localStorage.getItem('du_lieu_giay') || '[]');
        lap_bo_loc_hang(ds);
        render_danh_sach();

        const o = document.getElementById('o_tim_kiem');
        const b = document.getElementById('nut_tim_kiem');
        if (o && b) {
            b.onclick = () => {
                du_lieu_bo_nho.tu_khoa = o.value;
                du_lieu_bo_nho.trang = 1;
                render_danh_sach();
            };
            o.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') {
                    b.click();
                    e.preventDefault();
                }
            });
        }

        const nut_xoa_loc = document.getElementById('nut_xoa_loc');
        if (nut_xoa_loc) {
            nut_xoa_loc.onclick = () => {
                du_lieu_bo_nho.hang_chon.clear();
                document.querySelectorAll('#bo_loc_hang input[type=checkbox]').forEach(i => i.checked = false);
                du_lieu_bo_nho.trang = 1;
                render_danh_sach();
            };
        }
    });
}

// 🔹 Khởi chạy nếu có lưới giày trong trang
if (document.getElementById('luoi_giay')) {
    khoi_dong_trang_chu();
}
