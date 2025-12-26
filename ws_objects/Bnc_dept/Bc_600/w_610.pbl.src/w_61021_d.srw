$PBExportHeader$w_61021_d.srw
$PBExportComments$브랜드 매장별매출비교
forward
global type w_61021_d from w_com010_d
end type
end forward

global type w_61021_d from w_com010_d
integer width = 3694
integer height = 2288
end type
global w_61021_d w_61021_d

type variables
string is_from_yymm, is_to_yymm, is_opt_yn, is_brand
DataWindowChild idw_brand

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

is_from_yymm = dw_head.GetItemString(1, "fr_yymm")
if IsNull(is_from_yymm) or Trim(is_from_yymm) = "" then
   MessageBox(ls_title,"from_yymm를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   return false
end if

is_to_yymm = dw_head.GetItemString(1, "to_yymm")
if IsNull(is_to_yymm) or Trim(is_to_yymm) = "" then
   MessageBox(ls_title,"to_yymm를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"기준브랜드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_opt_yn = dw_head.GetItemString(1, "opt_yn")



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

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_from_yymm,is_to_yymm,is_opt_yn, is_brand)
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

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.retrieve(is_from_yymm,is_to_yymm,is_opt_yn, is_brand)

dw_print.inv_printpreview.of_SetZoom()
end event

on w_61021_d.create
call super::create
end on

on w_61021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_print.retrieve(is_from_yymm,is_to_yymm,is_opt_yn, is_brand)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_61021_d
end type

type cb_delete from w_com010_d`cb_delete within w_61021_d
end type

type cb_insert from w_com010_d`cb_insert within w_61021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61021_d
end type

type cb_update from w_com010_d`cb_update within w_61021_d
end type

type cb_print from w_com010_d`cb_print within w_61021_d
end type

type cb_preview from w_com010_d`cb_preview within w_61021_d
end type

type gb_button from w_com010_d`gb_button within w_61021_d
end type

type cb_excel from w_com010_d`cb_excel within w_61021_d
end type

type dw_head from w_com010_d`dw_head within w_61021_d
string dataobject = "d_61021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_61021_d
end type

type ln_2 from w_com010_d`ln_2 within w_61021_d
end type

type dw_body from w_com010_d`dw_body within w_61021_d
string dataobject = "d_61021_d01"
end type

type dw_print from w_com010_d`dw_print within w_61021_d
string dataobject = "d_61021_d01"
end type

