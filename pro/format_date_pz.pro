pro format_date_pz,date,day,month,year,hour,min,sec
  year=fix(strmid(date,0,4))
  month=fix(strmid(date,5,2))
  day=fix(strmid(date,8,2))

  hour=fix(strmid(date,11,2))
  min=fix(strmid(date,14,2))
  sec=fix(strmid(date,17,2))
  ;;print,'day ',strmid(date,8,2),', month: ',strmid(date,5,2),', y: ',strmid(date,0,4),', h: ',strmid(date,11,2),', min: ',strmid(date,14,2),', sec: ',strmid(date,17,2)

end
