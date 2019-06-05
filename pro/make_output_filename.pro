function make_output_filename,prefix=prefix,postfix=postfix,version=version

  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop
  COMMON IKI, iki_version

  iki_version=version
    
  start = STRSPLIT(hdr_start, '.', /EXTRACT)
  dd_start = start[0]
  mm_start = start[1]
  yy_start = start[2]

  stop = STRSPLIT(hdr_stop, '.', /EXTRACT)
  dd_stop = stop[0]
  mm_stop = stop[1]
  yy_stop = stop[2]

  timezero = JULDAY(1, 1, 2000, 0, 0, 0)
  jd_start = JULDAY(fix(mm_start), fix(dd_start), fix(yy_start), 0, 0, 0)
  jd_stop  = JULDAY(fix(mm_stop), fix(dd_stop), fix(yy_stop), 0, 0, 0)
  dt1 = (jd_start - timezero)*86400L
  dt2 = (jd_stop  - timezero)*86400L
  
  ;; filename for output
  ;; P_PLAN_190122_613105205_617231359_<POSTFIX>.fits
  jd_today=SYSTIME(/JULIAN, /UTC)
  CALDAT, jd_today, Month , Day , Year , Hour , Minute , Second
  yr=String(year,format='(i04)')
  dt=(jd_today-timezero)*86400
  
  fout=prefix+'_PLAN_'+STRMID(yr, 2, 2)+String(Month,format='(i02)')+String(Day,format='(i02)')+'_'+$
       String(dt1,format='(i09)')+'_'+String(dt2,format='(i09)')+'_'+postfix+'.fits'
  print
  print,'Output filename: ',fout
  print
  return, fout
end

;; T_PLAN_DATE_TSTART_TSTOP.fits 
;;
;; where:
;;
;; TSTART, TSTOP:   time period covered by planning file in seconds (nine digits) counted
;;                                          from 2000-01-01 00:00:00 MSK
;; DATE:                            date of last update, written as yymmdd
;; <T>:                               type indicator of file, e.g., "P" for preliminary, "F" for final, "L" for long term.
