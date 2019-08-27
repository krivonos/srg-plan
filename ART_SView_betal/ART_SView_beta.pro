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



;@ANGLE_BETWEEN_TWO_VECTORS.pro
;@ARRAYS_ARE_SAME_SIZE.pro
;@DOT_PRODUCT.pro
;@MAGNITUDE.pro
;@NORMALIZE.pro
;@REPLICATE_VECTOR.pro

;; cat Correction_Quaternions_ART-XC_Release_2.txt
;; Tel.No            Q0                       Q1                       Q2                        Q3
;; -------------------------------------------------------------------------------------------------------
;;   1      -0.0253822607926940      -0.0013460478969772      -0.0010308083508865       0.9996763808484496
;;   2      -0.0278942419232757      -0.0012308887991602      -0.0009912718735396       0.9996096305860415
;;   3      -0.0218437922616629      -0.0013321831701231      -0.0010327175254869       0.9997599749550605
;;   4      -0.0236571226930715      -0.0012197597513018      -0.0009268017282141       0.9997189573928217
;;   5      -0.0319250004074392      -0.0012520331046345      -0.0010569697192827       0.9994889241893090
;;   6      -0.0282551980978759      -0.0012799715693514      -0.0011048317403854       0.9995993121246417
;;   7      -0.0295448995670286      -0.0012731151181261      -0.0009942313703070       0.9995621489389505
 
;; -------------------------------------------------------------------------------------------------------
 
;; Mean 1   -0.0269275087805867      -0.0012974798150874      -0.0010326590297526       0.9996360134730687
;; Mean 2   -0.0269289308204354      -0.0012762856299535      -0.0010196617583003       0.9996307612907535

pro ART_SView_beta
forward_function NORM_V
forward_function GET_ANGLE_VECTORS


;; JD = JULDAY(08., 15., 2019., 4., 00., 0.)-3.d0/24.   ; -3/24 in transfer from MSK to UTC
;; CatPos = [266.416817	, -29.007825	]   ; 'SGR A*' Output : 266.56348      -28.864768      266.417     -29.0078

