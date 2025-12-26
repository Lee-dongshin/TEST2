$PBExportHeader$w_58030_d.srw
$PBExportComments$부자재수출현황
forward
global type w_58030_d from w_com010_d
end type
end forward

global type w_58030_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_58030_d w_58030_d

type variables
string is_invoice_no, is_ord_origin, is_fr_ymd, is_to_ymd, is_brand
datawindowchild idw_brand


end variables

on w_58030_d.create
call super::create
end on

on w_58030_d.destroy
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

is_invoice_no = dw_head.GetItemString(1, "invoice_no")
is_ord_origin = dw_head.GetItemString(1, "ord_origin")
is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")
is_brand = dw_head.GetItemString(1, "brand")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_invoice_no, is_ord_origin, is_fr_ymd, is_to_ymd, is_brand)
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

dw_print.object.t_invoice_no.text = is_invoice_no
dw_print.object.t_ord_origin.text = is_ord_origin
dw_print.object.t_yymmdd.text = "조회기간:" + is_fr_ymd + " - " + is_to_ymd
dw_print.object.t_brand.text = "브랜드: " + is_brand

end event

event ue_preview();
/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation	 = 0
dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_58030_d
end type

type cb_delete from w_com010_d`cb_delete within w_58030_d
end type

type cb_insert from w_com010_d`cb_insert within w_58030_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58030_d
end type

type cb_update from w_com010_d`cb_update within w_58030_d
end type

type cb_print from w_com010_d`cb_print within w_58030_d
end type

type cb_preview from w_com010_d`cb_preview within w_58030_d
end type

type gb_button from w_com010_d`gb_button within w_58030_d
end type

type cb_excel from w_com010_d`cb_excel within w_58030_d
end type

type dw_head from w_com010_d`dw_head within w_58030_d
integer height = 144
string dataobject = "d_58030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_58030_d
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_d`ln_2 within w_58030_d
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_d`dw_body within w_58030_d
integer y = 368
integer height = 1672
string dataobject = "d_58030_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_58030_d
string dataobject = "d_58030_r01"
end type

