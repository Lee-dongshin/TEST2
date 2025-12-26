$PBExportHeader$w_21002_p.srw
$PBExportComments$테스트일자 조회 팝업
forward
global type w_21002_p from window
end type
type cb_2 from commandbutton within w_21002_p
end type
type cb_1 from commandbutton within w_21002_p
end type
type dw_1 from datawindow within w_21002_p
end type
type gb_1 from groupbox within w_21002_p
end type
end forward

global type w_21002_p from window
integer width = 1728
integer height = 828
boolean titlebar = true
string title = "테스트 일자 팝업"
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
end type
global w_21002_p w_21002_p

on w_21002_p.create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.cb_1,&
this.dw_1,&
this.gb_1}
end on

on w_21002_p.destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;string p_style

dw_1.SetTransObject(sqlca)


dw_1.SetRedraw(False)

p_style = Message.StringParm


dw_1.retrieve(p_style)


dw_1.SetRedraw(True)

end event

type cb_2 from commandbutton within w_21002_p
integer x = 1349
integer y = 616
integer width = 338
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "닫기(&X)"
end type

event clicked;CloseWithReturn(parent,"CloseEvent")
end event

type cb_1 from commandbutton within w_21002_p
integer x = 1010
integer y = 616
integer width = 338
integer height = 88
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "저장(&S)"
end type

event clicked;String  r_detail

dw_1.accepttext()


r_detail = dw_1.getitemstring(1,"test_detail")

CloseWithReturn(parent, r_detail)
end event

type dw_1 from datawindow within w_21002_p
integer x = 14
integer y = 28
integer width = 1691
integer height = 556
integer taborder = 10
string title = "none"
string dataobject = "d_21002_p01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_21002_p
integer x = 992
integer y = 580
integer width = 718
integer height = 144
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

