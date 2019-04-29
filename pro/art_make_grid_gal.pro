; makes 5x5 pattern

pro art_make_grid_gal, lon, lat, pa, gw=gw,gh=gh,step=step,key=key, pexp=pexp

  @art
  
  EULER, lon, lat, ra, dec, 2
  print,ra,dec
  
  ; 5x5 step, arcmin
  
  shift=step*(5-1)/2/(art_pix*60.0)
  
  if(n_elements(key) eq 0) then key='art_5x5'
  if(n_elements(pexp) eq 0) then pexp=2000.0
  if(n_elements(step) eq 0) then step=2
  
  art=LONARR(art_strip_num,art_strip_num)
  art_make_header, ra, dec, pa, astr=astr, hdr=hdr, bitpix=3
  writefits, key+'.img',art,hdr

  nstep=fix((gh*60.0)/step)+1
  hgal=gh*60./2.0-INDGEN(nstep)*step
  wgal=gw*60.*(0.5-INDGEN(2))

  ;;line(266.3136123,-28.79163841,266.5458136,-28.79159612) # line=0 0

  t1=0L
  t2=1L
  openw,reg,key+'.reg',/get_lun
  printf,reg,'galactic'
  for i=0L,nstep-1 do begin
     printf,reg,'line('+$
           String(wgal[t1]/60.0,format='(f16.8)')+','+$
           String(hgal[i]/60.0,format='(f16.8)')+','+$
           String(wgal[t2]/60.0,format='(f16.8)')+','+$
           String(hgal[i]/60.0,format='(f16.8)')+$
           ') # line=0 1'
     tt=t1
     t1=t2
     t2=tt
  endfor
  close,reg
  free_lun,reg
  return
  
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
