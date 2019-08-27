pro push_table, ra, dec, obsid, start, stop, texp, roll_angle, sun_x0z_angle, table=table, create=create, target=target, cat_ra_obj=cat_ra_obj, cat_dec_obj=cat_dec_obj, object=object
  
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop, seance_guid, ra_prev, dec_prev, delta_ra, delta_dec

  if(create eq 1) then DELVARX, table
  
  if (n_elements(table) eq 0) then begin
     table={OBSERVATION, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:double(roll_angle), sun_xoz_angle:double(sun_x0z_angle), target:target, ra_obj:double(cat_ra_obj), dec_obj:double(cat_dec_obj), object:object}
  endif else begin
     table=[table, {OBSERVATION, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, texp: texp, roll_angle:double(roll_angle), sun_xoz_angle:double(sun_x0z_angle), target:target, ra_obj:double(cat_ra_obj), dec_obj:double(cat_dec_obj), object:object}]
  endelse
end
