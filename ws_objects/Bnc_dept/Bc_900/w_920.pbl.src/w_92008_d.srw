$PBExportHeader$w_92008_d.srw
$PBExportComments$각종 지원자료
forward
global type w_92008_d from w_com010_d
end type
end forward

global type w_92008_d from w_com010_d
end type
global w_92008_d w_92008_d

on w_92008_d.create
call super::create
end on

on w_92008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
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

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_92008_d
end type

type cb_delete from w_com010_d`cb_delete within w_92008_d
end type

type cb_insert from w_com010_d`cb_insert within w_92008_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_92008_d
end type

type cb_update from w_com010_d`cb_update within w_92008_d
end type

type cb_print from w_com010_d`cb_print within w_92008_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_92008_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_92008_d
end type

type cb_excel from w_com010_d`cb_excel within w_92008_d
end type

type dw_head from w_com010_d`dw_head within w_92008_d
boolean visible = false
integer height = 52
end type

type ln_1 from w_com010_d`ln_1 within w_92008_d
integer beginy = 244
integer endy = 244
end type

type ln_2 from w_com010_d`ln_2 within w_92008_d
integer beginy = 248
integer endy = 248
end type

type dw_body from w_com010_d`dw_body within w_92008_d
integer y = 268
integer height = 1772
string dataobject = "d_92008_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_92008_d
end type

