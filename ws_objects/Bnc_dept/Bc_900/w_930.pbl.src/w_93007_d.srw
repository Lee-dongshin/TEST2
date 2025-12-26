$PBExportHeader$w_93007_d.srw
$PBExportComments$프로그램별 사용순위
forward
global type w_93007_d from w_com020_d
end type
type dw_1 from datawindow within w_93007_d
end type
end forward

global type w_93007_d from w_com020_d
integer width = 3648
dw_1 dw_1
end type
global w_93007_d w_93007_d

type variables
DataStore	 ids_Source


boolean      ib_moveinprogress=False

integer      ii_min_left_space = 20
integer      ii_min_right_space = 20

/*  */
Boolean      ib_lvpass = False   
String       is_Winid, is_Winname 
Long         il_Parent, il_Person, il_index
Long	       il_DragSourcelv, il_ParentTarget
Integer	    ii_Columns, ii_OpenPos

string is_fr_yymmdd, is_to_yymmdd

end variables

on w_93007_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_93007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
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

is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_yymmdd, is_to_yymmdd)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
	MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
	MessageBox("조회오류", "조회 실패 하였습니다.") 
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범) 												  */	
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
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list, "ScaleToBottom")
inv_resize.of_Register(dw_body, "ScaleToBottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"fr_yymmdd",string(ld_datetime,"yyyymmdd"))
end if


IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_yymmdd",string(ld_datetime,"yyyymmdd"))
end if
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_93007_d","0")
end event

type cb_close from w_com020_d`cb_close within w_93007_d
end type

type cb_delete from w_com020_d`cb_delete within w_93007_d
end type

type cb_insert from w_com020_d`cb_insert within w_93007_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_93007_d
end type

type cb_update from w_com020_d`cb_update within w_93007_d
end type

type cb_print from w_com020_d`cb_print within w_93007_d
end type

type cb_preview from w_com020_d`cb_preview within w_93007_d
end type

type gb_button from w_com020_d`gb_button within w_93007_d
end type

type cb_excel from w_com020_d`cb_excel within w_93007_d
end type

type dw_head from w_com020_d`dw_head within w_93007_d
integer height = 164
string dataobject = "d_93007_h01"
end type

type ln_1 from w_com020_d`ln_1 within w_93007_d
integer beginy = 360
integer endy = 360
end type

type ln_2 from w_com020_d`ln_2 within w_93007_d
integer beginy = 364
integer endy = 364
end type

type dw_list from w_com020_d`dw_list within w_93007_d
integer y = 376
integer width = 2048
integer height = 1668
string dataobject = "d_93007_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_pgm_id
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_pgm_id = This.GetItemString(row, 'pgm_id') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_pgm_id) THEN return
il_rows = dw_body.retrieve(is_fr_yymmdd, is_to_yymmdd, ls_pgm_id)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_93007_d
integer x = 2103
integer y = 376
integer width = 713
integer height = 1668
string dataobject = "d_93007_d02"
boolean hscrollbar = true
end type

event dw_body::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_person_id
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

ls_person_id = This.GetItemString(row, 'person_id') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(ls_person_id) THEN return
il_rows = dw_1.retrieve(is_fr_yymmdd, is_to_yymmdd, ls_person_id)
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
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

type st_1 from w_com020_d`st_1 within w_93007_d
integer x = 2085
integer y = 376
integer height = 1668
end type

type dw_print from w_com020_d`dw_print within w_93007_d
integer x = 78
integer y = 620
end type

type dw_1 from datawindow within w_93007_d
integer x = 2821
integer y = 372
integer width = 768
integer height = 1668
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_93007_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/


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

