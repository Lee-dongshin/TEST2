$PBExportHeader$w_21001_k.srw
$PBExportComments$자재코드등록 테스트
forward
global type w_21001_k from window
end type
type em_1 from editmask within w_21001_k
end type
type cb_2 from commandbutton within w_21001_k
end type
type cb_1 from commandbutton within w_21001_k
end type
type ddlb_4 from dropdownlistbox within w_21001_k
end type
type st_4 from statictext within w_21001_k
end type
type ddlb_3 from dropdownlistbox within w_21001_k
end type
type st_3 from statictext within w_21001_k
end type
type st_2 from statictext within w_21001_k
end type
type ddlb_1 from dropdownlistbox within w_21001_k
end type
type st_1 from statictext within w_21001_k
end type
type dw_1 from datawindow within w_21001_k
end type
type gb_1 from groupbox within w_21001_k
end type
end forward

global type w_21001_k from window
string tag = "W_21001_K"
integer width = 3707
integer height = 1980
boolean titlebar = true
string title = "테스트조회"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
em_1 em_1
cb_2 cb_2
cb_1 cb_1
ddlb_4 ddlb_4
st_4 st_4
ddlb_3 ddlb_3
st_3 st_3
st_2 st_2
ddlb_1 ddlb_1
st_1 st_1
dw_1 dw_1
gb_1 gb_1
end type
global w_21001_k w_21001_k

on w_21001_k.create
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.ddlb_4=create ddlb_4
this.st_4=create st_4
this.ddlb_3=create ddlb_3
this.st_3=create st_3
this.st_2=create st_2
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.Control[]={this.em_1,&
this.cb_2,&
this.cb_1,&
this.ddlb_4,&
this.st_4,&
this.ddlb_3,&
this.st_3,&
this.st_2,&
this.ddlb_1,&
this.st_1,&
this.dw_1,&
this.gb_1}
end on

on w_21001_k.destroy
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.ddlb_4)
destroy(this.st_4)
destroy(this.ddlb_3)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.gb_1)
end on

event open;

dw_1.SetTransObject(sqlca)


em_1.text = '2018'

ddlb_1.SelectItem(1)

ddlb_3.SelectItem(1)

ddlb_4.SelectItem(1)
end event

event close;Close (this)
end event

type em_1 from editmask within w_21001_k
integer x = 1033
integer y = 112
integer width = 261
integer height = 84
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_2 from commandbutton within w_21001_k
integer x = 3287
integer y = 60
integer width = 293
integer height = 168
integer taborder = 70
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "종료(&X)"
end type

event clicked;Trigger Event close()
end event

type cb_1 from commandbutton within w_21001_k
integer x = 3013
integer y = 60
integer width = 274
integer height = 168
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "조회(&R)"
end type

event clicked;String is_brand, is_mat_year, is_mat_season, is_mat_item, ls_msg


dw_1.setredraw(false)

is_brand = RightA(ddlb_1.text,1)
is_mat_year = trim(em_1.text)
is_mat_season = RightA(ddlb_3.text,1)
is_mat_item = RightA(ddlb_4.text,1)


if LenA(trim(is_brand)) < 1 then
	messagebox('확인', '브랜드를 선택해주세요')
	return
end if


if LenA(trim(is_mat_year)) < 4 then
	messagebox('확인', '년도를 제대로 입력해주세요')
	return
end if

if LenA(trim(is_mat_season)) < 1 then
	messagebox('확인', '시즌을 선택해주세요')
	return
end if

if LenA(trim(is_mat_item)) < 1 then
	messagebox('확인', '소재를 선택해주세요')
	return
end if


dw_1.retrieve(is_brand, is_mat_year, is_mat_season, is_mat_item)

dw_1.setredraw(true)

dw_1.SetFocus()

end event

type ddlb_4 from dropdownlistbox within w_21001_k
integer x = 2309
integer y = 112
integer width = 393
integer height = 1496
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"전체                                  %","안감                                  A","벨트                                  B","박클                                  C","단추                                  D"}
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_21001_k
integer x = 2080
integer y = 124
integer width = 215
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "소재:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_3 from dropdownlistbox within w_21001_k
integer x = 1600
integer y = 112
integer width = 407
integer height = 1276
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"봄                         S","여름                     M","가을                     A","겨울                     W","사계절                  X"}
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_21001_k
integer x = 1399
integer y = 124
integer width = 174
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "시즌:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_21001_k
integer x = 846
integer y = 124
integer width = 174
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "년도:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_21001_k
integer x = 343
integer y = 112
integer width = 480
integer height = 1392
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
string item[] = {"전체                                  %","ON & ON                           N","OLIVE DES OLIVE            O","Lapalette                            B"}
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_21001_k
integer x = 55
integer y = 124
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "브랜드:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_21001_k
integer y = 296
integer width = 3584
integer height = 1516
integer taborder = 60
string dataobject = "d_21001_t01"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;datawindowchild ldw_child

this.getchild("unit",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('004')

this.getchild("mat_type",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('123')

this.getchild("hs_nm",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('034')
ldw_child.InsertRow(1)
end event

type gb_1 from groupbox within w_21001_k
integer x = 14
integer y = 8
integer width = 2976
integer height = 248
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

