$PBExportHeader$w_99100_d.srw
$PBExportComments$입고/출고/반품 내역 확인
forward
global type w_99100_d from w_com010_d
end type
type rb_1 from radiobutton within w_99100_d
end type
type rb_2 from radiobutton within w_99100_d
end type
type rb_3 from radiobutton within w_99100_d
end type
type rb_4 from radiobutton within w_99100_d
end type
type rb_5 from radiobutton within w_99100_d
end type
type rb_6 from radiobutton within w_99100_d
end type
type rb_7 from radiobutton within w_99100_d
end type
end forward

global type w_99100_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
end type
global w_99100_d w_99100_d

type variables
String is_brand, is_yymmdd
datawindowchild idw_brand
end variables

on w_99100_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
end on

on w_99100_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김근호                                      */	
/* 작성일      : 2018.04.03                                                  */	
/* 수정일      : 2018..                                                  */
/*===========================================================================*/


IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_yymmdd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김근호                                      */	
/* 작성일      : 2018.04.03                                                  */	
/* 수정일      : 2018..                                                  */
/*===========================================================================*/


String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_brand = dw_head.GetItemString(1,"brand")

if trim(is_brand) = '' or isnull(trim(is_brand)) then
	messagebox('확인','브랜드를 입력해주세요.')
	return false
end if

is_yymmdd = dw_head.GetItemString(1,"yymmdd")

if trim(is_yymmdd) = '' or isnull(trim(is_yymmdd)) then
	messagebox('확인','년월일을 입력해주세요.')
	return false
elseif LenA(trim(is_yymmdd)) < 6 then
	messagebox('확인','년월일을 확인해주세요.')
	return false
end if


return true

end event

type cb_close from w_com010_d`cb_close within w_99100_d
end type

type cb_delete from w_com010_d`cb_delete within w_99100_d
end type

type cb_insert from w_com010_d`cb_insert within w_99100_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99100_d
end type

type cb_update from w_com010_d`cb_update within w_99100_d
end type

type cb_print from w_com010_d`cb_print within w_99100_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_99100_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_99100_d
end type

type cb_excel from w_com010_d`cb_excel within w_99100_d
end type

type dw_head from w_com010_d`dw_head within w_99100_d
string dataobject = "d_99100_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')
end event

type ln_1 from w_com010_d`ln_1 within w_99100_d
end type

type ln_2 from w_com010_d`ln_2 within w_99100_d
end type

type dw_body from w_com010_d`dw_body within w_99100_d
integer width = 3575
integer height = 1540
string dataobject = "d_99100_d01"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;setrow(row)

end event

type dw_print from w_com010_d`dw_print within w_99100_d
end type

type rb_1 from radiobutton within w_99100_d
integer x = 1984
integer y = 192
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "입고내역"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99100_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_99100_d
integer x = 1984
integer y = 264
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고내역"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99110_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within w_99100_d
integer x = 1984
integer y = 336
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고내역(창고)"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99120_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_4 from radiobutton within w_99100_d
integer x = 2478
integer y = 192
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "출고내역(매장)"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99130_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_5 from radiobutton within w_99100_d
integer x = 2478
integer y = 264
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "반품내역(창고)"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99140_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_6 from radiobutton within w_99100_d
integer x = 2478
integer y = 336
integer width = 466
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "반품내역(매장)"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99150_d01"
dw_body.SetTransObject(SQLCA)

end event

type rb_7 from radiobutton within w_99100_d
integer x = 3035
integer y = 192
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "판매내역"
borderstyle borderstyle = stylelowered!
end type

event clicked;dw_body.dataobject = "d_99160_d01"
dw_body.SetTransObject(SQLCA)

end event

