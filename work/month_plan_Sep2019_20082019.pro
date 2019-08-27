

pro month_plan_Sep2019_20082019
  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop, seance_guid, ra_prev, dec_prev, delta_ra, delta_dec
  @art


  cat_ra_sgra=266.416817d
  cat_dec_sgra=-29.007825d
  

  npol='RG_MonthPlan_2019-09_v04.txt'
  read_month_plan_npol,npol
  
  fout=make_output_filename(prefix='P',postfix='RK',version='04')
  
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
  
  uds_field=3
  date=[2019, 09, 1, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=370, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102035', $
                    shift=shift, table=table, target='UDS field 3',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS05')

  uds_field=3
  date=[2019, 09, 2, 18, 40]
  shift=0.0d
  shift=observation(date=date, texp=350, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102036', $
                    shift=shift, table=table, target='UDS field 3 rota',relax_time=0, start_with_slew=0,$
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS06')

  ;; September planning starts here

  uds_field=4
  date=[2019, 09, 3, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102037', $
                    shift=shift, table=table, target='UDS field 4',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS07')
  
  uds_field=4
  date=[2019, 09, 4, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102038', $
                    shift=shift, table=table, target='UDS field 4',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS07')

  uds_field=2
  date=[2019, 09, 5, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102039', $
                    shift=shift, table=table, target='UDS field 2',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS03')

  uds_field=2
  date=[2019, 09, 6, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102040', $
                    shift=shift, table=table, target='UDS field 2 rota',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS04')

  uds_field=4
  date=[2019, 09, 7, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102041', $
                    shift=shift, table=table, target='UDS field 4 rota',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS08')

  uds_field=6
  date=[2019, 09, 8, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102042', $
                    shift=shift, table=table, target='UDS field 6 rota',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS12')


  
;;  uds_field=7
;;  date=[2019, 09, 9, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=360, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102043', $
;;                    shift=shift, table=table, target='UDS field 7',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS13')

  ;; the original position between sources: 195.59226      -63.903639
  date=[2019, 09, 9, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=195.99735d, dec=-63.970215d, obsid='11910020001', $
                    shift=shift, table=table, target='PSRB1259 and 2RXPJ130159 seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=195.698559d, cat_dec_obj=-63.835729d, object='PSR_B1259m63')

  

;;  uds_field=2
;;  date=[2019, 09, 10, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=370, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102044', $
;;                    shift=shift, table=table, target='UDS field 2',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS03')

  date=[2019, 09, 10, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=228.84419d, dec=-59.098101d, obsid='11910021001', $
                    shift=shift, table=table, target='PSR 1509-58 seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=228.48133d, cat_dec_obj=-59.13578d, object='PSR_1509m58')

  
;;  uds_field=2
;;  date=[2019, 09, 11, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=370, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102045', $
;;                    shift=shift, table=table, target='UDS field 2 rota',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS04')

  date=[2019, 09, 11, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=213.74534d, dec=-65.354362d, obsid='11910022001', $
                    shift=shift, table=table, target='Circinus galaxy seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=213.291275d, cat_dec_obj=-65.339019d, object='Circinus')
  
;;  uds_field=3
;;  date=[2019, 09, 12, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=370, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102046', $
;;                    shift=shift, table=table, target='UDS field 3 rota',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS06')

  
  date=[2019, 09, 12, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=238.06981d, dec=-56.415199d, obsid='11910023001', $
                    shift=shift, table=table, target='XTE J1550-564 seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=237.744384d, cat_dec_obj=-56.476475d, object='XTE_J1550m564')

;;  uds_field=4
;;  date=[2019, 09, 13, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=370, ra=uds_rota[uds_field-1].ra, dec=uds_rota[uds_field-1].dec, obsid='11900102047', $
;;                    shift=shift, table=table, target='UDS field 4 rota',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds_rota[uds_field-1].ra, cat_dec_obj=cat_uds_rota[uds_field-1].dec, object='UDS_MOS08')

  date=[2019, 09, 13, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=237.31571d, dec=-45.413502d, obsid='11910024001', $
                    shift=shift, table=table, target='NY lup seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=237.060817d, cat_dec_obj=-45.477755d, object='NY_lup')

  
;;  uds_field=2
;;  date=[2019, 09, 14, 18, 30]
;;  shift=0.0d
;;  shift=observation(date=date, texp=370, ra=uds[uds_field-1].ra, dec=uds[uds_field-1].dec, obsid='11900102048', $
;;                    shift=shift, table=table, target='UDS field 7',relax_time=0, start_with_slew=0, $
;;                    cat_ra_obj=cat_uds[uds_field-1].ra, cat_dec_obj=cat_uds[uds_field-1].dec, object='UDS_MOS13')

  date=[2019, 09, 14, 18, 30]
  shift=0.0d
  shift=observation(date=date, texp=360, ra=228.84717d, dec=-59.106527d, obsid='11910021002', $
                    shift=shift, table=table, target='PSR 1509-58 seance',relax_time=0, start_with_slew=0, $
                    cat_ra_obj=228.48133d, cat_dec_obj=-59.13578d, object='PSR_1509m58')

  write_plan,filename=fout, table=table, title='September 2019', info=info
  
end
