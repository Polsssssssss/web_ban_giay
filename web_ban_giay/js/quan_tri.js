

function tai_bang_quan_tri(){
  const bang = document.getElementById('bang_admin');
  const ds = JSON.parse(localStorage.getItem('du_lieu_giay')||'[]');
  bang.innerHTML='';
  for(const sp of ds){
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${sp.id}</td>
      <td><img src="${sp.anh}" alt="${sp.ten}" style="width:64px; height:64px; object-fit:cover; border-radius:8px; border:1px solid #222"></td>
      <td>${sp.ten}</td>
      <td>${sp.hang}</td>
      <td>${Number(sp.gia_tien).toLocaleString('vi-VN',{style:'currency',currency:'VND'})}</td>
      <td>${sp.ton_kho}</td>
      <td>
        <button class="btn_sua">Sửa</button>
        <button class="btn_xoa">Xóa</button>
      </td>
    `;
    tr.querySelector('.btn_xoa').onclick = ()=>{
      if(confirm('Xóa sản phẩm này?')){
        const ds2 = JSON.parse(localStorage.getItem('du_lieu_giay')||'[]').filter(x=>x.id!==sp.id);
        localStorage.setItem('du_lieu_giay', JSON.stringify(ds2));
        tai_bang_quan_tri();
      }
    };
    tr.querySelector('.btn_sua').onclick = ()=>{
     
      const ten = prompt('Tên giày:', sp.ten); if(ten===null) return;
      const hang = prompt('Hãng:', sp.hang); if(hang===null) return;
      const gia = parseInt(prompt('Giá tiền:', sp.gia_tien)); if(isNaN(gia)) return;
      const ton = parseInt(prompt('Tồn kho:', sp.ton_kho)); if(isNaN(ton)) return;
      const anh = prompt('Đường dẫn ảnh (assets/giay_demo/xxx.jpg):', sp.anh); if(anh===null) return;
      const mo_ta = prompt('Mô tả:', sp.mo_ta||''); if(mo_ta===null) return;
      const ds3 = JSON.parse(localStorage.getItem('du_lieu_giay')||'[]');
      const idx = ds3.findIndex(x=>x.id===sp.id);
      if(idx>=0){
        ds3[idx] = {...sp, ten, hang, gia_tien:gia, ton_kho:ton, anh, mo_ta};
        localStorage.setItem('du_lieu_giay', JSON.stringify(ds3));
        tai_bang_quan_tri();
      }
    };
    bang.appendChild(tr);
  }
}

function tao_id_moi(ds){
 
  let max = 0;
  for(const x of ds){
    const m = /G(\d+)/.exec(x.id);
    if(m){ max = Math.max(max, parseInt(m[1])); }
  }
  const n = (max+1).toString().padStart(3,'0');
  return 'G' + n;
}

document.getElementById('nut_them_giay')?.addEventListener('click', ()=>{
  const ten = document.getElementById('them_ten').value.trim();
  const hang = document.getElementById('them_hang').value.trim();
  const gia = parseInt(document.getElementById('them_gia').value);
  const ton = parseInt(document.getElementById('them_ton').value);
  const anh_ten = document.getElementById('them_anh').value.trim();
  const mo_ta = document.getElementById('them_mo_ta').value.trim();
  if(!ten||!hang||!gia||!ton||!anh_ten){ alert('Điền đủ thông tin.'); return; }

  const ds = JSON.parse(localStorage.getItem('du_lieu_giay')||'[]');
  const id = tao_id_moi(ds);
  const sp = {id, ten, hang, gia_tien:gia, ton_kho:ton, anh:`assets/giay_demo/${anh_ten}`, mo_ta};
  ds.push(sp);
  localStorage.setItem('du_lieu_giay', JSON.stringify(ds));

  
  ['them_ten','them_hang','them_gia','them_ton','them_anh','them_mo_ta'].forEach(id=>document.getElementById(id).value='');

  tai_bang_quan_tri();
  alert('Đã thêm sản phẩm!');
});
