pro print_mjd, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2

  @art
  
  mjd_t1 = shift*m2d + mjd_obs
  mjd_t2 = shift*m2d + mjd_obs + texp*m2d
  
  CALDAT, mjd_t1 + 2400000.5, t1_Month , t1_Day , t1_Year , t1_Hour , t1_Minute , t1_Second
  start=String(t1_Day, '.', t1_Month, '.', t1_Year, t1_Hour, ':', t1_Minute, ':', round(t1_Second), $
                format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
  
  CALDAT, mjd_t2 + 2400000.5, t2_Month , t2_Day , t2_Year , t2_Hour , t2_Minute , t2_Second
  stop=String(t2_Day, '.', t2_Month, '.', t2_Year, t2_Hour, ':', t2_Minute, ':', round(t2_Second), $
                format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
                
end
