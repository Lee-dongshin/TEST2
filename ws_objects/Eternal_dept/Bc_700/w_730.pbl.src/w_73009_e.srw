$PBExportHeader$w_73009_e.srw
$PBExportComments$고객 리스트요청 확인
forward
global type w_73009_e from w_com030_e
end type
end forward

global type w_73009_e from w_com030_e
end type
global w_73009_e w_73009_e

type variables
string  is_yymm, is_brand, is_shop_cd, is_yymmdd, is_biz_chk, is_crm_chk
datawindowchild idw_brand

end variables

on w_73009_e.create
call super::create
end on

on w_73009_e.destroy
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

is_yymm = dw_head.GetItemString(1, "yymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"요청년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymm")
   return false
end if

is_biz_chk = dw_head.GetItemString(1, "biz_chk")
is_crm_chk = dw_head.GetItemString(1, "crm_chk")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                               */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_yymm, is_brand, is_biz_chk, is_crm_chk)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
   dw_body.InsertRow(0)
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long ll_cur_row
datetime ld_datetime
string ls_chk, ls_emp_nm

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
   dw_body.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   dw_body.Setitem(1, "mod_id", gs_user_id)
   dw_body.Setitem(1, "mod_dt", ld_datetime)
END IF

// 영업담당자,부서장,CRM담당자 확인 


ls_chk = dw_body.Getitemstring(1,"biz_chk")
IF  ls_chk = 'N' then 
	 dw_body.setitem(1, "biz_empno", '')
	 dw_body.SetItem(1, "biz_name", '')			
END IF

ls_chk = dw_body.Getitemstring(1,"biz_chk2")
IF  ls_chk = 'N' then 
	 dw_body.setitem(1, "biz_empno2", '')
	 dw_body.SetItem(1, "biz_name2", '')			
END IF

ls_chk = dw_body.Getitemstring(1,"crm_chk")
IF  ls_chk = 'N' then 
	 dw_body.setitem(1, "crm_empno", '')
	 dw_body.SetItem(1, "crm_name", '')			
END IF



//------------------------------------------------------------------

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

/* dw_list에 추가되거나 수정된 내용를 반영 */  
IF il_rows = 1 THEN
   IF idw_status = NewModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)+1
      dw_list.InsertRow(ll_cur_row)
      dw_list.Setitem(ll_cur_row, "display_column", dw_body.GetItemString(1, "display_column"))
      dw_list.SelectRow(0, FALSE)
      dw_list.SelectRow(ll_cur_row, TRUE)
      dw_list.SetRow(ll_cur_row)
   ELSEIF idw_status = DataModified! THEN
      ll_cur_row = dw_list.GetSelectedRow(0)
      dw_list.Setitem(ll_cur_row, "display_column", dw_body.GetItemString(1, "display_column"))
   END IF
END IF

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "biz_empno"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
				   dw_body.SetItem(al_row, "biz_name", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "WHERE goout_gubn = '1' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "biz_empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "biz_name", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("biz_reason")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
		CASE "crm_empno"				
			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data,ls_emp_nm) = 0 THEN
				   dw_body.SetItem(al_row, "crm_name", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "WHERE goout_gubn = '1' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "crm_empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "crm_name", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("crm_reason")
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

type cb_close from w_com030_e`cb_close within w_73009_e
end type

type cb_delete from w_com030_e`cb_delete within w_73009_e
boolean visible = false
end type

type cb_insert from w_com030_e`cb_insert within w_73009_e
boolean visible = false
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_73009_e
end type

type cb_update from w_com030_e`cb_update within w_73009_e
end type

type cb_print from w_com030_e`cb_print within w_73009_e
end type

type cb_preview from w_com030_e`cb_preview within w_73009_e
end type

type gb_button from w_com030_e`gb_button within w_73009_e
end type

type cb_excel from w_com030_e`cb_excel within w_73009_e
end type

type dw_head from w_com030_e`dw_head within w_73009_e
string dataobject = "d_73009_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


end event

type ln_1 from w_com030_e`ln_1 within w_73009_e
end type

type ln_2 from w_com030_e`ln_2 within w_73009_e
end type

type dw_list from w_com030_e`dw_list within w_73009_e
integer width = 1504
string dataobject = "d_73009_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) THEN return
il_rows = dw_body.retrieve(is_yymmdd,is_shop_cd)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com030_e`dw_body within w_73009_e
integer x = 1559
integer y = 468
integer width = 2048
string dataobject = "d_73009_d02"
end type

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
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
string ls_emp_nm, ls_chk

CHOOSE CASE dwo.name
	CASE "biz_chk"
		IF ib_itemchanged THEN RETURN 1
		  		
		 dw_body.setitem(row, "biz_empno", gs_user_id)		
	   	IF gf_emp_nm(gs_user_id, ls_emp_nm) = 0 THEN
				   dw_body.SetItem(row, "biz_name", ls_emp_nm)
		   END IF 
			
   CASE "biz_chk2"
		IF ib_itemchanged THEN RETURN 1

	   ls_chk = dw_body.Getitemstring(row,"biz_chk2")
		
		  dw_body.setitem(row, "biz_empno2", gs_user_id)		
	   	IF gf_emp_nm(gs_user_id, ls_emp_nm) = 0 THEN
				   dw_body.SetItem(row, "biz_name2", ls_emp_nm)
		   END IF 

	CASE "crm_chk"
		IF ib_itemchanged THEN RETURN 1
		ls_chk = dw_body.Getitemstring(row,"crm_chk")
		
			 dw_body.setitem(row, "crm_empno", gs_user_id)
			 IF gf_emp_nm(gs_user_id, ls_emp_nm) = 0 THEN
				 dw_body.SetItem(row, "crm_name", ls_emp_nm)					
			 END IF			 
		
	CASE "biz_empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	
	CASE "biz_empno2"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "crm_empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


end event

type st_1 from w_com030_e`st_1 within w_73009_e
integer x = 1536
integer y = 468
end type

type dw_print from w_com030_e`dw_print within w_73009_e
string dataobject = "d_73009_d02"
end type

