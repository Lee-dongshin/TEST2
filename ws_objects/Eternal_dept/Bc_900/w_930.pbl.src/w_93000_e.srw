$PBExportHeader$w_93000_e.srw
$PBExportComments$프로그램PASSWD CHK
forward
global type w_93000_e from w_response
end type
type cb_cancel from u_cb within w_93000_e
end type
type cb_ok from u_cb within w_93000_e
end type
type st_1 from statictext within w_93000_e
end type
type sle_passwd from singlelineedit within w_93000_e
end type
type gb_2 from groupbox within w_93000_e
end type
end forward

global type w_93000_e from w_response
integer x = 0
integer y = 0
integer width = 1056
integer height = 428
boolean controlmenu = false
event ue_retrieve ( )
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
sle_passwd sle_passwd
gb_2 gb_2
end type
global w_93000_e w_93000_e

type variables
String   is_passwd, is_rtrn_val
end variables

event closequery;if is_rtrn_val = '' then
	return 1
end if

end event

event open;call super::open;long   ll_rows

This.Title = gst_cd.window_title
is_passwd  = gst_cd.data_value

is_rtrn_val = ''
end event

on w_93000_e.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.sle_passwd=create sle_passwd
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_passwd
this.Control[iCurrent+5]=this.gb_2
end on

on w_93000_e.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.sle_passwd)
destroy(this.gb_2)
end on

event pfc_preopen;call super::pfc_preopen;This.x = (This.ParentWindow().WorkSpaceWidth() / 2) - (This.Width	/ 2)
This.y = (This.ParentWindow().WorkSpaceHeight() / 2) - (This.Height/ 2)
end event

event pfc_close;is_rtrn_val = 'CANCEL'

CloseWithReturn(This, is_rtrn_val)


end event

type cb_cancel from u_cb within w_93000_e
integer x = 512
integer y = 12
integer width = 498
integer taborder = 70
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "취소(&C)"
end type

event clicked;call super::clicked;Parent.Trigger Event pfc_close()
end event

type cb_ok from u_cb within w_93000_e
integer x = 14
integer y = 12
integer width = 498
integer taborder = 60
integer textsize = -9
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "확인(&O)"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.15                                                  */	
/* 수성일      : 1999.11.15                                                  */
/*===========================================================================*/
String     ls_passwd

ls_passwd = sle_passwd.Text
if is_passwd   = ls_passwd then
   is_rtrn_val = 'OK'
else
   is_rtrn_val = 'NO'
end if	

CloseWithReturn(parent, is_rtrn_val)

end event

type st_1 from statictext within w_93000_e
integer x = 37
integer y = 152
integer width = 343
integer height = 48
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "PASSWORD :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_passwd from singlelineedit within w_93000_e
integer x = 393
integer y = 136
integer width = 576
integer height = 80
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event modified;call super::modified;call super::modified;
cb_ok.Trigger Event Clicked()
end event

type gb_2 from groupbox within w_93000_e
integer x = 14
integer y = 84
integer width = 997
integer height = 168
integer taborder = 50
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

