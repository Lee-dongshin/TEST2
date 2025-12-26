$PBExportHeader$w_75013_d.srw
$PBExportComments$매장별 쿠폰 발행,회수현황
forward
global type w_75013_d from w_com010_d
end type
type dw_1 from datawindow within w_75013_d
end type
end forward

global type w_75013_d from w_com010_d
dw_1 dw_1
end type
global w_75013_d w_75013_d

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_vip, is_shop_div, is_shop_grp, is_shop_cd, is_point

datawindowchild idw_brand, idw_shop_grp
end variables

on w_75013_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_75013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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
is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd = dw_head.GetItemString(1, "to_ymd")
is_vip = dw_head.GetItemString(1, "vip")
is_shop_div = dw_head.GetItemString(1, "shop_div")
is_shop_grp = dw_head.GetItemString(1, "shop_grp")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")
is_point = dw_head.GetItemString(1, "point")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//messagebox("point",is_point)
il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_vip, is_shop_cd, is_shop_div, is_shop_grp, is_point)
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
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &
			                         "  AND SHOP_STAT = '00' "	+ &
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

event open;call super::open;datetime ld_datetime
IF gf_cdate(ld_datetime,-5)  THEN  
	dw_head.setitem(1,"fr_ymd",string(ld_datetime,"yyyymmdd"))
end if

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))
end if
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_print.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_vip, is_shop_cd, is_shop_div, is_shop_grp, is_point)
IF il_rows > 0 THEN
   dw_print.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

dw_print.inv_printpreview.of_SetZoom()
//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "FixedToRight&Bottom")
inv_resize.of_Register(dw_1, "ScaleoToRight")
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_75013_d
end type

type cb_delete from w_com010_d`cb_delete within w_75013_d
end type

type cb_insert from w_com010_d`cb_insert within w_75013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_75013_d
end type

type cb_update from w_com010_d`cb_update within w_75013_d
end type

type cb_print from w_com010_d`cb_print within w_75013_d
end type

type cb_preview from w_com010_d`cb_preview within w_75013_d
end type

type gb_button from w_com010_d`gb_button within w_75013_d
end type

type cb_excel from w_com010_d`cb_excel within w_75013_d
end type

type dw_head from w_com010_d`dw_head within w_75013_d
integer x = 0
integer width = 3680
integer height = 208
string dataobject = "d_75013_h01"
end type

event dw_head::constructor;call super::constructor;this.getchild("brand",idw_brand)
idw_brand.settransobject(sqlca)
idw_brand.retrieve('001')
idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd","%")
idw_brand.setitem(1,"inter_nm","전체")

this.getchild("shop_grp",idw_shop_grp)
idw_shop_grp.settransobject(sqlca)
idw_shop_grp.retrieve('912')
idw_shop_grp.insertrow(1)
idw_shop_grp.setitem(1,"inter_cd","%")
idw_shop_grp.setitem(1,"inter_nm","전체")




end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_75013_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_d`ln_2 within w_75013_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_d`dw_body within w_75013_d
event ue_graph ( long al_row )
integer y = 412
integer height = 1628
string dataobject = "d_75013_d01"
boolean hscrollbar = true
end type

event dw_body::ue_graph(long al_row);string ls_shop_cd


ls_shop_cd = this.getitemstring(al_row,"shop_nm")

il_rows = dw_1.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_vip, ls_shop_cd, is_shop_div, is_shop_grp, is_point)
if il_rows > 0 then
	dw_1.object.gr_1.title = ls_shop_cd
	dw_1.visible = true
end if
end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_cd
if row = 0 then return 1


choose case dwo.name
	case "shop_nm"
		post event ue_graph(row)

end choose

end event

type dw_print from w_com010_d`dw_print within w_75013_d
string dataobject = "d_75013_r01"
end type

type dw_1 from datawindow within w_75013_d
boolean visible = false
integer x = 599
integer y = 1044
integer width = 2994
integer height = 984
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_75013_g01"
boolean controlmenu = true
boolean border = false
boolean livescroll = true
end type

event doubleclicked;this.visible = false
end event

