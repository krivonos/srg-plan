; -----------------------------------------------------
;
; Procedure to compute source coordinate for SRG
; Spacecraft pointing taking into account ART-XC
; disalignment with the SC
; v.1.0
; Igor Lapshov, 14.08.2019
; -----------------------------------------------------

;@EarthPos.pro
;@read_srg_orbit_file_txt_form.pro
;@read_srg_orbit_file_txt_form_2.pro



;;@ANGLE_BETWEEN_TWO_VECTORS.pro
;;@ARRAYS_ARE_SAME_SIZE.pro
;;@DOT_PRODUCT.pro
;;@MAGNITUDE.pro
;;@NORMALIZE.pro
;;@REPLICATE_VECTOR.pro


pro ART_SView_beta, year=year, month=month, day=day, hour=hour, min=min, sec=sec, ra=ra, dec=dec, $
                    art_ra=art_ra, art_dec=art_dec, $
                    ero_ra=ero_ra, ero_dec=ero_dec

;;forward_function NORM_V
;;forward_function GET_ANGLE_VECTORS

JD = JULDAY(month, day, year, hour, min, sec)-3.d0/24. ; -3/24 in transfer from MSK to UTC
CatPos = [ra, dec] ; 4U 1538-522 for ART-XC


;Qcorr = [ -0.0269275087805867d0,      -0.0012974798150874d0,      -0.0010326590297526d0,       0.9996360134730687d0] ; 2-nd release
Qcorr = [ -0.0170407534937525d0,      -0.0013956210322403d0,      -0.0011146951027288d0,       0.9998532004335073d0]  ; 3-rd release
vvv_art = qtvrot([1.d0, 0.d0, 0.d0], Qcorr)

Qcorr_e = [-0.00194013400307d0,        -0.00100054863679d0,        -0.00139211809704d0,         0.99999664838922d0]     ; eROSITA correction quaternion
vvv_ero = qtvrot([1.d0, 0.d0, 0.d0], Qcorr_e)

ang_ART_ERO = ANGLE_BETWEEN_TWO_VECTORS(vvv_art, vvv_ero)
print, 'Angle between ART and eROSITA axis is : ', ang_ART_ERO*180.d0/!DPI*60.d0


Qcott_inv = QTINV(Qcorr)   ; --- Catalogue position to detector coordinate position
Qcott_inv_e = QTINV(Qcorr_e)		   ; --- eROSITA Detector position to Catalogue coordinate


; - Rotate detector to SC Coordinates
QDCS = QTCOMPOSE([1.d0, 0.d0, 0.d0], 1.d0*!DPI*0.0833333333d0)	; Rotate Detector by 15 degrees
ODCS_inv = QDCS	                   ;  --- Catalogue position to detector coordinate position
ODCS_inv_e = [0., 0., 0., 1.]				; --- eROSITA Detector position to Catalogue coordinate



;ODCS_inv = [0.d0, 0.d0, 0.d0, 1.d0]   ; --- Neutral

; SC
VdcX = [1.d0, 0.d0, 0.d0]
VdcY = [0.d0, 1.d0, 0.d0]
VdcZ = [0.d0, 0.d0, 1.d0]



VdcXr = NORMALIZE(reform(QTVROT(VdcX, ODCS_inv)))
VdcYr = NORMALIZE(reform(QTVROT(VdcY, ODCS_inv)))
VdcZr = NORMALIZE(reform(QTVROT(VdcZ, ODCS_inv)))

VdcXr_e = NORMALIZE(reform(QTVROT(VdcX, ODCS_inv_e)))
VdcYr_e = NORMALIZE(reform(QTVROT(VdcY, ODCS_inv_e)))
VdcZr_e = NORMALIZE(reform(QTVROT(VdcZ, ODCS_inv_e)))

VdcXc = NORMALIZE(reform(QTVROT(VdcXr, Qcott_inv)))
VdcYc = NORMALIZE(reform(QTVROT(VdcYr, Qcott_inv)))
VdcZc = NORMALIZE(reform(QTVROT(VdcZr, Qcott_inv)))

VdcXc_e = NORMALIZE(reform(QTVROT(VdcXr_e, Qcott_inv_e)))
VdcYc_e = NORMALIZE(reform(QTVROT(VdcYr_e, Qcott_inv_e)))
VdcZc_e = NORMALIZE(reform(QTVROT(VdcZr_e, Qcott_inv_e)))

Vsc =NORMALIZE(CV_COORD(FROM_SPHERE=[CatPos[0], CatPos[1], 1.d0], /TO_RECT, /DEGREES))

q1 = QTCOMPOSE([0.d0, 0.d0, 1.d0], (CatPos[0])*!DPI/180d0)
VdcXq1 = NORMALIZE(reform(QTVROT(VdcX, q1)))
VdcYq1 = NORMALIZE(reform(QTVROT(VdcY, q1)))
VdcZq1 = NORMALIZE(reform(QTVROT(VdcZ, q1)))

VdcXq1_e = NORMALIZE(reform(QTVROT(VdcX, q1)))
VdcYq1_e = NORMALIZE(reform(QTVROT(VdcY, q1)))
VdcZq1_e = NORMALIZE(reform(QTVROT(VdcZ, q1)))

q2 = QTCOMPOSE(VdcYq1, -1.*(CatPos[1])*!DPI/180d0)
q2_e = QTCOMPOSE(VdcYq1_e, -1.*(CatPos[1])*!DPI/180d0)

