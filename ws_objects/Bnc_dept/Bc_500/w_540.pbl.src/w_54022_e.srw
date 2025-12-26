$PBExportHeader$w_54022_e.srw
$PBExportComments$reorder 의뢰일 등록
forward
global type w_54022_e from w_com020_e
end type
end forward

global type w_54022_e from w_com020_e
end type
global w_54022_e w_54022_e

type variables
string is_brand, is_year, is_season, is_item, is_req_ymd
datawindowchild idw_brand, idw_season, idw_item
end variables

on w_54022_e.create
call super::create
end on

on w_54022_e.destroy
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





if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_year = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_item = dw_head.GetItemString(1, "item")
is_req_ymd = dw_head.GetItemString(1, "req_ymd")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_year, is_season, is_item)
dw_body.Reset()
cb_insert.enabled = true
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
long i
string ls_flag

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF


//messagebox("is_brand",is_brand)
//messagebox("is_year",is_year)
//messagebox("is_season",is_season)
//messagebox("is_item",is_item)
//messagebox("is_reorder_ymd",is_reorder_ymd)

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_req_ymd, 'New')

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(i,"flag")
		if ls_flag = 'New' then 
			dw_body.SetItemStatus(i, 0, Primary!, New!)
		end if
	next 
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)



end event

event pfc_preopen;call super::pfc_preopen;datetime ld_datetime




IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"req_ymd",string(ld_datetime,"yyyymmdd"))
end if

end event

event ue_update;call super::ue_update;/*===========================================================================*/
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
		dw_body.Setitem(i, "req_ymd", is_req_ymd)
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

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 종호)                                      */	
/* 작성일      : 2001.12.04                                                  */	
/* 수정일      : 2001.12.04                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_cust_cd, ls_cust_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"							// 거래처 코드
//			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				if isnull(as_data) or LenA(as_data) = 0 then return 0
//				ElseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					dw_body.SetItem(al_row, "cust_nm", ls_cust_nm)
//					RETURN 0
//				END IF
//				
//			END IF   
//			
			   gst_cd.ai_div          = ai_div	// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "거래처 코드 검색" 
				gst_cd.datawindow_nm   = "d_com911" 
				gst_cd.default_where   = " WHERE Cust_Code Between '5000' And '9999' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " (CustCode LIKE ~'" + as_data + "%~' or Cust_sname LIKE ~'%" + as_data + "%~') "
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
					dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"CustCode"))
					dw_body.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"Cust_sName"))
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("color")
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

type cb_close from w_com020_e`cb_close within w_54022_e
end type

type cb_delete from w_com020_e`cb_delete within w_54022_e
end type

type cb_insert from w_com020_e`cb_insert within w_54022_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_54022_e
end type

type cb_update from w_com020_e`cb_update within w_54022_e
end type

type cb_print from w_com020_e`cb_print within w_54022_e
end type

type cb_preview from w_com020_e`cb_preview within w_54022_e
end type

type gb_button from w_com020_e`gb_button within w_54022_e
end type

type cb_excel from w_com020_e`cb_excel within w_54022_e
end type

type dw_head from w_com020_e`dw_head within w_54022_e
integer height = 164
string dataobject = "d_54022_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

//This.GetChild("sojae", idw_sojae)
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')
//
This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

//This.GetChild("color", idw_color)
//idw_color.SetTransObject(SQLCA)
//idw_color.retrieve('%')
//idw_color.InsertRow(1)
//idw_color.SetItem(1, "color", '%')
//idw_color.SetItem(1, "color_enm", '전체')
//
//This.GetChild("size", idw_size)
//idw_size.SetTransObject(SQLCA)
//idw_size.retrieve('%')
//idw_size.InsertRow(1)
//idw_size.SetItem(1, "size", '%')
//idw_size.SetItem(1, "size_nm", '전체')
//
end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

	
	CHOOSE CASE dwo.name


	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
	  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
				  						
		
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_54022_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_54022_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_54022_e
integer y = 380
integer width = 567
integer height = 1660
string dataobject = "d_54022_l01"
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

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

is_req_ymd = This.GetItemString(row, 'req_ymd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_req_ymd) THEN return

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_req_ymd, 'Dat')
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_54022_e
integer x = 613
integer y = 380
integer width = 2994
integer height = 1660
string dataobject = "d_54022_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild idw_child, ldw_color

This.GetChild("country_cd", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('000')

This.GetChild("color", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve()

This.GetChild("to_color", ldw_color)
ldw_color.SetTransObject(SQLCA)
ldw_color.Retrieve()
ldw_color.InsertRow(1)
//ldw_color.SetItem(1, "size", 'Al')
//ldw_color.SetItem(1, "size_nm", '통합')
//
//This.GetChild("sojae", idw_sojae)
//idw_sojae.SetTransObject(SQLCA)
//idw_sojae.Retrieve('%')
//idw_sojae.InsertRow(1)
//idw_sojae.SetItem(1, "sojae", '%')
//idw_sojae.SetItem(1, "sojae_nm", '전체')
//
This.GetChild("size", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve()
idw_child.InsertRow(1)
idw_child.SetItem(1, "size", 'Al')
idw_child.SetItem(1, "size_nm", '통합')

//This.GetChild("color", idw_color)
//idw_color.SetTransObject(SQLCA)
//idw_color.retrieve('%')
//idw_color.InsertRow(1)
//idw_color.SetItem(1, "color", '%')
//idw_color.SetItem(1, "color_enm", '전체')
//
//This.GetChild("size", idw_size)
//idw_size.SetTransObject(SQLCA)
//idw_size.retrieve('%')
//idw_size.InsertRow(1)
//idw_size.SetItem(1, "size", '%')
//idw_size.SetItem(1, "size_nm", '전체')
//
end event

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

CHOOSE CASE dwo.name
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_54022_e
integer x = 594
integer y = 380
integer height = 1660
end type

type dw_print from w_com020_e`dw_print within w_54022_e
integer x = 338
integer y = 636
end type

