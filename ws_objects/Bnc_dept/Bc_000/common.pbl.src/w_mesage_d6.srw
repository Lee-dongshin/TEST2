$PBExportHeader$w_mesage_d6.srw
$PBExportComments$생산업체부자재출고요청
forward
global type w_mesage_d6 from w_com010_d
end type
end forward

global type w_mesage_d6 from w_com010_d
integer width = 1175
integer height = 1060
string title = "협력업체 부자재출고요청"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event type long ue_refresh ( string as_person_id )
end type
global w_mesage_d6 w_mesage_d6

type variables

end variables

event type long ue_refresh(string as_person_id);long ll_rows

ll_rows = dw_body.retrieve(as_person_id)

if ll_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

//timer(600)
return ll_rows

end event

event pfc_preopen();call super::pfc_preopen;this.x = 1661
this.y = 1300
trigger event ue_refresh(gs_user_id)
end event

on w_mesage_d6.create
call super::create
end on

on w_mesage_d6.destroy
call super::destroy
end on

event timer;call super::timer;il_rows = dw_body.retrieve(gs_user_id)

if il_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

end event

type cb_close from w_com010_d`cb_close within w_mesage_d6
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d6
integer x = 1307
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d6
integer x = 1445
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d6
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_mesage_d6
integer x = 1335
integer y = 40
end type

type cb_print from w_com010_d`cb_print within w_mesage_d6
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d6
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_mesage_d6
boolean visible = false
integer x = 1321
integer y = 4
end type

type cb_excel from w_com010_d`cb_excel within w_mesage_d6
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_mesage_d6
boolean visible = false
integer x = 1449
integer width = 2811
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d6
boolean visible = false
integer beginx = 837
integer endx = 4457
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d6
boolean visible = false
integer beginx = 837
integer endx = 4457
end type

type dw_body from w_com010_d`dw_body within w_mesage_d6
integer x = 0
integer y = 0
integer width = 1161
integer height = 960
string dataobject = "d_message_006"
boolean minbox = true
boolean livescroll = false
end type

event dw_body::clicked;call super::clicked;choose case dwo.name
	case "b_refresh"
		trigger event ue_refresh(gs_user_id)
end choose
end event

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_ord_origin

if row > 0 then
	ls_ord_origin = this.getitemstring(row,"ord_origin")

	OpenWithParm(w_31012_d, ls_ord_origin)
//	open(w_31012_d)	//원/부자재 출고요청서

end if

end event

event dw_body::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
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

type dw_print from w_com010_d`dw_print within w_mesage_d6
integer x = 1394
integer y = 520
end type

