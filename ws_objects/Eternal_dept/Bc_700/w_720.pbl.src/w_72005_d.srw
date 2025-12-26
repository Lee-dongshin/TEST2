$PBExportHeader$w_72005_d.srw
$PBExportComments$매출분석(지역/연령별)
forward
global type w_72005_d from w_com010_d
end type
end forward

global type w_72005_d from w_com010_d
end type
global w_72005_d w_72005_d

type variables
String 	is_brand, is_vip
String   is_sale_from,is_sale_to
DataWindowChild idw_brand

end variables

on w_72005_d.create
call super::create
end on

on w_72005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "sale_from", String(ld_datetime,'yyyy0101'))
dw_head.SetItem(1, "sale_to", String(ld_datetime,'yyyymmdd'))

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

is_sale_from = dw_head.GetItemString(1, "sale_from")
if IsNull(is_sale_from) OR is_sale_from = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_from")
   return false
end if

is_sale_to = dw_head.GetItemString(1, "sale_to")
if IsNull(is_sale_to) OR is_sale_to = "" then
   MessageBox(ls_title,"조회일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_to")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
is_vip = dw_head.GetItemString(1, "vip")
return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_sale_from,is_sale_to,is_brand, is_vip)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime
string ls_shop_nm , ls_vip

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"  + &
            "t_st_ymd.Text = '" + String(is_sale_from, '@@@@/@@/@@') + "'" + &
				"t_ed_ymd.Text = '" + String(is_sale_to, '@@@@/@@/@@') + "'" + &
				"t_vip.Text = '" + ls_vip + "'"


dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_72005_d","0")
end event

type cb_close from w_com010_d`cb_close within w_72005_d
end type

type cb_delete from w_com010_d`cb_delete within w_72005_d
end type

type cb_insert from w_com010_d`cb_insert within w_72005_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_72005_d
end type

type cb_update from w_com010_d`cb_update within w_72005_d
end type

type cb_print from w_com010_d`cb_print within w_72005_d
end type

type cb_preview from w_com010_d`cb_preview within w_72005_d
end type

type gb_button from w_com010_d`gb_button within w_72005_d
end type

type cb_excel from w_com010_d`cb_excel within w_72005_d
end type

type dw_head from w_com010_d`dw_head within w_72005_d
integer height = 172
string dataobject = "d_72005_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1,'inter_cd','')
idw_brand.SetItem(1,'inter_nm','전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "area"
		This.SetItem(1, "brand", "")
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_72005_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_72005_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_72005_d
integer y = 368
integer height = 1672
string dataobject = "d_72005_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
DataWindowChild ldw_child 

This.GetChild("area", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('090')
end event

type dw_print from w_com010_d`dw_print within w_72005_d
integer x = 1477
integer y = 796
integer width = 1435
integer height = 468
string dataobject = "d_72005_r01"
end type

event dw_print::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/
DataWindowChild ldw_child 

This.GetChild("area", ldw_child)
ldw_child.SetTRansObject(SQLCA)
ldw_child.Retrieve('090')
end event

