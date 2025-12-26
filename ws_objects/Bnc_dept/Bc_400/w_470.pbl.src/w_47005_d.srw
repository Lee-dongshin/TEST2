$PBExportHeader$w_47005_d.srw
$PBExportComments$입점몰 주문판매현황
forward
global type w_47005_d from w_com010_d
end type
end forward

global type w_47005_d from w_com010_d
end type
global w_47005_d w_47005_d

type variables
String is_fr_ymd, is_to_ymd, is_shop_cd, is_brandm, is_view_opt, is_brand
DataWindowChild idw_brand
end variables

on w_47005_d.create
call super::create
end on

on w_47005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"W_47005_d","0")
end event

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
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"주문일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if


is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

is_view_opt = dw_head.GetItemString(1, "view_opt")


return true
end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
string ls_opt

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if is_view_opt = "AA" then 
	dw_body.dataobject = "d_47005_d01"
	ls_opt = "A"
elseif is_view_opt = "AB" then 
	dw_body.dataobject = "d_47005_d11"
	ls_opt = "B"
elseif is_view_opt = "BA" then 
	dw_body.dataobject = "d_47005_d02"
	ls_opt = "A"	
elseif is_view_opt = "BB" then 
	dw_body.dataobject = "d_47005_d12"
	ls_opt = "B"
end if

dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_shop_cd, is_brand, ls_opt)
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event open;call super::open;dw_head.setitem(1, "brand", "%")
end event

type cb_close from w_com010_d`cb_close within w_47005_d
end type

type cb_delete from w_com010_d`cb_delete within w_47005_d
end type

type cb_insert from w_com010_d`cb_insert within w_47005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_47005_d
end type

type cb_update from w_com010_d`cb_update within w_47005_d
end type

type cb_print from w_com010_d`cb_print within w_47005_d
end type

type cb_preview from w_com010_d`cb_preview within w_47005_d
end type

type gb_button from w_com010_d`gb_button within w_47005_d
end type

type cb_excel from w_com010_d`cb_excel within w_47005_d
end type

type dw_head from w_com010_d`dw_head within w_47005_d
integer width = 3584
integer height = 184
string dataobject = "d_47005_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.insertrow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_47005_d
integer beginy = 380
integer endy = 380
end type

type ln_2 from w_com010_d`ln_2 within w_47005_d
integer beginy = 384
integer endy = 384
end type

type dw_body from w_com010_d`dw_body within w_47005_d
integer y = 400
integer height = 1640
string dataobject = "d_47005_d01"
end type

type dw_print from w_com010_d`dw_print within w_47005_d
end type

