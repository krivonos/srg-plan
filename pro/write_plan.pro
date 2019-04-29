pro write_plan,filename=filename, append=append, table=table
  if(n_elements(append) eq 0) then append=0  
  if not (append) then file_delete,filename,/ALLOW_NONEXISTENT
  FXBHMAKE, hdr, n_elements(a), 'OBSERVATION'
  sxaddpar, hdr, 'TUNIT1', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT2', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT3', 'obsid', 'obsid'
  sxaddpar, hdr, 'TUNIT4', 'date', 'date of start'
  sxaddpar, hdr, 'TUNIT5', 'date', 'date of stop'
  sxaddpar, hdr, 'TUNIT6', 'min', 'Exposure in minutes'
  sxaddpar, hdr, 'TUNIT7', 'deg', 'ROLL angle'
  sxaddpar, hdr, 'TUNIT8', 'deg', 'SUN X0Z angle'
  sxaddhist,["This is a comment line to put in the header", $
             "And another comment"],hdr,/comment
  MWRFITS, table, filename, hdr

  ;; delete table
  DELVARX,table
end
