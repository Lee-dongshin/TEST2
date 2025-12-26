$PBExportHeader$w_53029_d.srw
$PBExportComments$호텔판매행사  직원인센티브
forward
global type w_53029_d from w_com010_d
end type
type rb_1 from radiobutton within w_53029_d
end type
type rb_2 from radiobutton within w_53029_d
end type
type rb_3 from radiobutton within w_53029_d
end type
type dw_1 from datawindow within w_53029_d
end type
type cb_1 from commandbutton within w_53029_d
end type
end forward

global type w_53029_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
dw_1 dw_1
cb_1 cb_1
end type
global w_53029_d w_53029_d

type variables
string	is_fr_ymd, is_to_ymd

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

is_fr_ymd =  dw_head.GetItemstring(1, "fr_ymd")
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd =  dw_head.GetItemstring(1, "to_ymd")
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
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



if rb_1.checked then 

	il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd, gs_user_id)

else	
	il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd)
end if	



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

on w_53029_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_1=create dw_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_1
end on

on w_53029_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_1)
destroy(this.cb_1)
end on

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_53029_d
end type

type cb_delete from w_com010_d`cb_delete within w_53029_d
end type

type cb_insert from w_com010_d`cb_insert within w_53029_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53029_d
end type

type cb_update from w_com010_d`cb_update within w_53029_d
end type

type cb_print from w_com010_d`cb_print within w_53029_d
end type

type cb_preview from w_com010_d`cb_preview within w_53029_d
end type

type gb_button from w_com010_d`gb_button within w_53029_d
end type

type cb_excel from w_com010_d`cb_excel within w_53029_d
end type

type dw_head from w_com010_d`dw_head within w_53029_d
integer width = 1490
string dataobject = "d_53029_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_53029_d
end type

type ln_2 from w_com010_d`ln_2 within w_53029_d
end type

type dw_body from w_com010_d`dw_body within w_53029_d
string dataobject = "d_53029_d01"
end type

event dw_body::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (동은아빠)                                     */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
String 	ls_search

IF row > 0 THEN
	dw_1.Visible = True
	ls_search 	= this.GetItemString(row,'empno')
	dw_1.Retrieve(is_fr_ymd,is_to_ymd,ls_search)

ELSE
	return
END IF

this.selectRow(0, false);
this.setRow(row);
this.selectRow(row, true);
end event

type dw_print from w_com010_d`dw_print within w_53029_d
string dataobject = "d_53029_d01"
end type

type rb_1 from radiobutton within w_53029_d
integer x = 1682
integer y = 284
integer width = 357
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
string text = "직원실적"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_2.TextColor        = 0
rb_3.TextColor        = 0

dw_body.DataObject  = 'd_53029_d01'
dw_print.DataObject = 'd_53029_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd, gs_user_id)
end event

type rb_2 from radiobutton within w_53029_d
integer x = 2117
integer y = 284
integer width = 453
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
string text = "협력업체실적"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_1.TextColor        = 0
rb_3.TextColor        = 0

dw_body.DataObject  = 'd_53029_d02'
dw_print.DataObject = 'd_53029_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd)

end event

type rb_3 from radiobutton within w_53029_d
integer x = 2651
integer y = 284
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
string text = "전체실적"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_1.TextColor        = 0
rb_2.TextColor        = 0

dw_body.DataObject  = 'd_53029_d03'
dw_print.DataObject = 'd_53029_d03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd)
end event

type dw_1 from datawindow within w_53029_d
boolean visible = false
integer x = 251
integer y = 84
integer width = 2702
integer height = 1908
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "판매상세내역"
string dataobject = "d_53029_d11"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_53029_d
integer x = 18
integer y = 40
integer width = 402
integer height = 96
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "정렬초기화"
end type

event clicked;	dw_body.SetSort("saup_gubn A, dept_code A, INTER_CD2 A ,SALE_AMT D")		
	Parent.Trigger Event ue_retrieve()	
end event

