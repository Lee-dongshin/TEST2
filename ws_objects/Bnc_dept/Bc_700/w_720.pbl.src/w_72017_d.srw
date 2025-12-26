$PBExportHeader$w_72017_d.srw
$PBExportComments$재구매및이탈고객현황
forward
global type w_72017_d from w_com010_d
end type
type rb_1 from radiobutton within w_72017_d
end type
type rb_2 from radiobutton within w_72017_d
end type
type rb_3 from radiobutton within w_72017_d
end type
end forward

global type w_72017_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
end type
global w_72017_d w_72017_d

type variables
string is_from_yy,  is_to_yy
end variables

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

is_from_yy = dw_head.GetItemString(1, "from_yy")
if IsNull(is_from_yy) or Trim(is_from_yy) = "" then
   MessageBox(ls_title,"From년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("from_yy")
   return false
end if

is_to_yy = dw_head.GetItemString(1, "to_yy")
if IsNull(is_to_yy) or Trim(is_to_yy) = "" then
   MessageBox(ls_title,"To년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yy")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_from_yy, is_to_yy)
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

on w_72017_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
end on

on w_72017_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
end on

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.Retrieve(is_from_yy, is_to_yy)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Retrieve(is_from_yy, is_to_yy)
dw_print.inv_printpreview.of_SetZoom()


end event

type cb_close from w_com010_d`cb_close within w_72017_d
end type

type cb_delete from w_com010_d`cb_delete within w_72017_d
end type

type cb_insert from w_com010_d`cb_insert within w_72017_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_72017_d
end type

type cb_update from w_com010_d`cb_update within w_72017_d
end type

type cb_print from w_com010_d`cb_print within w_72017_d
end type

type cb_preview from w_com010_d`cb_preview within w_72017_d
end type

type gb_button from w_com010_d`gb_button within w_72017_d
end type

type cb_excel from w_com010_d`cb_excel within w_72017_d
end type

type dw_head from w_com010_d`dw_head within w_72017_d
integer width = 1330
integer height = 124
string dataobject = "d_72017_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_72017_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_72017_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_72017_d
integer y = 340
integer height = 1700
string dataobject = "d_72017_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_72017_d
string dataobject = "d_72017_d01"
end type

type rb_1 from radiobutton within w_72017_d
integer x = 1545
integer y = 224
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "전체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_2.TextColor = 0
rb_3.TextColor = 0

dw_body.DataObject  = 'd_72017_d01'
dw_print.DataObject = 'd_72017_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_72017_d
integer x = 2094
integer y = 224
integer width = 494
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
string text = "이메일있는 고객"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = 0
rb_3.TextColor = 0

dw_body.DataObject  = 'd_72017_d02'
dw_print.DataObject = 'd_72017_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_3 from radiobutton within w_72017_d
integer x = 2761
integer y = 224
integer width = 494
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
string text = "이메일없는 고객"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_1.TextColor = 0
rb_2.TextColor = 0

dw_body.DataObject  = 'd_72017_d03'
dw_print.DataObject = 'd_72017_d03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

