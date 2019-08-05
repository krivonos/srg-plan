pro write_plan,filename=filename, append=append, table=table, info=info, title=title, npol=npol

  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop, seance_guid, ra_prev, dec_prev, delta_ra, delta_dec
  COMMON IKI, iki_version
  
  @art
  
  if(n_elements(append) eq 0) then append=0  
  if not (append) then file_delete,filename,/ALLOW_NONEXISTENT

  FXBHMAKE, hdr, n_elements(a), 'OBSERVATION'
  sxaddpar, hdr, 'OBSMODE', 'OBSERVATION', ' Possible values: OBSERVATION, SCAN, SURVEY'
  
  sxaddpar, hdr, 'TUNIT1', 'str', 'scan (F), survey (S), observation (P)'
  sxaddpar, hdr, 'TUNIT1', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT2', 'deg', 'J2000'
  sxaddpar, hdr, 'TUNIT3', 'obsid', 'obsid'
  sxaddpar, hdr, 'TUNIT4', 'date', 'date of start'
  sxaddpar, hdr, 'TUNIT5', 'date', 'date of stop'
  sxaddpar, hdr, 'TUNIT6', 'min', 'Exposure in minutes'
  sxaddpar, hdr, 'TUNIT7', 'deg', 'ROLL angle'
  sxaddpar, hdr, 'TUNIT8', 'deg', 'SUN X0Z angle'
  sxaddpar, hdr, 'DELT_RA', delta_ra, 'Delta RA known after allign.'
  sxaddpar, hdr, 'DELT_DEC', delta_dec, 'Delta Dec known after allign.'
  if(n_elements(title) ne 0) then begin
     sxaddpar, hdr, 'TITLE', title, 'Description'
  endif

  if(n_elements(npol) ne 0) then begin
     sxaddpar, hdr, 'NPOL', npol, ' NPOL month plan'
  endif

  jd_sys=systime(/JULIAN, /UTC)
  CALDAT, jd_sys, Month , Day , Year , Hour , Minute , Second
  str_sys=String(Day, '.', Month, '.', Year, Hour+MSK, ':', Minute, ':', round(Second), $
                 format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
  sxaddpar, hdr, 'GENTIME', str_sys, ' Creation Date and Time in UTC+3 (MSK)'
     
  if(n_elements(info) ne 0) then begin
     sxaddpar, hdr, 'PROJECT', 'SRG', ' Project'
     sxaddpar, hdr, 'INSTITUT', 'IKI', ' Affiliation'
     sxaddpar, hdr, 'AUTHOR', info.author, ' Responsible person'
     sxaddpar, hdr, 'EMAIL', info.email, ' E-mail'
     sxaddpar, hdr, 'START', hdr_start, ' Start date'
     sxaddpar, hdr, 'STOP', hdr_stop, ' Stop date'
     sxaddpar, hdr, 'VERSION', iki_version, ' Version'
     sxaddpar, hdr, 'PLANNING', 'month', ' PLANNING_TERM'
  endif
  print,'Write file: ',filename
  MWRFITS, table, filename, hdr

  ;; delete table
  DELVARX,table
end
