
// xac_thuc.js - dang ky/dang nhap/dang xuat + header

function tai_hien_trang_thai_dang_nhap_header(){
  const v = JSON.parse(localStorage.getItem('tai_khoan_dang_nhap')||'null');
  const div = document.getElementById('hien_thi_tai_khoan');
  const nut_dn = document.getElementById('nut_dang_nhap');
  const nut_dx = document.getElementById('nut_dang_xuat');
  if(!div || !nut_dn || !nut_dx) return;

  if(v){
    div.textContent = v.vai_tro === 'admin' ? `👑 ${v.email}` : `👤 ${v.email}`;
    nut_dn.style.display = 'none';
    nut_dx.style.display = '';
    nut_dx.onclick = () => { dang_xuat(); location.href='index.html'; };
  }else{
    div.textContent = '';
    nut_dn.style.display = '';
    nut_dx.style.display = 'none';
  }

  // cap nhat so gio hang
  cap_nhat_hien_thi_gio_hang();
}

function dang_xuat(){
  localStorage.removeItem('tai_khoan_dang_nhap');
  cap_nhat_hien_thi_gio_hang();
}

function dang_ky_khach(ten, email, mat_khau){
  if(!ten || !email || !mat_khau){ alert('Vui lòng điền đủ thông tin.'); return false; }
  const ds = JSON.parse(localStorage.getItem('tai_khoan_khach')||'[]');
  if(ds.some(x=>x.email===email)){ alert('Email đã tồn tại.'); return false; }
  ds.push({ten, email, mat_khau});
  localStorage.setItem('tai_khoan_khach', JSON.stringify(ds));
  return true;
}

async function dang_nhap(vai_tro, email, mat_khau){
  if(!email || !mat_khau) return false;
  if(vai_tro === 'admin'){
    const ds = JSON.parse(localStorage.getItem('tai_khoan_admin')||'[]');
    const ok = ds.find(x=>x.email===email && x.mat_khau===mat_khau);
    if(ok){
      localStorage.setItem('tai_khoan_dang_nhap', JSON.stringify({vai_tro:'admin', email}));
      return true;
    }
  }else{
    const ds = JSON.parse(localStorage.getItem('tai_khoan_khach')||'[]');
    const ok = ds.find(x=>x.email===email && x.mat_khau===mat_khau);
    if(ok){
      localStorage.setItem('tai_khoan_dang_nhap', JSON.stringify({vai_tro:'khach', email}));
      return true;
    }
  }
  return false;
}

function bao_ve_trang_admin(){
  const v = JSON.parse(localStorage.getItem('tai_khoan_dang_nhap')||'null');
  if(!v || v.vai_tro!=='admin'){
    alert('Chỉ quản trị mới được vào trang này.');
    location.href='dangnhap.html';
  }
}
