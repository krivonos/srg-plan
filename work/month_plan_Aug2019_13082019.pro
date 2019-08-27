pro get_coords, obsid, get_ra=get_ra, get_dec=get_dec
  coords='P_PLAN_190723_617932800_620697600_RK_v05_coord.fits'
  coords_tbl = readfits(coords,coords_hdr,EXTEN_NO=1,/SILENT)
  coords_obsid=TBGET( coords_hdr, coords_tbl, 'EXPERIMENT', /NOSCALE)
  coords_ra=TBGET( coords_hdr, coords_tbl, 'RA', /NOSCALE)
  coords_dec=TBGET( coords_hdr, coords_tbl, 'DEC', /NOSCALE)
  index=where(coords_obsid eq obsid, count)
  if(count ne 1) then message,'Coordinates were not found for'+obsid 
  print,'From ',coords,' use RA=',coords_ra[index[0]],', Dec=',coords_dec[index[0]]
  get_ra=coords_ra[index[0]]
  get_dec=coords_dec[index[0]]
end


pro month_plan_Aug2019_13082019
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop, seance_guid, ra_prev, dec_prev, delta_ra, delta_dec
  @art

  delta_ra=0.0d
  delta_dec=0.0d

  cat_ra_sgra=266.416817d
  cat_dec_sgra=-29.007825d
  
  ;; nominal coordinates:
  cat_ra_cygx1=299.590316d
  cat_dec_cygx1=35.201606d

  cat_ra_cena=201.365063
  cat_dec_cena=-43.019113

  cat_cen_x3_ra_gaia=170.312883d
  cat_cen_x3_dec_gaia=-60.623785d
  ;;ra_cenx3=cen_x3_ra_gaia
  ;;dec_cenx3=cen_x3_dec_gaia

  ;; Rodion coordinates:
  ra_cenx3=170.661729943293d
  dec_cenx3=-60.6112693550916d        

  ra_cygx1=299.787555620090d
  dec_cygx1=35.1428125673076d

  ra_cena=201.570425443922d
  dec_cena=-42.9361227037655d    
  
  npol='RG_MonthPlan_2019-08_v21.txt'
  read_month_plan_npol,npol
  
  fout=make_output_filename(prefix='P',postfix='RK',version='33')
  
  info={INFO, AUTHOR:'Roman Krivonos', EMAIL:'krivonos@cosmos.ru'}


  ;;
  ;; Init UDS field, nominal, original coordinates
  ;; 
  cat_uds=[{ra:34.47838000d, dec:-4.98117d, texp:1380L},$ ;; Field 1 XXX
           {ra:34.77938407d, dec:-4.98117d, texp:1440L},$ ;; Field 2
           {ra:34.62889072d, dec:-4.72136d, texp:1440L},$ ;; Field 3
           {ra:34.32786928d, dec:-4.72136d, texp:1440L},$ ;; Field 4
           {ra:34.17710107d, dec:-4.98117d, texp:1440L},$ ;; Field 5
           {ra:34.32775027d, dec:-5.24098d, texp:1440L},$ ;; Field 6
           {ra:34.62900973d, dec:-5.24098d, texp:1440L}]  ;; Field 7

  cat_uds_center=[{ra:34.47186231d, dec:-4.987422498d}]
  
  cat_uds_rota=[{ra:34.47838000d, dec:-4.98117d},$    ;; Field 1 rota XXX
                {ra:34.73903265d, dec:-4.83124482d},$ ;; Field 2 rota
                {ra:34.47838769d, dec:-4.68118224d},$ ;; Field 3 rota
                {ra:34.21765314d, dec:-4.83113194d},$ ;; Field 4 rota
                {ra:34.21743901d, dec:-5.13124798d},$ ;; Field 5 rota
                {ra:34.47838950d, dec:-5.28118740d},$ ;; Field 6 rota
                {ra:34.73924305d, dec:-5.13113502d}]  ;; Field 7 rota

  ;;
  ;; Rodion corrected coordinates for UDS
  ;;
  uds=[{ra: 34.47838000d, dec: -4.98117d},$ ;; Field 1 XXX
       {ra: 34.93651847d, dec: -4.91085894d},$ ;; Field 2
       {ra: 34.78596554d, dec: -4.65104992d},$ ;; Field 3
       {ra: 34.48494410d, dec: -4.65104992d},$ ;; Field 4
       {ra: 34.33423547d, dec: -4.91085894d},$ ;; Field 5
       {ra: 34.48494754d, dec: -5.17066796d},$ ;; Field 6
       {ra: 34.78620700d, dec: -5.17066796d}]  ;; Field 7
 
  uds_center=[{ra: 34.62899819d, dec: -4.91711141d}]
 
  uds_rota=[{ra: 34.47838000d, dec: -4.98117d},$ ;; Field 1 rota XXX
            {ra: 34.89613227d, dec: -4.76093432d},$ ;; Field 2 rota
            {ra: 34.63545359d, dec: -4.61087231d},$ ;; Field 3 rota
            {ra: 34.37475274d, dec: -4.76082144d},$ ;; Field 4 rota
            {ra: 34.37460933d, dec: -5.06093636d},$ ;; Field 5 rota
            {ra: 34.63559679d, dec: -5.21087521d},$ ;; Field 6 rota
            {ra: 34.89641334d, dec: -5.06082340d}]  ;; Field 7 rota

  
  ra_prev=34.47838000d
  dec_prev=-4.98117d
  ;;
  ;; UDS field 1
  ;;
  date=[2019, 08, 1, 2, 0]
  shift=0.0d
  uds_field=1
  shift=observation(date=date, texp=1380, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102001', shift=shift, table=table, target='UDS field 1/1',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS01')

  ;;
  ;; beta 0
  ;;
  target='Cyg X-1 test scan '
  stem='119100' ;; +000
  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t2min+29, $ ;; -20 take into account slew time from UDS Field 1
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
                   t2min  ] ;; +20

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=0, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=3, ignore_seance=0, $
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

