$PBExportHeader$w_com300.srw
$PBExportComments$스타일정보창
forward
global type w_com300 from window
end type
type st_1 from statictext within w_com300
end type
type dw_3 from datawindow within w_com300
end type
type dw_2 from datawindow within w_com300
end type
type dw_1 from datawindow within w_com300
end type
end forward

global type w_com300 from window
integer width = 1879
integer height = 2020
boolean titlebar = true
string title = "스타일정보"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
event ue_chno_ddw ( )
event ue_chno ( )
event ue_retrieve ( )
st_1 st_1
dw_3 dw_3
dw_2 dw_2
dw_1 dw_1
end type
global w_com300 w_com300

type variables
string is_style, is_chno
datawindowchild idw_chno
end variables

event ue_chno();is_style = dw_1.getitemstring(1,"style")

dw_2.insertrow(1)
dw_2.GetChild("chno", idw_chno)
idw_chno.SetTransObject(SQLCA)
idw_chno.Retrieve(is_style)
idw_chno.insertrow(1)
idw_chno.Setitem(1, "chno", "%")
end event

event ue_retrieve();is_style = dw_1.getitemstring(1,"style")
dw_1.retrieve(is_style, is_chno)
dw_3.visible = false
end event

on w_com300.create
this.st_1=create st_1
this.dw_3=create dw_3
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.st_1,&
this.dw_3,&
this.dw_2,&
this.dw_1}
end on

on w_com300.destroy
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;this.x = 500
this.y = 500

dw_1.SetTransObject(SQLCA)
dw_3.SetTransObject(SQLCA)
post event ue_chno()
dw_3.visible = false

end event

type st_1 from statictext within w_com300
integer x = 672
integer y = 132
integer width = 325
integer height = 48
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean italic = true
boolean underline = true
long textcolor = 16711680
long backcolor = 1090519039
string text = "Life Cycle"
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;dw_3.visible = true
dw_3.retrieve(is_style, is_chno)
end event

type dw_3 from datawindow within w_com300
boolean visible = false
integer x = 27
integer y = 1172
integer width = 1810
integer height = 728
integer taborder = 20
string title = "none"
string dataobject = "d_life_cycle"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_3.visible = false
end event

type dw_2 from datawindow within w_com300
integer x = 1381
integer y = 1124
integer width = 187
integer height = 68
integer taborder = 20
string title = "none"
string dataobject = "d_chno_001"
boolean border = false
boolean livescroll = true
end type

event itemchanged;is_chno = data
post event ue_retrieve()

end event

type dw_1 from datawindow within w_com300
integer width = 1847
integer height = 1920
integer taborder = 10
string title = "none"
string dataobject = "d_style_pic"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

