$PBExportHeader$w_12013_d.srw
$PBExportComments$스타일 변경
forward
global type w_12013_d from w_com010_d
end type
end forward

global type w_12013_d from w_com010_d
integer width = 3616
integer height = 632
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_12013_d w_12013_d

type variables
string fr_style, fr_chno, to_style, to_chno


end variables

on w_12013_d.create
call super::create
end on

on w_12013_d.destroy
call super::destroy
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

fr_style = dw_head.GetItemString(1, "fr_style")
fr_chno  = dw_head.GetItemString(1, "fr_chno")
to_style = dw_head.GetItemString(1, "to_style")
to_chno  = dw_head.GetItemString(1, "to_chno")



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.reset()
il_rows = dw_body.retrieve(fr_style, fr_chno, to_style, to_chno, gs_user_id)
IF il_rows > 0 THEN
   commit USING SQLCA;	
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   rollback USING SQLCA;
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   rollback USING SQLCA;
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;
dw_head.setitem(1,"mod_id",gs_user_id)
dw_head.setitem(1,"mod_nm",gs_user_nm)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12013_d
integer x = 27
integer y = 40
end type

type cb_delete from w_com010_d`cb_delete within w_12013_d
end type

type cb_insert from w_com010_d`cb_insert within w_12013_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12013_d
boolean visible = false
boolean enabled = false
end type

type cb_update from w_com010_d`cb_update within w_12013_d
integer x = 389
end type

type cb_print from w_com010_d`cb_print within w_12013_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_12013_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_12013_d
end type

type cb_excel from w_com010_d`cb_excel within w_12013_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_12013_d
integer height = 188
string dataobject = "d_12013_h01"
end type

event dw_head::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (김태범) 															  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

if dwo.name = "cb_exec" then
	if messagebox("확인","실행하시겠습니까..?", Exclamation!, OKCancel!, 2) <> 1 then return 1 

	oldpointer = SetPointer(HourGlass!)	
	IF dw_head.Enabled THEN
		Parent.Trigger Event ue_retrieve()	//조회
	ELSE
		Parent.Trigger Event ue_head()	//조건
	END IF
	
	SetPointer(oldpointer)

end if
end event

type ln_1 from w_com010_d`ln_1 within w_12013_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_12013_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_12013_d
integer x = 9
integer y = 372
integer width = 3579
integer height = 128
string dataobject = "d_12013_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

type dw_print from w_com010_d`dw_print within w_12013_d
integer x = 73
integer y = 716
end type

