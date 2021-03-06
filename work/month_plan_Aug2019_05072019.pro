pro month_plan_Aug2019_05072019

  read_month_plan_npol,'RG_MonthPlan_2019-08_v02.txt', seance_cut=60.
  
  fout=make_output_filename(prefix='P',postfix='RK',version='01')
  
  info={INFO, AUTHOR:'Roman Krivonos', EMAIL:'krivonos@cosmos.ru'}

  ;;
  ;; insert individual Cen X-3 FIRST LIGHT observation RIGHT AFTER correction
  ;;
  ;; [correction]
  ;; GUID = 5613383e-76f7-48e4-ba94-22e2ea60caf4
  ;; START = 11.07.2019 16:07:10
  ;; STOP  = 11.07.2019 19:07:10
  ;; IMPSTART  = 11.07.2019 17:17:10

  date=[2019, 08, 1, 15, 0]
  shift=0.0d
  shift=observation(date=date, texp=1560, ra=170.04282d, dec=-60.75630d, obsid='119100101', shift=shift, table=table, target='Cen X-3 first light')


  
  ;;
  ;; Cen X-3 alignment, right after this seance:
  ;;
  ;; [seance]
  ;; GUID = 71192cbc-621f-4188-a15f-cf19e86960ff
  ;; START = 12.07.2019 17:30:00
  ;; STOP  = 12.07.2019 21:30:00
  ;; STATIONS = Ussur., Baykonur, MeOz

  target='Cen X-3 align.'
  stem='1191001';; root for obsid +00
  date=[2019, 08, 2, 21, 0]
  shift=0.0d
  texp=130L
  grid=[{ra:170.04282d, dec:-60.75630d, texp:texp},$
        {ra:170.04282d, dec:-60.62297d, texp:texp},$
        {ra:170.04282d, dec:-60.48964d, texp:texp},$
        {ra:170.31575d, dec:-60.48964d, texp:texp},$
        {ra:170.31575d, dec:-60.62297d, texp:texp},$
        {ra:170.31575d, dec:-60.75630d, texp:texp},$
        {ra:170.58643d, dec:-60.75630d, texp:texp},$
        {ra:170.58643d, dec:-60.62297d, texp:texp},$
        {ra:170.58643d, dec:-60.48964d, texp:texp}]

  for i=0L, n_elements(grid)-1 do begin
     obsid=String(stem,i+2,format='(a,i02)')
     shift=observation(date=date,ra=grid[i].ra, dec=grid[i].dec, texp=grid[i].texp,  obsid=obsid, shift=shift, table=table, target=target)
  endfor



  ;;
  ;; Init UDS field
  ;; 
  uds=[{ra:34.47838000d, dec:-4.98117d, texp:1440L},$ ;; Field 1
       {ra:34.77938407d, dec:-4.98117d, texp:1440L},$ ;; Field 2
       {ra:34.62889072d, dec:-4.72136d, texp:1440L},$ ;; Field 3
       {ra:34.32786928d, dec:-4.72136d, texp:1440L},$ ;; Field 4
       {ra:34.17710107d, dec:-4.98117d, texp:1440L},$ ;; Field 5
       {ra:34.32775027d, dec:-5.24098d, texp:1440L},$ ;; Field 6
       {ra:34.62900973d, dec:-5.24098d, texp:1440L}]  ;; Field 7

  ;;
  ;; UDS field 1
  ;;
  uds_field=1
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119010201', shift=shift, table=table, target='UDS field 1')

  shift=observation(date=date, texp=1440, ra=201.365063, dec=-43.019113, obsid='119100201', shift=shift, table=table, target='Cen A NuSTAR')


 
  ;; 
  ;; Cyg X-1 aster observation
  ;;

  target='Cyg X-1 PSF calib.'
  stem='119100' ;; +00
  ra=299.5903
  dec=35.2016
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

  art_make_aster_v4, ra, dec, key=key, target=target, offset=offset, beta=45, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=3, ignore_seance=0



  
  ;;
  ;; UDS field 2,3,4,5,6,7
  ;;
  uds_field=2
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100202', shift=shift, table=table, target='UDS field 2')
  uds_field=3
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100203', shift=shift, table=table, target='UDS field 3')
  uds_field=4
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100204', shift=shift, table=table, target='UDS field 4')
  uds_field=5
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100205', shift=shift, table=table, target='UDS field 5')
  uds_field=6
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100206', shift=shift, table=table, target='UDS field 6')
  uds_field=7
  shift=observation(date=date, texp=uds[uds_field-1].texp, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='119100207', shift=shift, table=table, target='UDS field 7')

  write_plan,filename=fout, table=table, title='August 2019', info=info
  return

  

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