;;  uds_field=1
;;  shift=observation(date=date, texp=536, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102002', shift=shift, table=table, target='UDS field 1/2')

  shift=observation(date=date, texp=536, ra=ra_cena, dec=dec_cena, obsid='11910002001', shift=shift, table=table, target='Cen A test', $
                    cat_ra_obj=cat_ra_cena, cat_dec_obj=cat_dec_cena, object='Cen_A')

  ;;
  ;; beta 45
  ;;
  target='Cyg X-1 test scan '
  stem='119100' ;; +000
  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t2min+29, $ ;; -20 take into account slew time from UDS Field 1
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
                   t2min  ] ;; +20

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=45, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=4, ignore_seance=0, $
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  ;;uds_field=1
  ;;shift=observation(date=date, texp=536, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102003', shift=shift, table=table, target='UDS field 1/3')

  shift=observation(date=date, texp=536, ra=ra_cenx3, dec=dec_cenx3, obsid='11910001012', shift=shift, table=table, target='Cen X-3 revision'$
                    ,cat_ra_obj=cat_cen_x3_ra_gaia,cat_dec_obj=cat_cen_x3_dec_gaia,object='Cen_X3')

  ;;
  ;; beta 90
  ;;
  target='Cyg X-1 PSF scan '
  stem='119100' ;; +000
  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t2min+29, $ ;; -20 take into account slew time from UDS Field 1
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
                   t2min  ] ;; +20

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=90, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=5, ignore_seance=0, $
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  uds_field=1
  shift=observation(date=date, texp=536, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102004', shift=shift, table=table, target='UDS field 1/2',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS01')

  shift=observation(date=date, texp=2220, ra=ra_cena, dec=dec_cena, obsid='11910002002', shift=shift, table=table, target='Cen A NuSTAR',$
                   cat_ra_obj=cat_ra_cena, cat_dec_obj=cat_dec_cena, object='Cen_A')

  ;;
  ;; beta 135, after correction, reset date
  ;;
  date=[2019, 08, 7, 2, 24]
  shift=0.0d

  target='Cyg X-1 PSF scan '
  stem='119100' ;; +000
  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0]

  t1min=44
  t2min=46
  exposures_min = [t2min, $ ;; -20 
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
                   t2min  ] ;; +20

  ra_prev=ra_cygx1
  dec_prev=dec_cygx1
  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=135, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=6, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  ;;uds_field=1
  ;;shift=observation(date=date, texp=512, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102005', shift=shift, table=table, target='UDS field 1/3')

  shift=observation(date=date, texp=512, ra=ra_cena, dec=dec_cena, obsid='11910002003', shift=shift, table=table, target='Cen A low threshold revision 1',$
                    cat_ra_obj=cat_ra_cena, cat_dec_obj=cat_dec_cena, object='Cen_A')

  
  target='Cyg X-1 PSF scan '
  stem='119100' ;; +000
  offset = [-40.0, -30.0, -27.0, -24.0, 24.0, 27.0, 30.0, 40.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t4min, $ ;; -40
                   t3min, $ ;; -30
                   t3min, $ ;; -27
                   t2min, $ ;; -24
                   t2min, $ ;; +24
                   t3min, $ ;; +27
                   t3min, $ ;; +30
                   t4min]   ;; +40
  ;; 0, 45
  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=0, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=7, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=45, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=8, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  ;;uds_field=1
  ;;shift=observation(date=date, texp=560, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102006', shift=shift, table=table, target='UDS field 1/4')
  shift=observation(date=date, texp=560, ra=ra_cena, dec=dec_cena, obsid='11910002004', shift=shift, table=table, target='Cen A low threshold revision 2',$
                    cat_ra_obj=cat_ra_cena, cat_dec_obj=cat_dec_cena, object='Cen_A')

  ;; 90, 135
  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=90, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=9, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=135, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=10, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  ;; stop at 01:00
  uds_field=1
  ;;shift=observation(date=date, texp=560, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102007', shift=shift, table=table, target='UDS field 1/5 seance')
  shift=observation(date=date, texp=560, ra=uds_center[0].ra, dec=uds_center[0].dec, obsid='11900102007', shift=shift, table=table, target='UDS field 1/5 random seance',$
                    cat_ra_obj=cat_uds_center[uds_field-1].ra, cat_dec_obj=cat_uds_center[uds_field-1].dec, object='UDS_MOS02')
  
  uds_field=2
  shift=observation(date=date, texp=660, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102008', shift=shift, table=table, target='UDS field 2/1 +scan window',$
                   cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS03')
  date=[2019, 08, 10, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=480, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102009', shift=shift, table=table, target='UDS field 2/2 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS04')

  ;;
  ;; beta 0
  ;;
  target='Cyg X-1 revision scan '
  stem='119100' ;; +000
  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0, 1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, 18.0, 20.0]

  t1min=45
  t2min=50
  t3min=55
  t4min=60
  exposures_min = [t2min+29, $ ;; -20 take into account slew time from UDS Field 1
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
                   t2min  ] ;; +20

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=0, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=11, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  
  uds_field=3
  ;;date=[2019, 08, 11, 17, 0]
  ;;shift=0.0d
  
  shift=observation(date=date, texp=525, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102010', shift=shift, table=table, target='UDS field 3/1 session',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS05')

  ;; Rodion coordinates
  ra_sgra=266.62233
  dec_sgra=-29.02376

  date=[2019, 08, 12, 1, 30]
  shift=0.0d
  shift=observation(date=date, texp=890, ra=ra_sgra, dec=dec_sgra, obsid='11910014001', shift=shift, table=table, target='Sgr A* flare', relax_time=0, start_with_slew=0,$
                    cat_ra_obj=cat_ra_sgra,cat_dec_obj=cat_dec_sgra,object='Sgr_Astar')

  uds_field=4
  ;;shift=observation(date=date, texp=660, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102012', shift=shift, table=table, target='UDS field 4/1 +scan window')
  date=[2019, 08, 12, 17, 6]
  shift=0.0d
  shift=observation(date=date, texp=474, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102013', shift=shift, table=table, target='UDS field 4/2 rota seance',start_with_slew=0,$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS08')

  ;;
  ;; beta 45
  ;;
  target='Cyg X-1 revision scan '
  stem='119100' ;; +000

  offset = [-20.0, -18.0, -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, 0.0]

  exposures_min = [t2min+29, $ ;; -20 take into account slew time from UDS Field 1
                   t2min, $ ;; -18
                   t1min, $ ;; -15
                   t1min, $ ;; -12
                   t1min, $ ;; -9
                   t1min, $ ;; -7
                   t1min, $ ;; -5
                   t1min, $ ;; -3
                   t1min, $ ;; -1
                   t1min-10]  ;; +0
                   
  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=135, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=12, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  exposures_min = [t2min, $ ;; -20 take into account slew time from UDS Field 1
                   t2min, $ ;; -18
                   t1min, $ ;; -15
                   t1min, $ ;; -12
                   t1min, $ ;; -9
                   t1min, $ ;; -7
                   t1min, $ ;; -5
                   t1min, $ ;; -3
                   t1min, $ ;; -1
                   t1min-10]  ;; +0

  art_make_aster_v6, ra_cygx1, dec_cygx1, key=key, target=target, offset=offset, beta=45, tol=60, $
                     exposures_min=exposures_min, table=table, date=date, stem=stem, shift=shift, startstem=13, ignore_seance=0, relax_time=3,$
                     cat_ra_obj=cat_ra_cygx1, cat_dec_obj=cat_dec_cygx1, object='Cyg_X1'

  
  uds_field=5
  ;;date=[2019, 08, 13, 17, 0]
  ;;shift=0.0d
  shift=observation(date=date, texp=535, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102014', shift=shift, table=table, target='UDS field 5/1 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS09')

  uds_field=6
  shift=observation(date=date, texp=660, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102015', shift=shift, table=table, target='UDS field 6/1 +scan window',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS11')
  date=[2019, 08, 14, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=480, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102016', shift=shift, table=table, target='UDS field 6/2 rota seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS12')


  uds_field=7
  shift=observation(date=date, texp=60, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102017', shift=shift, table=table, target='UDS field 7/1',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS14')

;; nominal coordinates
;;  gc=[{ra: 266.58787d, dec: -28.72842d},$       ;; Gal1: 1E 1743.1-2843
;;      {ra: 266.416817d, dec: -29.007825d},$     ;; Gal2: Sgr A*
;;      {ra: 266.2710443d, dec: -29.21621671d},$  ;; Gal3
;;      {ra: 266.0911698d, dec: -29.47198082d},$  ;; Gal4
;;      {ra: 265.978460d, dec: -29.745170d}]      ;; Gal5: 1E 1740.7-294

  ;; Igor coordinates
  gc=[{ra:266.760437d, dec:-28.610603d}, $      ;; 0.029521      Gal1 : 1E 1743.1-2843
      {ra: 266.589478d, dec:-28.888767d},$      ;; 0.029782      Gal2 : SGR A*
      {ra: 266.443817d, dec:-29.097004d},$      ;; 0.030087      Gal3 
      {ra: 266.264038d, dec:-29.352583d},$      ;; 0.031660      Gal4 
      {ra: 266.151855d, dec:-29.626318d}]       ;; 0.028860      Gal5 : 1E 1740.7-294
  
  date=[2019, 08, 15, 2, 40]
  shift=0.0d
  ;;gal=1
  ;;shift=observation(date=date, texp=188, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910015001', shift=shift, table=table, relax_time=0, start_with_slew=0, target='GC1: 1E 1743.1-2843')
  gal=2
  shift=observation(date=date, texp=860, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910014002', shift=shift, table=table, relax_time=0, start_with_slew=0, target='Sgr A* monitoring 1',$
                    cat_ra_obj=cat_ra_sgra,cat_dec_obj=cat_dec_sgra,object='Sgr_Astar')
  ;;gal=3
  ;;shift=observation(date=date, texp=188, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910016001', shift=shift, table=table,relax_time=3, target='GC3')
  ;;gal=4
  ;;shift=observation(date=date, texp=188, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910017001', shift=shift, table=table, relax_time=3,target='GC4')
  date=[2019, 08, 15, 17, 6]
  shift=0.0d
  gal=5
  shift=observation(date=date, texp=(60+14), ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910015001', shift=shift, table=table, relax_time=0, start_with_slew=0,target='1E 1740.7-294 INTEGRAL',$
                    cat_ra_obj=265.978460d, cat_dec_obj=-29.745170d, object='1E1740d7m2942')

  ;; 15.08 19:00 - 16.08 01.00 UDS
  uds_field=7
  date=[2019, 08, 15, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=420, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102018', shift=shift, relax_time=0, start_with_slew=0, table=table, target='UDS field 7/2 seance',$
                   cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS13')

  date=[2019, 08, 16, 2, 40]
  shift=0.0d
  gal=2
  shift=observation(date=date, texp=860, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910014003', shift=shift, table=table, relax_time=0, start_with_slew=0, target='Sgr A* monitoring 2',$
                    cat_ra_obj=cat_ra_sgra,cat_dec_obj=cat_dec_sgra,object='Sgr_Astar')
  gal=1
  shift=observation(date=date, texp=80, ra=gc[gal-1].ra, dec=gc[gal-1].dec, obsid='11910016001', shift=shift, table=table,  target='1E 1743.1-2843',$
                   cat_ra_obj=266.58787d, cat_dec_obj=-28.72842d, object='1E1743d1m2843')

  ;; 15.08 19:00 - 16.08 01.00 UDS
  uds_field=7
  date=[2019, 08, 16, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=380, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102019', shift=shift, relax_time=0, start_with_slew=0, table=table, target='UDS field 7/3 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS14')

  
  ;; *** *** *** ***
  ;;uds_field=7
  ;;date=[2019, 08, 16, 17, 0]
  ;;shift=0.0d
  ;;shift=observation(date=date, texp=480, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102019', shift=shift, table=table, target='UDS field 7/3 rota seance')


  uds_field=7
  date=[2019, 08, 17, 14, 42]
  shift=0.0d
  shift=observation(date=date, texp=108, ra=299.59d, dec=35.2d, obsid='00013002001', shift=shift, table=table, relax_time=0, start_with_slew=0, target='Cyg X-1 00003002001',$
                   cat_ra_obj=299.59d, cat_dec_obj=35.2d, object='Cyg_X1')

  uds_field=7
  date=[2019, 08, 17, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=150, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102020', shift=shift, table=table, relax_time=0, start_with_slew=0, target='UDS field 7/4 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS14')

  uds_field=7
  date=[2019, 08, 18, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102021', shift=shift, table=table, target='UDS field 7/5 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS14')

  uds_field=7
  date=[2019, 08, 19, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102022', shift=shift, table=table, target='UDS field 7/6 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS14')

  uds_field=7
  date=[2019, 08, 20, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102023', shift=shift, table=table, target='UDS field 7/7 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS13')

  date=[2019, 08, 21, 15, 25]
  shift=0.0d
  ;; Catalog
  ;;grs_ra=264.368252d
  ;;grs_dec=-29.133921d
  ;; Igor
  grs_ra=264.52014d0
  grs_dec=-28.994937d0
  shift=observation(date=date, texp=175, ra=grs_ra, dec=grs_dec, obsid='11910019001', shift=shift, table=table,relax_time=0, start_with_slew=0, target='GRS 1734-292 historic',$
                    cat_ra_obj=264.368252d, cat_dec_obj=-29.133921d, object='GRS_1734m292')

  uds_field=6
  date=[2019, 08, 21, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=420, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102024', shift=shift, table=table, relax_time=0, start_with_slew=0, target='UDS field 6/3 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS11')

  
  date=[2019, 08, 22, 2, 40]
  shift=0.0d
  ;;sgrb2_ra=266.835d
  ;;sgrb2_dec=-28.3853d
  ;; Igor:
  sgrb2_ra=266.98369d
  sgrb2_dec=-28.244566d
  shift=observation(date=date, texp=360, ra=sgrb2_ra, dec=sgrb2_dec, obsid='11910018001', shift=shift, table=table, relax_time=0, start_with_slew=0, target='Sgr B2',$
                    cat_ra_obj=266.835d, cat_dec_obj=-28.3853d, object='Sgr_B2')

  ;; cat
  ;;sgra_ra=266.416817d
  ;;sgra_dec=-29.007825d      
  sgra_ra=266.56612d
  sgra_dec=-28.866865d
  shift=observation(date=date, texp=580, ra=sgra_ra, dec=sgra_dec, obsid='11910014004', shift=shift, table=table, target='Sgr A* monitoring 3',$
                    cat_ra_obj=cat_ra_sgra,cat_dec_obj=cat_dec_sgra,object='Sgr_Astar')
  
  uds_field=5
  date=[2019, 08, 22, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=150, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102025',$
                    shift=shift, table=table, relax_time=0, start_with_slew=0, target='UDS field 5/2 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS10')

  uds_field=5
  date=[2019, 08, 23, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=285, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102026', shift=shift, table=table, target='UDS field 5/3 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS09')
  
  uds_field=5
  date=[2019, 08, 24, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=285, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102027', shift=shift, table=table, target='UDS field 5/4 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS10')

  uds_field=5
  date=[2019, 08, 25, 17, 0]
  shift=0.0d
  shift=observation(date=date, texp=285, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102028', shift=shift, table=table, target='UDS field 5/5 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS09')

  uds_field=5
  date=[2019, 08, 26, 18, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102029', shift=shift, table=table, target='UDS field 5/6 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS10')

  uds_field=5
  date=[2019, 08, 27, 18, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102030', shift=shift, table=table, target='UDS field 5/7 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS09')
  
  uds_field=5
  date=[2019, 08, 28, 18, 0]
  shift=0.0d
  shift=observation(date=date, texp=270, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102031', shift=shift, table=table, target='UDS field 5/8 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS10')

  date=[2019, 08, 29, 13, 8]
  shift=0.0d
  ;; cat
  ;;crab_ra=83.63308d
  ;;crab_dec=22.0145d
  ;; Igor v1
  ;;crab_ra=83.785735d     
  ;;crab_dec=22.144617d

  ;; Igor v2
  crab_ra=83.796684d0     
  crab_dec=22.129052d0
  shift=observation(date=date, texp=332, ra=crab_ra, dec=crab_dec, obsid='11910017001', shift=shift, table=table, relax_time=0, start_with_slew=0, target='Crab',$
                    cat_ra_obj=83.63308d, cat_dec_obj=22.0145d, object='Crab')

  uds_field=3
  date=[2019, 08, 29, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=400, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102032', shift=shift, table=table, target='UDS field 3/2 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS06')

  uds_field=3
  date=[2019, 08, 30, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=400, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102033', shift=shift, table=table, target='UDS field 3/3 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS05')

  uds_field=3
  date=[2019, 08, 31, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=400, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102034', shift=shift, table=table, target='UDS field 3/4 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS06')

  uds_field=3
  date=[2019, 09, 1, 19, 0]
  shift=0.0d
  shift=observation(date=date, texp=400, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102035', shift=shift, table=table, target='UDS field 3/5 seance',$
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS05')

  uds_field=3
  date=[2019, 09, 2, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=370, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102036', relax_time=0, start_with_slew=0,$
                    shift=shift, table=table, target='UDS field 3/6 rota seance',$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS06')

  
  print,'*** *** ***'
  
  ;; extra pointings after scans:
  list=['P_PLAN_190722_619338660_619371096_ILv1.fits', $
        ;;'P_PLAN_190719_619338660_619371096_ILv1.fits', $ dublicated Cyg X-1
        'P_PLAN_190719_619392600_619455297_ILv1.fits', $
        'P_PLAN_190719_619479000_619541540_ILv1.fits', $
        'P_PLAN_190719_619565400_619627632_ILv1.fits', $
        'P_PLAN_190719_619651800_619714032_ILv1.fits', $
        'P_PLAN_190719_619824600_619887140_ILv1.fits', $
        'P_PLAN_190719_619911000_619977632_ILv1.fits', $
        'P_PLAN_190719_619997400_620064032_ILv1.fits', $
        'P_PLAN_190719_620083800_620150432_ILv1.fits', $
        'P_PLAN_190719_620170200_620236832_ILv1.fits', $
        'P_PLAN_190719_620256600_620323232_ILv1.fits', $
        'P_PLAN_190719_620343000_620409632_ILv1.fits', $
        ;;'P_PLAN_190722_619306200_619338635_ILv1.fits', $ remove template 42 as Igor said
        'P_PLAN_190722_620429400_620487356_ILv1.fits', $
        'P_PLAN_190722_620515800_620573756_ILv1.fits', $
        'P_PLAN_190722_620602200_620660156_ILv1.fits', $
        'P_PLAN_190722_620688600_620746556_ILv1.fits']

  ;; 
  list=[$;;'plan_300719/P_PLAN_190730_619319999_619352435_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_619352459_619368018_ILv3.fits']  
        ;;'plan_300719/P_PLAN_190730_620175600_620242232_ILv3.fits', $  
        ;;'plan_300719/P_PLAN_190730_620262000_620328632_ILv3.fits', $  
        ;; ;; ;;'plan_300719/P_PLAN_190730_620348400_620398374_ILv3.fits'] 
        ;;'plan_300719/P_PLAN_190730_620439600_620497556_ILv3.fits', $  
        ;;'plan_300719/P_PLAN_190730_620526000_620583956_ILv3.fits', $  
        ;;'plan_300719/P_PLAN_190730_620612400_620670356_ILv3.fits', $  
        ;;'plan_300719/P_PLAN_190730_620698800_620756756_ILv3.fits']  

  

  for i=0L, n_elements(list)-1 do begin
     print,list[i]
     tbl = readfits('../../month/'+list[i],Header,EXTEN_NO=1,/SILENT)
     start=TBGET( header, tbl, 'START', /NOSCALE)
     stop=TBGET( header, tbl, 'STOP', /NOSCALE)
     template=TBGET( header, tbl, 'TEMPLATE', /NOSCALE)
     field_name=TBGET( header, tbl, 'FIELD_NAME', /NOSCALE)
     experiment=TBGET( header, tbl, 'EXPERIMENT', /NOSCALE)
     j=n_elements(template)-1
     ;;for j=0L,ilast-1 do begin
     print,'--> ',template[j],' ',start[j],' -- ',stop[j],' *** ', experiment[j],' *** ',field_name[j]
     scan_mjd_start = DATE_CONV( start[j], 'MODIFIED')
     scan_mjd_stop = DATE_CONV( stop[j], 'MODIFIED')
     print,scan_mjd_start,scan_mjd_stop,f='(2f15.5)'
     ;;endfor
     bin = Value_Locate(mjd_start, scan_mjd_stop, /L64)

     if(bin eq (n_elements(mjd_start)-1)) then begin
        print,'*** SKIP LAST SCAN ***'
        continue
     endif
     
     dur=mjd_start[bin+1]-scan_mjd_stop
     print,'npol --> ',seance_id[bin+1],mjd_start[bin+1],dur*24,'hr',f='(a,i4,2f15.5,a)'

     ;; calculate date for observation
     CALDAT, scan_mjd_stop+JD_SHIFT, Month , Day , Year , Hour , Minute , Second
     date=[Year, Month, Day, Hour, Minute+5.0] ;; add 5 minutes to the start
     obsid = repstr( experiment[j], '0000', '0001' )
     get_coords, obsid, get_ra=get_ra, get_dec=get_dec
     ra_prev=get_ra
     dec_prev=get_dec
     ;;shift=observation(date=date, texp=dur*24*60 - 34, ra=get_ra, dec=get_dec, obsid=obsid, shift=0.0d, table=table, target=field_name[j]+' '+experiment[j])
  endfor


  
  write_plan,filename=fout, table=table, title='August 2019', info=info
  return
  
  list=['plan_300719/P_PLAN_190730_619319999_619352435_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_619352459_619368018_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620175600_620242232_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620262000_620328632_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620348400_620398374_ILv3.fits', $
        'plan_300719/P_PLAN_190730_620439600_620497556_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620526000_620583956_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620612400_620670356_ILv3.fits', $  
        'plan_300719/P_PLAN_190730_620698800_620756756_ILv3.fits']  

  for i=0L, n_elements(list)-1 do begin
     print,list[i]
     tbl = readfits('../../month/'+list[i],Header,EXTEN_NO=1,/SILENT)
     start=TBGET( header, tbl, 'START', /NOSCALE)
     stop=TBGET( header, tbl, 'STOP', /NOSCALE)
     template=TBGET( header, tbl, 'TEMPLATE', /NOSCALE)
     field_name=TBGET( header, tbl, 'FIELD_NAME', /NOSCALE)
     experiment=TBGET( header, tbl, 'EXPERIMENT', /NOSCALE)
     j=n_elements(template)-1
     print,'--> ',template[j],' ',start[j],' -- ',stop[j],' *** ', experiment[j],' *** ',field_name[j]
  endfor  
end
