$PBExportHeader$w_com400.srw
$PBExportComments$스타일/색상정보창
forward
global type w_com400 from window
end type
type dw_2 from datawindow within w_com400
end type
type dw_1 from datawindow within w_com400
end type
end forward

global type w_com400 from window
integer width = 1879
integer height = 2020
boolean titlebar = true
string title = "스타일/색상정보"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
event ue_chno_ddw ( )
event ue_chno ( )
event ue_retrieve ( )
dw_2 dw_2
dw_1 dw_1
end type
global w_com400 w_com400

type variables
string is_style, is_chno,is_color
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
dw_1.retrieve(is_style, is_chno,is_color)
end event

on w_com400.create
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.dw_2,&
this.dw_1}
end on

on w_com400.destroy
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;this.x = 500
this.y = 500

dw_1.SetTransObject(SQLCA)

post event ue_chno()


end event

type dw_2 from datawindow within w_com400
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

type dw_1 from datawindow within w_com400
integer width = 1847
integer height = 1920
integer taborder = 10
string title = "none"
string dataobject = "d_style_color_pic"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

