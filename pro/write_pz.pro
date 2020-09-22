pro write_pz,filename=filename, append=append, table=table
 
  @art
  
  if(n_elements(append) eq 0) then append=0  
  if not (append) then file_delete,filename,/ALLOW_NONEXISTENT

  for i=0L, n_elements(table)-2 do begin
     delta=(table[i+1].mjd_start-table[i].mjd_stop)*24*60
     if(delta gt 60) then begin
        print,table[i].experiment
        print,table[i+1].experiment
     endif
  endfor
  
  
  FXBHMAKE, hdr, n_elements(a), 'OBSERVATION'
  sxaddpar, hdr, 'OBSMODE', 'OBSERVATION', ' Possible values: OBSERVATION, SCAN, SURVEY'
  
  sxaddpar, hdr, 'TUNIT1', 'str', 'scan (F), survey (S), observation (P)'
  sxaddpar, hdr, 'TUNIT1', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT2', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT3', 'obsid', 'obsid'
  sxaddpar, hdr, 'TUNIT4', 'date', 'date of start'
  sxaddpar, hdr, 'TUNIT5', 'date', 'date of stop'
;;  sxaddpar, hdr, 'TUNIT6', 'min', 'Exposure in minutes'
;;  sxaddpar, hdr, 'TUNIT7', 'deg', 'ROLL angle'
;;  sxaddpar, hdr, 'TUNIT8', 'deg', 'SUN X0Z angle'


  jd_sys=systime(/JULIAN, /UTC)
  CALDAT, jd_sys, Month , Day , Year , Hour , Minute , Second
  str_sys=String(Day, '.', Month, '.', Year, Hour+MSK, ':', Minute, ':', round(Second), $
                 format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
  sxaddpar, hdr, 'GENTIME', str_sys, ' Creation Date and Time in UTC+3 (MSK)'
     
  print,'Write file: ',filename
  MWRFITS, table, filename, hdr

  ;; delete table
  DELVARX,table
end