VdcXq2 = NORMALIZE(reform(QTVROT(VdcXq1, q2)))
VdcYq2 = NORMALIZE(reform(QTVROT(VdcYq1, q2)))
VdcZq2 = NORMALIZE(reform(QTVROT(VdcZq1, q2)))

VdcXq2_e = NORMALIZE(reform(QTVROT(VdcXq1_e, q2_e)))
VdcYq2_e = NORMALIZE(reform(QTVROT(VdcYq1_e, q2_e)))
VdcZq2_e = NORMALIZE(reform(QTVROT(VdcZq1_e, q2_e)))

sunpos, jd, ra_Sun, dec_Sun   ; Calc RA and DEC position of the Sun for a given JDate
Vsun =NORMALIZE(CV_COORD(FROM_SPHERE=[ra_Sun, dec_Sun, 1.d0], /TO_RECT, /DEGREES))

VScSunN = NORMALIZE(CROSSP(Vsun, VdcXq2))
VScSunN_e = NORMALIZE(CROSSP(Vsun, VdcXq2_e))
;angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq2)

angXXs = ANGLE_BETWEEN_TWO_VECTORS(Vsun, VdcXq2)
angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq2)
angZZs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcZq2)

print, ' OX-Sun Angle : ', angXXs*180./!DPI, '(deg)'

if (angZZs GT !DPI/2.d0) then begin
  angYYs = -1.d0*angYYs
endif

angXXs_e = ANGLE_BETWEEN_TWO_VECTORS(Vsun, VdcXq2_e)
angYYs_e = ANGLE_BETWEEN_TWO_VECTORS(VScSunN_e, VdcYq2_e)
angZZs_e = ANGLE_BETWEEN_TWO_VECTORS(VScSunN_e, VdcZq2_e)


if (angZZs_e GT !DPI/2.d0) then begin
  angYYs_e = -1.d0*angYYs_e
endif


q3 = QTCOMPOSE(VdcXq2, angYYs)
VdcXq3 = NORMALIZE(reform(QTVROT(VdcXq2, q3)))
VdcYq3 = NORMALIZE(reform(QTVROT(VdcYq2, q3)))
VdcZq3 = NORMALIZE(reform(QTVROT(VdcZq2, q3)))

VScSunN = NORMALIZE(CROSSP(Vsun, VdcXq3))
angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq3)

q3_e = QTCOMPOSE(VdcXq2_e, angYYs_e)
VdcXq3_e = NORMALIZE(reform(QTVROT(VdcXq2_e, q3_e)))
VdcYq3_e = NORMALIZE(reform(QTVROT(VdcYq2_e, q3_e)))
VdcZq3_e = NORMALIZE(reform(QTVROT(VdcZq2_e, q3_e)))

VScSunN = NORMALIZE(CROSSP(Vsun, VdcXq3))
angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq3)

VScSunN_e = NORMALIZE(CROSSP(Vsun, VdcXq3_e))
angYYs_e = ANGLE_BETWEEN_TWO_VECTORS(VScSunN_e, VdcYq3_e)

;print, angYYs*180./!DPI

q320 = QTMULT(q3, q2)
q32  = qtnormalize(q320)
q321 = QTMULT(q32, q1)
qd  = qtnormalize(q321)

q320_e = QTMULT(q3_e, q2_e)
q32_e  = qtnormalize(q320_e)
q321_e = QTMULT(q32_e, q1)
qd_e  = qtnormalize(q321_e)


vxnew = NORMALIZE(reform(QTVROT(VdcX, qd)))
vynew = NORMALIZE(reform(QTVROT(VdcY, qd)))
vznew = NORMALIZE(reform(QTVROT(VdcZ, qd)))

VdcXcnew = reform(QTVROT(VdcXc, qd))

CSkyX =CV_COORD(FROM_RECT=VdcXcnew, /TO_SPHERE, /DEGREES)


;print, ' ---------- '
if (CSkyX[0] LT 0.) then CSkyX[0] = 360.+CSkyX[0]
print, 'ART-XC : ', CSkyX[0], CSkyX[1], CatPos[0], CatPos[1]

art_ra=CSkyX[0]
art_dec=CSkyX[1]

;gcirc, 2, CSkyX[0], CSkyX[1], CatPos[0], CatPos[1], distsec
;print, distsec/60.
vxnew_e = NORMALIZE(reform(QTVROT(VdcX, qd_e)))
vynew_e = NORMALIZE(reform(QTVROT(VdcY, qd_e)))
vznew_e = NORMALIZE(reform(QTVROT(VdcZ, qd_e)))

VdcXcnew_e = reform(QTVROT(VdcXc_e, qd_e))

CSkyX_e =CV_COORD(FROM_RECT=VdcXcnew_e, /TO_SPHERE, /DEGREES)


;print, ' ---------- '
if (CSkyX_e[0] LT 0.) then CSkyX_e[0] = 360.+CSkyX_e[0]
print, 'eROSITA : ', CSkyX_e[0], CSkyX_e[1], CatPos[0], CatPos[1]

;stop
end




pro quat_from_vectors, V1, V2, quat

if (V1[0] EQ V2[0] AND V1[1] EQ V2[1] AND V1[2] EQ V2[2]) then begin
	quat = [0.d0, 0.d0, 0.d0, 1.d0]
	goto, a
endif

 cos_theta = DOT_PRODUCT(V1, V2)
 angle = acos(cos_theta)
 w = CROSSP(V1, V2)
; quat = [w*sin(angle/2.), cos(angle/2.)]
print, ' --> ', w, angle*180./!PI
quat = QTCOMPOSE(w, angle)
;stop
a:
end
