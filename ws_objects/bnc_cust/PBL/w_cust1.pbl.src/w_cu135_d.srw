$PBExportHeader$w_cu135_d.srw
$PBExportComments$업체별 CMT 정산현황
forward
global type w_cu135_d from w_com010_d
end type
end forward

global type w_cu135_d from w_com010_d
integer width = 3653
integer height = 2236
end type
global w_cu135_d w_cu135_d

type variables
string is_make_cust, is_fr_yymmdd, is_to_yymmdd

end variables

on w_cu135_d.create
call super::create
end on

on w_cu135_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                              */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_make_cust = gs_user_id
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")



return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_make_cust, is_fr_yymmdd, is_to_yymmdd)
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

event ue_title();call super::ue_title;/*===========================================================================*/
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
             "t_user_id.Text = '" + gs_shop_cd + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_fr_yymmdd.text = is_fr_yymmdd
dw_print.object.t_to_yymmdd.text = is_to_yymmdd
end event

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime
string ls_modify, ls_to_yymmdd, ls_fr_yymmdd

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_yymmdd  = string(ld_datetime, 'yyyymmdd')
ls_fr_yymmdd  = LeftA(ls_to_yymmdd,6) +  '01'

dw_head.Setitem(1,"fr_yymmdd",ls_fr_yymmdd)
dw_head.Setitem(1,"to_yymmdd",ls_to_yymmdd)


end event

type cb_close from w_com010_d`cb_close within w_cu135_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu135_d
end type

type cb_insert from w_com010_d`cb_insert within w_cu135_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu135_d
end type

type cb_update from w_com010_d`cb_update within w_cu135_d
end type

type cb_print from w_com010_d`cb_print within w_cu135_d
end type

type cb_preview from w_com010_d`cb_preview within w_cu135_d
end type

type gb_button from w_com010_d`gb_button within w_cu135_d
integer width = 3598
end type

type dw_head from w_com010_d`dw_head within w_cu135_d
integer y = 160
integer width = 3598
integer height = 164
string dataobject = "d_cu135_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_cu135_d
integer beginy = 364
integer endx = 3598
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_cu135_d
integer beginy = 368
integer endx = 3598
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_cu135_d
integer y = 388
integer width = 3598
integer height = 1660
string dataobject = "d_cu135_d01"
end type

type dw_print from w_com010_d`dw_print within w_cu135_d
string dataobject = "d_cu135_r01"
end type

