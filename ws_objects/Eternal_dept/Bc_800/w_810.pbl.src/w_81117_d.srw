$PBExportHeader$w_81117_d.srw
$PBExportComments$본부별 평가구성율표
forward
global type w_81117_d from w_com010_d
end type
end forward

global type w_81117_d from w_com010_d
end type
global w_81117_d w_81117_d

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve()
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

on w_81117_d.create
call super::create
end on

on w_81117_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_81117_d
end type

type cb_delete from w_com010_d`cb_delete within w_81117_d
end type

type cb_insert from w_com010_d`cb_insert within w_81117_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_81117_d
end type

type cb_update from w_com010_d`cb_update within w_81117_d
end type

type cb_print from w_com010_d`cb_print within w_81117_d
end type

type cb_preview from w_com010_d`cb_preview within w_81117_d
end type

type gb_button from w_com010_d`gb_button within w_81117_d
end type

type cb_excel from w_com010_d`cb_excel within w_81117_d
end type

type dw_head from w_com010_d`dw_head within w_81117_d
boolean visible = false
integer x = 55
integer y = 216
integer width = 3525
integer height = 184
end type

type ln_1 from w_com010_d`ln_1 within w_81117_d
integer beginx = 5
integer beginy = 188
integer endx = 3625
integer endy = 188
end type

type ln_2 from w_com010_d`ln_2 within w_81117_d
integer beginx = 5
integer beginy = 192
integer endx = 3625
integer endy = 192
end type

type dw_body from w_com010_d`dw_body within w_81117_d
integer x = 9
integer y = 212
integer height = 1824
string dataobject = "d_81117_d01"
end type

type dw_print from w_com010_d`dw_print within w_81117_d
integer x = 288
integer y = 800
string dataobject = "d_81117_d01"
end type

