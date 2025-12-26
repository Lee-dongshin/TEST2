$PBExportHeader$w_42003_r_s.srw
$PBExportComments$반품등록[출고read조건]
forward
global type w_42003_r_s from w_com010_d
end type
end forward

global type w_42003_r_s from w_com010_d
integer width = 1385
integer height = 652
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_closeparm ( )
end type
global w_42003_r_s w_42003_r_s

type variables
String is_brand
end variables

event ue_closeparm();IF dw_head.AcceptText() <> 1 THEN RETURN 

gsv_cd.gs_cd2 = dw_head.GetitemString(1, "fr_ymd")
gsv_cd.gs_cd3 = dw_head.GetitemString(1, "to_ymd")
gsv_cd.gs_cd4 = dw_head.GetitemString(1, "shop_cd")


IF isnull(gsv_cd.gs_cd2) or Trim(gsv_cd.gs_cd2) = "" THEN 
	MessageBox("확인", "출고 일자를 입력하십시요 !")
	dw_head.SetColumn("fr_ymd") 
	dw_head.SetFocus()
	Return
END IF

IF isnull(gsv_cd.gs_cd3) or Trim(gsv_cd.gs_cd3) = "" THEN 
	dw_head.SetColumn("to_ymd") 
	dw_head.SetFocus()
	Return
END IF

IF isnull(gsv_cd.gs_cd4) or Trim(gsv_cd.gs_cd4) = "" THEN 
	gsv_cd.gs_cd4 = "%"
END IF

CloseWithReturn(This, "YES")

end event

on w_42003_r_s.create
call super::create
end on

on w_42003_r_s.destroy
call super::destroy
end on

event pfc_preopen();call super::pfc_preopen;Window ldw_parent
Long   ll_x, ll_y

ldw_parent = This.ParentWindow()
This.x = ((ldw_parent.Width - This.Width) / 2) +  ldw_parent.x
This.y = ((ldw_parent.Height - This.Height) / 2) +  ldw_parent.y 

end event

event open;call super::open;is_brand = gsv_cd.gs_cd1 

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_cd, ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND  (SHOP_DIV  IN ('G', 'K', 'T') or shop_cd like '__499_') " + &
											 "  AND BRAND = '" + is_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("out_no")
				ib_itemchanged = False 
				lb_check = TRUE 
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

type cb_close from w_com010_d`cb_close within w_42003_r_s
integer x = 965
string text = "닫기(&X)"
end type

type cb_delete from w_com010_d`cb_delete within w_42003_r_s
end type

type cb_insert from w_com010_d`cb_insert within w_42003_r_s
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_42003_r_s
integer x = 55
integer width = 494
string text = "출고자료산출(&Q)"
end type

event cb_retrieve::clicked;String ls_yymmdd, ls_shop_cd, ls_out_no

Parent.Post Event ue_closeparm()
end event

type cb_update from w_com010_d`cb_update within w_42003_r_s
end type

type cb_print from w_com010_d`cb_print within w_42003_r_s
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_42003_r_s
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_42003_r_s
integer width = 1353
end type

type cb_excel from w_com010_d`cb_excel within w_42003_r_s
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_42003_r_s
integer x = 9
integer width = 1353
integer height = 364
string dataobject = "d_42003_r_h02"
boolean border = true
borderstyle borderstyle = stylelowered!
end type

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

type ln_1 from w_com010_d`ln_1 within w_42003_r_s
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_42003_r_s
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_42003_r_s
boolean visible = false
integer width = 914
integer height = 472
end type

type dw_print from w_com010_d`dw_print within w_42003_r_s
end type

