$PBExportHeader$w_mesage_d.srw
$PBExportComments$원가계산서
forward
global type w_mesage_d from w_com010_d
end type
end forward

global type w_mesage_d from w_com010_d
boolean visible = false
integer width = 1024
integer height = 1064
string title = "원가계산서"
string menuname = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
event type long ue_refresh ( string as_person_id )
end type
global w_mesage_d w_mesage_d

event type long ue_refresh(string as_person_id);long ll_rows

ll_rows = dw_body.retrieve(as_person_id)

if ll_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

//timer(10)
return ll_rows

end event

event pfc_preopen();call super::pfc_preopen;this.x = 70
this.y = 300
trigger event ue_refresh(gs_user_id)
end event

on w_mesage_d.create
call super::create
end on

on w_mesage_d.destroy
call super::destroy
end on

event timer;call super::timer;il_rows = dw_body.retrieve(gs_user_id)

if il_rows > 0 then
	this.visible = true
else
	this.visible = false
end if

end event

type cb_close from w_com010_d`cb_close within w_mesage_d
boolean visible = false
end type

type cb_delete from w_com010_d`cb_delete within w_mesage_d
end type

type cb_insert from w_com010_d`cb_insert within w_mesage_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_mesage_d
boolean visible = false
end type

type cb_update from w_com010_d`cb_update within w_mesage_d
integer x = 631
integer y = 40
end type

type cb_print from w_com010_d`cb_print within w_mesage_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_mesage_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_mesage_d
boolean visible = false
integer x = 617
integer y = 4
end type

type cb_excel from w_com010_d`cb_excel within w_mesage_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_mesage_d
boolean visible = false
integer x = 745
integer width = 2811
end type

type ln_1 from w_com010_d`ln_1 within w_mesage_d
boolean visible = false
end type

type ln_2 from w_com010_d`ln_2 within w_mesage_d
boolean visible = false
end type

type dw_body from w_com010_d`dw_body within w_mesage_d
integer x = 0
integer y = 0
integer width = 1010
integer height = 960
string dataobject = "d_message_001"
boolean minbox = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_level, ls_gubn

if row > 0 then
	ls_style = this.getitemstring(row,"style_no")
	ls_level = this.getitemstring(row,"level")
	ls_gubn  = this.getitemstring(row,"gubn")
	
	gsv_cd.gs_cd10 = ls_style
	gsv_cd.gs_cd9  = ls_level
	
	if LeftA(ls_style,1) = 'X' then
		open(w_32019_e)	//원가 계산서(타스타스용)
	elseif LeftA(ls_style,1) = 'J' or LeftA(ls_style,1) = 'Y' then
		open(w_32011_e)	//원가 계산서(상설용)		
	elseif ls_gubn = '1' then 
		close(w_mesage_d11)
		open(w_mesage_d11)	//원가변경 비교확정			
	else
		open(w_32000_e)	//원가 계산서	
	end if
end if

end event

event dw_body::clicked;//////////////////////////////////////////////////////////////////////////////
//	Event:			clicked
//	Description:	DataWindow clicked
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
// 					6.0 	Added Linkage service notification
// 					6.0 	Introduced non zero return value
// 					7.0   Do not bypass processing on linkage failure.  
// 					7.0	Linkage service should not fire events when querymode is enabled
//////////////////////////////////////////////////////////////////////////////
//	Copyright ?1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
integer li_rc
boolean lb_disablelinkage


// Check arguments
if IsNull(xpos) or IsNull(ypos) or IsNull(row) or IsNull(dwo) then return

// Is Querymode enabled?
if IsValid(inv_QueryMode) then lb_disablelinkage = inv_QueryMode.of_GetEnabled()

if not lb_disablelinkage then
	if IsValid (inv_Linkage) then
		if inv_Linkage.Event pfc_clicked ( xpos, ypos, row, dwo ) = &
			inv_Linkage.PREVENT_ACTION then
			// The user or a service action prevents from going to the clicked row.
			return 1
		end if
	end if
end if
	
if IsValid (inv_RowSelect) then inv_RowSelect.Event pfc_clicked ( xpos, ypos, row, dwo )

if IsValid (inv_Sort) then inv_Sort.Event pfc_clicked ( xpos, ypos, row, dwo ) 


///////////////////////////////////////
choose case dwo.name
	case "b_refresh"
		trigger event ue_refresh(gs_user_id)
end choose
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

type dw_print from w_com010_d`dw_print within w_mesage_d
integer x = 690
integer y = 520
end type

