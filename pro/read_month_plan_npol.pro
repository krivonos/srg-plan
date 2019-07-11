pro read_month_plan_npol,filename,seance_cut=seance_cut
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop

  read_month_plan,filename, key='[seance]'
  read_month_plan,filename, key='[correction]'


  if not (n_elements(seance_cut) eq 0) then begin 
     print,'*** CORRECT SEANCE START?STOP TIMES'
     for i=0L, n_elements(mjd_start)-1 do begin
        print,'seance_cut=',seance_cut
        print,'>> MJD start,stop: ',mjd_start[i],mjd_stop[i],format='(a,2f16.4)'

     dur = (mjd_stop[i] - mjd_start[i])
     mid = mjd_start[i] + dur/2
     
     mjd_start[i] = mid - (seance_cut/60.0/24.0)/2.
     mjd_stop[i] = mid + (seance_cut/60.0/24.0)/2.
     
     print,'<< MJD start,stop: ',mjd_start[i],mjd_stop[i],format='(a,2f16.4)'
     
  endfor
endif
  
end
