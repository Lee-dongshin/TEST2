$PBExportHeader$w_62028_d.srw
$PBExportComments$품평스타일 판매현황
forward
global type w_62028_d from w_com020_d
end type
end forward

global type w_62028_d from w_com020_d
integer width = 3680
integer height = 2260
end type
global w_62028_d w_62028_d

type variables

DataWindowChild	idw_brand
string is_brand, is_yymmdd
end variables

on w_62028_d.create
call super::create
end on

on w_62028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_preopen();call super::pfc_preopen;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand)
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
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text  = idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_yymmdd.text = is_yymmdd


end event

type cb_close from w_com020_d`cb_close within w_62028_d
end type

type cb_delete from w_com020_d`cb_delete within w_62028_d
end type

type cb_insert from w_com020_d`cb_insert within w_62028_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_62028_d
end type

type cb_update from w_com020_d`cb_update within w_62028_d
end type

type cb_print from w_com020_d`cb_print within w_62028_d
end type

type cb_preview from w_com020_d`cb_preview within w_62028_d
end type

type gb_button from w_com020_d`gb_button within w_62028_d
end type

type cb_excel from w_com020_d`cb_excel within w_62028_d
end type

type dw_head from w_com020_d`dw_head within w_62028_d
integer y = 164
integer height = 116
string dataobject = "d_62028_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com020_d`ln_1 within w_62028_d
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com020_d`ln_2 within w_62028_d
integer beginy = 296
integer endy = 296
end type

type dw_list from w_com020_d`dw_list within w_62028_d
integer y = 320
integer height = 1696
string dataobject = "d_62028_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) THEN return
il_rows = dw_body.retrieve(is_brand, is_yymmdd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_62028_d
integer y = 320
integer height = 1696
string dataobject = "d_62028_d01"
end type

type st_1 from w_com020_d`st_1 within w_62028_d
integer y = 320
integer height = 1696
end type

type dw_print from w_com020_d`dw_print within w_62028_d
integer x = 37
integer y = 712
string dataobject = "d_62028_r01"
end type

