
// du_lieu.js - khoi tao & nap du lieu vao localStorage

async function khoi_tao_du_lieu_co_ban(){
  // Nap danh sach admin mau tu json vao localStorage (chi khi chua co)
  if(!localStorage.getItem('tai_khoan_admin')){
    try{
      const res = await fetch('data/tai_khoan_mau.json');
      const j = await res.json();
      localStorage.setItem('tai_khoan_admin', JSON.stringify(j.admin||[]));
    }catch(e){
      // fallback: tao san 1 admin
      localStorage.setItem('tai_khoan_admin', JSON.stringify([
        {email:'admin@toko.vn', mat_khau:'Toko@123', ten:'Quan tri vien'}
      ]));
    }
  }

  // Nap du lieu giay
  if(!localStorage.getItem('du_lieu_giay')){
    try{
      const res = await fetch('data/giay.json');
      const j = await res.json();
      localStorage.setItem('du_lieu_giay', JSON.stringify(j));
    }catch(e){
      console.error('Khong the nap data/giay.json', e);
      localStorage.setItem('du_lieu_giay', '[]');
    }
  }

  // Khoi tao danh sach tai khoan khach neu chua co
  if(!localStorage.getItem('tai_khoan_khach')){
    localStorage.setItem('tai_khoan_khach', JSON.stringify([]));
  }
}
