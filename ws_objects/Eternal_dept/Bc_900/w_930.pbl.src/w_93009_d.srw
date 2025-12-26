$PBExportHeader$w_93009_d.srw
$PBExportComments$집계테이블 월 체크리스트
forward
global type w_93009_d from w_com010_d
end type
end forward

global type w_93009_d from w_com010_d
end type
global w_93009_d w_93009_d

type variables
string is_yymm, is_yymmdd, is_history, is_summary

end variables

on w_93009_d.create
call super::create
end on

on w_93009_d.destroy
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

is_yymm    = dw_head.GetItemString(1, "yymm")
is_yymmdd  = dw_head.GetItemString(1, "yymmdd")
is_history = dw_head.GetItemString(1, "history")
is_summary = dw_head.GetItemString(1, "summary")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm)
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

event ue_preview();//

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymm",string(ld_datetime,"yyyymm"))
end if

end event

type cb_close from w_com010_d`cb_close within w_93009_d
end type

type cb_delete from w_com010_d`cb_delete within w_93009_d
end type

type cb_insert from w_com010_d`cb_insert within w_93009_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_93009_d
end type

type cb_update from w_com010_d`cb_update within w_93009_d
end type

type cb_print from w_com010_d`cb_print within w_93009_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_93009_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_93009_d
end type

type cb_excel from w_com010_d`cb_excel within w_93009_d
end type

type dw_head from w_com010_d`dw_head within w_93009_d
integer height = 120
string dataobject = "d_93009_h01"
end type

event dw_head::buttonclicked;call super::buttonclicked;choose case dwo.name
	case "b_exec"
		IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
		
		if messagebox("확인","실행하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return
messagebox("is_yymmdd",is_yymmdd)
messagebox("is_history",is_history)
messagebox("is_summary",is_summary)
		DECLARE sp_corss_summary_exe PROCEDURE FOR sp_corss_summary_exe
					@yymmdd	= :is_yymmdd,
					@history	= :is_history,
					@summary	= :is_summary;
					
		execute sp_corss_summary_exe;	
		commit  USING SQLCA;	
		messagebox("확인","짝짝짝..짤 끝났어요.")
end choose

end event

type ln_1 from w_com010_d`ln_1 within w_93009_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_93009_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_93009_d
integer y = 344
integer height = 1696
string dataobject = "d_93009_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_93009_d
end type

