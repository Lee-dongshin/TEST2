$PBExportHeader$w_74015_d.srw
$PBExportComments$Point 사용조회
forward
global type w_74015_d from w_com010_d
end type
end forward

global type w_74015_d from w_com010_d
end type
global w_74015_d w_74015_d

type variables
decimal id_point
end variables

on w_74015_d.create
call super::create
end on

on w_74015_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(id_point)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
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

id_point =  dw_head.GetItemdecimal(1,'point')
if IsNull(id_point) or id_point = 0 then
   MessageBox(ls_title,"Point를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("point")
   return false
end if

return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_vip

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'"
           
				

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_74015_d","0")
end event

type cb_close from w_com010_d`cb_close within w_74015_d
end type

type cb_delete from w_com010_d`cb_delete within w_74015_d
end type

type cb_insert from w_com010_d`cb_insert within w_74015_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_74015_d
end type

type cb_update from w_com010_d`cb_update within w_74015_d
end type

type cb_print from w_com010_d`cb_print within w_74015_d
end type

type cb_preview from w_com010_d`cb_preview within w_74015_d
end type

type gb_button from w_com010_d`gb_button within w_74015_d
end type

type cb_excel from w_com010_d`cb_excel within w_74015_d
end type

type dw_head from w_com010_d`dw_head within w_74015_d
integer x = 50
integer y = 176
integer width = 1673
integer height = 216
string dataobject = "d_74015_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_74015_d
integer beginy = 436
integer endy = 436
end type

type ln_2 from w_com010_d`ln_2 within w_74015_d
integer beginy = 440
integer endy = 440
end type

type dw_body from w_com010_d`dw_body within w_74015_d
integer y = 444
integer height = 1580
string dataobject = "d_74015_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_74015_d
integer x = 1088
integer y = 792
integer height = 588
string dataobject = "d_74015_d01"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

