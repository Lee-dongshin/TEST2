$PBExportHeader$w_com700.srw
$PBExportComments$매장정보창
forward
global type w_com700 from window
end type
type dw_1 from datawindow within w_com700
end type
end forward

global type w_com700 from window
integer width = 4699
integer height = 2700
boolean titlebar = true
string title = "매장 정보"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
event ue_chno_ddw ( )
dw_1 dw_1
end type
global w_com700 w_com700

type variables
string is_style, is_chno = '%', is_size_gbn = '0', is_gubn = 'K'
datawindowchild idw_chno
end variables

on w_com700.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_com700.destroy
destroy(this.dw_1)
end on

event open;this.x = 500
this.y = 500

dw_1.SetTransObject(SQLCA)

end event

type dw_1 from datawindow within w_com700
integer width = 4699
integer height = 2700
integer taborder = 10
string title = "none"
string dataobject = "d_61040_r00"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

