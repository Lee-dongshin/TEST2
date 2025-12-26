$PBExportHeader$w_74021_d.srw
$PBExportComments$매장별회원모집현황
forward
global type w_74021_d from w_com010_d
end type
end forward

global type w_74021_d from w_com010_d
end type
global w_74021_d w_74021_d

type variables
String is_brand, is_frm_ymd, is_to_ymd
DataWindowChild idw_brand


end variables

event open;call super::open;datetime ld_datetime
String ls_today, ls_t_day

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

ls_today = string(ld_datetime,"yyyymmdd")

select convert(char(08), dateadd(day, -6, :ls_today),112)
into :ls_t_day
from dual;

dw_head.SetItem(1, "frm_ymd" ,ls_t_day)
dw_head.SetItem(1, "to_ymd" ,string(ld_datetime,"yyyymmdd"))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title
long ll_datepart

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

is_brand = "W"

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

select abs( datediff(day, :is_frm_ymd, :is_to_ymd) )
into :ll_datepart
from dual;

if ll_datepart > 7 then
   MessageBox(ls_title,"기간이 일주일은 조회 할 수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if	

return true

end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve('3', is_frm_ymd, is_to_ymd, is_brand)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()

il_rows = dw_body.retrieve('3', is_frm_ymd, is_to_ymd, is_brand)

IF il_rows = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
ELSE
   il_rows = dw_print.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve('3', is_frm_ymd, is_to_ymd, is_brand)



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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text    = '" + is_pgm_id + "'" + &
             "t_user_id.Text  = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_frm_ymd.Text  = '" + String(is_frm_ymd,"@@@@/@@/@@") + "'" + &
				 "t_to_ymd.Text   = '" + String(is_to_ymd,"@@@@/@@/@@") + "'" 
				 

dw_print.Modify(ls_modify)


end event

on w_74021_d.create
call super::create
end on

on w_74021_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_74021_d","0")
end event

type cb_close from w_com010_d`cb_close within w_74021_d
end type

type cb_delete from w_com010_d`cb_delete within w_74021_d
end type

type cb_insert from w_com010_d`cb_insert within w_74021_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_74021_d
end type

type cb_update from w_com010_d`cb_update within w_74021_d
end type

type cb_print from w_com010_d`cb_print within w_74021_d
end type

type cb_preview from w_com010_d`cb_preview within w_74021_d
end type

type gb_button from w_com010_d`gb_button within w_74021_d
end type

type cb_excel from w_com010_d`cb_excel within w_74021_d
end type

type dw_head from w_com010_d`dw_head within w_74021_d
integer y = 156
integer width = 3410
integer height = 164
string dataobject = "d_74021_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_74021_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com010_d`ln_2 within w_74021_d
integer beginy = 324
integer endy = 324
end type

type dw_body from w_com010_d`dw_body within w_74021_d
integer y = 340
integer width = 3598
integer height = 1672
string dataobject = "d_74021_d05"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_74021_d
string dataobject = "d_74021_r01"
end type

