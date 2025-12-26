$PBExportHeader$w_test_shop.srw
$PBExportComments$테스트매장 선택
forward
global type w_test_shop from w_response
end type
type st_1 from statictext within w_test_shop
end type
type sle_1 from singlelineedit within w_test_shop
end type
type cb_2 from commandbutton within w_test_shop
end type
type cb_1 from commandbutton within w_test_shop
end type
end forward

global type w_test_shop from w_response
integer width = 887
integer height = 304
string title = "테스트 매장"
st_1 st_1
sle_1 sle_1
cb_2 cb_2
cb_1 cb_1
end type
global w_test_shop w_test_shop

on w_test_shop.create
int iCurrent
call super::create
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_1
end on

on w_test_shop.destroy
call super::destroy
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

type st_1 from statictext within w_test_shop
integer x = 233
integer y = 120
integer width = 617
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_test_shop
event ue_keydown pbm_keydown
integer x = 27
integer y = 120
integer width = 206
integer height = 84
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key =  KeyEnter! THEN 
	Send(Handle(This), 256, 9, long(0,0))
	Return 1
END IF

end event

event losefocus;String ls_shop_cd 
ls_shop_cd = This.Text

IF isnull(ls_shop_cd) OR Trim(ls_shop_cd) = "" THEN
ELSEIF gf_shop_nm(This.Text, 'S', st_1.text) <> 0 THEN
	This.SetFocus()
END IF
end event

type cb_2 from commandbutton within w_test_shop
integer x = 434
integer y = 28
integer width = 402
integer height = 84
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소"
end type

event clicked;Parent.TriggerEvent("pfc_close")
end event

type cb_1 from commandbutton within w_test_shop
event ue_keydown pbm_keydown
integer x = 37
integer y = 28
integer width = 402
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인"
end type

event ue_keydown;IF key =  KeyEnter! THEN 
	This.PostEvent(clicked!)
END IF

end event

event clicked;String ls_shop_cd, ls_Return

ls_shop_cd = sle_1.Text
IF isnull(ls_shop_cd) OR Trim(ls_shop_cd) = "" THEN 
	ls_Return = "NO"
ELSE 
	gs_shop_cd  = ls_shop_cd
	gs_shop_div = MidA(ls_shop_cd, 2, 1) 
	gs_brand    = LeftA(ls_shop_cd, 1)
	ls_Return = "OK"
END IF

CloseWithReturn(Parent, ls_Return)

end event

