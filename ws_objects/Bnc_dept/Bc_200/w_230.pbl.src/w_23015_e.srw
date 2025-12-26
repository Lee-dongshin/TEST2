$PBExportHeader$w_23015_e.srw
$PBExportComments$계산서지급보류등록
forward
global type w_23015_e from w_com010_e
end type
end forward

global type w_23015_e from w_com010_e
end type
global w_23015_e w_23015_e

type variables
string is_brand, is_cust_cd
end variables

on w_23015_e.create
call super::create
end on

on w_23015_e.destroy
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
is_cust_cd = dw_head.GetItemString(1, "cust_cd")

if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if



if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
String     ls_claim_cust_nm 
Boolean    lb_check 
DataStore  lds_Source

is_brand = dw_head.getitemstring(1,'brand')
CHOOSE CASE as_column
	CASE "cust_cd"				
			IF ai_div = 1 THEN 				
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF LenA(as_data) = 6 and gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
				
				IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1
				gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																		" when '" + is_brand + "' = 'Y' then 'O' "      + &
																		" else '" + is_brand + "' end "      + &
												 "  and cust_code between '5000' and '8999'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
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
					dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
					dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
					/* 다음컬럼으로 이동 */			
			
					ib_itemchanged = False 
					lb_check = TRUE 
				ELSE
					lb_check = FALSE 
				END IF
				Destroy  lds_Source
			else
				if isnull(as_data) or as_data = "" then
					return 0					
				elseIF gf_cust_nm(as_data, 'S', ls_claim_cust_nm) = 0 THEN
				   dw_body.SetItem(al_row, "cust_nm", ls_claim_cust_nm)
					RETURN 0
				END IF 
				
				IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN -1
				gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = "Where brand     = case when '" + is_brand + "' = 'J' then 'N' "      + &
																		" when '" + is_brand + "' = 'Y' then 'O' "      + &
																		" else '" + is_brand + "' end "      + &
												 "  and cust_code between '5000' and '8999'"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (custcode LIKE '%" + as_data + "%' or cust_name like '%" + as_data + "%')" 
				ELSE
					gst_cd.Item_where = ""
				END IF
	
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)
	
				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
					dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
					dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
					/* 다음컬럼으로 이동 */			
			
					ib_itemchanged = False 
					lb_check = TRUE 
				ELSE
					lb_check = FALSE 
				END IF
				Destroy  lds_Source
			end if

			
END CHOOSE


IF lb_check THEN
	RETURN 2 
ELSE
	RETURN 1
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

il_rows = dw_body.retrieve(is_brand, is_cust_cd)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_23015_e","0")
end event

type cb_close from w_com010_e`cb_close within w_23015_e
end type

type cb_delete from w_com010_e`cb_delete within w_23015_e
end type

type cb_insert from w_com010_e`cb_insert within w_23015_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_23015_e
end type

type cb_update from w_com010_e`cb_update within w_23015_e
end type

type cb_print from w_com010_e`cb_print within w_23015_e
end type

type cb_preview from w_com010_e`cb_preview within w_23015_e
end type

type gb_button from w_com010_e`gb_button within w_23015_e
end type

type cb_excel from w_com010_e`cb_excel within w_23015_e
end type

type dw_head from w_com010_e`dw_head within w_23015_e
string dataobject = "d_23015_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name

	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_23015_e
end type

type ln_2 from w_com010_e`ln_2 within w_23015_e
end type

type dw_body from w_com010_e`dw_body within w_23015_e
string dataobject = "d_23015_d01"
end type

event dw_body::itemchanged;call super::itemchanged;choose case dwo.name 
	case "hold_ymd"
		if not gf_datechk(data) then  return 1
	case "cust_cd"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 2)				
end choose

end event

type dw_print from w_com010_e`dw_print within w_23015_e
end type

