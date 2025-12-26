$PBExportHeader$w_99001_s.srw
$PBExportComments$table list
forward
global type w_99001_s from w_com010_d
end type
end forward

global type w_99001_s from w_com010_d
integer width = 2953
integer height = 1808
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_99001_s w_99001_s

type variables

end variables

on w_99001_s.create
call super::create
end on

on w_99001_s.destroy
call super::destroy
end on

event open;call super::open;This.Post Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.06                                                  */	
/* 수정일      : 2001.12.06                                                  */
/*===========================================================================*/
IF ISNULL(gsv_cd.gs_cd1) OR Trim(gsv_cd.gs_cd1) = "" THEN Return

il_rows = dw_body.retrieve(gsv_cd.gs_cd1)
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

type cb_close from w_com010_d`cb_close within w_99001_s
integer x = 2528
end type

type cb_delete from w_com010_d`cb_delete within w_99001_s
end type

type cb_insert from w_com010_d`cb_insert within w_99001_s
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_99001_s
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_99001_s
end type

type cb_print from w_com010_d`cb_print within w_99001_s
end type

type cb_preview from w_com010_d`cb_preview within w_99001_s
end type

type gb_button from w_com010_d`gb_button within w_99001_s
integer width = 2917
end type

type cb_excel from w_com010_d`cb_excel within w_99001_s
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_99001_s
boolean visible = false
end type

type ln_1 from w_com010_d`ln_1 within w_99001_s
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_99001_s
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_99001_s
integer x = 0
integer y = 164
integer width = 2935
integer height = 1544
string dataobject = "d_99002_d01"
end type

type dw_print from w_com010_d`dw_print within w_99001_s
string dataobject = "d_99002_r01"
end type

