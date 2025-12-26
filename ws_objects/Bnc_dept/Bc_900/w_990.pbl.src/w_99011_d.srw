$PBExportHeader$w_99011_d.srw
$PBExportComments$월별 웹사이트 접속현황
forward
global type w_99011_d from w_com010_d
end type
type dw_1 from datawindow within w_99011_d
end type
end forward

global type w_99011_d from w_com010_d
dw_1 dw_1
end type
global w_99011_d w_99011_d

type variables
string   is_brand, is_fr_year, is_to_year
end variables

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_year = dw_head.GetItemString(1, "fr_year")
if IsNull(is_fr_year) or Trim(is_fr_year) = "" then
   MessageBox(ls_title,"From 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_year")
   return false
end if

is_to_year = dw_head.GetItemString(1, "to_year")
if IsNull(is_to_year) or Trim(is_to_year) = "" then
   MessageBox(ls_title,"To년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
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

il_rows = dw_body.retrieve(is_brand, is_fr_year, is_to_year)
//il_rows = dw_1.retrieve(is_brand, is_fr_year, is_to_year)
dw_body.ShareData(dw_1)
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

on w_99011_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_99011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

type cb_close from w_com010_d`cb_close within w_99011_d
end type

type cb_delete from w_com010_d`cb_delete within w_99011_d
end type

type cb_insert from w_com010_d`cb_insert within w_99011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99011_d
end type

type cb_update from w_com010_d`cb_update within w_99011_d
end type

type cb_print from w_com010_d`cb_print within w_99011_d
end type

type cb_preview from w_com010_d`cb_preview within w_99011_d
end type

type gb_button from w_com010_d`gb_button within w_99011_d
end type

type cb_excel from w_com010_d`cb_excel within w_99011_d
end type

type dw_head from w_com010_d`dw_head within w_99011_d
string dataobject = "d_99011_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_99011_d
end type

type ln_2 from w_com010_d`ln_2 within w_99011_d
end type

type dw_body from w_com010_d`dw_body within w_99011_d
integer y = 476
integer width = 896
integer height = 1564
string dataobject = "d_99011_d01"
end type

type dw_print from w_com010_d`dw_print within w_99011_d
integer x = 1655
integer y = 592
string dataobject = "d_99011_d02"
end type

type dw_1 from datawindow within w_99011_d
integer x = 910
integer y = 476
integer width = 2688
integer height = 1560
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_99011_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

