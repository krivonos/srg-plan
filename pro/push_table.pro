pro push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create

  if(create eq 1) then DELVARX, table
  
  if (n_elements(table) eq 0) then begin
     table={OBSERVATION, ra:ra, dec:dec, experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:roll_angle, sun_x0z_angle:sun_x0z_angle}
  endif else begin
     table=[table, {OBSERVATION, ra:ra, dec:dec, experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:roll_angle, sun_x0z_angle:sun_x0z_angle}]
  endelse
end
