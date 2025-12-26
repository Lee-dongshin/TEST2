$PBExportHeader$w_92005_d.srw
$PBExportComments$상표권 출원조회
forward
global type w_92005_d from w_com010_d
end type
end forward

global type w_92005_d from w_com010_d
integer width = 3657
end type
global w_92005_d w_92005_d

type variables
string is_country_cd, is_item_dong, is_trademark, is_state, is_apply_no, is_regist_no
string is_re_item_dong, is_re_apply_no, is_bs_issue_date, is_bs_issue_no
string is_mark_sheet_yn, is_re_mark_sheet_yn, is_re_apply_yn

string is_fr_apply_ymd, is_to_apply_ymd,  is_fr_regist_ymd, is_to_regist_ymd, is_office_cd
string is_fr_re_apply_ymd, is_to_re_apply_ymd, is_fr_re_regist_ymd, is_to_re_regist_ymd

datawindowchild idw_country_cd, idw_state, idw_office_cd, idw_item_dong, idw_trademark
end variables

on w_92005_d.create
call super::create
end on

on w_92005_d.destroy
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

is_country_cd = dw_head.GetItemString(1, "country_cd")
is_item_dong = dw_head.GetItemString(1, "item_grp")
is_trademark = dw_head.GetItemString(1, "trademark")
is_state = dw_head.GetItemString(1, "state")

is_apply_no = dw_head.GetItemString(1, "apply_no")
is_fr_apply_ymd = dw_head.GetItemString(1, "fr_apply_ymd")
is_to_apply_ymd = dw_head.GetItemString(1, "to_apply_ymd")
is_regist_no = dw_head.GetItemString(1, "regist_no")
is_fr_regist_ymd = dw_head.GetItemString(1, "fr_regist_ymd")
is_to_regist_ymd = dw_head.GetItemString(1, "to_regist_ymd")

is_re_item_dong = dw_head.GetItemString(1, "re_item_grp")
is_re_apply_no = dw_head.GetItemString(1, "re_apply_no")
is_fr_re_apply_ymd = dw_head.GetItemString(1, "fr_re_apply_ymd")
is_to_re_apply_ymd = dw_head.GetItemString(1, "to_re_apply_ymd")
is_fr_re_regist_ymd = dw_head.GetItemString(1, "fr_re_regist_ymd")
is_to_re_regist_ymd = dw_head.GetItemString(1, "to_re_regist_ymd")
is_bs_issue_date = dw_head.GetItemString(1, "bs_issue_date")
is_bs_issue_no = dw_head.GetItemString(1, "bs_issue_no")


is_mark_sheet_yn = dw_head.GetItemString(1, "mark_sheet_yn")
is_re_mark_sheet_yn = dw_head.GetItemString(1, "re_mark_sheet_yn")
is_re_apply_yn = dw_head.GetItemString(1, "re_apply_yn")
is_office_cd = dw_head.GetItemString(1, "office_cd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_country_cd, is_item_dong, is_trademark, is_state, is_apply_no, is_fr_apply_ymd, is_to_apply_ymd, &
					is_regist_no, is_fr_regist_ymd, is_to_regist_ymd, is_mark_sheet_yn, is_re_mark_sheet_yn, is_re_apply_yn, is_re_item_dong, &
					is_re_apply_no, is_fr_re_apply_ymd, is_to_re_apply_ymd, is_bs_issue_date, is_bs_issue_no, is_office_cd)

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

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


dw_print.object.t_country_cd.text = idw_country_cd.GetItemString(idw_country_cd.getrow(), "inter_nm")
dw_print.object.t_item_dong.text = dw_head.GetItemString(1, "item_grp")
dw_print.object.t_trademark.text = dw_head.GetItemString(1, "trademark")
dw_print.object.t_state.text = idw_state.GetItemString(idw_state.getrow(), "inter_nm")

dw_print.object.t_apply_no.text = dw_head.GetItemString(1, "apply_no")
dw_print.object.t_fr_apply_ymd.text = dw_head.GetItemString(1, "fr_apply_ymd")
dw_print.object.t_to_apply_ymd.text = dw_head.GetItemString(1, "to_apply_ymd")
dw_print.object.t_regist_no.text = dw_head.GetItemString(1, "regist_no")
dw_print.object.t_fr_regist_ymd.text = dw_head.GetItemString(1, "fr_regist_ymd")
dw_print.object.t_to_regist_ymd.text = dw_head.GetItemString(1, "to_regist_ymd")

