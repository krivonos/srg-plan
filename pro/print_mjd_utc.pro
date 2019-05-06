pro print_mjd_utc, mjd_obs, shift=shift, texp=texp, start=start, stop=stop, mjd_t1=mjd_t1, mjd_t2=mjd_t2

  @art
  
  mjd_t1 = shift*m2d + mjd_obs
  mjd_t2 = shift*m2d + mjd_obs + texp*m2d
  
 
  CALDAT, mjd_t1 + 2400000.5, t1_Month , t1_Day , t1_Year , t1_Hour , t1_Minute , t1_Second
  start = TIMESTAMP(YEAR = t1_Year, MONTH = t1_Month, $
                               DAY = t1_Day, HOUR = t1_Hour, MINUTE = t1_Minute, SECOND = round(t1_Second), OFFSET=MSK)

  
  CALDAT, mjd_t2 + 2400000.5, t2_Month , t2_Day, t2_Year , t2_Hour , t2_Minute , t2_Second
  stop = TIMESTAMP(YEAR = t2_Year, MONTH = t2_Month, $
                               DAY = t2_Day, HOUR = t2_Hour, MINUTE = t2_Minute, SECOND = round(t2_Second), OFFSET=MSK)
                
end
