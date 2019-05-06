pro month_plan_Jul2019

  read_month_plan,'RG_MonthPlan_2019-07_v01.txt', key='[seance]', root='/Users/krivonos/Work/SRG/month'
  read_month_plan,'RG_MonthPlan_2019-07_v01.txt', key='[correction]', root='/Users/krivonos/Work/SRG/month'
  print
  ;; filename for output
  fout='RG_MonthPlan_2019-07_v01.fits'

  info={INFO, PROJECT:'SRG', INSTITUT:'IKI', $
        AUTHOR:'Roman Krivonos', EMAIL:'krivonos@cosmos.ru', $
        START:'01.07.2019', STOP:'02.08.2019',VERSION:'01',PLANNING_TERM:'month'}

  ;; 
  ;; Cyg X-1 aster observation
  ;;

  target='Cyg X-1 PSF calib.'
  stem='10010001'
  ra=299.5903
  dec=35.2016
  date=[2019, 07, 16, 0, 0]
  offset = [-40.0, -30.0, -27.0, -24.0, -20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0, 24.0, 27.0, 30.0, 40.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t4min, $ ;; -40
                   t3min, $ ;; -30
                   t3min, $ ;; -27
                   t2min, $ ;; -24
                   t2min, $ ;; -20
                   t2min, $ ;; -18
                   t1min, $ ;; -15
                   t1min, $ ;; -12
                   t1min, $ ;; -9
                   t1min, $ ;; -7
                   t1min, $ ;; -5
                   t1min, $ ;; -3
                   t1min, $ ;; -1
                   t1min, $ ;; +0
                   t1min, $ ;; +1
                   t1min, $ ;; +3
                   t1min, $ ;; +5
                   t1min, $ ;; +7
                   t1min, $ ;; +9
                   t1min, $ ;; +12
                   t1min, $ ;; +15
                   t2min, $ ;; +18
                   t2min, $ ;; +20
                   t2min, $ ;; +24
                   t3min, $ ;; +27
                   t3min, $ ;; +30
                   t4min]   ;; +40

  art_make_aster_v3, ra, dec, key=key, target=target, offset=offset, beta=45, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem

  
  ;;
  ;; First observation set, Cen X3
  ;;
  target='Cen X-3 align.'
  stem='10011001';; root for obsid +000
  date=[2019, 07, 01, 0, 0]
  grid=[{ra:170.04282d, dec:-60.75630d, texp:120},$
        {ra:170.04282d, dec:-60.62297d, texp:120},$
        {ra:170.04282d, dec:-60.48964d, texp:120},$
        {ra:170.31575d, dec:-60.48964d, texp:120},$
        {ra:170.31575d, dec:-60.62297d, texp:120},$
        {ra:170.31575d, dec:-60.75630d, texp:120},$
        {ra:170.58643d, dec:-60.75630d, texp:120},$
        {ra:170.58643d, dec:-60.62297d, texp:120},$
        {ra:170.58643d, dec:-60.48964d, texp:120}]


  shift=0.0d
  for i=0L, n_elements(grid)-1 do begin
     obsid=String(stem,i+1,format='(a,i03)')
     shift=observation(date=date,ra=grid[i].ra, dec=grid[i].dec, texp=grid[i].texp,  obsid=obsid, shift=shift, table=table, target=target)
  endfor

  ;;
  ;; insert individual observation
  ;; 
  shift=observation(date=date, texp=1440, ra=34.40, dec=-4.98117, obsid='10012001099', shift=shift, table=table, target='Individual target')

  
  ;;
  ;; Second observation set, UDS field
  ;;
  target='UDS field'
  stem='10013001';; + counter 000
  date=[2019, 07, 19, 15, 40]
  grid=[{ra:34.47838000d, dec:-4.98117d, texp:1440L},$
        {ra:34.77938407d, dec:-4.98117d, texp:1440L},$
        {ra:34.62889072d, dec:-4.72136d, texp:1440L},$
        {ra:34.32786928d, dec:-4.72136d, texp:1440L},$
        {ra:34.17710107d, dec:-4.98117d, texp:1440L},$
        {ra:34.32775027d, dec:-5.24098d, texp:1440L},$
        {ra:34.62900973d, dec:-5.24098d, texp:1440L}]
  shift=0.0d
  for i=0L, n_elements(grid)-1 do begin
     obsid=String(stem,i+1,format='(a,i03)')
     shift=observation(date=date, texp=grid[i].texp, ra=grid[i].ra, dec=grid[i].dec, obsid=obsid, shift=shift, table=table, target=target)
  endfor

  write_plan,filename=fout, table=table, title='UDS field survey', info=info

end