dw_print.object.t_re_item_dong.text = dw_head.GetItemString(1, "re_item_grp")
dw_print.object.t_re_apply_no.text = dw_head.GetItemString(1, "re_apply_no")
dw_print.object.t_fr_re_apply_ymd.text = dw_head.GetItemString(1, "fr_re_apply_ymd")
dw_print.object.t_to_re_apply_ymd.text = dw_head.GetItemString(1, "to_re_apply_ymd")
dw_print.object.t_bs_issue_date.text = dw_head.GetItemString(1, "bs_issue_date")
dw_print.object.t_bs_issue_no.text = dw_head.GetItemString(1, "bs_issue_no")


dw_print.object.t_mark_sheet_yn.text = dw_head.GetItemString(1, "mark_sheet_yn")
dw_print.object.t_re_mark_sheet_yn.text = dw_head.GetItemString(1, "re_mark_sheet_yn")
dw_print.object.t_re_apply_yn.text = dw_head.GetItemString(1, "re_apply_yn")
end event

type cb_close from w_com010_d`cb_close within w_92005_d
end type

type cb_delete from w_com010_d`cb_delete within w_92005_d
end type

type cb_insert from w_com010_d`cb_insert within w_92005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_92005_d
end type

type cb_update from w_com010_d`cb_update within w_92005_d
end type

type cb_print from w_com010_d`cb_print within w_92005_d
end type

type cb_preview from w_com010_d`cb_preview within w_92005_d
end type

type gb_button from w_com010_d`gb_button within w_92005_d
end type

type cb_excel from w_com010_d`cb_excel within w_92005_d
end type

type dw_head from w_com010_d`dw_head within w_92005_d
integer x = 14
integer width = 4338
integer height = 380
string dataobject = "d_92005_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve()
idw_country_cd.insertrow(1)
idw_country_cd.SetItem(1, "inter_cd", '%')
idw_country_cd.SetItem(1, "inter_nm", '전체')


This.GetChild("state", idw_state)
idw_state.SetTransObject(SQLCA)
idw_state.Retrieve('00','01')
idw_state.insertrow(1)
idw_state.SetItem(1, "inter_cd", '')
idw_state.SetItem(1, "inter_nm", '')


This.GetChild("office_cd", idw_office_cd)
idw_office_cd.SetTransObject(SQLCA)
idw_office_cd.Retrieve('995')
idw_office_cd.insertrow(1)
idw_office_cd.SetItem(1, "inter_cd", '')
idw_office_cd.SetItem(1, "inter_nm", '')

This.GetChild("item_grp", idw_item_dong)
idw_item_dong.SetTransObject(SQLCA)
idw_item_dong.Retrieve('0')
idw_item_dong.insertrow(1)
idw_item_dong.SetItem(1, "item_grp", '')

This.GetChild("re_item_grp", idw_item_dong)
idw_item_dong.SetTransObject(SQLCA)
idw_item_dong.Retrieve('1')
idw_item_dong.insertrow(1)
idw_item_dong.SetItem(1, "re_item_grp", '')

This.GetChild("trademark", idw_trademark)
idw_trademark.SetTransObject(SQLCA)
idw_trademark.Retrieve()
idw_trademark.insertrow(1)
idw_trademark.SetItem(1, "trademark", '')



end event

type ln_1 from w_com010_d`ln_1 within w_92005_d
integer beginy = 560
integer endy = 560
end type

type ln_2 from w_com010_d`ln_2 within w_92005_d
integer beginy = 564
integer endy = 564
end type

type dw_body from w_com010_d`dw_body within w_92005_d
integer y = 580
integer height = 1460
string dataobject = "d_92005_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_apply_no

if row > 0 then
	ls_apply_no = this.getitemstring(row,"apply_no")

	
	gsv_cd.gs_cd10 = ls_apply_no

	

	open(w_92004_e)	


end if

end event

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)


// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify, ls_null

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".background.color='0~tcase(getrow() when currentrow() then rgb(192,192,192) else rgb(255,255,255) ) '"
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"

	END IF
NEXT

This.Modify(ls_modify)
end event

type dw_print from w_com010_d`dw_print within w_92005_d
integer x = 37
integer y = 604
string dataobject = "d_92005_r01"
end type

