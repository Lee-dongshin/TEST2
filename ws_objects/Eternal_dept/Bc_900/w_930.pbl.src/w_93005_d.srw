$PBExportHeader$w_93005_d.srw
$PBExportComments$사용자별 프로그램 사용 현황
forward
global type w_93005_d from w_com020_d
end type
end forward

global type w_93005_d from w_com020_d
end type
global w_93005_d w_93005_d

type variables
string is_fr_yymmdd, is_to_yymmdd
String   is_person_id, is_person_nm

end variables

on w_93005_d.create
call super::create
end on

on w_93005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */
/* 작성일      : 2001.11.21                                                  */
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

//id_st_dt = Datetime(Date(dw_head.GetItemDatetime(1, "st_dt")), Time('00:00:00'))
is_fr_yymmdd = dw_head.GetItemString(1,"fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1,"to_yymmdd")

return true	
end event

event ue_preview();/*===========================================================================*/

dw_body.ShareData(dw_print)
//dw_print.inv_printpreview.of_SetZoom(ls_modify)

end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

type cb_close from w_com020_d`cb_close within w_93005_d
end type

type cb_delete from w_com020_d`cb_delete within w_93005_d
end type

type cb_insert from w_com020_d`cb_insert within w_93005_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_93005_d
end type

type cb_update from w_com020_d`cb_update within w_93005_d
end type

type cb_print from w_com020_d`cb_print within w_93005_d
end type

type cb_preview from w_com020_d`cb_preview within w_93005_d
end type

type gb_button from w_com020_d`gb_button within w_93005_d
end type

type cb_excel from w_com020_d`cb_excel within w_93005_d
end type

type dw_head from w_com020_d`dw_head within w_93005_d
integer height = 124
string dataobject = "d_93005_h01"
end type

type ln_1 from w_com020_d`ln_1 within w_93005_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com020_d`ln_2 within w_93005_d
integer beginy = 328
integer endy = 328
end type

type dw_list from w_com020_d`dw_list within w_93005_d
integer y = 344
integer width = 617
integer height = 1704
string dataobject = "d_93005_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.21                                                  */	
/* 수정일      : 2001.11.21                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)


end event

event dw_list::doubleclicked;call super::doubleclicked;is_person_id = This.GetItemString(row, 'person_id') /* DataWindow에 Key 항목을 가져온다 */
is_person_nm = This.GetItemString(row, 'person_nm') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_person_id) THEN return
il_rows = dw_body.retrieve('%',is_person_id, is_fr_yymmdd, is_to_yymmdd)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_93005_d
integer x = 677
integer y = 344
integer width = 2921
integer height = 1704
string dataobject = "d_93005_d01"
end type

type st_1 from w_com020_d`st_1 within w_93005_d
integer x = 654
integer y = 344
integer height = 1704
end type

type dw_print from w_com020_d`dw_print within w_93005_d
integer x = 55
integer y = 444
string dataobject = "d_93004_r02"
end type

