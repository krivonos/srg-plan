pro uds
  @art
  ;;
  ;; Init UDS field
  ;; 
  uds=[{ra:34.47838000d, dec:-4.98117d, texp:1380L, name:'Field 1'},$
       {ra:34.77938407d, dec:-4.98117d, texp:1440L, name:'Field 2'},$
       {ra:34.62889072d, dec:-4.72136d, texp:1440L, name:'Field 3'},$
       {ra:34.32786928d, dec:-4.72136d, texp:1440L, name:'Field 4'},$
       {ra:34.17710107d, dec:-4.98117d, texp:1440L, name:'Field 5'},$
       {ra:34.32775027d, dec:-5.24098d, texp:1440L, name:'Field 6'},$
       {ra:34.62900973d, dec:-5.24098d, texp:1440L, name:'Field 7'}]

  target=''
  obsid='uds'
  roll=0
  bitpix=3
  strip_num=art_strip_num*2
  uds_field=1
  ra=uds[uds_field-1].ra
  dec=uds[uds_field-1].dec
  crpix=[strip_num/2+0.5, strip_num/2+0.5]
  art=LONARR(strip_num,strip_num)
  cdelt=[art_pix, art_pix]
  make_astr,astr, CD=rot_mat, DELTA = cdelt, CRPIX = crpix, $
            CRVAL = [ra,dec], $
            RADECSYS = 'FK5', EQUINOX = 2000.0
  mkhdr, hdr, bitpix, [strip_num, strip_num]  
  putast, hdr, astr, CD_TYPE=2
  writefits, 'uds.img',art,hdr

  
  openw,reg,obsid+'_nominal.reg',/get_lun
  alpha=30.0d/180.0d*!DPI
  for i=0L,6L do begin
     ra=uds[i].ra
     dec=uds[i].dec
     AD2XY, ra ,dec, astr, x, y
     xx=(x+1)-crpix[0]
     yy=(y+1)-crpix[1]
     ;;x' = x cos θ − y sin θ
     ;;y' = x sin θ + y cos θ
     rota_x = xx*cos(alpha) - yy*sin(alpha)
     rota_y = xx*sin(alpha) + yy*cos(alpha)
     XY2AD, (rota_x+crpix[0])-1 ,(rota_y+crpix[1])-1, astr, rota_ra, rota_dec
     print,(x+1)-crpix[0],(y+1)-crpix[1]
     printf,reg, 'fk5;circle(',ra,',',dec,',',art_pix/2,') # text={'+uds[i].name+'}',format='(a,f16.8,a,f16.8,a,f8.2,a)'
     printf,reg, 'fk5;circle(',rota_ra,',',rota_dec,',',art_pix/2,') # text={'+uds[i].name+' rota}',format='(a,f16.8,a,f16.8,a,f8.2,a)'
  endfor
  close,reg
  free_lun,reg

  
end
