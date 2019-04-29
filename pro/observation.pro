function observation,date=date, texp=texp, ra=ra, dec=dec,obsid=obsid, shift=shift, table=table, create=create
  if(n_elements(create) eq 0) then create=0  

  juldate, date, mjd_obs
  
  print_mjd, mjd_obs, shift=shift, texp=texp, start=start, stop=stop

  if(create eq 1) then DELVARX, table
 
  if (n_elements(table) eq 0) then begin
     table={OBSERVATION, ra_pnt:ra, dec_pnt:dec, experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:0.0, sun_x0z_angle:10.0}
  endif else begin
     table=[table, {OBSERVATION, ra_pnt:ra, dec_pnt:dec, experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:0.0, sun_x0z_angle:10.0}]
  endelse

  return,(shift+texp)
end
