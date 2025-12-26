$PBExportHeader$w_51011_d.srw
$PBExportComments$행사계획서(달력)
forward
global type w_51011_d from w_com010_d
end type
end forward

global type w_51011_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_51011_d w_51011_d

type variables
DataWindowChild	idw_brand
String is_brand, is_yymm
end variables

on w_51011_d.create
call super::create
end on

on w_51011_d.destroy
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"기준월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

return true

end event

event open;call super::open;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.setitem(1, "yymm", string(ld_datetime, "YYYYMM"))

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_51011_d","0")
end event

event ue_retrieve();call super::ue_retrieve;
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm)
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

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_51011_d
end type

type cb_delete from w_com010_d`cb_delete within w_51011_d
end type

type cb_insert from w_com010_d`cb_insert within w_51011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51011_d
end type

type cb_update from w_com010_d`cb_update within w_51011_d
end type

type cb_print from w_com010_d`cb_print within w_51011_d
end type

type cb_preview from w_com010_d`cb_preview within w_51011_d
end type

type gb_button from w_com010_d`gb_button within w_51011_d
end type

type cb_excel from w_com010_d`cb_excel within w_51011_d
end type

type dw_head from w_com010_d`dw_head within w_51011_d
integer height = 160
string dataobject = "d_51011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

type ln_1 from w_com010_d`ln_1 within w_51011_d
integer beginy = 340
integer endy = 340
end type

type ln_2 from w_com010_d`ln_2 within w_51011_d
integer beginy = 344
integer endy = 344
end type

type dw_body from w_com010_d`dw_body within w_51011_d
integer y = 360
integer height = 1680
string dataobject = "d_51011_d01"
end type

type dw_print from w_com010_d`dw_print within w_51011_d
string dataobject = "d_51011_r01"
end type

