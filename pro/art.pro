;
; ART-XC parameters
;

  dr = !PI/180.
  rd = 180./!PI


; Size of CdTe crystal, mm
art_pix_mm=29.953

; de-focusing shift, mm
art_defocus_mm=7.0

; focus length, mm
art_focus_len_mm=2700.0

; final focus length, mm
art_focus_mm=art_focus_len_mm-art_defocus_mm

; number of strips
art_strip_num=48

; Strips step, mm
art_strip_step=0.520

; Optical Axis position
art_oa_x=24.5
art_oa_y=24.5

; Pixel angular size, deg
art_pix=atan(art_strip_step/art_focus_mm)*rd

;; June 21, 2019
MJD_LAUNCH=58655.0
JD_LAUNCH=2458655.5
JD_SHIFT=2400000.5
MSK=3
m2d = 1.0d/(60.0d*24.0d)
d2m = (60.0d*24.0d)
speed_deg_in_sec=0.07
