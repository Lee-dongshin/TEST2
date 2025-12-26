$PBExportHeader$w_79022_d.srw
$PBExportComments$심의상담유형
forward
global type w_79022_d from w_com010_d
end type
end forward

global type w_79022_d from w_com010_d
end type
global w_79022_d w_79022_d

type variables
String is_fr_ymd, is_to_ymd
end variables

on w_79022_d.create
call super::create
end on

on w_79022_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79022_d","0")
end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_fr_ymd.text = '" + is_fr_ymd + "'" + &
 				 "t_to_ymd.text = '" + is_to_ymd + "'" 

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_79022_d
end type

type cb_delete from w_com010_d`cb_delete within w_79022_d
end type

type cb_insert from w_com010_d`cb_insert within w_79022_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79022_d
end type

type cb_update from w_com010_d`cb_update within w_79022_d
end type

type cb_print from w_com010_d`cb_print within w_79022_d
end type

type cb_preview from w_com010_d`cb_preview within w_79022_d
end type

type gb_button from w_com010_d`gb_button within w_79022_d
end type

type cb_excel from w_com010_d`cb_excel within w_79022_d
end type

type dw_head from w_com010_d`dw_head within w_79022_d
integer y = 152
integer height = 200
string dataobject = "d_79022_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_79022_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_79022_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_79022_d
integer y = 364
integer height = 1676
string dataobject = "d_79022_d01"
end type

type dw_print from w_com010_d`dw_print within w_79022_d
string dataobject = "d_79022_r01"
end type

