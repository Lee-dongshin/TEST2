$PBExportHeader$w_menu02.srw
$PBExportComments$프로그램 등록
forward
global type w_menu02 from w_response
end type
type dw_entry from u_dw within w_menu02
end type
type cb_ok from commandbutton within w_menu02
end type
type cb_cancel from commandbutton within w_menu02
end type
type st_1 from statictext within w_menu02
end type
type dw_1 from datawindow within w_menu02
end type
end forward

global type w_menu02 from w_response
integer x = 1417
integer y = 600
integer width = 1870
integer height = 652
boolean titlebar = false
boolean controlmenu = false
event type integer ue_popup ( string as_column,  long al_row,  string as_data,  integer ai_div )
dw_entry dw_entry
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
dw_1 dw_1
end type
global w_menu02 w_menu02

type prototypes
FUNCTION boolean GetKeyboardState (ref char kbarray[256]) library "user32.dll" alias for "GetKeyboardState;Ansi"
FUNCTION boolean SetKeyboardState (ref char kbarray[256]) library "user32.dll" alias for "SetKeyboardState;Ansi"

end prototypes

type variables
window           iw_Parent,iw_Frame
integer          ii_close_msg 
boolean          ib_itemchanged        /* itemchange 발생 행위 여부 */

end variables

on w_menu02.create
int iCurrent
call super::create
this.dw_entry=create dw_entry
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_entry
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_1
end on

on w_menu02.destroy
call super::destroy
destroy(this.dw_entry)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.dw_1)
end on

event open;n_cst_parms   lnv_Parm 
dw_entry.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)

SetPointer(HourGlass!)
lnv_Parm = Message.PowerObjectParm

iw_Frame    = lnv_Parm.iw_Frame
iw_Parent   = lnv_Parm.iw_Parent

CHOOSE CASE lnv_Parm.is_select
	CASE 'I'
      dw_entry.insertrow(0)
      dw_1.insertrow(0)
    CASE 'U'
	   dw_entry.Retrieve(lnv_Parm.is_parentid, lnv_Parm.is_winid)
	   dw_1.Retrieve(lnv_Parm.is_parentid, lnv_Parm.is_winid)
END CHOOSE

This.Move(This.X + lnv_Parm.ii_OpenPos, This.Y + lnv_Parm.ii_OpenPos)

end event

event closequery;//
end event

type dw_entry from u_dw within w_menu02
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 112
integer width = 1815
integer height = 376
integer taborder = 10
string dataobject = "d_menu02_d01"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : M.S.I (김태범)                                              */	
/* 작성일      : 2000.09.01                                                  */	
/* 수성일      : 2000.09.01                                                  */
/*===========================================================================*/

String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		return 1
   CASE KeyF5!
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
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : M.S.I                                                       */	
/* 작성일      : 1999.11.09                                                  */	
/* 수성일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

end event

event dberror;/*===========================================================================*/
/* 작성자      : M.S.I                                                       */	
/* 작성일      : 1999.11.09																  */	
/* 수성일      : 1999.11.09																  */
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
		//if	gf_get_dberror(sqldbcode, ls_message_string) <> 1 then
			ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
			   				     "~n" + "에러메세지("+sqlerrtext+")" 
		//end if
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event constructor;call super::constructor;DataWindowChild  ldw_child

