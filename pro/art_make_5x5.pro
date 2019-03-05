; makes 5x5 pattern

pro art_make_5x5, ra, dec, pa, key=key, pexp=pexp

  @art

  ; 5x5 step, arcmin
  step=6.0
  shift=step*(5-1)/2/(art_pix*60.0)
  
  if(n_elements(key) eq 0) then key='art_5x5'
  if(n_elements(pexp) eq 0) then pexp=2000.0
  
  art=LONARR(art_strip_num,art_strip_num)
  art_make_header, ra, dec, pa, astr=astr, hdr=hdr, bitpix=3
  writefits, key+'.img',art,hdr

  openw,reg,key+'.reg',/get_lun
  openw,dat,key+'.dat',/get_lun
  for i=0L, 4L do for j=0L, 4L do begin
     x=art_oa_x+(i)*step/(art_pix*60.0)-shift
     y=art_oa_y+(j)*step/(art_pix*60.0)-shift
     xy2ad,x-1.0,y-1.0,astr,new_ra,new_dec
     printf,dat, new_ra, new_dec, pa, pexp, format='(2f12.6,2f10.2)'
     printf,reg, 'fk5;circle(',new_ra,',',new_dec,',',art_pix/2,')'
  endfor
  close,dat
  free_lun,dat
  close,reg
  free_lun,reg
end
