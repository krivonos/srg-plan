;;
;; Author: Igor Lapshov
;;
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