;; JD = JULDAY(08., 21., 2019., 15., 20., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;; CatPos = [264.368252d, -29.133921d]   ; 'GRS 1734-292' 

;; JD = JULDAY(08., 22., 2019., 8., 45., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;; CatPos = [266.416817d	, -29.007825d]   ; 'Sgr A*' 

;;JD = JULDAY(08., 29., 2019., 13., 8., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;;CatPos = [83.63308d, 22.0145d]   ; 'Crab' 

JD = JULDAY(9., 14., 2019., 18., 30., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
CatPos = [228.48133d, -59.13578d]   ; 'PSR 1509-58'  228.84419      -59.098101

;;JD = JULDAY(9., 9., 2019., 18., 30., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;;CatPos = [195.5922639d, -63.90363949d]   ; 'PSR_B1259m63'  195.99735      -63.970215

;;JD = JULDAY(9., 11., 2019., 18., 30., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;;CatPos = [213.291275d, -65.339019d]   ; 'Circinus'  228.84419      -59.098101

;;JD = JULDAY(9., 12., 2019., 18., 30., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;;CatPos = [237.744384d, -56.476475d]   ; 'XTE_J1550m564'  

;;JD = JULDAY(9., 13., 2019., 18., 30., 0.)-3.d0/24. ; -3/24 in transfer from MSK to UTC
;;CatPos = [237.060817d, -45.477755d]   ; 'NY lup'  

;; backup version on Aug 21, 2019
;;Qcorr = [ -0.0865535877419564d0, -0.0012729829385031d0, -0.0010921338922188d0, 0.9962457845366249d0]

;; Mean 1:
Qcorr = [ -0.0269275087805867d0, -0.0012974798150874d0, -0.0010326590297526d0, 0.9996360134730687d0]

Qcott_inv = QTINV(Qcorr)        ; --- Catalogue position to detector coordinate position
;Qcott_inv = Qcorr		   ; --- Detector position to Catalogue coordinate


; - Rotate detector to SC Coordinates
QDCS = QTCOMPOSE([1.d0, 0.d0, 0.d0], 1.d0*!DPI*0.0833333333d0)	; Rotate Detector by 15 degrees
ODCS_inv = QDCS	                   ;  --- Catalogue position to detector coordinate position
;ODCS_inv = QTINV(QDCS)				; --- Detector position to Catalogue coordinate



;ODCS_inv = [0.d0, 0.d0, 0.d0, 1.d0]   ; --- Neutral

; SC
VdcX = [1.d0, 0.d0, 0.d0]
VdcY = [0.d0, 1.d0, 0.d0]
VdcZ = [0.d0, 0.d0, 1.d0]



VdcXr = NORMALIZE(reform(QTVROT(VdcX, ODCS_inv)))
VdcYr = NORMALIZE(reform(QTVROT(VdcY, ODCS_inv)))
VdcZr = NORMALIZE(reform(QTVROT(VdcZ, ODCS_inv)))


VdcXc = NORMALIZE(reform(QTVROT(VdcXr, Qcott_inv)))
VdcYc = NORMALIZE(reform(QTVROT(VdcYr, Qcott_inv)))
VdcZc = NORMALIZE(reform(QTVROT(VdcZr, Qcott_inv)))


Vsc =NORMALIZE(CV_COORD(FROM_SPHERE=[CatPos[0], CatPos[1], 1.d0], /TO_RECT, /DEGREES))

q1 = QTCOMPOSE([0.d0, 0.d0, 1.d0], (CatPos[0])*!DPI/180d0)
VdcXq1 = NORMALIZE(reform(QTVROT(VdcX, q1)))
VdcYq1 = NORMALIZE(reform(QTVROT(VdcY, q1)))
VdcZq1 = NORMALIZE(reform(QTVROT(VdcZ, q1)))

q2 = QTCOMPOSE(VdcYq1, -1.*(CatPos[1])*!DPI/180d0)
VdcXq2 = NORMALIZE(reform(QTVROT(VdcXq1, q2)))
VdcYq2 = NORMALIZE(reform(QTVROT(VdcYq1, q2)))
VdcZq2 = NORMALIZE(reform(QTVROT(VdcZq1, q2)))

sunpos, jd, ra_Sun, dec_Sun   ; Calc RA and DEC position of the Sun for a given JDate
Vsun =NORMALIZE(CV_COORD(FROM_SPHERE=[ra_Sun, dec_Sun, 1.d0], /TO_RECT, /DEGREES))

VScSunN = NORMALIZE(CROSSP(Vsun, VdcXq2))
angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq2)

q3 = QTCOMPOSE(VdcXq2, angYYs)
VdcXq3 = NORMALIZE(reform(QTVROT(VdcXq2, q3)))
VdcYq3 = NORMALIZE(reform(QTVROT(VdcYq2, q3)))
VdcZq3 = NORMALIZE(reform(QTVROT(VdcZq2, q3)))

VScSunN = NORMALIZE(CROSSP(Vsun, VdcXq3))
angYYs = ANGLE_BETWEEN_TWO_VECTORS(VScSunN, VdcYq3)


q320 = QTMULT(q3, q2)
q32  = qtnormalize(q320)
q321 = QTMULT(q32, q1)
qd  = qtnormalize(q321)



vxnew = NORMALIZE(reform(QTVROT(VdcX, qd)))
vynew = NORMALIZE(reform(QTVROT(VdcY, qd)))
vznew = NORMALIZE(reform(QTVROT(VdcZ, qd)))

VdcXcnew = reform(QTVROT(VdcXc, qd))

CSkyX =CV_COORD(FROM_RECT=VdcXcnew, /TO_SPHERE, /DEGREES)

;print, ' ---------- '
if (CSkyX[0] LT 0.) then CSkyX[0] = 360.+CSkyX[0]
print, CSkyX[0], CSkyX[1], CatPos[0], CatPos[1]

gcirc, 2, CSkyX[0], CSkyX[1], CatPos[0], CatPos[1], distsec
print
print, distsec/60.

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
