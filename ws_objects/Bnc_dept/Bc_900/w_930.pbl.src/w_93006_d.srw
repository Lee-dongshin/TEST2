$PBExportHeader$w_93006_d.srw
$PBExportComments$프로그램 사용 현황
forward
global type w_93006_d from w_com010_d
end type
end forward

global type w_93006_d from w_com010_d
end type
global w_93006_d w_93006_d

type variables
Datetime id_st_dt, id_ed_dt

end variables

on w_93006_d.create
call super::create
end on

on w_93006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.22                                                  */	
/* 수정일      : 2001.11.22                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "st_dt", ld_datetime)
dw_head.SetItem(1, "ed_dt", ld_datetime)

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.22                                                  */	
/* 수정일      : 2001.11.22                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(id_st_dt, id_ed_dt)
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.22                                                  */	
/* 수정일      : 2001.11.22                                                  */
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

id_st_dt = Datetime(Date(dw_head.GetItemDatetime(1, "st_dt")), Time('00:00:00'))
if IsNull(id_st_dt) then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_dt")
   return false
end if

id_ed_dt = Datetime(Date(dw_head.GetItemDatetime(1, "ed_dt")), Time('23:59:59'))
if IsNull(id_ed_dt) then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ed_dt")
   return false
end if

return true

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.22                                                  */	
/* 수정일      : 2001.11.22                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_st_dt.Text = '" + String(id_st_dt, 'yyyy/mm/dd') + "'" + &
            "t_ed_dt.Text = '" + String(id_ed_dt, 'yyyy/mm/dd') + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_93006_d
end type

type cb_delete from w_com010_d`cb_delete within w_93006_d
end type

type cb_insert from w_com010_d`cb_insert within w_93006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_93006_d
end type

type cb_update from w_com010_d`cb_update within w_93006_d
end type

type cb_print from w_com010_d`cb_print within w_93006_d
end type

type cb_preview from w_com010_d`cb_preview within w_93006_d
end type

type gb_button from w_com010_d`gb_button within w_93006_d
end type

type cb_excel from w_com010_d`cb_excel within w_93006_d
end type

type dw_head from w_com010_d`dw_head within w_93006_d
integer height = 124
string dataobject = "d_93006_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_93006_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_93006_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_93006_d
integer y = 344
integer height = 1696
string dataobject = "d_93006_d01"
end type

type dw_print from w_com010_d`dw_print within w_93006_d
string dataobject = "d_93006_r01"
end type

