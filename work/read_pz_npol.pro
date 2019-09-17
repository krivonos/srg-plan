pro read_pz_npol
  path='/Work/SRG/orientation/'
  read_pz,'flight_program_01082019.txt',root=path,table=table, load_date=[2019,08,01,17,0]
  read_pz,'flight_program_03082019.txt',root=path,table=table, load_date=[2019,08,03,17,0]
  read_pz,'flight_program_05082019.txt',root=path,table=table, load_date=[2019,08,05,17,0]
  read_pz,'flight_program_06082019.txt',root=path,table=table, load_date=[2019,08,06,17,0]
  read_pz,'flight_program_07082019.txt',root=path,table=table, load_date=[2019,08,07,17,0]
  read_pz,'flight_program_08082019.txt',root=path,table=table, load_date=[2019,08,08,17,0]
  read_pz,'flight_program_09082019.txt',root=path,table=table, load_date=[2019,08,09,17,0]
  
  read_pz,'flight_program_10082019.txt',root=path,table=table, load_date=[2019,08,10,17,0]
  read_pz,'flight_program_11082019.txt',root=path,table=table, load_date=[2019,08,11,17,0]
  read_pz,'flight_program_12082019.txt',root=path,table=table, load_date=[2019,08,12,17,0]
  read_pz,'flight_program_13082019.txt',root=path,table=table, load_date=[2019,08,13,17,0]
  read_pz,'flight_program_14082019.txt',root=path,table=table, load_date=[2019,08,14,17,0]
  read_pz,'flight_program_15082019.txt',root=path,table=table, load_date=[2019,08,15,17,0]
  read_pz,'flight_program_16082019.txt',root=path,table=table, load_date=[2019,08,16,17,0]
  read_pz,'flight_program_17082019.txt',root=path,table=table, load_date=[2019,08,17,17,0]
  read_pz,'flight_program_18082019.txt',root=path,table=table, load_date=[2019,08,18,17,0]
  read_pz,'flight_program_19082019.txt',root=path,table=table, load_date=[2019,08,19,17,0]
  read_pz,'flight_program_20082019.txt',root=path,table=table, load_date=[2019,08,20,17,0]

  read_pz,'pn21-08',root=path,table=table, load_date=[2019,08,21,17,0]
  read_pz,'pn22-08',root=path,table=table, load_date=[2019,08,22,17,0]
  read_pz,'pn23-08',root=path,table=table, load_date=[2019,08,23,17,0]
  read_pz,'pn24-08',root=path,table=table, load_date=[2019,08,24,17,0]
  read_pz,'pn25-08',root=path,table=table, load_date=[2019,08,25,17,0]
  read_pz,'pn26-08',root=path,table=table, load_date=[2019,08,26,17,0]
  read_pz,'pn27-08',root=path,table=table, load_date=[2019,08,27,17,0]
  read_pz,'pn28-08',root=path,table=table, load_date=[2019,08,28,17,0]
  read_pz,'pn29-08',root=path,table=table, load_date=[2019,08,29,17,0]

  read_pz,'pn30-08',root=path,table=table, load_date=[2019,08,30,17,0]
  read_pz,'pn31-08',root=path,table=table, load_date=[2019,08,31,17,0]

;;  20190910/pn06-09
;;20190910/pn07-09
;;20190910/pn08-09
;;20190910/pn09-08
;;20190910/pn09-09
;;20190910/pn10-09
;;20190910/pn11-09_1
;;20190910/pn11-09_2
;;20190910/pn12-09
  read_pz,'pn06-09',root=path,table=table, load_date=[2019,09,06,17,0]
  read_pz,'pn07-09',root=path,table=table, load_date=[2019,09,07,17,0]
  read_pz,'pn08-09',root=path,table=table, load_date=[2019,09,08,17,0]
  read_pz,'pn09-09',root=path,table=table, load_date=[2019,09,09,17,0]
  read_pz,'pn10-09',root=path,table=table, load_date=[2019,09,10,17,0]
  read_pz,'pn11-09_1',root=path,table=table, load_date=[2019,09,11,17,0]
  read_pz,'pn11-09_2',root=path,table=table, load_date=[2019,09,11,17,0]
  read_pz,'pn12-09',root=path,table=table, load_date=[2019,09,12,17,0]

  read_pz,'pn14-09',root=path,table=table, load_date=[2019,09,14,17,0]
  read_pz,'pn16-09',root=path,table=table, load_date=[2019,09,16,17,0]

  write_pz,filename='pz.fits', table=table
  
end
