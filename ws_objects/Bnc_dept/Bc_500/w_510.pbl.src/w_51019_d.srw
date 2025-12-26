$PBExportHeader$w_51019_d.srw
$PBExportComments$매장근무현황 조회
forward
global type w_51019_d from w_com010_d
end type
end forward

global type w_51019_d from w_com010_d
event ue_title_body ( )
end type
global w_51019_d w_51019_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_goout_gubn, is_emp_no
datawindowchild idw_brand
end variables

event ue_title_body();/*===========================================================================*/
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

dw_body.Modify(ls_modify)

dw_body.object.t_brand.text = '브랜드: '+idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_body.object.t_yymmdd.text = '조회기간: '+is_fr_yymmdd + ' - ' + is_to_yymmdd
dw_body.object.t_shop_cd.text = '매장: '+is_shop_cd
if is_goout_gubn = "1"  then 
	dw_body.object.t_goout_gubn.text = '근무상태: 재직중'
elseif is_goout_gubn = "1"  then 
	dw_body.object.t_goout_gubn.text = '근무상태: 퇴직'
else
	dw_body.object.t_goout_gubn.text = '근무상태: 전체'
end if
dw_body.object.t_emp_no.text = '담당: '+is_emp_no




end event

on w_51019_d.create
call super::create
end on

on w_51019_d.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_goout_gubn = dw_head.GetItemString(1, "goout_gubn")
is_emp_no = dw_head.GetItemString(1, "emp_no")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
This.Trigger Event ue_title_body ()
il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_goout_gubn, is_emp_no)
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
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)

dw_print.object.t_brand.text = '브랜드: '+idw_brand.getitemstring(idw_brand.getrow(),"inter_nm")
dw_print.object.t_yymmdd.text = '조회기간: '+is_fr_yymmdd + ' - ' + is_to_yymmdd
dw_print.object.t_shop_cd.text = '매장: '+is_shop_cd
if is_goout_gubn = "1"  then 
	dw_print.object.t_goout_gubn.text = '근무상태: 재직중'
elseif is_goout_gubn = "1"  then 
	dw_print.object.t_goout_gubn.text = '근무상태: 퇴직'
else
	dw_print.object.t_goout_gubn.text = '근무상태: 전체'
end if
dw_print.object.t_emp_no.text = '담당: '+is_emp_no




end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = string(ld_datetime, "YYYYMMDD")

dw_head.setitem(1, "fr_yymmdd", ls_datetime)
dw_head.setitem(1, "to_yymmdd", ls_datetime)

end event

type cb_close from w_com010_d`cb_close within w_51019_d
end type

type cb_delete from w_com010_d`cb_delete within w_51019_d
end type

type cb_insert from w_com010_d`cb_insert within w_51019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51019_d
end type

type cb_update from w_com010_d`cb_update within w_51019_d
end type

type cb_print from w_com010_d`cb_print within w_51019_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_51019_d
end type

type gb_button from w_com010_d`gb_button within w_51019_d
end type

type cb_excel from w_com010_d`cb_excel within w_51019_d
end type

type dw_head from w_com010_d`dw_head within w_51019_d
string dataobject = "d_51019_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


//This.GetChild("season", idw_season)
//idw_season.SetTransObject(SQLCA)
//idw_season.Retrieve('003')
//
//This.GetChild("sojae", idw_sojae)
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')
//
//This.GetChild("item", idw_item)
//idw_item.SetTransObject(SQLCA)
//idw_item.Retrieve()
//idw_item.InsertRow(1)
//idw_item.SetItem(1, "item", '%')
//idw_item.SetItem(1, "item_nm", '전체')
//
//This.GetChild("color", idw_color)
//idw_color.SetTransObject(SQLCA)
//idw_color.retrieve('%')
//idw_color.InsertRow(1)
//idw_color.SetItem(1, "color", '%')
//idw_color.SetItem(1, "color_enm", '전체')
//
//This.GetChild("size", idw_size)
//idw_size.SetTransObject(SQLCA)
//idw_size.retrieve('%')
//idw_size.InsertRow(1)
//idw_size.SetItem(1, "size", '%')
//idw_size.SetItem(1, "size_nm", '전체')
//
end event

type ln_1 from w_com010_d`ln_1 within w_51019_d
end type

type ln_2 from w_com010_d`ln_2 within w_51019_d
end type

type dw_body from w_com010_d`dw_body within w_51019_d
string dataobject = "d_51019_d01"
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_51019_d
string dataobject = "d_51019_d01"
end type

