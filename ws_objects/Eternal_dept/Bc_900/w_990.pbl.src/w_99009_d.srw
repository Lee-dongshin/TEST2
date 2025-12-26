$PBExportHeader$w_99009_d.srw
$PBExportComments$summary checklist생성
forward
global type w_99009_d from w_com010_d
end type
type rb_1 from radiobutton within w_99009_d
end type
type rb_2 from radiobutton within w_99009_d
end type
type rb_3 from radiobutton within w_99009_d
end type
type rb_4 from radiobutton within w_99009_d
end type
type rb_5 from radiobutton within w_99009_d
end type
type rb_6 from radiobutton within w_99009_d
end type
type rb_7 from radiobutton within w_99009_d
end type
end forward

global type w_99009_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
end type
global w_99009_d w_99009_d

type variables
string  is_yymm, is_brand
datawindowchild idw_brand
end variables

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm,is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_99009_d.create
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

on w_99009_d.destroy
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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_yymm = dw_head.GetItemString(1, "yymm")

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


return true

end event

type cb_close from w_com010_d`cb_close within w_99009_d
end type

type cb_delete from w_com010_d`cb_delete within w_99009_d
end type

type cb_insert from w_com010_d`cb_insert within w_99009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99009_d
end type

type cb_update from w_com010_d`cb_update within w_99009_d
end type

type cb_print from w_com010_d`cb_print within w_99009_d
end type

type cb_preview from w_com010_d`cb_preview within w_99009_d
end type

type gb_button from w_com010_d`gb_button within w_99009_d
end type

type cb_excel from w_com010_d`cb_excel within w_99009_d
end type

type dw_head from w_com010_d`dw_head within w_99009_d
integer x = 64
integer y = 176
integer width = 1339
string dataobject = "d_99009_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.Setitem(1,"inter_cd",'%')
idw_brand.Setitem(1,"inter_nm",'전체')

end event

type ln_1 from w_com010_d`ln_1 within w_99009_d
end type

type ln_2 from w_com010_d`ln_2 within w_99009_d
end type

type dw_body from w_com010_d`dw_body within w_99009_d
string dataobject = "d_99009_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_99009_d
integer x = 366
integer y = 596
string dataobject = "d_99009_d01"
end type

type rb_1 from radiobutton within w_99009_d
integer x = 1582
integer y = 200
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
long backcolor = 15780518
string text = "입고"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d01'
dw_print.DataObject = 'd_99009_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)




end event

type rb_2 from radiobutton within w_99009_d
integer x = 2089
integer y = 200
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
long backcolor = 15780518
string text = "출고1"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d02'
dw_print.DataObject = 'd_99009_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

 
end event

type rb_3 from radiobutton within w_99009_d
integer x = 2089
integer y = 268
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
long backcolor = 15780518
string text = "출고2"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d03'
dw_print.DataObject = 'd_99009_d03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rb_4 from radiobutton within w_99009_d
integer x = 2089
integer y = 340
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
long backcolor = 15780518
string text = "출고3"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d04'
dw_print.DataObject = 'd_99009_d04'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rb_5 from radiobutton within w_99009_d
integer x = 2606
integer y = 200
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
long backcolor = 15780518
string text = "반품2"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d05'
dw_print.DataObject = 'd_99009_d05'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_6 from radiobutton within w_99009_d
integer x = 2606
integer y = 268
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
long backcolor = 15780518
string text = "반품3"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_7.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d06'
dw_print.DataObject = 'd_99009_d06'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rb_7 from radiobutton within w_99009_d
integer x = 3118
integer y = 200
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
long backcolor = 15780518
string text = "판매"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
 

dw_body.DataObject  = 'd_99009_d07'
dw_print.DataObject = 'd_99009_d07'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

