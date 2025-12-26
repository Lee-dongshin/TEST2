$PBExportHeader$w_com201.srw
$PBExportComments$검색창
forward
global type w_com201 from w_response
end type
type cb_back from commandbutton within w_com201
end type
type st_text from statictext within w_com201
end type
type cb_cancel from u_cb within w_com201
end type
type dw_body from u_dw within w_com201
end type
type cb_ok from u_cb within w_com201
end type
type cb_search from u_cb within w_com201
end type
type gb_1 from groupbox within w_com201
end type
end forward

global type w_com201 from w_response
integer width = 1559
integer height = 2626
event ue_retrieve ( )
cb_back cb_back
st_text st_text
cb_cancel cb_cancel
dw_body dw_body
cb_ok cb_ok
cb_search cb_search
gb_1 gb_1
end type
global w_com201 w_com201

type variables
datastore  ids_Source
string     is_old_select, is_default_where, is_job_flag
boolean    ib_spacebar
end variables

event ue_retrieve();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/
// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_nm, ls_item_where, ls_ColType, ls_data
Long    ll_rows 
Decimal ldc_data 

li_column_count = Integer(dw_body.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

IF Trim(is_default_where) = "" OR isnull(is_default_where) THEN
	ls_item_where = 'WHERE '
END IF	

FOR i=1 TO li_column_count
	ls_column_nm = dw_body.Describe('#' + String(i) + '.Name')
	ls_ColType   = dw_body.Describe(ls_column_nm + '.ColType')
	IF MidA(ls_ColType, 1, 4) = 'char' THEN
		ls_data = Trim(dw_body.GetitemString(1, ls_column_nm))
		IF ls_data <> "" AND not isnull(ls_data) THEN
			IF ls_item_where = 'WHERE ' THEN
		      ls_item_where = ls_item_where + ls_column_nm + &
			                   ' like ~'%' + ls_data + '%~''
			ELSE
		      ls_item_where = ls_item_where + ' AND ' +ls_column_nm + &
			                   ' like ~'%' + ls_data + '%~''
			END IF
      END IF			
	ELSEIF MidA(ls_ColType, 1, 7) = 'decimal' OR MidA(ls_ColType, 1, 6) = 'number' OR MidA(ls_ColType, 1, 4) = 'long' THEN 
		ldc_data = dw_body.GetitemDecimal(1, ls_column_nm)
		IF not isnull(ldc_data) THEN
			IF ls_item_where = 'WHERE ' THEN
		      ls_item_where = ls_item_where + ls_column_nm + &
			                   ' = ' + String(ldc_data) 
			ELSE
		      ls_item_where = ls_item_where + ' AND ' +ls_column_nm + &
			                   ' = ' + String(ldc_data) 
			END IF
      END IF			
	END IF
NEXT

IF ls_item_where = 'WHERE ' THEN
   ls_item_where = ""
END IF	

ll_rows = dw_body.SetSQLSelect(is_old_select + " " + is_default_where + " " + ls_item_where)

IF ll_rows <> 1 THEN								/* sql error check*/
	MessageBox("SQL 문장오류", is_old_select + " " + is_default_where + " " + ls_item_where)
	Close(this)
	Return
END IF

ll_rows = dw_body.Retrieve()
IF ll_rows > 0 then
	cb_ok.enabled = True
ELSE	
	cb_ok.enabled = False
END IF

IF dw_body.RowCount() = 1 THEN
	dw_body.Trigger Event RowFocusChanged(1)
ELSEIF dw_body.RowCount() > 1 THEN
	dw_body.ScrollToRow (1)
END IF

dw_body.SetFocus()
end event

event closequery;//
end event

on w_com201.create
int iCurrent
call super::create
this.cb_back=create cb_back
this.st_text=create st_text
this.cb_cancel=create cb_cancel
this.dw_body=create dw_body
this.cb_ok=create cb_ok
this.cb_search=create cb_search
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_back
this.Control[iCurrent+2]=this.st_text
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.dw_body
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_search
this.Control[iCurrent+7]=this.gb_1
end on

on w_com201.destroy
call super::destroy
destroy(this.cb_back)
destroy(this.st_text)
destroy(this.cb_cancel)
destroy(this.dw_body)
destroy(this.cb_ok)
destroy(this.cb_search)
destroy(this.gb_1)
end on

event close;call super::close;gst_cd.default_where = " "
gst_cd.Item_where    = " "
end event

event key;call super::key;IF key = KeyEscape! THEN
   cb_cancel.PostEvent(Clicked!)
END IF
end event

event open;call super::open;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 2001.12.20                                                  */
/*===========================================================================*/
///* DataWindow의 Transction 정의 */
String ls_datawindow
String ls_item_where
long   ll_rows

ids_source = Message.PowerObjectParm

ls_datawindow = gst_cd.datawindow_nm
This.Title = gst_cd.window_title
dw_body.DataObject = ls_datawindow

IF dw_body.SetTransObject(SQLCA) <> 1 THEN   /* datawindow check */
	MessageBox("코드검색오류","데이타 윈도우[" + ls_datawindow + "]" + "가 없습니다!")  
	Close(this)
	Return
END IF

dw_body.Object.DataWindow.Retrieve.AsNeeded='Yes'
ids_Source.DataObject = ls_datawindow

is_old_select = "sp_com201_d01 "
is_default_where = gst_cd.default_where


is_job_flag = '1'


ll_rows = dw_body.Retrieve(gsv_cd.gs_cd1, gsv_cd.gs_cd2, gsv_cd.gs_cd3, gsv_cd.gs_cd4, gsv_cd.gs_cd5)
IF ll_rows = 1 AND gst_cd.ai_div = 1 then
	dw_body.selectrow(1, True)
	cb_ok.TriggerEvent(Clicked!)

ELSEIF ll_rows > 0 then
	cb_ok.enabled = True
	dw_body.ScrollToRow (1)
	dw_body.SetFocus()
END IF

end event

type cb_back from commandbutton within w_com201
integer x = 480
integer y = 48
integer width = 288
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "뒤로"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/
long 		  i, ll_cur_row, ll_selected[]
string ls_brand, ls_year, ls_season, ls_item, ls_mat_cd

ll_cur_row = dw_body.inv_rowselect.of_SelectedCount(ll_selected)


ls_brand  = dw_body.getitemstring(1,"brand")
ls_year   = dw_body.getitemstring(1,"mat_year")
ls_season = dw_body.getitemstring(1,"mat_season")
ls_item   = dw_body.getitemstring(1,"mat_item")
ls_mat_cd = ""


if LenA(ls_mat_cd)=10 then  
	FOR i=1 TO ll_cur_row
		dw_body.RowsCopy(ll_selected[i], ll_selected[i], Primary!, ids_Source, i+1, Primary!)
	NEXT
	
	CloseWithReturn(parent, ids_Source)
else
	dw_body.retrieve(ls_brand, ls_year, ls_season, ls_item, ls_mat_cd)
end if

end event

type st_text from statictext within w_com201
boolean visible = false
integer x = 59
integer y = 36
integer width = 649
integer height = 104
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "각 항목에 찾을 문자열을 입력하세요"
boolean focusrectangle = false
end type

type cb_cancel from u_cb within w_com201
integer x = 1152
integer y = 48
integer taborder = 20
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;call super::clicked;Parent.Trigger Event pfc_close()
end event

type dw_body from u_dw within w_com201
event ue_keydown pbm_dwnkey
integer y = 172
integer width = 1536
integer height = 2330
integer taborder = 10
string dataobject = "d_com_smat"
boolean hscrollbar = true
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15																  */	
/* 수정일      : 1999.11.15																  */
/*===========================================================================*/

IF is_job_flag = '2' THEN 
	IF key = KeyEnter! THEN
		cb_search.PostEvent(Clicked!)
	END IF
	
 	Return 0
END IF

CHOOSE CASE key
	CASE KeyEnter!
		IF This.GetSelectedRow(0) = 0 THEN Return -1
		This.TriggerEvent(DoubleClicked!)
	CASE KeySpaceBar!
		IF ib_spacebar Then
			ib_spacebar = False
			Return 0
		END IF
		long row
		row  = This.GetRow()   
	   If this.IsSelected(row) Then
			this.SelectRow(row,FALSE)
	   Else
			this.SelectRow(row,TRUE)
		End If
		ib_spacebar = True
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF cb_ok.Enabled  THEN 
   cb_ok.TriggerEvent(clicked!)
END IF
end event

event losefocus;call super::losefocus;This.AcceptText()
end event

event rbuttonup;//
end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
this.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

event itemerror;call super::itemerror;return 1
end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 1
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 1400
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 2000.01.17 (정시영)                                         */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

type cb_ok from u_cb within w_com201
integer x = 805
integer y = 48
integer taborder = 30
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "확인(&O)"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/
long 		  i, ll_cur_row, ll_selected[]
string ls_brand, ls_year, ls_season, ls_item, ls_mat_cd

ll_cur_row = dw_body.inv_rowselect.of_SelectedCount(ll_selected)

IF ll_cur_row < 1 THEN
   MessageBox("검색창","코드를 선택하십시요!")
   Return
END IF

ls_brand  = dw_body.getitemstring(ll_selected[1],"brand")
ls_year   = dw_body.getitemstring(ll_selected[1],"mat_year")
ls_season = dw_body.getitemstring(ll_selected[1],"mat_season")
ls_item   = dw_body.getitemstring(ll_selected[1],"mat_item")
ls_mat_cd = dw_body.getitemstring(ll_selected[1],"mat_cd")

if LenA(ls_mat_cd)=10 then  
	FOR i=1 TO ll_cur_row
		dw_body.RowsCopy(ll_selected[i], ll_selected[i], Primary!, ids_Source, i+1, Primary!)
	NEXT
	
	CloseWithReturn(parent, ids_Source)
else
	dw_body.retrieve(ls_brand, ls_year, ls_season, ls_item, ls_mat_cd)
end if

end event

type cb_search from u_cb within w_com201
boolean visible = false
integer x = 32
integer y = 40
integer taborder = 10
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조건(&S)"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수정일      : 1999.11.15                                                  */
/*===========================================================================*/

IF is_job_flag = '1' THEN
   cb_search.Text = "검색(&S)"
   st_text.Visible = True
   cb_ok.Enabled = False
	dw_body.of_SetRowManager(False)
   dw_body.of_SetBase(False)
   dw_body.of_SetSort(False)
   dw_body.of_SetRowSelect(False)
   dw_body.DBCancel()
   dw_body.reset()
   dw_body.insertrow(0)
	dw_body.SetFocus()
	is_job_flag = '2'
ELSE
   cb_search.Text = "조건(&S)"
   st_text.Visible = False
   cb_ok.Enabled  = True
	dw_body.of_SetRowManager(True)
   dw_body.of_SetBase(True)
   dw_body.of_SetSort(True)
   dw_body.of_SetRowSelect(True)
	dw_body.inv_sort.of_SetColumnHeader(True)
	is_job_flag = '1'
	Parent.Trigger Event ue_retrieve()
END IF

end event

type gb_1 from groupbox within w_com201
integer x = 411
integer width = 1129
integer height = 164
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

