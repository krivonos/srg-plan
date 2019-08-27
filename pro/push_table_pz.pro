pro push_table_pz, ra, dec, obsid, start, stop, table=table, q1=q1, q2=q2, q3=q3, q4=q4, start_npol=start_npol, stop_npol=stop_npol, load_stamp=load_stamp, $
                   mjd_start=mjd_start, mjd_stop=mjd_stop,$
                   obt_start=obt_start, obt_stop=obt_stop
 
  if (n_elements(table) eq 0) then begin
     table={PZ, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, q1:q1, q2:q2, q3:q3, q4:q4, start_npol:start_npol, stop_npol:stop_npol,load_stamp:load_stamp, mjd_start:double(mjd_start), mjd_stop:double(mjd_stop),obt_start:double(obt_start), obt_stop:double(obt_stop)}
  endif else begin
     table=[table, {PZ, ra:double(ra), dec:double(dec), experiment:obsid, start:start, stop:stop, q1:q1, q2:q2, q3:q3, q4:q4, start_npol:start_npol, stop_npol:stop_npol,load_stamp:load_stamp, mjd_start:double(mjd_start), mjd_stop:double(mjd_stop),obt_start:double(obt_start), obt_stop:double(obt_stop)}]
  endelse
end
