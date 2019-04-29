pro print_month_plan,mjd_t1,mjd_t2,print_key,stem,seq,ra,dec,ROLL_ANGLE,SUN_XOZ_ANGLE,month_plan=month_plan,t1_str=t1_str,t2_str=t2_str
  
  CALDAT, mjd_t1 + 2400000., t1_Month , t1_Day , t1_Year , t1_Hour , t1_Minute , t1_Second
  t1_str=String(t1_Day, '.', t1_Month, '.', t1_Year, t1_Hour, ':', t1_Minute, ':', round(t1_Second), $
                format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
        
  CALDAT, mjd_t2 + 2400000., t2_Month , t2_Day , t2_Year , t2_Hour , t2_Minute , t2_Second
  t2_str=String(t2_Day, '.', t2_Month, '.', t2_Year, t2_Hour, ':', t2_Minute, ':', round(t2_Second), $
                format='(i02,a,i02,a,i04,1x,i02,a,i02,a,i02)')
  
  month_plan+=String('//------------------------------------------------------------------')+String(10B)
  month_plan+=String('[observation]')+String(10B)
  month_plan+=String('// '+print_key)+String(10B)
  month_plan+=String('START = '+t1_str)+String(10B)
  month_plan+=String('STOP = '+t2_str)+String(10B)
  month_plan+=String('EXPERIMENT = ',stem,seq,format='(2a,I03)')+String(10B)
  month_plan+=String('RA = ',ra,' // J2000',format='(a,f14.6,a)')+String(10B)
  month_plan+=String('DEC = ',dec,' // J2000',format='(a,f+14.6,a)')+String(10B)
  month_plan+=String('ROLL_ANGLE = ',ROLL_ANGLE,' // Reference value',format='(a,f+14.6,a)')+String(10B)
  month_plan+=String('SUN_XOZ_ANGLE = ',SUN_XOZ_ANGLE,' // Reference value',format='(a,f+14.6,a)')+String(10B)
  month_plan+=String('//------------------------------------------------------------------')+String(10B)
end