This.GetChild("user_grp", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('921')

This.GetChild("user_grp_1", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('921')

This.GetChild("part_cd", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('920')
ldw_child.InsertRow(1)

This.GetChild("part_cd_1", ldw_child)
ldw_child.SetTransObject(sqlca)
ldw_child.Retrieve('920')
ldw_child.InsertRow(1)

end event

event itemerror;RETURN 1
end event

event rbuttonup;//
end event

type cb_ok from commandbutton within w_menu02
integer x = 1285
integer y = 512
integer width = 274
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&Y)"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보(김 태범)                                           */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.11.11                                                  */
/*===========================================================================*/
n_cst_parms   lnv_Parm 
lnv_Parm = Message.PowerObjectParm

String   ls_pg_id, ls_display_seq
Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   Return 0
END IF

dw_entry.AcceptText()

IF dw_entry.getitemstatus(1,0,Primary!) = NewModified!  THEN				/* New Record */
      dw_entry.SetItem(1,"reg_id" ,   gs_shop_cd  )
ELSEIF dw_entry.getitemstatus(1,0,Primary!) = DataModified! THEN			/* Modify Record */
      dw_entry.SetItem(1,"mod_id" ,   gs_shop_cd  )
		dw_entry.SetItem(1,"mod_dt" ,   ld_datetime)
END IF
ls_pg_id = Trim(dw_entry.GetItemString(1,"pgm_id"))

IF lnv_Parm.is_select = 'I' THEN
	dw_1.SetItem(1,"menu_id" , lnv_Parm.is_parentid)
	dw_1.SetItem(1,"pgm_id",      ls_pg_id)
	dw_1.SetItem(1,"display_seq", dw_entry.GetItemString(1,"display_seq"))
   dw_1.SetItem(1,"reg_id" , gs_shop_cd  )
ELSEIF dw_entry.getitemstatus(1,"pgm_id",Primary!) = DataModified!       or &
	    dw_entry.getitemstatus(1,"display_seq",Primary!) = DataModified! THEN
	dw_1.SetItem(1,"pgm_id", ls_pg_id)
	dw_1.SetItem(1,"display_seq", dw_entry.GetItemString(1,"display_seq"))
   dw_1.SetItem(1,"mod_id" , gs_shop_cd  )
   dw_1.SetItem(1,"mod_dt" , ld_datetime  )
END IF

IF dw_1.Update(TRUE, FALSE) = 1 then
   IF dw_entry.Update(TRUE, FALSE) = 1 Then
		IF lnv_Parm.is_select = 'U' AND lnv_Parm.is_winid <> ls_pg_id THEN
			UPDATE tb_93030_h
			   SET MENU_ID  = CASE MENU_ID 
				                  WHEN :lnv_Parm.is_winid THEN :ls_pg_id
									   ELSE MENU_ID
										END, 
				    PGM_ID   = CASE PGM_ID 
					               WHEN :lnv_Parm.is_winid THEN :ls_pg_id
									   ELSE PGM_ID
									END
			 WHERE MENU_ID = :lnv_Parm.is_winid
			    OR PGM_ID  = :lnv_Parm.is_winid;
			IF SQLCA.SQLCODE <> 0 THEN
				MessageBox("SQL오류", SQLCA.SQLERRTEXT)
	         ROLLBACK;
            Return 
			END IF
		END IF
		dw_1.ResetUpdate()
		dw_entry.ResetUpdate()
	   COMMIT;
	ELSE  
      dw_entry.Setfocus()
	   ROLLBACK;
      Return 
   END IF
ELSE
   ROLLBACK;
   dw_entry.Setfocus()
   Return 
END IF

//ListView refresh
iw_Parent.Trigger Dynamic Event ue_refresh()

//TreeView InsertItem
lnv_Parm.ib_Check = True
lnv_Parm.is_Gubun = Trim(dw_entry.GetItemString(1,"pgm_fg")) 
lnv_Parm.is_Winid = Trim(dw_entry.GetItemString(1,"pgm_id"))
ls_display_seq    = Trim(dw_entry.GetItemString(1,"display_seq"))
IF ISNULL(ls_display_seq) OR ls_display_seq = "" THEN
   lnv_Parm.is_Label = Trim(dw_entry.GetItemString(1,"pgm_nm"))
ELSE
   lnv_Parm.is_Label = ls_display_seq + "." + Trim(dw_entry.GetItemString(1,"pgm_nm"))
END IF	

CloseWithReturn(Parent, lnv_Parm)

end event

type cb_cancel from commandbutton within w_menu02
integer x = 1559
integer y = 512
integer width = 274
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;/*===========================================================================*/
/* 작성자      : 지우정보 (김 태범)                                          */	
/* 작성일      : 1999.10.06                                                  */	
/* 수성일      : 1999.11.11                                                  */
/*===========================================================================*/
n_cst_parms   lnv_Parm 

lnv_Parm.ib_Check = False

CloseWithReturn(Parent, lnv_Parm)

end event

type st_1 from statictext within w_menu02
integer x = 46
integer y = 4
integer width = 530
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16777215
long backcolor = 8421376
boolean enabled = false
string text = "프로그램 등록"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_menu02
boolean visible = false
integer x = 27
integer y = 472
integer width = 882
integer height = 268
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_menu02_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

