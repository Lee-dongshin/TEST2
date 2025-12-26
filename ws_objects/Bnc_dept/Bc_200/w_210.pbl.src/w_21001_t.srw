$PBExportHeader$w_21001_t.srw
$PBExportComments$자재코드등록 테스트
forward
global type w_21001_t from w_com010_e
end type
type st_1 from statictext within w_21001_t
end type
type ddlb_1 from dropdownlistbox within w_21001_t
end type
type st_2 from statictext within w_21001_t
end type
type st_3 from statictext within w_21001_t
end type
type ddlb_3 from dropdownlistbox within w_21001_t
end type
type st_4 from statictext within w_21001_t
end type
type ddlb_4 from dropdownlistbox within w_21001_t
end type
type sle_year from singlelineedit within w_21001_t
end type
type gb_1 from groupbox within w_21001_t
end type
end forward

global type w_21001_t from w_com010_e
integer width = 3758
st_1 st_1
ddlb_1 ddlb_1
st_2 st_2
st_3 st_3
ddlb_3 ddlb_3
st_4 st_4
ddlb_4 ddlb_4
sle_year sle_year
gb_1 gb_1
end type
global w_21001_t w_21001_t

on w_21001_t.create
int iCurrent
call super::create
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.st_2=create st_2
this.st_3=create st_3
this.ddlb_3=create ddlb_3
this.st_4=create st_4
this.ddlb_4=create ddlb_4
this.sle_year=create sle_year
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.ddlb_3
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.ddlb_4
this.Control[iCurrent+8]=this.sle_year
this.Control[iCurrent+9]=this.gb_1
end on

on w_21001_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.ddlb_3)
destroy(this.st_4)
destroy(this.ddlb_4)
destroy(this.sle_year)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;String is_brand, is_mat_year, is_mat_season, is_mat_item, ls_msg


dw_body.setredraw(false)



is_brand = RightA(ddlb_1.text,1)
is_mat_year = trim(sle_year.text)
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


//is_brand = 'O'
//is_mat_year = '2018'
//is_mat_season = '%'
//is_mat_item = '%'

dw_body.retrieve(is_brand, is_mat_year, is_mat_season, is_mat_item)

dw_body.setredraw(true)
ls_msg = '조회가 완료되었습니다.'
dw_body.SetFocus()

end event

event open;call super::open;sle_year.text = '2018'

ddlb_1.SelectItem(1)

ddlb_3.SelectItem(1)

ddlb_4.SelectItem(1)

end event

type cb_close from w_com010_e`cb_close within w_21001_t
end type

type cb_delete from w_com010_e`cb_delete within w_21001_t
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_21001_t
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21001_t
end type

type cb_update from w_com010_e`cb_update within w_21001_t
boolean visible = false
end type

type cb_print from w_com010_e`cb_print within w_21001_t
end type

type cb_preview from w_com010_e`cb_preview within w_21001_t
end type

type gb_button from w_com010_e`gb_button within w_21001_t
end type

type cb_excel from w_com010_e`cb_excel within w_21001_t
end type

type dw_head from w_com010_e`dw_head within w_21001_t
boolean visible = false
integer x = 4009
integer y = 196
integer width = 1047
end type

type ln_1 from w_com010_e`ln_1 within w_21001_t
end type

type ln_2 from w_com010_e`ln_2 within w_21001_t
end type

type dw_body from w_com010_e`dw_body within w_21001_t
string dataobject = "d_21001_t01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;datawindowchild ldw_child

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

type dw_print from w_com010_e`dw_print within w_21001_t
integer x = 4069
integer y = 584
end type

type st_1 from statictext within w_21001_t
integer x = 55
integer y = 268
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

type ddlb_1 from dropdownlistbox within w_21001_t
integer x = 343
integer y = 260
integer width = 480
integer height = 1392
integer taborder = 100
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

type st_2 from statictext within w_21001_t
integer x = 846
integer y = 272
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

type st_3 from statictext within w_21001_t
integer x = 1477
integer y = 272
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

type ddlb_3 from dropdownlistbox within w_21001_t
integer x = 1678
integer y = 260
integer width = 407
integer height = 1276
integer taborder = 110
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

type st_4 from statictext within w_21001_t
integer x = 2158
integer y = 276
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

type ddlb_4 from dropdownlistbox within w_21001_t
integer x = 2386
integer y = 260
integer width = 393
integer height = 1496
integer taborder = 120
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

type sle_year from singlelineedit within w_21001_t
integer x = 1033
integer y = 260
integer width = 311
integer height = 80
integer taborder = 110
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_21001_t
integer x = 18
integer y = 156
integer width = 3584
integer height = 248
integer taborder = 90
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

