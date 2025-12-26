$PBExportHeader$w_23087_d.srw
$PBExportComments$자재 구매 금액 (입고기준/만기기준)
forward
global type w_23087_d from w_com010_d
end type
type rb_1 from radiobutton within w_23087_d
end type
type rb_2 from radiobutton within w_23087_d
end type
type gb_1 from groupbox within w_23087_d
end type
end forward

global type w_23087_d from w_com010_d
integer width = 3675
integer height = 2276
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_23087_d w_23087_d

on w_23087_d.create
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

on w_23087_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

type cb_close from w_com010_d`cb_close within w_23087_d
end type

type cb_delete from w_com010_d`cb_delete within w_23087_d
end type

type cb_insert from w_com010_d`cb_insert within w_23087_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_23087_d
end type

type cb_update from w_com010_d`cb_update within w_23087_d
end type

type cb_print from w_com010_d`cb_print within w_23087_d
end type

type cb_preview from w_com010_d`cb_preview within w_23087_d
end type

type gb_button from w_com010_d`gb_button within w_23087_d
end type

type cb_excel from w_com010_d`cb_excel within w_23087_d
end type

type dw_head from w_com010_d`dw_head within w_23087_d
integer x = 928
integer width = 2629
integer height = 124
string dataobject = "d_23087_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_23087_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_23087_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_23087_d
integer y = 348
integer height = 1692
string dataobject = "d_23087_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_23087_d
end type

type rb_1 from radiobutton within w_23087_d
integer x = 73
integer y = 216
integer width = 361
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
string text = "입고 기준"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_2.TextColor = RGB(0, 0, 0)

end event

type rb_2 from radiobutton within w_23087_d
integer x = 439
integer y = 216
integer width = 361
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
string text = "만기 기준"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0, 0, 0)
This.TextColor = RGB(0, 0, 255)

end event

type gb_1 from groupbox within w_23087_d
integer y = 136
integer width = 855
integer height = 188
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

