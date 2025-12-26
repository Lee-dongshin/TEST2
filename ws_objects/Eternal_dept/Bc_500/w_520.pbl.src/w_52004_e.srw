$PBExportHeader$w_52004_e.srw
$PBExportComments$매장배분통제관리
forward
global type w_52004_e from w_com010_e
end type
end forward

global type w_52004_e from w_com010_e
integer width = 3675
integer height = 2288
end type
global w_52004_e w_52004_e

type variables
String is_brand, is_shop_div
end variables

on w_52004_e.create
call super::create
end on

on w_52004_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
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

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_shop_div)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.31                                                  */	
/* 수정일      : 2002.01.31                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN			/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;dw_head.Setitem(1, "shop_div", "%")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52004_e","0")
end event

type cb_close from w_com010_e`cb_close within w_52004_e
end type

type cb_delete from w_com010_e`cb_delete within w_52004_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_52004_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_52004_e
end type

type cb_update from w_com010_e`cb_update within w_52004_e
end type

type cb_print from w_com010_e`cb_print within w_52004_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_52004_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_52004_e
end type

type cb_excel from w_com010_e`cb_excel within w_52004_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_52004_e
integer height = 160
string dataobject = "d_52004_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_Child

This.GetChild("brand", ldw_Child)
ldw_Child.SetTransObject(SQLCA)
ldw_Child.Retrieve('001')

This.GetChild("shop_div", ldw_Child)
ldw_Child.SetTransObject(SQLCA)
ldw_Child.Retrieve('910')
ldw_Child.insertRow(1)
ldw_Child.Setitem(1, "inter_cd", "%")
ldw_Child.Setitem(1, "inter_nm", "전체")
//ldw_child.SetFilter("inter_cd <> 'A' and inter_cd <> 'T' and inter_cd <> 'X'")
ldw_child.SetFilter("inter_cd <> 'A' ")
ldw_child.Filter()
end event

type ln_1 from w_com010_e`ln_1 within w_52004_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_e`ln_2 within w_52004_e
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_e`dw_body within w_52004_e
integer y = 376
integer height = 1672
string dataobject = "d_52004_d01"
end type

type dw_print from w_com010_e`dw_print within w_52004_e
integer x = 174
integer y = 496
end type

