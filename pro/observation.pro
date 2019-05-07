function observation,date=date, texp=texp, ra=ra, dec=dec, obsid=obsid, $
                     shift=shift, table=table, create=create, tol=tol, $
                     roll_angle=roll_angle, sun_x0z_angle=sun_x0z_angle, target=target, ignore_seance=ignore_seance
  @art
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name


  if(n_elements(target) eq 0) then target=''  
  if(n_elements(ignore_seance) eq 0) then ignore_seance=1  
  if(n_elements(roll_angle) eq 0) then roll_angle=0.0  
  if(n_elements(sun_x0z_angle) eq 0) then sun_x0z_angle=0.0  
  if(n_elements(create) eq 0) then create=0  
  if(n_elements(tol) eq 0) then tol=60 ;; tolerance in minutes  

  juldate, date, mjd_obs
  ;; correct MJD by 0.5 to be consistent with HEASARC
  ;; https://heasarc.gsfc.nasa.gov/cgi-bin/Tools/xTime/xTime.pl
  mjd_obs-=0.5
  ;;print,mjd_obs,format='(f16.8)'
    
  print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
  print,'>>',obsid,' ',start,' ',stop,' ',target

  if(ignore_seance) then begin
     push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
     return,(shift+texp)
  endif
  
  istart=-1L
  istop=-1L
  icover=-1L
  for i=0L, n_elements(mjd_start)-1 do begin
     if(mjd_t1 gt mjd_start[i] and mjd_t1 le mjd_stop[i]) then istart=i
     if(mjd_t2 gt mjd_start[i] and mjd_t2 le mjd_stop[i]) then begin
        istop=i
     endif
     if(mjd_t1 le mjd_start[i] and mjd_t2 gt mjd_stop[i]) then begin
        if(icover ge 0) then begin
           print,' *** WARNING: Multiple cover case, logic not defined, skip... ***'
           print
           push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
           return,(shift+texp)
        endif
        icover=i
     endif
  endfor

  ;;print,'session index: ',istart,istop

  ;;
  ;; case when start of observation falls in the ground session (or both):
  ;;
  ;;    |------|            |------|       (ground contact)
  ;;      ^......^            ^..^         (observation)
  ;;
  if((istart ge 0 and istop lt 0) or (istart ge 0 and istop ge 0)) then begin
     print,seance_name[istart],seance_id[istart],' --> case 1: when start of observation falls in the ground session (or both)'
     print,'--> shift observation to the end of the ground session'
     print
     shift+=(mjd_stop[istart]-mjd_t1)*d2m
     print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
     print,'||',obsid,' ',start,' ',stop
  endif

  ;;
  ;; case when end of observation falls in the ground session or fully
  ;; covers ground session:
  ;;
  ;;   ttt|------|         ttt|------|      (ground contact)
  ;;   ^......^            ^............^   (observation)
  ;;
  ;; 'ttt' shows tolerance time
  ;;
  ;; Note that logic for multiple cover case shown below is not
  ;; defined (needs triple division, or more):
  ;;
  ;;      |------|            |------|         (ground contact)
  ;;   ^....................................^  (observation)
  ;;
  if((istart lt 0 and istop ge 0) or icover ge 0) then begin
     print,'[seance]',seance_id[istop],' --> case 2: end of observation falls in the ground session'
     mytol=(mjd_start[istop]-mjd_t1)*d2m
     if(mytol lt tol) then begin
        print,'--> shift observation to the end of the ground session'
        print
        shift+=(mjd_stop[istop]-mjd_t1)*d2m
        print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
     endif else begin
        print,'--> divide observation in two parts'
        print
        print_mjd_utc, mjd_obs, shift=shift, texp=mytol, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
        push_table, ra, dec, obsid, start, stop, mytol, roll_angle, sun_x0z_angle, table=table, create=create, target=target
        shift+=(mjd_stop[istop]-mjd_t1)*d2m
        print_mjd_utc, mjd_obs, shift=shift, texp=(texp-mytol), start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
        push_table, ra, dec, obsid, start, stop, (texp-mytol), roll_angle, sun_x0z_angle, table=table, create=create, target=target
        return,(shift+texp-mytol)
     endelse      
  endif
  
  push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
  return,(shift+texp)
end
