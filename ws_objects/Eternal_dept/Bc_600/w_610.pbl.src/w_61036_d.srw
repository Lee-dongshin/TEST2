$PBExportHeader$w_61036_d.srw
$PBExportComments$대만,베트남 판매실적
forward
global type w_61036_d from w_com010_d
end type
end forward

global type w_61036_d from w_com010_d
end type
global w_61036_d w_61036_d

type variables
string is_yymm

end variables

on w_61036_d.create
call super::create
end on

on w_61036_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm,'%')
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

type cb_close from w_com010_d`cb_close within w_61036_d
end type

type cb_delete from w_com010_d`cb_delete within w_61036_d
end type

type cb_insert from w_com010_d`cb_insert within w_61036_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61036_d
end type

type cb_update from w_com010_d`cb_update within w_61036_d
end type

type cb_print from w_com010_d`cb_print within w_61036_d
end type

type cb_preview from w_com010_d`cb_preview within w_61036_d
end type

type gb_button from w_com010_d`gb_button within w_61036_d
end type

type cb_excel from w_com010_d`cb_excel within w_61036_d
end type

type dw_head from w_com010_d`dw_head within w_61036_d
integer height = 144
string dataobject = "d_61036_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_61036_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_61036_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_61036_d
integer y = 368
integer height = 1672
string dataobject = "d_61036_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61036_d
string dataobject = "d_61036_d01"
end type

