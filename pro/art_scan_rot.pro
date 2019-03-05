pro art_scan_rot, alpha, offset=offset, prot_x=prot_x, prot_y=prot_y
 ; alpha: angle in radians
 ; offset: offsets in arcmins 
  
  @art

  px=DBLARR(N_ELEMENTS(offset))+offset
  py=DBLARR(N_ELEMENTS(offset))

  prot_x=px*cos(alpha)-py*sin(alpha)
  prot_y=px*sin(alpha)+py*cos(alpha)

  prot_x=prot_x/(art_pix*60.0)+art_oa_x
  prot_y=prot_y/(art_pix*60.0)+art_oa_y
end
