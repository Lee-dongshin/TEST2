$PBExportHeader$w_21002_p2.srw
$PBExportComments$테스트일자 이력 팝업
forward
global type w_21002_p2 from window
end type
type cb_2 from commandbutton within w_21002_p2
end type
type dw_1 from datawindow within w_21002_p2
end type
type gb_1 from groupbox within w_21002_p2
end type
end forward

global type w_21002_p2 from window
integer width = 1746
integer height = 844
boolean titlebar = true
string title = "테스트 일자 팝업"
windowtype windowtype = response!
long backcolor = 67108864
cb_2 cb_2
dw_1 dw_1
gb_1 gb_1
end type
global w_21002_p2 w_21002_p2

on w_21002_p2.create
this.cb_2=create cb_2
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.cb_2,&
this.dw_1,&
this.gb_1}
end on

on w_21002_p2.destroy
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;string p_style, aaa
dec p_count
dw_1.SetTransObject(sqlca)


dw_1.SetRedraw(False)

aaa = Message.StringParm

p_style = LeftA(aaa,8)
p_count = Dec(MidA(aaa,9,99))



dw_1.retrieve(p_style, p_count)


dw_1.SetRedraw(True)

end event

type cb_2 from commandbutton within w_21002_p2
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

event clicked;ClosewithReturn(parent,'')
end event

type dw_1 from datawindow within w_21002_p2
integer x = 14
integer y = 28
integer width = 1678
integer height = 556
integer taborder = 10
string title = "none"
string dataobject = "d_21002_p02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_21002_p2
integer x = 1330
integer y = 580
integer width = 379
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

