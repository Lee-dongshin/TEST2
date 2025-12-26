$PBExportHeader$w_23094_d.srw
$PBExportComments$CLAIM 내역 현황
forward
global type w_23094_d from w_com010_d
end type
type rb_1 from radiobutton within w_23094_d
end type
type rb_2 from radiobutton within w_23094_d
end type
type gb_1 from groupbox within w_23094_d
end type
end forward

global type w_23094_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_23094_d w_23094_d

on w_23094_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_23094_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

type cb_close from w_com010_d`cb_close within w_23094_d
end type

type cb_delete from w_com010_d`cb_delete within w_23094_d
end type

type cb_insert from w_com010_d`cb_insert within w_23094_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23094_d
end type

type cb_update from w_com010_d`cb_update within w_23094_d
end type

type cb_print from w_com010_d`cb_print within w_23094_d
end type

type cb_preview from w_com010_d`cb_preview within w_23094_d
end type

type gb_button from w_com010_d`gb_button within w_23094_d
end type

type cb_excel from w_com010_d`cb_excel within w_23094_d
end type

type dw_head from w_com010_d`dw_head within w_23094_d
integer x = 763
integer width = 2793
integer height = 220
string dataobject = "d_23094_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_23094_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_23094_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_23094_d
integer y = 444
integer height = 1596
string dataobject = "d_23094_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_23094_d
end type

type rb_1 from radiobutton within w_23094_d
integer x = 59
integer y = 216
integer width = 631
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "CLAIM 정산 집계 현황"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_2.TextColor = RGB(0, 0, 0)

dw_body.DataObject = 'd_23094_d01'
dw_body.SetTransObject(SQLCA)

end event

type rb_2 from radiobutton within w_23094_d
integer x = 59
integer y = 312
integer width = 631
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "CLAIM 내역(COLOR별)"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0, 0, 0)
This.TextColor = RGB(0, 0, 255)

dw_body.DataObject = 'd_23094_d02'
dw_body.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_23094_d
integer y = 136
integer width = 750
integer height = 284
integer taborder = 110
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

