pro read_pz, filename, key=key, root=root, table=table, load_date=load_date, zone=zone

  COMMON NPOL, obsid_prev
  @art
  if(n_elements(root) eq 0) then begin 
     root=getenv('SRG_MONTH_PLAN_NPOL')
  endif

  if(n_elements(zone) eq 0) then begin 
     zone='utc'
  endif

  dummy='00000000000'
  
  if(n_elements(key) eq 0) then begin 
     key='EXPERIMENT' 
  endif
  print,filename
  file=root+'/'+filename
  if not (file_test(file)) then message,'PZ not found '+file

  nlines = FILE_LINES(file)
  record = STRARR(nlines)
  OPENR, unit, file,/GET_LUN
  READF, unit, record
  FREE_LUN, unit


  load_stamp = TIMESTAMP(YEAR = load_date[0], MONTH = load_date[1], $
                               DAY = load_date[2], HOUR = load_date[3], MINUTE = load_date[4], SECOND = 0, OFFSET=MSK)

  print,'load ',load_stamp
  if (n_elements(mjd_start) eq 0) then begin
     pz_id=[]
     pz_q1=[]
     pz_q2=[]
     pz_q3=[]
     pz_q4=[]
     pz_start=[]
     pz_stop=[]
     pz_ra=[]
     pz_dec=[]
     pz_mjd_start=[]
     pz_mjd_stop=[]
     pz_experiment=[]
  endif
  id=1L

    ;; remove comments
  sarr=[]
  for i=0L, N_ELEMENTS(record)-1 do begin
     push,sarr,record[i]
     ;;print,record[i]
  endfor



     key='stop' 
  for i=0L, N_ELEMENTS(sarr)-1 do begin

     ;;res = STRCMP(sarr[i], key)
     res = STRPOS(sarr[i], key)
    ;;print,sarr[i], res
     if(res gt 0) then begin
        str_stop=sarr[i]
        str_start=sarr[i-1]
        str_q4=sarr[i-2]
        str_q3=sarr[i-3]
        str_q2=sarr[i-4]
        str_q1=sarr[i-5]

        
        
        p2=strpos(str_q2,'!')
        p3=strpos(str_q3,'!')
        if(p2 gt 0 and p3 gt 0) then begin
           ra_value = STRMID(str_q2, strpos(str_q2,'!')+2)
           dec_value = STRMID(str_q3, strpos(str_q3,'!')+2)
        endif else begin
           ra_value=0.0
           dec_value=0.0
        endelse

        tmp_str_stop=STRTRIM(str_stop,2)
        tmp_stop = STRTRIM(STRMID(tmp_str_stop, strpos(tmp_str_stop,'!')+1),2)
        if(tmp_stop eq 'stop') then begin
           print,'INFO: set dummy obsid ',dummy
           experiment_value = dummy
        endif else begin
           tmp_value = STRMID(str_stop, strpos(str_stop,'=')+2)
           tmp_value2 = STRMID(tmp_value, 0, strpos(tmp_value,'!'))
           experiment_value = STRTRIM(tmp_value2, 2)
        endelse
        

        if not (ISA(obsid_prev, /STRING)) then begin
           obsid_prev=experiment_value
           print,'NOT DEFINED'
        endif else begin
        endelse
        if(obsid_prev eq experiment_value and experiment_value ne dummy) then begin
           print, 'SKIP DUPLICATION ',obsid_prev,' --> ',experiment_value
           continue
        endif
           
        
        stop_value = STRTRIM(STRMID(str_stop, 0, strpos(str_stop,'!')),2)
        start_value = STRTRIM(STRMID(str_start, 0, strpos(str_start,'!')),2)
        
        format_date_pz,start_value,start_day,start_month,start_year,start_hour,start_min,start_sec
        format_date_pz,stop_value,stop_day,stop_month,stop_year,stop_hour,stop_min,stop_sec

        ;;;;;;;;;;;;;;;;;;;;
        ;; CONVERT TO MSK ;;
        ;;;;;;;;;;;;;;;;;;;;
        if (zone eq 'utc') then begin
           juldate, [start_year, start_month, start_day, start_hour+3, start_min], mjd_start_msk
           juldate, [stop_year, stop_month, stop_day, stop_hour+3, stop_min], mjd_stop_msk
           
           juldate, [start_year, start_month, start_day, start_hour, start_min], mjd_start_utc
           juldate, [stop_year, stop_month, stop_day, stop_hour, stop_min], mjd_stop_utc
        endif else if (zone eq 'msk') then begin
           juldate, [start_year, start_month, start_day, start_hour, start_min], mjd_start_msk
           juldate, [stop_year, stop_month, stop_day, stop_hour, stop_min], mjd_stop_msk

           juldate, [start_year, start_month, start_day, start_hour-3, start_min], mjd_start_utc
           juldate, [stop_year, stop_month, stop_day, stop_hour-3, stop_min], mjd_stop_utc
        endif else if (diff lt thres2) then begin
           message,'Time zone is not known: '+zone
        endif

        ;; correct MJD by 0.5 to be consistent with HEASARC
        ;; https://heasarc.gsfc.nasa.gov/cgi-bin/Tools/xTime/xTime.pl
        mjd_start_msk-=0.5d
        mjd_stop_msk-=0.5d

        mjd_start_utc-=0.5d
        mjd_stop_utc-=0.5d


        ;;CALDAT, start+JD_SHIFT, Month , Day , Year , Hour , Minute , Second
        
        ;;push,pz_mjd_start,start
        ;;push,pz_mjd_stop,stop
        ;;push,pz_id,String(id,format='(i03)')
        ;;push,pz_q1,double(str_q1)
        ;;push,pz_q2,double(str_q2)
        ;;push,pz_q3,double(str_q3)
        ;;push,pz_q4,double(str_q4)
        ;;push,pz_ra,double(ra_value)
        ;;push,pz_dec,double(dec_value)
        ;;push,pz_experiment,experiment_value

        print_mjd_msk, mjd_start_msk, shift=0.0d, texp=0L, start=start_msk, stop=tmp
        print_mjd_msk, mjd_stop_msk, shift=0.0d, texp=0L, start=tmp, stop=stop_msk
        
        print_mjd_utc, mjd_start_utc, shift=0.0d, texp=0L, start=start_utc, stop=tmp
        print_mjd_utc, mjd_stop_utc, shift=0.0d, texp=0L, start=tmp, stop=stop_utc

        obt_start=0.0 ;;(start-MJDREF)*86400.0d0
        obt_stop=0.0;;(stop-MJDREF)*86400.0d0
        
        push_table_pz, double(ra_value), double(dec_value), experiment_value, start_msk, stop_msk, $
                       q1=double(str_q1), q2=double(str_q2), q3=double(str_q3), q4=double(str_q4), $
                       table=table, start_npol=start_value, stop_npol=stop_value, load_stamp=load_stamp, $
                       mjd_start=mjd_start_utc, mjd_stop=mjd_stop_utc, $
                       start_utc=start_utc, stop_utc=stop_utc,$
                       obt_start=obt_start, obt_stop=obt_stop, filename=filename
        
        print,'pz',String(id,format='(i03)'),' -> ',start_value,(mjd_start_utc),', ',stop_value,(mjd_stop_utc), ' / ',experiment_value,format='(4a,1x,f12.4,2a,1x,f12.4,2a)'
        id+=1
        obsid_prev=experiment_value
           
     endif
  endfor
end

