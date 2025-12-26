$PBExportHeader$w_93003_e.srw
$PBExportComments$부서 프로그램 관리
forward
global type w_93003_e from w_com020_e
end type
type pb_next from picturebutton within w_93003_e
end type
type pb_previous from picturebutton within w_93003_e
end type
end forward

global type w_93003_e from w_com020_e
pb_next pb_next
pb_previous pb_previous
end type
global w_93003_e w_93003_e

type variables
String is_dept_cd, is_check1 = 'N', is_check2 = 'N'

end variables

on w_93003_e.create
int iCurrent
call super::create
this.pb_next=create pb_next
this.pb_previous=create pb_previous
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_next
this.Control[iCurrent+2]=this.pb_previous
end on

on w_93003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_next)
destroy(this.pb_previous)
end on

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)                                             */	
/* 작성일      : 2000.09.18                                                  */	
/* 수성일      : 2000.09.18                                                  */
/* Description : 코드 검색시 작성                                            */
/*===========================================================================*/

string     ls_dept_cd, ls_dept_nm
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "dept_cd"					// 사용자 번호
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF gf_dept_nm(as_data, ls_dept_nm) <> 0 THEN
					MessageBox("입력오류","등록되지 않은 부서코드 입니다!")
					RETURN 1
				END IF
				dw_head.SetItem(al_row, "dept_nm", ls_dept_nm)
				
			ELSE								// F1 key Or PopUp Button Click -> Call
				gst_cd.window_title    = "부서 검색" 
				gst_cd.datawindow_nm   = "d_com932"
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "DEPT_CD  LIKE  ~'" + as_data + "%~'"
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
					dw_head.SetItem(al_row, "dept_cd", lds_Source.GetItemString(1,"dept_cd"))
					dw_head.SetItem(al_row, "dept_nm", lds_Source.GetItemString(1,"dept_nm"))
					ib_itemchanged = False				
				END IF
				Destroy  lds_Source
			END IF			
END CHOOSE

RETURN 0

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */
/* 작성일      : 2001.11.16                                                  */
/* 수정일      : 2001.11.16                                                  */
/*===========================================================================*/
Long ll_rows

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_dept_cd)
//dw_body.Reset()
ll_rows = dw_body.retrieve(is_dept_cd)

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF ll_rows > 0 THEN
   dw_body.SetFocus()
	il_rows = ll_rows
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
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

is_dept_cd = dw_head.GetItemString(1, "dept_cd")
if IsNull(is_dept_cd) or Trim(is_dept_cd) = "" then
   MessageBox(ls_title,"부서 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dept_cd")
   return false
end if

return true

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.11.16                                                  */	
/* 수정일      : 2001.11.16                                                  */
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
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
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

type cb_close from w_com020_e`cb_close within w_93003_e
end type

type cb_delete from w_com020_e`cb_delete within w_93003_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_93003_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_93003_e
end type

type cb_update from w_com020_e`cb_update within w_93003_e
end type

type cb_print from w_com020_e`cb_print within w_93003_e
boolean visible = false
end type

type cb_preview from w_com020_e`cb_preview within w_93003_e
boolean visible = false
end type

type gb_button from w_com020_e`gb_button within w_93003_e
end type

type cb_excel from w_com020_e`cb_excel within w_93003_e
boolean visible = false
end type

type dw_head from w_com020_e`dw_head within w_93003_e
integer width = 3557
integer height = 128
string dataobject = "d_93003_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)                                             */	
/* 작성일      : 2000.09.18                                                  */	
/* 수성일      : 2000.09.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "dept_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE
end event

type ln_1 from w_com020_e`ln_1 within w_93003_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com020_e`ln_2 within w_93003_e
integer beginy = 332
integer endy = 332
end type

type dw_list from w_com020_e`dw_list within w_93003_e
integer x = 14
integer y = 348
integer width = 1719
integer height = 1684
string dataobject = "d_93003_d01"
end type

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : M.S.I (김 태범)                                             */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 2000.09.18                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

