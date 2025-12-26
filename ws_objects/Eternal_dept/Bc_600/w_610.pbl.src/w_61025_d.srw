$PBExportHeader$w_61025_d.srw
$PBExportComments$전체매출현황(국내/해외)
forward
global type w_61025_d from w_com010_d
end type
type st_1 from statictext within w_61025_d
end type
type rb_1 from radiobutton within w_61025_d
end type
type rb_2 from radiobutton within w_61025_d
end type
end forward

global type w_61025_d from w_com010_d
st_1 st_1
rb_1 rb_1
rb_2 rb_2
end type
global w_61025_d w_61025_d

type variables
string	is_yyyy
end variables

event ue_retrieve();call super::ue_retrieve;/*============================================================================*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*============================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy)
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

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"기준년을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

return true

end event

on w_61025_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
end on

on w_61025_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
end on

type cb_close from w_com010_d`cb_close within w_61025_d
end type

type cb_delete from w_com010_d`cb_delete within w_61025_d
end type

type cb_insert from w_com010_d`cb_insert within w_61025_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61025_d
end type

type cb_update from w_com010_d`cb_update within w_61025_d
end type

type cb_print from w_com010_d`cb_print within w_61025_d
end type

type cb_preview from w_com010_d`cb_preview within w_61025_d
end type

type gb_button from w_com010_d`gb_button within w_61025_d
end type

type cb_excel from w_com010_d`cb_excel within w_61025_d
end type

type dw_head from w_com010_d`dw_head within w_61025_d
integer x = 183
integer y = 192
integer width = 1280
integer height = 176
string dataobject = "d_61025_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61025_d
end type

type ln_2 from w_com010_d`ln_2 within w_61025_d
end type

type dw_body from w_com010_d`dw_body within w_61025_d
string dataobject = "d_61025_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(false)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_61025_d
integer x = 1093
integer y = 524
string dataobject = "d_61025_r01"
end type

type st_1 from statictext within w_61025_d
integer x = 1865
integer y = 364
integer width = 768
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "단위:  pcs, 천원, RMB"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_61025_d
boolean visible = false
integer x = 1797
integer y = 236
integer width = 274
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "국내"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor       = RGB(0, 0, 255)
rb_2.TextColor     	= 0
dw_body.DataObject  	= 'd_61025_d01'
dw_print.DataObject 	= 'd_61025_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_61025_d
boolean visible = false
integer x = 2217
integer y = 240
integer width = 457
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "중국"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor       = RGB(0, 0, 255)
rb_1.TextColor     	= 0
dw_body.DataObject  	= 'd_61025_d02'
dw_print.DataObject 	= 'd_61025_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

