; makes header for NuSTAR snapshot
; bitpix: 1 - Byte, 2 - 16 bit integer, 4 - float, 3 - Long
pro art_make_header, center_ra, center_dec, PA, astr=astr, hdr=hdr, bitpix=bitpix, oa=oa

  @art

  art_make_astr, center_ra, center_dec, PA, astr=astr, oa=oa
  mkhdr, hdr, bitpix, [art_strip_num, art_strip_num]  
  putast, hdr, astr, CD_TYPE=2
end
