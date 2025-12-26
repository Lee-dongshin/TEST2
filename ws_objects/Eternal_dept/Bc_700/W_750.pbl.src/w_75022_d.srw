$PBExportHeader$w_75022_d.srw
$PBExportComments$월별 회원판매추이
forward
global type w_75022_d from w_com010_d
end type
end forward

global type w_75022_d from w_com010_d
end type
global w_75022_d w_75022_d

type variables
datawindowchild idw_brand
string is_brand, is_fr_yymm, is_to_yymm, is_gubn
end variables

on w_75022_d.create
call super::create
end on

on w_75022_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;
datetime ld_datetime

IF gf_cdate(ld_datetime,-12)  THEN  
	dw_head.setitem(1,"fr_yymm",string(ld_datetime,"yyyymm"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymm",string(ld_datetime,"yyyymm"))
end IF
end event

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

is_brand = dw_head.GetItemString(1, "brand")
is_fr_yymm = dw_head.GetItemString(1, "fr_yymm")
is_to_yymm = dw_head.GetItemString(1, "to_yymm")
is_gubn = dw_head.GetItemString(1, "gubn")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_gubn = '0' then
	dw_body.dataobject = "d_75009_d07"
else
	dw_body.dataobject = "d_75009_d08"	
end if
dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_brand, is_fr_yymm, is_to_yymm)
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

type cb_close from w_com010_d`cb_close within w_75022_d
end type

type cb_delete from w_com010_d`cb_delete within w_75022_d
end type

type cb_insert from w_com010_d`cb_insert within w_75022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75022_d
end type

type cb_update from w_com010_d`cb_update within w_75022_d
end type

type cb_print from w_com010_d`cb_print within w_75022_d
end type

type cb_preview from w_com010_d`cb_preview within w_75022_d
end type

type gb_button from w_com010_d`gb_button within w_75022_d
end type

type cb_excel from w_com010_d`cb_excel within w_75022_d
end type

type dw_head from w_com010_d`dw_head within w_75022_d
integer height = 188
string dataobject = "d_75022_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.insertrow(1)
idw_brand.setitem(1, "inter_cd", "%")
idw_brand.setitem(1, "inter_nm", "전체")

dw_head.setitem(1, "brand", "%")
end event

type ln_1 from w_com010_d`ln_1 within w_75022_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_d`ln_2 within w_75022_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_d`dw_body within w_75022_d
integer y = 408
integer height = 1632
string dataobject = "d_75009_d08"
end type

type dw_print from w_com010_d`dw_print within w_75022_d
end type

