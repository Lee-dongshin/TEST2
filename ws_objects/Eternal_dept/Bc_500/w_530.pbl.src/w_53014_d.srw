$PBExportHeader$w_53014_d.srw
$PBExportComments$타브랜드 월매출 분포도
forward
global type w_53014_d from w_com010_d
end type
type dw_1 from datawindow within w_53014_d
end type
type dw_2 from datawindow within w_53014_d
end type
end forward

global type w_53014_d from w_com010_d
integer width = 3680
integer height = 2256
dw_1 dw_1
dw_2 dw_2
end type
global w_53014_d w_53014_d

type variables
string is_brand, is_fr_yymm, is_to_yymm, is_sale_fg
datawindowchild idw_brand
end variables

on w_53014_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
end on

on w_53014_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")
is_sale_fg = dw_head.GetItemString(1, "sale_fg")
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_sale_fg, 7)
IF il_rows > 0 THEN
	il_rows = dw_1.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_sale_fg, 7)
	il_rows = dw_2.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_sale_fg, 7)
	
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToBottom")
inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")

inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
//this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_sale_fg, 7)

dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_53014_d
end type

type cb_delete from w_com010_d`cb_delete within w_53014_d
end type

type cb_insert from w_com010_d`cb_insert within w_53014_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53014_d
end type

type cb_update from w_com010_d`cb_update within w_53014_d
end type

type cb_print from w_com010_d`cb_print within w_53014_d
end type

type cb_preview from w_com010_d`cb_preview within w_53014_d
end type

type gb_button from w_com010_d`gb_button within w_53014_d
end type

type cb_excel from w_com010_d`cb_excel within w_53014_d
end type

type dw_head from w_com010_d`dw_head within w_53014_d
integer height = 140
string dataobject = "d_53014_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_53014_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_53014_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_53014_d
integer x = 0
integer y = 1496
integer width = 2720
integer height = 524
string dataobject = "d_53014_d01"
end type

type dw_print from w_com010_d`dw_print within w_53014_d
integer x = 0
integer y = 4
string dataobject = "d_53014_r00"
end type

type dw_1 from datawindow within w_53014_d
integer y = 332
integer width = 3602
integer height = 1156
integer taborder = 40
string title = "none"
string dataobject = "d_53014_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_53014_d
integer x = 2720
integer y = 1496
integer width = 882
integer height = 524
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_53014_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

