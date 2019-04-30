pro format_date,date,day,month,year,hour,min,sec
  day=fix(strmid(date,0,2))
  month=fix(strmid(date,3,2))
  year=fix(strmid(date,6,4))

  hour=fix(strmid(date,11,2))
  min=fix(strmid(date,14,2))
  sec=fix(strmid(date,17,2))
  ;;print,day,month,year,hour,min,sec

end
