$PBExportHeader$w_91020_d.srw
$PBExportComments$사무용품요청조회
forward
global type w_91020_d from w_com010_d
end type
end forward

global type w_91020_d from w_com010_d
end type
global w_91020_d w_91020_d

type variables
String is_fr_ymd, is_to_ymd, is_proc_gubn

end variables

on w_91020_d.create
call super::create
end on

on w_91020_d.destroy
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

is_proc_gubn = dw_head.GetItemString(1, "proc_gubn")
if IsNull(is_proc_gubn) or Trim(is_proc_gubn) = "" then
   MessageBox(ls_title,"처리구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("proc_gubn")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_proc_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
	dw_body.Modify("DataWindow.Detail.Height.AutoSize=Yes")
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;
	datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" +  &
             "t_fr_ymd.Text = '" + IS_FR_YMD + "'" + &
             "t_to_ymd.Text = '" + IS_TO_YMD + "'" 

//MESSAGEBOX("ls_modify", ls_modify)

dw_print.Modify(ls_modify)	
dw_print.Modify("DataWindow.Detail.Height.AutoSize=Yes")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_91020_D","0")
end event

type cb_close from w_com010_d`cb_close within w_91020_d
end type

type cb_delete from w_com010_d`cb_delete within w_91020_d
end type

type cb_insert from w_com010_d`cb_insert within w_91020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_91020_d
end type

type cb_update from w_com010_d`cb_update within w_91020_d
end type

type cb_print from w_com010_d`cb_print within w_91020_d
end type

type cb_preview from w_com010_d`cb_preview within w_91020_d
end type

type gb_button from w_com010_d`gb_button within w_91020_d
end type

type cb_excel from w_com010_d`cb_excel within w_91020_d
end type

type dw_head from w_com010_d`dw_head within w_91020_d
integer height = 140
string dataobject = "d_91020_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_91020_d
integer beginy = 316
integer endy = 316
end type

type ln_2 from w_com010_d`ln_2 within w_91020_d
integer beginy = 320
integer endy = 320
end type

type dw_body from w_com010_d`dw_body within w_91020_d
integer y = 332
integer height = 1708
string dataobject = "d_91020_d01"
end type

type dw_print from w_com010_d`dw_print within w_91020_d
string dataobject = "d_91020_R01"
end type

