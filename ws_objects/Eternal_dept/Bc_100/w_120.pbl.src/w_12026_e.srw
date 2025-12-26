$PBExportHeader$w_12026_e.srw
$PBExportComments$요척변경서
forward
global type w_12026_e from w_com020_e
end type
end forward

global type w_12026_e from w_com020_e
integer width = 3685
integer height = 2288
end type
global w_12026_e w_12026_e

type variables
string is_style
DataWindowChild  idw_mat_info


end variables

on w_12026_e.create
call super::create
end on

on w_12026_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve('%')
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_STYLE, LS_CHNO 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"				
//			IF ai_div = 1 THEN 	
//				IF gf_shop_nm(as_data, 'S', ls_style) = 0 THEN
//				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
//					RETURN 0
//				END IF 
//			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "스타일 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE brand = '" + gs_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "style LIKE '%" + as_data + "%'"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_body.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
				
				idw_mat_info.Retrieve(lds_Source.GetItemString(1,"style"),lds_Source.GetItemString(1,"chno") )
				
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("mat_cd")
				dw_body.setfocus()
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

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
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

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

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

type cb_close from w_com020_e`cb_close within w_12026_e
end type

type cb_delete from w_com020_e`cb_delete within w_12026_e
end type

type cb_insert from w_com020_e`cb_insert within w_12026_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_12026_e
end type

type cb_update from w_com020_e`cb_update within w_12026_e
end type

type cb_print from w_com020_e`cb_print within w_12026_e
end type

type cb_preview from w_com020_e`cb_preview within w_12026_e
end type

type gb_button from w_com020_e`gb_button within w_12026_e
end type

type cb_excel from w_com020_e`cb_excel within w_12026_e
end type

type dw_head from w_com020_e`dw_head within w_12026_e
boolean visible = false
integer y = 116
integer height = 36
end type

type ln_1 from w_com020_e`ln_1 within w_12026_e
boolean visible = false
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com020_e`ln_2 within w_12026_e
boolean visible = false
integer beginy = 296
integer endy = 296
end type

type dw_list from w_com020_e`dw_list within w_12026_e
integer y = 164
integer width = 937
integer height = 1884
string dataobject = "d_12026_l01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_chno
IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_style = This.GetItemString(row, 'style') /* DataWindow에 Key 항목을 가져온다 */
ls_chno  = this.GetItemString(row, 'chno')
IF IsNull(is_style) THEN return
idw_mat_info.Retrieve(is_style,ls_chno)

il_rows = dw_body.retrieve(is_style)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

event dw_list::constructor;call super::constructor;datawindowchild ldw_child

dw_list.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('123')
end event

type dw_body from w_com020_e`dw_body within w_12026_e
integer x = 987
integer y = 164
integer width = 2610
integer height = 1884
string dataobject = "d_12026_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
string ls_mat_fg
decimal ldc_bf_reqqty, ldc_req_qty
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "mat_cd"
		ldc_bf_reqqty  = idw_mat_info.getitemdecimal(idw_mat_info.getrow(),"bf_reqqty")
		dw_body.setitem(row,"bf_reqqty", ldc_bf_reqqty)

		ldc_req_qty  = idw_mat_info.getitemdecimal(idw_mat_info.getrow(),"req_qty")
		dw_body.setitem(row,"req_qty", ldc_req_qty)

		ls_mat_fg = idw_mat_info.getitemstring(idw_mat_info.getrow(),"mat_fg_cd")
		dw_body.setitem(row,"mat_fg", ls_mat_fg)
		
		this.setcolumn("req_qty")
		
END CHOOSE

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

dw_body.GetChild("mat_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('123')


dw_body.GetChild("mat_cd", idw_mat_info)
idw_mat_info.SetTransObject(SQLCA)
idw_mat_info.Retrieve('xxxxxxxx','x')

end event

type st_1 from w_com020_e`st_1 within w_12026_e
integer x = 969
integer y = 164
integer height = 1884
end type

type dw_print from w_com020_e`dw_print within w_12026_e
integer x = 87
integer y = 248
end type

