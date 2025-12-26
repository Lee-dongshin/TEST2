$PBExportHeader$w_52007_e.srw
$PBExportComments$매장배분 등급 관리
forward
global type w_52007_e from w_com010_e
end type
end forward

global type w_52007_e from w_com010_e
integer width = 3675
integer height = 2276
end type
global w_52007_e w_52007_e

type variables
DataWindowChild idw_brand, idw_shop_lv
String is_brand, is_shop_lv
end variables

on w_52007_e.create
call super::create
end on

on w_52007_e.destroy
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

is_shop_lv = dw_head.GetItemString(1, "shop_lv")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_shop_lv)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

type cb_close from w_com010_e`cb_close within w_52007_e
end type

type cb_delete from w_com010_e`cb_delete within w_52007_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52007_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52007_e
end type

type cb_update from w_com010_e`cb_update within w_52007_e
end type

type cb_print from w_com010_e`cb_print within w_52007_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_52007_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52007_e
end type

type cb_excel from w_com010_e`cb_excel within w_52007_e
end type

type dw_head from w_com010_e`dw_head within w_52007_e
integer height = 144
string dataobject = "d_52007_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("shop_lv", idw_shop_lv)
idw_shop_lv.SetTransObject(SQLCA)
idw_shop_lv.Retrieve('093')
idw_shop_lv.InsertRow(1)
idw_shop_lv.SetItem(1, "inter_cd", '%')
idw_shop_lv.SetItem(1, "inter_nm", '전체')


end event

type ln_1 from w_com010_e`ln_1 within w_52007_e
end type

type ln_2 from w_com010_e`ln_2 within w_52007_e
end type

type dw_body from w_com010_e`dw_body within w_52007_e
integer y = 360
integer height = 1680
string dataobject = "d_52007_d01"
end type

event dw_body::constructor;call super::constructor;
This.GetChild("shop_lv", idw_shop_lv)
idw_shop_lv.SetTransObject(SQLCA)
idw_shop_lv.Retrieve('093')
idw_shop_lv.InsertRow(1)
idw_shop_lv.SetItem(1, "inter_cd", '%')
idw_shop_lv.SetItem(1, "inter_nm", '전체')


end event

type dw_print from w_com010_e`dw_print within w_52007_e
end type

