$PBExportHeader$w_62033_d.srw
$PBExportComments$시즌별 전년비 판매현황
forward
global type w_62033_d from w_com010_d
end type
end forward

global type w_62033_d from w_com010_d
integer width = 3680
integer height = 2280
end type
global w_62033_d w_62033_d

type variables
string is_fr_yymmdd, is_to_yymmdd, is_flag

end variables

on w_62033_d.create
call super::create
end on

on w_62033_d.destroy
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_flag = dw_head.GetItemString(1, "flag")

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, is_flag)
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

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
il_rows = dw_print.retrieve(is_fr_yymmdd, is_to_yymmdd, is_flag)

dw_print.inv_printpreview.of_SetZoom()



end event

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end IF
end event

type cb_close from w_com010_d`cb_close within w_62033_d
end type

type cb_delete from w_com010_d`cb_delete within w_62033_d
end type

type cb_insert from w_com010_d`cb_insert within w_62033_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62033_d
end type

type cb_update from w_com010_d`cb_update within w_62033_d
end type

type cb_print from w_com010_d`cb_print within w_62033_d
end type

type cb_preview from w_com010_d`cb_preview within w_62033_d
end type

type gb_button from w_com010_d`gb_button within w_62033_d
end type

type cb_excel from w_com010_d`cb_excel within w_62033_d
end type

type dw_head from w_com010_d`dw_head within w_62033_d
integer y = 164
integer height = 160
string dataobject = "d_62033_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_62033_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_62033_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_62033_d
integer y = 368
integer height = 1672
string dataobject = "d_62033_d01"
end type

type dw_print from w_com010_d`dw_print within w_62033_d
string dataobject = "d_62033_d01"
end type

