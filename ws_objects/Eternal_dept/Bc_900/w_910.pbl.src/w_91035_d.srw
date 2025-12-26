$PBExportHeader$w_91035_d.srw
$PBExportComments$색상코드 조회
forward
global type w_91035_d from w_com010_d
end type
end forward

global type w_91035_d from w_com010_d
integer width = 3671
integer height = 2280
end type
global w_91035_d w_91035_d

type variables
string is_color, is_color_enm
end variables

on w_91035_d.create
call super::create
end on

on w_91035_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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

is_color = dw_head.GetItemString(1, "color_grp")
If IsNull(is_color) OR Trim(is_color) = "" then is_color = '%'

is_color_enm = dw_head.GetItemString(1, "color_desc")
If IsNull(is_color_enm) OR Trim(is_color_enm) = "" then is_color_enm = '%'

return true	
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_color, is_color_enm)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_color = "%" THEN is_color = "전체"
IF is_color_enm = "%" THEN is_color_enm = "전체"

dw_body.ShareData(dw_print)

ls_modify =	"t_color_cd.Text = '" + is_color + "'" + &
           "t_color_enm.Text = '" + is_color_enm + "'" + &
			  "t_user_id.Text = '" + gs_user_id + "'" + &
           "t_datetime.Text = '" + ls_datetime + "'"
			  
dw_print.modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_91035_d
end type

type cb_delete from w_com010_d`cb_delete within w_91035_d
end type

type cb_insert from w_com010_d`cb_insert within w_91035_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_91035_d
end type

type cb_update from w_com010_d`cb_update within w_91035_d
end type

type cb_print from w_com010_d`cb_print within w_91035_d
end type

type cb_preview from w_com010_d`cb_preview within w_91035_d
end type

type gb_button from w_com010_d`gb_button within w_91035_d
end type

type cb_excel from w_com010_d`cb_excel within w_91035_d
end type

type dw_head from w_com010_d`dw_head within w_91035_d
integer y = 164
integer height = 144
string dataobject = "d_91035_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_91035_d
integer beginy = 308
integer endy = 308
end type

type ln_2 from w_com010_d`ln_2 within w_91035_d
integer beginy = 312
integer endy = 312
end type

type dw_body from w_com010_d`dw_body within w_91035_d
integer y = 332
integer height = 1708
string dataobject = "d_91035_d01"
end type

type dw_print from w_com010_d`dw_print within w_91035_d
string dataobject = "d_91005_r01"
end type

