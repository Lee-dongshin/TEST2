$PBExportHeader$w_31018_t.srw
$PBExportComments$검사결과보고서
forward
global type w_31018_t from w_com020_e
end type
type dw_1 from datawindow within w_31018_t
end type
type dw_2 from datawindow within w_31018_t
end type
type dw_3 from datawindow within w_31018_t
end type
end forward

global type w_31018_t from w_com020_e
integer width = 3643
dw_1 dw_1
dw_2 dw_2
dw_3 dw_3
end type
global w_31018_t w_31018_t

type variables
DataWindowChild idw_brand, idw_season
String is_brand, is_year, is_season, is_style, is_chno, is_yymmdd
end variables

on w_31018_t.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.dw_2=create dw_2
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_3
end on

on w_31018_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.dw_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if
return true
end event

event ue_retrieve();call super::ue_retrieve;IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_style, is_chno, is_year, is_season, is_yymmdd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;
/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
end event

event ue_delete();long	i,	ll_cur_row

ll_cur_row = dw_body.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
for i = dw_1.rowcount() to 1 STEP -1
	dw_1.DeleteRow(i)
next 
dw_body.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_insert();string ls_flag
long i
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.retrieve(is_yymmdd, is_style, is_chno, 'New')
IF il_rows > 0 THEN
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(1,"flag")
		if ls_flag = "New" then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next
	il_rows = dw_1.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_1.getitemstring(i,"flag")
			if ls_flag = "New" then 
			dw_1.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next
	end if
   dw_body.SetFocus()
END IF

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_brand, ls_dept_cd
Boolean    lb_check 
DataStore  lds_Source
CHOOSE CASE as_column
	CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE 1 = 1 "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
			
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
	CASE "empno"				
		ls_brand = LeftA(is_style,1)
		
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data)  = "" THEN
				   dw_body.SetItem(al_row, "emp_nm", "")
					RETURN 0
				END IF 
			END IF

		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "검사원 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 

//			If gf_get_inter_sub('991', ls_brand + '50', '1', ls_dept_cd) = False Then
//				dw_body.SetItem(al_row, "empno", "")
//				dw_body.SetItem(al_row, "emp_nm", "")
//				Return 2
//			END IF 
//			gst_cd.default_where   = " WHERE brand = '" + ls_brand + "' and DEPT_CODE in ('s200','d000','d300','T210') " + &
//			                         "   AND GOOUT_GUBN = '1' "
//
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF

			gst_cd.default_where   = " WHERE GOOUT_GUBN = '1' "

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (EMPNO LIKE '" + as_data + "%' or kname like '%" + as_data + "%') "
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
				dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				dw_body.SetColumn("remark")
				ib_itemchanged = False 
				lb_check = TRUE 
				
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source				
end choose

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0
end event

event ue_preview();This.Trigger Event ue_title ()

il_rows = dw_print.retrieve(is_yymmdd, is_style, is_chno, 'Dat')
dw_print.inv_printpreview.of_SetZoom()

end event