event dw_list::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_choice1"
		If is_check1 = 'N' then
			is_check1 = 'Y'
			This.Object.cb_choice1.Text = '제외'
		Else
			is_check1 = 'N'
			This.Object.cb_choice1.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "flag", is_check1)
		Next
		
END CHOOSE

end event

type dw_body from w_com020_e`dw_body within w_93003_e
integer x = 1888
integer y = 348
integer width = 1719
integer height = 1684
string dataobject = "d_93003_d02"
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : M.S.I (정 시영)															  */	
/* 작성일      : 2000.09.18																  */	
/* 수정일      : 2000.09.18																  */
/*===========================================================================*/
long	ll_row_count, i

CHOOSE CASE dwo.name
	CASE "cb_choice2"
		If is_check2 = 'N' then
			is_check2 = 'Y'
			This.Object.cb_choice2.Text = '제외'
		Else
			is_check2 = 'N'
			This.Object.cb_choice2.Text = '선택'
		End If
		
		ll_row_count = This.RowCount()
		For i = 1 to ll_row_count
			This.SetItem(i, "flag", is_check2)
		Next
		
END CHOOSE

end event

event dw_body::itemchanged;//////////////////////////////////////////////////////////////////////////////
//	Event:			itemchanged
//	Description:	Send itemchanged notification to services
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						6.0   Initial version
// 					7.0	Linkage service should not fire events when querymode is enabled
//////////////////////////////////////////////////////////////////////////////
//	Copyright ?1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean lb_disablelinkage
integer li_rc

// Is Querymode enabled?
If IsValid(inv_QueryMode) then lb_disablelinkage = inv_QueryMode.of_GetEnabled()

if not lb_disablelinkage then
	if IsValid (inv_Linkage) then
		//	*Note: If the changed value needs to be validated.  Validation needs to 
		//		occur prior to this linkage.pfc_itemchanged event.  If key syncronization is 
		//		performed, then the changed value cannot be undone. (i.e. return codes)	
		li_rc = inv_Linkage.event pfc_itemchanged (row, dwo, data)
	end if
end if

end event

type st_1 from w_com020_e`st_1 within w_93003_e
boolean visible = false
integer y = 380
integer height = 1652
boolean enabled = false
end type

type dw_print from w_com020_e`dw_print within w_93003_e
end type

type pb_next from picturebutton within w_93003_e
integer x = 1733
integer y = 528
integer width = 160
integer height = 252
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "next.bmp"
alignment htextalign = left!
end type

event clicked;/* 사용불가 프로그램을 사용가능 프로그램으로 이동 */
Long i, row_cnt

row_cnt = dw_list.RowCount()
For i = row_cnt To 1 Step -1
	If dw_list.GetItemString(i, 'flag') = 'Y' Then
		dw_list.RowsMove(i, i, Primary!, dw_body, 1, Primary!)
		dw_body.SetItem(1, 'flag', 'N')
		ib_changed = true
		cb_update.enabled = true
		is_check1 = 'N'
		dw_list.Object.cb_choice1.Text = '선택'
	End If
Next

end event

type pb_previous from picturebutton within w_93003_e
integer x = 1733
integer y = 872
integer width = 160
integer height = 252
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string picturename = "previous.bmp"
alignment htextalign = left!
end type

event clicked;/* 사용불가 프로그램을 사용가능 프로그램으로 이동 */
Long i, row_cnt

row_cnt = dw_body.RowCount()

For i = row_cnt To 1 Step -1
	If dw_body.GetItemString(i, 'flag') = 'Y' Then
		dw_body.RowsCopy(i, i, Primary!, dw_list, 1, Primary!)
		dw_body.RowsMove(i, i, Primary!, dw_body, 1, Delete!)
		dw_list.SetItem(1, 'flag', 'N')
		ib_changed = true
		cb_update.enabled = true
		is_check2 = 'N'
		dw_body.Object.cb_choice2.Text = '선택'
	End If
Next

end event

