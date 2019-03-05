; makes astr structure for NuSTAR snapshot
pro art_make_astr, center_ra, center_dec, PA, astr=astr, oa=oa

  @art
  
  if(n_elements(oa) eq 0) then oa=[art_oa_x, art_oa_y]

  rot_mat = [ [ cos(PA*dr), -sin(PA*dr)], $ ;Rotation matrix
              [ sin(PA*dr),  cos(PA*dr)] ] 

  crpix=oa
  
  cdelt=[art_pix, art_pix]
  make_astr,astr, CD=rot_mat, DELTA = cdelt, CRPIX = crpix, $
            CRVAL = [center_ra,center_dec], $
            RADECSYS = 'FK5', EQUINOX = 2000.0

  ; it forces FK5, but sometimes we need galactic coords
  ; RADECSYS = 'FK5', EQUINOX = 2000.0
end

