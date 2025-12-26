$PBExportHeader$w_com500.srw
$PBExportComments$매장직원정보창
forward
global type w_com500 from window
end type
type dw_1 from datawindow within w_com500
end type
end forward

global type w_com500 from window
integer width = 3570
integer height = 1492
boolean titlebar = true
string title = "매장직원현황"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 67108864
dw_1 dw_1
end type
global w_com500 w_com500

on w_com500.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_com500.destroy
destroy(this.dw_1)
end on

event open;this.x = 500
this.y = 500

dw_1.SetTransObject(SQLCA)


end event

type dw_1 from datawindow within w_com500
integer y = 8
integer width = 3529
integer height = 1344
integer taborder = 10
string title = "매장직원현황"
string dataobject = "d_com005"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

