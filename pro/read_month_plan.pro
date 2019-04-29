pro read_month_plan, filename, root=root 
  root='/Users/krivonos/Work/SRG/month'
  file=root+'/'+filename
  if not (file_exist(file)) then message,'Month plan not found '+file

  nlines = FILE_LINES(file)
  sarr = STRARR(nlines)
  OPENR, unit, file,/GET_LUN
  READF, unit, sarr
  FREE_LUN, unit

  for i=0L, N_ELEMENTS(sarr)-1 do begin
     print,sarr[i]
  endfor
end

