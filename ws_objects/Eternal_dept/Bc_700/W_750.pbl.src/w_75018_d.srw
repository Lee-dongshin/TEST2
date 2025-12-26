$PBExportHeader$w_75018_d.srw
$PBExportComments$그릅별 회원 분석
forward
global type w_75018_d from w_com010_d
end type
end forward

global type w_75018_d from w_com010_d
end type
global w_75018_d w_75018_d

type variables
string is_t_brand, is_t_flag
end variables

on w_75018_d.create
call super::create
end on

on w_75018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_t_brand = dw_head.GetItemString(1, "t_brand")
is_t_flag = dw_head.GetItemString(1, "t_flag")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_t_brand, is_t_flag)
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

type cb_close from w_com010_d`cb_close within w_75018_d
end type

type cb_delete from w_com010_d`cb_delete within w_75018_d
end type

type cb_insert from w_com010_d`cb_insert within w_75018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75018_d
end type

type cb_update from w_com010_d`cb_update within w_75018_d
end type

type cb_print from w_com010_d`cb_print within w_75018_d
end type

type cb_preview from w_com010_d`cb_preview within w_75018_d
end type

type gb_button from w_com010_d`gb_button within w_75018_d
end type

type cb_excel from w_com010_d`cb_excel within w_75018_d
end type

type dw_head from w_com010_d`dw_head within w_75018_d
integer height = 184
string dataobject = "d_75018_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_75018_d
integer beginy = 376
integer endy = 376
end type

type ln_2 from w_com010_d`ln_2 within w_75018_d
integer beginy = 380
integer endy = 380
end type

type dw_body from w_com010_d`dw_body within w_75018_d
integer y = 392
integer height = 1616
string dataobject = "d_75018_d01"
end type

type dw_print from w_com010_d`dw_print within w_75018_d
integer x = 137
integer y = 952
string dataobject = "d_75018_r01"
end type

