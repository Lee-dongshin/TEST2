$PBExportHeader$w_91008_e.srw
$PBExportComments$비축부자재 등록
forward
global type w_91008_e from w_com010_e
end type
end forward

global type w_91008_e from w_com010_e
end type
global w_91008_e w_91008_e

type variables
string is_brand, is_save_gubn
datawindowchild idw_brand
end variables

on w_91008_e.create
call super::create
end on

on w_91008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm , ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "mat_cd"				
			ls_brand = dw_body.getitemstring(al_row,"brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_91008_ddw" 
			gst_cd.default_where   = "WHERE brand = '" + ls_brand + "'" 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " 1=1 "
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
				dw_body.SetItem(al_row, "brand", lds_Source.GetItemString(1,"brand") )
				dw_body.SetItem(al_row, "mat_cd", RightA(lds_Source.GetItemString(1,"mat_cd"),6) )
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("end_ymd")
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

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "brand", is_brand)
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve('%', is_save_gubn)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

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

is_save_gubn = dw_head.GetItemString(1, "save_gubn")

return true

end event

type cb_close from w_com010_e`cb_close within w_91008_e
end type

type cb_delete from w_com010_e`cb_delete within w_91008_e
end type

type cb_insert from w_com010_e`cb_insert within w_91008_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91008_e
end type

type cb_update from w_com010_e`cb_update within w_91008_e
end type

type cb_print from w_com010_e`cb_print within w_91008_e
end type

type cb_preview from w_com010_e`cb_preview within w_91008_e
end type

type gb_button from w_com010_e`gb_button within w_91008_e
end type

type cb_excel from w_com010_e`cb_excel within w_91008_e
end type

type dw_head from w_com010_e`dw_head within w_91008_e
string dataobject = "d_91008_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_save_gubn
This.GetChild("save_gubn", ldw_save_gubn)
ldw_save_gubn.SetTransObject(SQLCA)
ldw_save_gubn.Retrieve('033')
ldw_save_gubn.insertrow(1)
ldw_save_gubn.setitem(1,"save_gubn", "%")


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_91008_e
end type

type ln_2 from w_com010_e`ln_2 within w_91008_e
end type

type dw_body from w_com010_e`dw_body within w_91008_e
string dataobject = "d_91008_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_save_gubn
This.GetChild("save_gubn", ldw_save_gubn)
ldw_save_gubn.SetTransObject(SQLCA)
ldw_save_gubn.Retrieve('033')

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type dw_print from w_com010_e`dw_print within w_91008_e
end type

