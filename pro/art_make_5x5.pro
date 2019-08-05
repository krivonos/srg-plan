; makes 5x5 pattern

pro art_make_5x5, ra, dec, pa, key=key, pexp=pexp, side=side

  @art


  
  if(n_elements(key) eq 0) then key='art_5x5'
  if(n_elements(pexp) eq 0) then pexp=50
  if(n_elements(side) eq 0) then side=3

  ;; 5x5 step, arcmin
  step=6.0
  shift=step*(side-1)/2/(art_pix*60.0)

  
  art=LONARR(art_strip_num,art_strip_num)
  art_make_header, ra, dec, pa, astr=astr, hdr=hdr, bitpix=3
  writefits, key+'.img',art,hdr

  openw,reg,key+'.reg',/get_lun
  openw,dat,key+'.dat',/get_lun
  seq=1L
  total=0L
  for i=0L, side-1 do for j=0L, side-1 do begin
     x=art_oa_x+(i)*step/(art_pix*60.0)-shift
     y=art_oa_y+(j)*step/(art_pix*60.0)-shift
     xy2ad,x-1.0,y-1.0,astr,new_ra,new_dec
     printf,dat, seq, new_ra, new_dec, pa, pexp, format='(i2,2f14.8,2f10.2)'
     printf,reg, 'fk5;circle(',new_ra,',',new_dec,',',art_pix/2,') # text={',String(pexp,format='(i2)'),'}'
     seq++
     total+=pexp
  endfor

  ;; extra points:
;;  extra_i=[2,2,5,-1]
;;  extra_j=[5,-1,2,2]
;;  for n=0L, n_elements(extra_i)-1 do begin
;;     x=art_oa_x+(extra_i[n])*step/(art_pix*60.0)-shift
;;     y=art_oa_y+(extra_j[n])*step/(art_pix*60.0)-shift
;;     xy2ad,x-1.0,y-1.0,astr,new_ra,new_dec
;;     printf,dat, seq, new_ra, new_dec, pa, pexp, format='(i2,2f12.6,2f10.2)'
;;     printf,reg, 'fk5;circle(',new_ra,',',new_dec,',',art_pix/2,') # text={',String(pexp,format='(i2)'),'}'
;;     seq++
;;     total+=pexp
;;  endfor
  
  print,'Total, min:',total
  close,dat
  free_lun,dat
  close,reg
  free_lun,reg
end
