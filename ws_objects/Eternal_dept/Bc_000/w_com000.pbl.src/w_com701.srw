$PBExportHeader$w_com701.srw
$PBExportComments$취급주의사항 [검색창]
forward
global type w_com701 from w_response
end type
type cb_ok from u_cb within w_com701
end type
type cb_cancel from u_cb within w_com701
end type
type dw_body from u_dw within w_com701
end type
type gb_1 from groupbox within w_com701
end type
end forward

global type w_com701 from w_response
integer width = 3319
integer height = 528
cb_ok cb_ok
cb_cancel cb_cancel
dw_body dw_body
gb_1 gb_1
end type
global w_com701 w_com701

type variables
datastore  ids_Source

end variables

on w_com701.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_body=create dw_body
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.dw_body
this.Control[iCurrent+4]=this.gb_1
end on

on w_com701.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_body)
destroy(this.gb_1)
end on

event closequery;//

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

ll_rows = dw_body.Retrieve(gst_cd.Item_where)
//IF ll_rows < 1 then dw_body.InsertRow(0)

end event

event close;call super::close;gst_cd.default_where   = ""
gst_cd.Item_where      = ""

end event

type cb_ok from u_cb within w_com701
integer x = 2569
integer y = 48
integer taborder = 30
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&O)"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.25                                                  */	
/* 수정일      : 2002.03.15                                                  */
/*===========================================================================*/
ids_Source.InsertRow(1)
ids_Source.SetItem(1, "han_mark", dw_body.GetItemString(1, "marks"))

CloseWithReturn(parent, ids_Source)

end event

type cb_cancel from u_cb within w_com701
integer x = 2917
integer y = 48
integer taborder = 20
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;Parent.Trigger Event pfc_close()

end event

type dw_body from u_dw within w_com701
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 176
integer width = 3287
integer taborder = 20
string dataobject = "d_com702"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15																  */	
/* 수정일      : 1999.11.15																  */
/*===========================================================================*/

CHOOSE CASE key
	CASE KeyEnter!
		This.TriggerEvent(DoubleClicked!)
END CHOOSE

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

event doubleclicked;call super::doubleclicked;IF cb_ok.Enabled  THEN 
   cb_ok.TriggerEvent(clicked!)
END IF

end event

event itemerror;return 1

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

event losefocus;call super::losefocus;This.AcceptText()

end event

event rbuttonup;//
end event

type gb_1 from groupbox within w_com701
integer x = 2542
integer width = 754
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

