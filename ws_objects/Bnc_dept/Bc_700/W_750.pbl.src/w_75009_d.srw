$PBExportHeader$w_75009_d.srw
$PBExportComments$이벤트반응분석
forward
global type w_75009_d from w_com020_d
end type
type dw_event from u_dw within w_75009_d
end type
type ddlb_1 from dropdownlistbox within w_75009_d
end type
type dw_1 from datawindow within w_75009_d
end type
end forward

global type w_75009_d from w_com020_d
integer height = 2540
event graph_nlabel_set ( )
dw_event dw_event
ddlb_1 ddlb_1
dw_1 dw_1
end type
global w_75009_d w_75009_d

type variables
string is_fr_ymd, is_to_ymd, is_event_nm, list_yymmdd, list_event_no

end variables

on w_75009_d.create
int iCurrent
call super::create
this.dw_event=create dw_event
this.ddlb_1=create ddlb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_event
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.dw_1
end on

on w_75009_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_event)
destroy(this.ddlb_1)
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

is_fr_ymd   = dw_head.GetItemString(1, "fr_ymd")
is_to_ymd   = dw_head.GetItemString(1, "to_ymd")
is_event_nm = dw_head.GetItemString(1, "event_nm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_ymd, is_to_ymd, is_event_nm)
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
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(st_1, "ScaleToBottom")

inv_resize.of_Register(dw_event, "ScaleToRight")

idrg_Vertical[1] = dw_list
idrg_Vertical[2] = dw_body

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)


/*===========================================================================*/
/* 작성자      : (주)지우정보 (김태범)													  */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_event, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")

/* DataWindow의 Transction 정의 */
dw_event.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)


end event

event open;call super::open;datetime ld_datetime

IF gf_cdate(ld_datetime,0)  THEN  
	dw_head.setitem(1,"to_ymd",string(ld_datetime,"yyyymmdd"))

end if

IF gf_cdate(ld_datetime,-1)  THEN  
	dw_head.setitem(1,"fr_ymd",string(ld_datetime,"yyyymmdd"))

end if


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_75009_d","0")
end event

type cb_close from w_com020_d`cb_close within w_75009_d
end type

type cb_delete from w_com020_d`cb_delete within w_75009_d
end type

type cb_insert from w_com020_d`cb_insert within w_75009_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_75009_d
end type

type cb_update from w_com020_d`cb_update within w_75009_d
end type

type cb_print from w_com020_d`cb_print within w_75009_d
end type

type cb_preview from w_com020_d`cb_preview within w_75009_d
end type

type gb_button from w_com020_d`gb_button within w_75009_d
end type

type cb_excel from w_com020_d`cb_excel within w_75009_d
end type

type dw_head from w_com020_d`dw_head within w_75009_d
integer height = 140
string dataobject = "d_75009_h01"
end type

type ln_1 from w_com020_d`ln_1 within w_75009_d
integer beginy = 320
integer endy = 320
end type

type ln_2 from w_com020_d`ln_2 within w_75009_d
integer beginy = 324
integer endy = 324
end type

type dw_list from w_com020_d`dw_list within w_75009_d
integer y = 340
integer width = 443
integer height = 2004
string dataobject = "d_75009_l01"
end type

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

long	ll_cnt
IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

list_yymmdd   = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
list_event_no = This.GetItemString(row, 'event_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(list_yymmdd) THEN return

il_rows = dw_event.retrieve(list_yymmdd, list_event_no)
if il_rows > 0 then
	il_rows = dw_body.retrieve(list_yymmdd, list_event_no)
	if il_rows > 0 then 	
		dw_body.scrolltorow(dw_body.rowcount())
		il_rows = dw_1.retrieve(list_yymmdd, list_event_no)
	end if
end if

dw_body.object.gr_1.category.displayeverynlabels= string(dw_body.rowcount()/10)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_body from w_com020_d`dw_body within w_75009_d
integer x = 489
integer y = 648
integer width = 3113
integer height = 1480
string dataobject = "d_75009_d01"
end type

type st_1 from w_com020_d`st_1 within w_75009_d
integer x = 471
integer y = 344
integer height = 2000
end type

event st_1::ue_mouseup;call super::ue_mouseup;Long		ll_Width

ll_Width = idrg_Vertical[2].X + idrg_Vertical[2].Width - st_1.X - ii_BarThickness

dw_event.Move (st_1.X + ii_BarThickness, dw_event.Y)
dw_event.Resize (ll_Width, dw_event.Height)

dw_1.Move (st_1.X + ii_BarThickness, dw_1.Y)
dw_1.Resize (ll_Width, dw_1.Height)

ddlb_1.Move (st_1.X + 594, ddlb_1.Y)




end event

type dw_print from w_com020_d`dw_print within w_75009_d
integer x = 603
integer y = 48
end type

type dw_event from u_dw within w_75009_d
integer x = 489
integer y = 340
integer width = 3113
integer height = 292
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_75002_m01"
end type

type ddlb_1 from dropdownlistbox within w_75009_d
integer x = 1065
integer y = 660
integer width = 805
integer height = 584
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "1 - 일자별"
boolean autohscroll = true
string item[] = {"1 - 일자별","2 - 유통별","3 - 지역별","4 - 매장구분별","5 - 나이별"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;string ls_dataobject
if dw_list.rowcount() = 0 then return 1

choose case index
	case 1
		ls_dataobject = "d_75009_d01"
	case 2
		ls_dataobject = "d_75009_d02"
	case 3
		ls_dataobject = "d_75009_d03"
	case 4
		ls_dataobject = "d_75009_d04"
	case 5
		ls_dataobject = "d_75009_d05"
	case 6
		ls_dataobject = "d_75009_d06"
end choose 
		
dw_body.dataobject = ls_dataobject
dw_body.SetTransObject(SQLCA)


il_rows = dw_body.retrieve(list_yymmdd, list_event_no)
if il_rows > 0 then
	dw_body.object.gr_1.category.displayeverynlabels= string(dw_body.rowcount()/10)
end if
end event

type dw_1 from datawindow within w_75009_d
integer x = 485
integer y = 2136
integer width = 3122
integer height = 208
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_75009_d06"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

