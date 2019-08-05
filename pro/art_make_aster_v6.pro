;+
;NAME:
;
; art_make_aster.pro
; 
; 
;PURPOSE:
;
; Produces an ASCII file with observational pattern for ART-XC telescope onboard SRG.
; Two scans available: 1', 3', 5', 7', 9', 12', 15', 18' ("normal")
; and 1', 3', 5', 7',  9', 12', 15', 18', 20', 22', 24', 27', 30',
; 40', 50' ("wide"). Different partitioning of the circle
; is available with "beta" parameter.
; 
;CALL:
;
; art_make_aster, ra, dec, pa, key='mysource', pexp=pexp, beta=beta, /wide
;
;INPUT:
;
; Ra, Dec   : J200 coordinates of the target
; PA        : Positional Angle (PA), the rotational angle with respect
;             to the North Pole
; pexp      : Exposure for each pointing (default: 200 s)
; key       : Optional name pattern for output files
; beta      : 30, 45, 60 or 90 degrees angle for partitioning the circle
; 
;
;OUTPUT:
; 
; Writtes an ASCII file (filename provided in call) with pointings in
; the following format: RA, Dec, PA, Exposure. Also saves the
; corresponding DS9 region file and FITS image file.
;  
;
;HISTORY:
;
; Roman Krivonos, Space Research Institute (IKI), krivonos@iki.rssi.ru
; February 2016
;
;-

;; //------------------------------------------------------------------
;; [observation]
;; // Second Observation of Cyg X-1
;; // Data from preliminary scientific program Appendix 1 Line 3
;; GUID = d051c8f9-0441-4968-9ce5-59a780f786a3
;; START = 26.04.2019 19:00:00
;; STOP = 27.04.2019 23:00:00
;; EXPERIMENT = 000000003
;; RA = 299,59033300	// J2000
;; DEC = +35,20160000	// J2000
;; ROLL_ANGLE = 000,0	// Reference value
;; SUN_XOZ_ANGLE = +10,0
;; //------------------------------------------------------------------


pro art_make_aster_v6, ra, dec, key=key, target=target, pexp=pexp, beta=beta, exposures_min=exposures_min, offset=offset, date=date, month_plan=month_plan,ROLL_ANGLE=ROLL_ANGLE,SUN_XOZ_ANGLE=SUN_XOZ_ANGLE, stem=stem, table=table, shift=shift, startstem=startstem, ignore_seance=ignore_seance, tol=tol, nrays=nrays, relax_time=relax_time

  @art

  if(n_elements(SUN_XOZ_ANGLE) eq 0) then SUN_XOZ_ANGLE=+10.0
  if(n_elements(ROLL_ANGLE) eq 0) then ROLL_ANGLE=0.0
  if(n_elements(key) eq 0) then key='art_aster'
  if(n_elements(stem) eq 0) then message,'Please provide main numbers for obsid'
  if(n_elements(target) eq 0) then target=''
  if(n_elements(pexp) eq 0) then pexp=20
  if(n_elements(beta) eq 0) then beta=0
  if(n_elements(nrays) eq 0) then nrays=1
  if(n_elements(startstem) eq 0) then startstem=1

  if(n_elements(date) eq 0) then message, 'Input date is not provided' ;;date=[2019, 06, 21, 0, 0]
  
  if(n_elements(offset) eq 0) then $
     offset = [-50.0, -40.0, $
               -30.0, -24.0, -20.0, -18.0, $
               -15.0, -12.0, -9.0, -7.0, -5.0, -3.0, -1.0, $
               0.0, $
               1.0, 3.0, 5.0, 7.0,  9.0, 12.0, 15.0, $
               18.0, 20.0, 24.0, 30.0, $
               40.0, 50.0]

  noff=n_elements(offset)
  if(n_elements(exposures_min) ne 0) then begin
     nexp=n_elements(exposures_min)
     if (nexp ne noff) then $
        message,'exposure array length not compatible with offset'
  endif else begin
     exposures_min=FLTARR(noff)+pexp
  endelse

  
;;  if not (beta eq 90L or beta eq 60L or beta eq 45L or beta eq 30L) then begin
;;     print, 'beta allowed values: 90, 60, 45 or 30'
;;     stop
;;  endif
  
  ;;nrays=360/beta
  ;;nrays=4
  ;;beta=45
  alpha=[beta];INDGEN(nrays,/DOUBLE)*beta  

  juldate, date, mjd_obs

  art=LONARR(art_strip_num,art_strip_num)
  art_make_header, ra, dec, roll_angle, astr=astr, hdr=hdr, bitpix=3
  writefits, key+'.img',art,hdr

  openw,reg,key+'.reg',/get_lun
  openw,dat,key+'.dat',/get_lun

;;  ; make one on-axis pointing:
;;  x=art_oa_x
;;  y=art_oa_y
;;  xy2ad,x-1.0,y-1.0,astr,new_ra,new_dec
;;  printf,dat,new_ra,new_dec,pa,pexp, format='(2f12.6,2f10.2)'
;;  printf,reg,'fk5;circle(',new_ra,',',new_dec,',',art_pix/2,') # text={'+String(pexp,format='(i2)')+'}'

  m2d = 1.0d/(60.0d*24.0d)
  total=0L
  seq=1
  ;;shift=0.0d
  for k=0L, n_elements(alpha)-1 do begin
     art_scan_rot, alpha(k)*dr, offset=offset, prot_x=prot_x, prot_y=prot_y  
     xy2ad,prot_x-1.0,prot_y-1.0,astr,new_ra,new_dec
     for i=0L,n_elements(offset)-1 do begin
        obsid=String(stem,startstem+k,(i+1),format='(a,i02,i03)')
        shift=observation(date=date,ra=new_ra(i), dec=new_dec(i), texp=exposures_min[i], obsid=obsid, shift=shift, table=table, $
                          target=target+String(beta,format='(i3)')+' offset '+string(offset[i],format='(f6.2)'), ignore_seance=ignore_seance, tol=tol, relax_time=relax_time)       
        
        printf,dat,seq,(k+1),(i+1),new_ra(i),new_dec(i), roll_angle, exposures_min[i], format='(3i3, 2f12.6,2f10.2)'
        printf,reg,'fk5;circle(',new_ra(i),',',new_dec(i),',',art_pix/2,') # text={'+String(exposures_min[i],format='(i2)')+'}'

        total+=exposures_min[i]
        seq++
     endfor
  endfor

  close,dat
  free_lun,dat
  close,reg
  free_lun,reg
  print,'Aster: total exposure, min:',total

end


