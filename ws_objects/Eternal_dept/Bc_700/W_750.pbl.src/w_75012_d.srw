$PBExportHeader$w_75012_d.srw
$PBExportComments$RFM별 고객리스트
forward
global type w_75012_d from w_com010_d
end type
type dw_member from datawindow within w_75012_d
end type
end forward

global type w_75012_d from w_com010_d
dw_member dw_member
end type
global w_75012_d w_75012_d

type variables
string is_rfm_grd, is_area_cd, is_shop_cd, is_shop_grp, is_brand

datawindowchild idw_area_cd, idw_shop_grp, idw_area, idw_sale_type

end variables

on w_75012_d.create
int iCurrent
call super::create
this.dw_member=create dw_member
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_member
end on

on w_75012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_member)
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

is_rfm_grd = dw_head.GetItemString(1, "rfm_grd")
if IsNull(is_rfm_grd) or Trim(is_rfm_grd) = "" then
   MessageBox(ls_title,"고객 등급을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rfm_grd")
   return false
end if
is_area_cd  = dw_head.GetItemString(1, "area_cd")
is_shop_cd  = dw_head.GetItemString(1, "shop_cd")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")
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

il_rows = dw_body.retrieve(is_rfm_grd, is_area_cd, is_shop_cd, is_shop_grp, is_brand)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE SHOP_STAT = '00' "	+ &
											 "  AND SHOP_DIV  IN ('G','K') "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(SHOP_CD LIKE '" + as_data + "%' or SHOP_SNM LIKE '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event pfc_preopen();call super::pfc_preopen;dw_member.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_75012_d
end type

type cb_delete from w_com010_d`cb_delete within w_75012_d
end type

type cb_insert from w_com010_d`cb_insert within w_75012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75012_d
end type

type cb_update from w_com010_d`cb_update within w_75012_d
end type

type cb_print from w_com010_d`cb_print within w_75012_d
end type

type cb_preview from w_com010_d`cb_preview within w_75012_d
end type

type gb_button from w_com010_d`gb_button within w_75012_d
end type

type cb_excel from w_com010_d`cb_excel within w_75012_d
end type

type dw_head from w_com010_d`dw_head within w_75012_d
integer width = 3575
integer height = 148
string dataobject = "d_75012_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("area_cd",idw_area_cd)
idw_area_cd.settransobject(sqlca)
idw_area_cd.retrieve('090')
idw_area_cd.insertrow(1)
idw_area_cd.setitem(1,"inter_cd","%")
idw_area_cd.setitem(1,"inter_nm","전체")

this.getchild("shop_grp",idw_shop_grp)
idw_shop_grp.settransobject(sqlca)
idw_shop_grp.retrieve('912')
idw_shop_grp.insertrow(1)
idw_shop_grp.setitem(1,"inter_cd","%")
idw_shop_grp.setitem(1,"inter_nm","전체")

end event

type ln_1 from w_com010_d`ln_1 within w_75012_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_75012_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_75012_d
integer y = 344
integer height = 1696
string dataobject = "d_75012_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string  ls_jumin
long    ll_rows


dw_member.Reset()
ls_jumin = this.getitemstring(row,"jumin")
ll_rows = dw_member.Retrieve(ls_jumin) 

if  ll_rows > 0 then
	dw_member.visible = true
end if

end event

type dw_print from w_com010_d`dw_print within w_75012_d
string dataobject = "d_75012_r01"
end type

type dw_member from datawindow within w_75012_d
boolean visible = false
integer x = 5
integer y = 300
integer width = 4500
integer height = 2000
integer taborder = 40
boolean titlebar = true
string title = "회원정보"
string dataobject = "d_member_info"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;This.GetChild("area", idw_area)
idw_area.SetTRansObject(SQLCA)
idw_area.Retrieve('090')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
end event

event doubleclicked;This.Visible = false 
end event

