$PBExportHeader$w_sh206_d.srw
$PBExportComments$쿠폰지급현황
forward
global type w_sh206_d from w_com010_d
end type
end forward

global type w_sh206_d from w_com010_d
long backcolor = 16777215
end type
global w_sh206_d w_sh206_d

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_shop_cd)
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

on w_sh206_d.create
call super::create
end on

on w_sh206_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type cb_close from w_com010_d`cb_close within w_sh206_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh206_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh206_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh206_d
end type

type cb_update from w_com010_d`cb_update within w_sh206_d
end type

type cb_print from w_com010_d`cb_print within w_sh206_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh206_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh206_d
long backcolor = 16777215
end type

type dw_head from w_com010_d`dw_head within w_sh206_d
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_sh206_d
integer beginy = 176
integer endy = 176
end type

type ln_2 from w_com010_d`ln_2 within w_sh206_d
integer beginy = 180
integer endy = 180
end type

type dw_body from w_com010_d`dw_body within w_sh206_d
integer y = 200
integer height = 1624
string dataobject = "d_sh206_d01"
end type

type dw_print from w_com010_d`dw_print within w_sh206_d
end type

