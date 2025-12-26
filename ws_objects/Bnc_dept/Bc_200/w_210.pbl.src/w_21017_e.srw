$PBExportHeader$w_21017_e.srw
$PBExportComments$부자재 직송등록
forward
global type w_21017_e from w_com020_e
end type
type dw_1 from datawindow within w_21017_e
end type
end forward

global type w_21017_e from w_com020_e
dw_1 dw_1
end type
global w_21017_e w_21017_e

type variables
string is_yymmdd, is_mat_cd, is_smat_cust, is_make_cust, is_save_gubn
end variables

on w_21017_e.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_21017_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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


is_mat_cd = dw_head.GetItemString(1, "mat_cd")

is_smat_cust = dw_head.GetItemString(1, "smat_cust")
if IsNull(is_smat_cust) or LenA(is_smat_cust) <> 4 then
   MessageBox(ls_title,"부자재업체 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_make_cust")
   return false
end if

is_make_cust = dw_head.GetItemString(1, "make_cust")
if IsNull(is_make_cust) or LenA(is_make_cust) <> 4 then
   MessageBox(ls_title,"생산업체 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_make_cust")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or not gf_datechk(is_yymmdd) then
   MessageBox(ls_title,"등록일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("is_yymmdd")
   return false
end if


return true	
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                      */ 
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(RightA(is_smat_cust,4), RightA(is_make_cust,4), is_save_gubn)
dw_body.Reset()
dw_1.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();datetime ld_datetime
/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 														  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

menu			lm_curr_menu
lm_curr_menu = this.menuid
IF gl_user_level = 999 then 
   lm_curr_menu.item[2].enabled = True 
ELSE
   lm_curr_menu.item[2].enabled = False
END IF 	

/*===========================================================================*/
/* 작성자      : 지우정보 (김태범) 				   									  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


//--------------------------------------
IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "make_cust_nm"				
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "생산업체 코드 검색" 
			gst_cd.datawindow_nm   = "d_com920" 
			gst_cd.default_where   = "WHERE 1=1 "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(cust_code LIKE '" + as_data + "%'" + &
											" or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "make_cust", lds_Source.GetItemString(1,"cust_code"))
				dw_head.SetItem(al_row, "make_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("mat_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "smat_cust"				
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재업체 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			gst_cd.default_where   = "WHERE change_gubn = '00' and cust_code like '[5-8]%' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(custcode like '%" + as_data + "%'" + &
											" or cust_sname like '%" + as_data + "%')"
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
				dw_head.SetItem(al_row, "smat_cust", lds_Source.GetItemString(1,"cust_code"))
				dw_head.SetItem(al_row, "smat_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("make_cust_nm")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source			
	CASE "mat_nm"				
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com021" 
			gst_cd.default_where   = "WHERE 1=1 "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "(mat_cd LIKE '" + as_data + "%'" + &
											" or mat_nm like '%" + as_data + "%')"
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
				dw_body.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("in_qty")
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
string ls_save_gubn

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
	   dw_body.Setitem(i, "make_cust", is_make_cust)
	   dw_body.Setitem(i, "smat_cust", RightA(gs_user_id,4))		
	   dw_body.Setitem(i, "yymmdd", is_yymmdd)
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
	ls_save_gubn = dw_list.getitemstring(dw_list.getrow(),"save_gubn")
	dw_1.retrieve(RightA(gs_user_id,4), ls_save_gubn, is_make_cust)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF
dw_body.reset()
il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_21017_e
end type

type cb_delete from w_com020_e`cb_delete within w_21017_e
end type

type cb_insert from w_com020_e`cb_insert within w_21017_e
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_21017_e
end type

type cb_update from w_com020_e`cb_update within w_21017_e
end type

type cb_print from w_com020_e`cb_print within w_21017_e
end type

type cb_preview from w_com020_e`cb_preview within w_21017_e
end type

type gb_button from w_com020_e`gb_button within w_21017_e
end type

type cb_excel from w_com020_e`cb_excel within w_21017_e
end type

type dw_head from w_com020_e`dw_head within w_21017_e
integer y = 172
integer height = 144
string dataobject = "d_sm103_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand_cd"      // dddw로 작성된 항목
	CASE "make_cust_nm"
		IF ib_itemchanged or data = '' or isnull(data) THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "smat_cust"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_21017_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com020_e`ln_2 within w_21017_e
integer beginy = 348
integer endy = 348
end type

type dw_list from w_com020_e`dw_list within w_21017_e
integer y = 364
integer width = 553
integer height = 1656
string dataobject = "d_sm103_L01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_save_gubn
IF row <= 0 THEN Return

//IF ib_changed THEN 
//  	CHOOSE CASE gf_update_yn(Parent.title)
//		CASE 1
//			IF Parent.Trigger Event ue_update() < 1 THEN
//				RETURN
//			END IF		
//		CASE 3
//			RETURN
//	END CHOOSE
//END IF
//	


This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_save_gubn = This.GetItemString(row, 'save_gubn') /* DataWindow에 Key 항목을 가져온다 */
IF IsNull(ls_save_gubn) THEN return
il_rows = dw_1.retrieve(RightA(gs_user_id,4), ls_save_gubn, is_make_cust)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_21017_e
integer x = 576
integer y = 364
integer width = 3026
integer height = 204
string dataobject = "d_sm103_d01"
boolean vscrollbar = false
boolean livescroll = false
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
	CASE "make_cust_nm"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "smat_nm"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE

end event

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

This.GetChild("save_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('033')

end event

type st_1 from w_com020_e`st_1 within w_21017_e
integer x = 558
integer y = 364
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_21017_e
integer x = 1093
integer y = 632
end type

type dw_1 from datawindow within w_21017_e
integer x = 576
integer y = 572
integer width = 3026
integer height = 1448
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sm103_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;	string ls_yymmdd, ls_smat_cust, ls_save_gubn, ls_make_cust, ls_brand
	
	if row > 0 then 

		ls_yymmdd    = this.getitemstring(row,"yymmdd")
		ls_smat_cust = this.getitemstring(row,"smat_cust")
		ls_save_gubn = this.getitemstring(row,"save_gubn")
		ls_make_cust = this.getitemstring(row,"make_cust")
		ls_brand     = this.getitemstring(row,"brand")
			
		il_rows = dw_body.retrieve(ls_yymmdd, ls_smat_cust, ls_save_gubn, ls_make_cust, ls_brand)

	end if

end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)


// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

