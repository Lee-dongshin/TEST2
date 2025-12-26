$PBExportHeader$w_com000.srw
$PBExportComments$기본 Window
forward
global type w_com000 from w_sheet
end type
type cb_close from commandbutton within w_com000
end type
type cb_delete from commandbutton within w_com000
end type
type cb_insert from commandbutton within w_com000
end type
type cb_retrieve from commandbutton within w_com000
end type
type cb_update from commandbutton within w_com000
end type
type cb_print from commandbutton within w_com000
end type
type cb_preview from commandbutton within w_com000
end type
type gb_button from groupbox within w_com000
end type
end forward

global type w_com000 from w_sheet
integer x = 0
integer y = 4
integer width = 2935
integer height = 2020
event ue_retrieve ( )
event ue_insert ( )
event ue_delete ( )
event type long ue_update ( )
event ue_print ( )
event ue_preview ( )
event ue_msg ( integer ai_cb_div,  long al_rows )
event type boolean ue_keycheck ( string as_cb_div )
event ue_button ( integer ai_cb_div,  long al_rows )
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
event ue_init ( datawindow adw_winid )
event ue_head ( )
cb_close cb_close
cb_delete cb_delete
cb_insert cb_insert
cb_retrieve cb_retrieve
cb_update cb_update
cb_print cb_print
cb_preview cb_preview
gb_button gb_button
end type
global w_com000 w_com000

type prototypes
FUNCTION boolean GetKeyboardState (ref char kbarray[256]) library "user32.dll" alias for "GetKeyboardState;Ansi"
FUNCTION boolean SetKeyboardState (ref char kbarray[256]) library "user32.dll" alias for "SetKeyboardState;Ansi"

end prototypes

type variables
long           il_rows               /* retrieve, update, insertrow, deleterow.... Return Value */
boolean        ib_changed            /* 수정사항체크 */
boolean        ib_itemchanged        /* itemchange 발생 행위 여부 */
dwitemstatus	idw_status            /* DataWindow item status */
int            ii_min_column_id, ii_max_column_id /* datawindow column id */
String         is_pgm_id, is_pgm_nm  /* Program id, name */

end variables

event ue_init;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)														  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/* Tab order가 존재한 처음과 마지막 Colunm 검색                              */
/*===========================================================================*/
Integer i, li_column_count
String  ls_tab_order, ls_min_tab_order = '9000', ls_max_tab_order = '0', ls_column_cnt

ls_column_cnt = adw_winid.Describe("DataWindow.Column.Count")
IF IsNull(ls_column_cnt) THEN
	MessageBox("실행오류","DataWindow(" + String(adw_winid) + ")가 없습니다!")
	Return
END IF

li_column_count = Integer(ls_column_cnt)

FOR i=1 TO li_column_count
	ls_tab_order = adw_winid.Describe('#' + String(i) + '.tabsequence')
	IF ls_tab_order = '?' OR ls_tab_order = '0' THEN CONTINUE
	IF Integer(ls_min_tab_order) > Integer(ls_tab_order) THEN
		ls_min_tab_order = ls_tab_order
		ii_min_column_id = i
	END IF
	IF Integer(ls_max_tab_order) < Integer(ls_tab_order) THEN
		ls_max_tab_order = ls_tab_order
		ii_max_column_id = i
	END IF
NEXT

end event

on w_com000.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_retrieve=create cb_retrieve
this.cb_update=create cb_update
this.cb_print=create cb_print
this.cb_preview=create cb_preview
this.gb_button=create gb_button
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_delete
this.Control[iCurrent+3]=this.cb_insert
this.Control[iCurrent+4]=this.cb_retrieve
this.Control[iCurrent+5]=this.cb_update
this.Control[iCurrent+6]=this.cb_print
this.Control[iCurrent+7]=this.cb_preview
this.Control[iCurrent+8]=this.gb_button
end on

on w_com000.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_retrieve)
destroy(this.cb_update)
destroy(this.cb_print)
destroy(this.cb_preview)
destroy(this.gb_button)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)		   											  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
//graphicobject 		stp_obj
PowerObject	      stp_obj
object  				type_obj
String            ls_parm, ls_window_title
Integer           li_pos

TreeViewItem		ltvi_Window
ListViewItem		llvi_Window

// Arrange of Controls
This.ParentWindow().Trigger ArrangeSheets(Layer!)

IF IsValid(Message.PowerObjectParm) THEN				//메뉴탐색기에서 CALL
	stp_obj  = Message.PowerObjectParm
	type_obj = stp_obj.TypeOf( )
	CHOOSE CASE type_obj
		CASE TreeViewItem!
			ltvi_Window = Message.PowerObjectParm
			This.Title  = ltvi_Window.Label + " [" + ltvi_Window.Data + "]"
			is_pgm_id   = ltvi_Window.Data
			is_pgm_nm   = ltvi_Window.Label
		CASE ListViewItem!
			llvi_Window = Message.PowerObjectParm
			This.Title  = llvi_Window.Label + " [" + llvi_Window.Data + "]"
			is_pgm_id   = llvi_Window.Data
			is_pgm_nm   = llvi_Window.Label
	END CHOOSE
ELSEIF Message.StringParm <> "" THEN
	ls_parm = Message.StringParm
	li_pos  = PosA(ls_parm, "W_",1)
	is_pgm_id       = MidA(ls_parm, li_pos, 10)
	ls_window_title = MidA(ls_parm, li_pos + 10)
	This.Title      = ls_window_title + " [" + is_pgm_id + "]"
	is_pgm_nm       = ls_window_title
END IF
end event

event pfc_preopen();/*===========================================================================*/
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

end event

type cb_close from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 2514
integer y = 44
integer width = 347
integer height = 92
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
Parent.Trigger Event pfc_close()
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type cb_delete from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 1088
integer y = 44
integer width = 347
integer height = 92
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제(&D)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
Parent.Trigger Event ue_delete()
end event

type cb_insert from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 745
integer y = 44
integer width = 347
integer height = 92
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "추가(&A)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
Parent.Trigger Event ue_insert()
end event

type cb_retrieve from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 2171
integer y = 44
integer width = 347
integer height = 92
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&Q)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type cb_update from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 32
integer y = 44
integer width = 347
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "저장(&S)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/
This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김태범)  													  */	
/* 작성일      : 1999.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/
pointer oldpointer  // Declares a pointer variable

This.Enabled = False
oldpointer = SetPointer(HourGlass!)

il_rows = Parent.Trigger Event ue_update()

SetPointer(oldpointer)

IF il_rows = 1 THEN 
	This.Enabled = False
ELSE
	This.Enabled = True
END IF

end event

type cb_print from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 1431
integer y = 44
integer width = 347
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "인쇄(&P)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
Parent.Trigger Event ue_print()

end event

type cb_preview from commandbutton within w_com000
event ue_keydown pbm_keydown
integer x = 1774
integer y = 44
integer width = 347
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "미리보기(&V)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF
end event

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
Parent.Trigger Event ue_preview()
end event

event getfocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : 지우정보       															  */	
/*===========================================================================*/
This.Weight = 400

end event

type gb_button from groupbox within w_com000
integer width = 2889
integer height = 156
integer taborder = 80
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
borderstyle borderstyle = stylelowered!
end type

