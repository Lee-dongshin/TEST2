$PBExportHeader$w_cu100_e03.srw
$PBExportComments$생산진도관리(생산의뢰서보기)
forward
global type w_cu100_e03 from w_com010_d
end type
end forward

global type w_cu100_e03 from w_com010_d
integer width = 3653
integer height = 2236
end type
global w_cu100_e03 w_cu100_e03

event open;call super::open;Trigger Event ue_retrieve()
end event

on w_cu100_e03.create
call super::create
end on

on w_cu100_e03.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(gs_style,gs_chno)
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

type cb_close from w_com010_d`cb_close within w_cu100_e03
end type

type cb_delete from w_com010_d`cb_delete within w_cu100_e03
end type

type cb_insert from w_com010_d`cb_insert within w_cu100_e03
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu100_e03
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_cu100_e03
end type

type cb_print from w_com010_d`cb_print within w_cu100_e03
boolean enabled = true
end type

type cb_preview from w_com010_d`cb_preview within w_cu100_e03
boolean enabled = true
end type

type gb_button from w_com010_d`gb_button within w_cu100_e03
integer width = 3593
end type

type dw_head from w_com010_d`dw_head within w_cu100_e03
boolean visible = false
integer width = 864
integer height = 128
end type

type ln_1 from w_com010_d`ln_1 within w_cu100_e03
boolean visible = false
integer beginy = 168
integer endy = 168
end type

type ln_2 from w_com010_d`ln_2 within w_cu100_e03
boolean visible = false
integer beginy = 172
integer endy = 172
end type

type dw_body from w_com010_d`dw_body within w_cu100_e03
integer y = 156
integer width = 3602
integer height = 1888
string dataobject = "d_cu100_d03"
end type

type dw_print from w_com010_d`dw_print within w_cu100_e03
string dataobject = "d_cu100_d03"
end type

