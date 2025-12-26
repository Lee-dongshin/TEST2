$PBExportHeader$w_61031_d.srw
$PBExportComments$미사용-마일리지사용현황
forward
global type w_61031_d from w_com020_d
end type
end forward

global type w_61031_d from w_com020_d
integer width = 3680
integer height = 2280
end type
global w_61031_d w_61031_d

type variables
string is_brand , is_fr_yymm, is_to_yymm, is_yymm
datawindowchild  idw_brand
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
if IsNull(is_fr_yymm) or Trim(is_fr_yymm) = "" then
   MessageBox(ls_title,"From년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"To년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
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

il_rows = dw_list.retrieve(is_brand, is_fr_yymm, is_to_yymm)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_61031_d.create
call super::create
end on

on w_61031_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com020_d`cb_close within w_61031_d
end type

type cb_delete from w_com020_d`cb_delete within w_61031_d
end type

type cb_insert from w_com020_d`cb_insert within w_61031_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_61031_d
end type

type cb_update from w_com020_d`cb_update within w_61031_d
end type

type cb_print from w_com020_d`cb_print within w_61031_d
end type

type cb_preview from w_com020_d`cb_preview within w_61031_d
end type

type gb_button from w_com020_d`gb_button within w_61031_d
end type

type cb_excel from w_com020_d`cb_excel within w_61031_d
end type

type dw_head from w_com020_d`dw_head within w_61031_d
string dataobject = "d_61031_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com020_d`ln_1 within w_61031_d
end type

type ln_2 from w_com020_d`ln_2 within w_61031_d
end type

type dw_list from w_com020_d`dw_list within w_61031_d
string dataobject = "d_61031_d02"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymm = This.GetItemString(row, 'yymm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymm) THEN return
il_rows = dw_body.retrieve(is_brand, is_yymm)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_61031_d
string dataobject = "d_61031_d01"
end type

type st_1 from w_com020_d`st_1 within w_61031_d
end type

type dw_print from w_com020_d`dw_print within w_61031_d
integer x = 2235
integer y = 652
end type

