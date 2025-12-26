$PBExportHeader$w_51025_d.srw
$PBExportComments$매장 마감 EDI 입력 조회
forward
global type w_51025_d from w_com010_d
end type
end forward

global type w_51025_d from w_com010_d
end type
global w_51025_d w_51025_d

type variables
string is_brand, is_fr_ymd, is_to_ymd
DataWindowChild idw_brand
end variables

on w_51025_d.create
call super::create
end on

on w_51025_d.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if


is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd,is_to_ymd, is_brand)
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
string ls_modify, ls_datetime, ls_year, ls_season, ls_item, ls_sojae

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")


ls_modify =	"txtbrand.Text     = '" + is_brand + "' " + &	
            "txtfrm_date.Text  = '" + is_fr_ymd + "' " + &
            "txtto_date.Text   = '" + is_to_ymd+ "' " //+ &
//            "txthouse_cd.Text  = '" + is_house_cd + "' " + &
//            "txtin_gubn.Text   = '" + is_in_gubn + "' " + &				
//            "txtjup_gubn.Text  = '" + is_jup_gubn + "' " + &				
//				"txtyear.Text      = '" + ls_year + "' " + &				
//            "txtseason.Text     = '" + ls_season + "' " + &								
//				"txtitem.Text      = '" + ls_item + "' " + &				
//            "txtsojae.Text     = '" + ls_sojae + "'" 								

dw_print.Modify(ls_modify)

end event

event ue_preview();
This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

type cb_close from w_com010_d`cb_close within w_51025_d
end type

type cb_delete from w_com010_d`cb_delete within w_51025_d
end type

type cb_insert from w_com010_d`cb_insert within w_51025_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_51025_d
end type

type cb_update from w_com010_d`cb_update within w_51025_d
end type

type cb_print from w_com010_d`cb_print within w_51025_d
end type

type cb_preview from w_com010_d`cb_preview within w_51025_d
end type

type gb_button from w_com010_d`gb_button within w_51025_d
end type

type cb_excel from w_com010_d`cb_excel within w_51025_d
end type

type dw_head from w_com010_d`dw_head within w_51025_d
integer y = 156
integer height = 196
string dataobject = "d_51025_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_d`ln_1 within w_51025_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_51025_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_51025_d
integer y = 364
integer width = 3566
integer height = 1640
string dataobject = "d_51025_d01"
end type

type dw_print from w_com010_d`dw_print within w_51025_d
string dataobject = "d_51025_r01"
end type

