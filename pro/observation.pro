function observation,date=date, texp=texp, ra=ra, dec=dec, obsid=obsid, $
                     shift=shift, table=table, create=create, tol=tol, $
                     roll_angle=roll_angle, sun_x0z_angle=sun_x0z_angle, $
                     target=target, ignore_seance=ignore_seance, ignore_correction=ignore_correction, relax_time=relax_time
  @art
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop, seance_guid, ra_prev, dec_prev, delta_ra, delta_dec


  if(n_elements(target) eq 0) then target=''  
  if(n_elements(relax_time) eq 0) then relax_time=5  
  if(n_elements(ignore_seance) eq 0) then ignore_seance=1  
  if(n_elements(ignore_correction) eq 0) then ignore_correction=0  
  if(n_elements(roll_angle) eq 0) then roll_angle=0.0d  
  if(n_elements(sun_x0z_angle) eq 0) then sun_x0z_angle=0.0d  
  if(n_elements(create) eq 0) then create=0  
  if(n_elements(tol) eq 0) then tol=60 ;; tolerance in minutes

  GCIRC, 2, ra, dec, ra_prev, dec_prev, dist_arcsec
  print, ra, dec, ra_prev, dec_prev,format='(4f18.6)'
  ;;print,'*** Angular offset from previous target, deg:',(dist_arcsec/60./60.)

  ;;art=LONARR(art_strip_num,art_strip_num)
  ;;art_make_header, ra, dec, roll_angle, astr=astr, hdr=hdr, bitpix=3
  ;;writefits, obsid+'.img',art,hdr

  ;;openw,reg,obsid+'_nominal.reg',/get_lun
  ;;printf,reg, 'fk5;circle(',ra,',',dec,',',art_pix/2,') # text={'+target+'}',format='(a,f16.8,a,f16.8,a,f8.2,a)'
  ;;close,reg
  ;;free_lun,reg

    
  slew_min=ceil((dist_arcsec/60./60.)/speed_deg_in_sec/60.)+relax_time
  texp_in=texp
  
  ;; shift by slew time: 
  ;; shift+=slew_min

  IF(slew_min ge texp) then message,'Required slew time is greater than exposure'
  IF((slew_min/texp) gt 0.5) then begin
     print,'*** WARNING: Required slew time is greater than half of exposure time', String(7B)
  endif
  ;; cut exposure time: 
  shift+=slew_min
  texp-=slew_min

  
  ;;print,'*** Required time for slew, min:',slew_min
  ;;print,'Using tolerance = ',tol

  juldate, date, mjd_obs
  ;; correct MJD by 0.5 to be consistent with HEASARC
  ;; https://heasarc.gsfc.nasa.gov/cgi-bin/Tools/xTime/xTime.pl
  mjd_obs-=0.5
  ;;print,mjd_obs,format='(f16.8)'
    
  print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
  print,'>>',obsid,' ',start,' ',stop,' ',target,', texp: ',string(texp,' /',texp_in,format='(I5,a,I5)'),', slew:',string(slew_min,format='(I3)'),' min'

  if(ignore_seance eq 1 and ignore_correction eq 1) then begin
     ;;print,'*** ignore all ***'
     push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
     ra_prev=ra
     dec_prev=dec
     return,(shift+texp)
  endif
  
  istart=-1L
  istop=-1L
  icover=-1L
  for i=0L, n_elements(mjd_start)-1 do begin
     if(mjd_t1 gt mjd_start[i] and mjd_t1 le mjd_stop[i]) then istart=i
     if(mjd_t2 gt mjd_start[i] and mjd_t2 le mjd_stop[i]) then istop=i
     
;;     if(mjd_t1 le mjd_start[i] and mjd_t2 gt mjd_stop[i]) then begin
;;        if(icover ge 0) then begin
;;           print,' *** WARNING: Multiple cover case, logic not defined, skip... ***'
;;           print
;;           push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
;;           return,(shift+texp)
;;        endif
;;        icover=i
;;     endif
  endfor

  if(istart ge 0) then begin
     if((ignore_correction eq 1 and seance_name[istart] eq '[correction]') or $
        (ignore_seance eq 1 and seance_name[istart] eq '[seance]')) then begin
        print,' *** ignore *** ',seance_name[istart],seance_id[istart]
        push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
        ra_prev=ra
        dec_prev=dec
        return,(shift+texp)
     endif
  endif

  if(istop ge 0) then begin
     if((ignore_correction eq 1 and seance_name[istop] eq '[correction]') or $
        (ignore_seance eq 1 and seance_name[istop] eq '[seance]')) then begin
        print,' *** ignore *** ',seance_name[istop],seance_id[istop]
        push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
        ra_prev=ra
        dec_prev=dec
        return,(shift+texp)
     endif
  endif
  
  ;;print,'session index: ',istart,istop

  ;;
  ;; case when start of observation falls in the ground session (or both):
  ;;
  ;;    |------|            |------|       (ground contact)
  ;;      ^......^            ^..^         (observation)
  ;;
  if((istart ge 0 and istop lt 0) or (istart ge 0 and istop ge 0)) then begin
     print,seance_name[istart],seance_id[istart],' --> case 1: when start of observation falls in the ground session (or both)'
     print,'--> shift observation to the end of ',seance_name[istart],seance_id[istart]
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
     print,seance_name[istop],seance_id[istop],' --> case 2: end of observation falls in the ground session'
     mytol=(mjd_start[istop]-mjd_t1)*d2m
     if(mytol lt tol) then begin
        print,'--> tolerance ',mytol
        print,'--> shift observation to the end of ',seance_name[istop],seance_id[istop]
        print
        shift+=(mjd_stop[istop]-mjd_t1)*d2m
        print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
     endif else begin
        print,'--> tolerance ',mytol
        print,'--> divide observation in two parts'
        print
        print_mjd_utc, mjd_obs, shift=shift, texp=mytol, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
        push_table, ra, dec, obsid, start, stop, mytol, roll_angle, sun_x0z_angle, table=table, create=create, target=target
        shift+=(mjd_stop[istop]-mjd_t1)*d2m
        print_mjd_utc, mjd_obs, shift=shift, texp=(texp-mytol), start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2
        push_table, ra, dec, obsid, start, stop, (texp-mytol), roll_angle, sun_x0z_angle, table=table, create=create, target=target
        ra_prev=ra
        dec_prev=dec
        return,(shift+texp-mytol)
     endelse      
  endif
  
  push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target
  ra_prev=ra
  dec_prev=dec
  return,(shift+texp)
end
