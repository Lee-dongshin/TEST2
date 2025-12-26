$PBExportHeader$u_61014.sru
forward
global type u_61014 from userobject
end type
type dw_1 from datawindow within u_61014
end type
end forward

global type u_61014 from userobject
integer width = 4251
integer height = 344
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type
global u_61014 u_61014

on u_61014.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on u_61014.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within u_61014
integer width = 4242
integer height = 332
integer taborder = 10
string title = "none"
string dataobject = "d_61014_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