event type long ue_update();call super::ue_update;long i, ll_row_count
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
	
	FOR i=1 TO ll_row_count
		idw_status = dw_1.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_1.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_1.Setitem(i, "mod_id", gs_user_id)
			dw_1.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT
	
	il_rows = dw_1.Update(TRUE, FALSE)	
	if il_rows = 1 then
		dw_1.ResetUpdate()
		dw_body.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
	
	
	FOR i=1 TO dw_2.rowcount()
		idw_status = dw_2.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_2.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_2.Setitem(i, "mod_id", gs_user_id)
			dw_2.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT	
	
	il_rows = dw_2.Update(TRUE, FALSE)	
	if il_rows = 1 then
		dw_2.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
	
	FOR i=1 TO dw_3.rowcount()
		idw_status = dw_3.GetItemStatus(i, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */
			dw_3.Setitem(i, "reg_id", gs_user_id)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_3.Setitem(i, "mod_id", gs_user_id)
			dw_3.Setitem(i, "mod_dt", ld_datetime)
		END IF
	NEXT	
	
	il_rows = dw_3.Update(TRUE, FALSE)	
	if il_rows = 1 then
		dw_3.ResetUpdate()
		commit  USING SQLCA;
	else
		rollback  USING SQLCA;
	end if
	
	
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event open;call super::open;dw_1.object.chk_gram.protect = 1
dw_1.object.chk_gram_fin.protect = 1
end event

type cb_close from w_com020_e`cb_close within w_31018_t
end type

type cb_delete from w_com020_e`cb_delete within w_31018_t
end type

type cb_insert from w_com020_e`cb_insert within w_31018_t
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_31018_t
end type

type cb_update from w_com020_e`cb_update within w_31018_t
end type

type cb_print from w_com020_e`cb_print within w_31018_t
end type

type cb_preview from w_com020_e`cb_preview within w_31018_t
end type

type gb_button from w_com020_e`gb_button within w_31018_t
end type

type cb_excel from w_com020_e`cb_excel within w_31018_t
end type

type dw_head from w_com020_e`dw_head within w_31018_t
integer height = 156
string dataobject = "d_31018_h01_new"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')



end event

type ln_1 from w_com020_e`ln_1 within w_31018_t
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com020_e`ln_2 within w_31018_t
integer beginy = 336
integer endy = 336
end type

type dw_list from w_com020_e`dw_list within w_31018_t
integer y = 348
integer width = 974
integer height = 1668
string dataobject = "d_31018_l01"
end type

event dw_list::clicked;call super::clicked;string ls_yymmdd,ls_flag
long i

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

is_style = This.GetItemString(row, 'style') 
is_chno  = This.GetItemString(row, 'chno') 
is_yymmdd = This.GetItemString(row, 'yymmdd') 
IF IsNull(is_style) THEN return
IF IsNull(is_chno) THEN return



il_rows = dw_body.retrieve(is_yymmdd, is_style, is_chno, 'Dat')
IF il_rows > 0 THEN	
	for i = 1 to il_rows
		ls_flag = dw_body.getitemstring(1,"flag")
		if ls_flag = "New" then
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		end if
	next
	
	il_rows = dw_1.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_1.getitemstring(i,"flag")
			if ls_flag = "New" then 
				dw_1.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next 		
	end if


   dw_body.SetFocus()
END IF

	il_rows = dw_2.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows > 0 then 
		for i = 1 to il_rows 
			ls_flag = dw_2.getitemstring(i,"flag")
			if ls_flag = "New" then 
				dw_2.SetItemStatus(i, 0, Primary!, NewModified!)
			end if
		next 
		dw_2.visible = true
	end if	
	

	il_rows = dw_3.retrieve(is_yymmdd, is_style, is_chno)
	if il_rows = 0 then 
		il_rows = dw_3.InsertRow(0)
		
		if il_rows > 0 then
			dw_3.setitem(1,"yymmdd", is_yymmdd)
			dw_3.setitem(1,"style", is_style)
			dw_3.setitem(1,"chno", is_chno)

		end if		
	end if
	dw_3.visible = true	
	
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_e`dw_body within w_31018_t
integer x = 1010
integer y = 348
integer width = 3835
integer height = 2552
string dataobject = "d_31018_d01"
end type

event dw_body::constructor;call super::constructor;datawindowchild	ldw_make_type

This.GetChild("make_type", ldw_make_type)
ldw_make_type.SetTransObject(SQLCA)
ldw_make_type.Retrieve('030')
end event

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

event dw_body::ue_keydown;
String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		if ls_column_name <> "remark" then 
			Send(Handle(This), 256, 9, long(0,0))
		end if
		Return 1
//	CASE KeyDownArrow!
//		IF This.GetRow() = This.RowCount() THEN
//		   This.InsertRow(This.GetRow() + 1)
//		END IF
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_31018_t
boolean visible = false
integer x = 997
integer y = 348
integer height = 1692
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_31018_t
string dataobject = "d_31018_r01"
end type

type dw_1 from datawindow within w_31018_t
integer x = 3721
integer y = 1408
integer width = 1074
integer height = 448
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_31017_d03"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
end event

type dw_2 from datawindow within w_31018_t
boolean visible = false
integer x = 1093
integer y = 2912
integer width = 3730
integer height = 524
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_31017_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event constructor;datawindowchild ldw_child

This.GetChild("chk_cd_0", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_3", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_4", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_5", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_6", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_7", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_8", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')

This.GetChild("chk_cd_9", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('125')


end event

event itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true

/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

type dw_3 from datawindow within w_31018_t
boolean visible = false
integer x = 3712
integer y = 1968
integer width = 1093
integer height = 828
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_31018_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event itemchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true

/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
//
//CHOOSE CASE dwo.name
//	CASE "colunm1" 
//    IF data = 'A' THEN
//	      /*action*/
//    END IF
//	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
//		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
//END CHOOSE
//
end event

event buttonclicked;///*===========================================================================*/
///* 작성자      : 지우정보                                                    */	
///* 작성일      : 1999.11.09                                                  */	
///* 수정일      : 1999.11.09                                                  */
///*===========================================================================*/

string ls_yymmdd
CHOOSE CASE dwo.name
	CASE "b_add" 
		il_rows = dw_3.InsertRow(0)
		
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			ls_yymmdd = dw_head.getitemstring(1,"yymmdd")
			dw_3.setitem(il_rows,"yymmdd", ls_yymmdd)
			dw_3.setitem(il_rows,"style", is_style)
			dw_3.setitem(il_rows,"chno", is_chno)
			
			dw_3.ScrollToRow(il_rows)
			dw_3.SetColumn(0)
			dw_3.SetFocus()
		end if

	CASE "b_del"	     //  Popup 검색창이 존재하는 항목 
		idw_status = dw_3.GetItemStatus(row, 0, Primary!)
		dw_3.deleteRow(row)
		if idw_status <> new! and idw_status <> newmodified! then
			ib_changed = true
			cb_update.enabled = true
		end if		
END CHOOSE


end event

