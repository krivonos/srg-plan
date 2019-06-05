pro month_plan_Apr2019_test
  
  read_month_plan_npol,'RG_MonthPlan_2019-04_v01.txt'
  
  fout=make_output_filename(prefix='T',postfix='RK_V1',version='01')
  
  info={INFO, AUTHOR:'Roman Krivonos', EMAIL:'krivonos@cosmos.ru'}

  ;;
  ;; LMC X-4
  ;;
  target='LMC X-4 first light'
  date=[2019, 4, 13, 1, 30]
  shift=0.0d

  texp=1440/3
  shift=observation(date=date, texp=texp*2, ra=83.192083d, dec=-66.3675d, obsid='10011001000', shift=shift, table=table, target='LMC X-4 first light')
  shift=observation(date=date, texp=texp*2, ra=84.911d, dec=-69.746d, obsid='10011001001', shift=shift, table=table, target='LMC X-1')
  shift=observation(date=date, texp=texp, ra=126.029d, dec=-42.997d, obsid='10011001002', shift=shift, table=table, target='Puppis A')
  shift=observation(date=date, texp=texp, ra=6.022329d, dec=-72.081444d, obsid='10011001003', shift=shift, table=table, target='NGC 104')
  shift=observation(date=date, texp=texp, ra=121.595833d, dec=-41.375833d, obsid='10011001004', shift=shift, table=table, target='1RXS J080623.0-412233')
  shift=observation(date=date, texp=texp, ra=89.947466d, dec=-50.447785d, obsid='10011001005', shift=shift, table=table, target='PKS 0558-504')
  shift=observation(date=date, texp=texp, ra=255.9312d, dec=78.7175d, obsid='10011001006', shift=shift, table=table, target='A2256')
  shift=observation(date=date, texp=texp, ra=248.620799d, dec=70.525665d, obsid='10011001007', shift=shift, table=table, target='PG 1634+706')
  shift=observation(date=date, texp=texp, ra=47.980209d, dec=-76.864124d, obsid='10011001008', shift=shift, table=table, target='PKS 0312-770')
  shift=observation(date=date, texp=texp*2, ra=19.291d, dec=-73.447d, obsid='10011001009', shift=shift, table=table, target='SMC X-1')
  shift=observation(date=date, texp=texp, ra=85.04516d, dec=-69.33173d, obsid='10011001010', shift=shift, table=table, target='PSR B0540-69')
  shift=observation(date=date, texp=texp, ra=96.5642d, dec=-53.6811d, obsid='10011001011', shift=shift, table=table, target='A3391')
 
  ;; 
  ;; SMC X-1 aster
  ;;

  target='SMC X-1 PSF calib.'
  stem='10010001'
  ra=19.291
  dec=-73.447
  ;;date=[2019, 07, 14, 21, 30]
  ;;shift=0.0d
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
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift

  write_plan,filename=fout, table=table, info=info

end

