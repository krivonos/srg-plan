pro read_month_plan, filename, key=key, root=root

  COMMON NPOL, mjd_start, mjd_stop, seance_id, seance_name, hdr_start, hdr_stop
  
  if(n_elements(root) eq 0) then begin 
     root=getenv('SRG_MONTH_PLAN_NPOL')
  endif

  if(n_elements(key) eq 0) then begin 
     key='[seance]' 
  endif
  
  file=root+'/'+filename
  if not (file_test(file)) then message,'Month plan not found '+file

  nlines = FILE_LINES(file)
  record = STRARR(nlines)
  OPENR, unit, file,/GET_LUN
  READF, unit, record
  FREE_LUN, unit

  ;; remove comments
  sarr=[]
  for i=0L, N_ELEMENTS(record)-1 do begin
     res = record[i].StartsWith('//') 
     
     if not (res) then begin
     ;;   print,'push ',res,record[i]
        push,sarr,record[i]
     endif
  endfor
  
  if (n_elements(mjd_start) eq 0) then begin
     mjd_start=[]
     mjd_stop=[]
     seance_id=[]
     seance_name=[]
  endif
  id=1L

  ;;
  ;; read header
  ;;
  i0=0L
  hdr_name_STR=sarr[i0]
  HDR_GUID_STR = sarr[i0+1] 
  HDR_PROJECT_STR = sarr[i0+2]
  HDR_PLANNING_TERM_STR = sarr[i0+3]
  HDR_START_STR = sarr[i0+4]
  HDR_STOP_STR  = sarr[i0+5]
  HDR_VERSION_STR = sarr[i0+6]
  HDR_GENTIME_STR = sarr[i0+7]
  HDR_AUTHOR_STR = sarr[i0+8]
  hdr_start = STRMID(hdr_start_str, strpos(hdr_start_str,'=')+2)
  hdr_stop  = STRMID(hdr_stop_str, strpos(hdr_stop_str,'=')+2)

  print
  print,hdr_name_str
  print,hdr_start
  print,hdr_stop
  print
  
  
  for i=0L, N_ELEMENTS(sarr)-1 do begin
     res = STRCMP(sarr[i], key)
     if(res) then begin
        str_name=sarr[i]
        str_guid=sarr[i+1]
        str_start=strtrim(sarr[i+2],1)
        str_stop=sarr[i+3]
        str_stations=sarr[i+4]
        ;;str_comm=sarr[i+5]

        start_value = STRMID(str_start, strpos(str_start,'=')+2)
        stop_value = STRMID(str_stop, strpos(str_stop,'=')+2)

        format_date,start_value,start_day,start_month,start_year,start_hour,start_min,start_sec
        format_date,stop_value,stop_day,stop_month,stop_year,stop_hour,stop_min,stop_sec
        
        juldate, [start_year, start_month, start_day, start_hour, start_min], start
        juldate, [stop_year, stop_month, stop_day, stop_hour, stop_min], stop

        push,mjd_start,start-0.5
        push,mjd_stop,stop-0.5
        push,seance_id,String(id,format='(i03)')
        push,seance_name,str_name

        print,key,String(id,format='(i03)'),' -> ',start_value,(start-0.5),', ',stop_value,(stop-0.5), ' / ', str_stations,format='(4a,1x,f16.8,2a,1x,f16.8,2a)'
        id+=1
     endif
  endfor
end

