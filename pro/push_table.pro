pro push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target

  if(create eq 1) then DELVARX, table
  
  if (n_elements(table) eq 0) then begin
     table={OBSERVATION, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:double(roll_angle), sun_xoz_angle:double(sun_x0z_angle), target:target}
  endif else begin
     table=[table, {OBSERVATION, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:double(roll_angle), sun_xoz_angle:double(sun_x0z_angle), target:target}]
  endelse
end
