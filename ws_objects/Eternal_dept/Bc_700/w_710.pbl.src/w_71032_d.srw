$PBExportHeader$w_71032_d.srw
$PBExportComments$고객정보지수
forward
global type w_71032_d from w_com010_d
end type
type st_1 from statictext within w_71032_d
end type
type rb_1 from radiobutton within w_71032_d
end type
type rb_2 from radiobutton within w_71032_d
end type
type rb_3 from radiobutton within w_71032_d
end type
type st_2 from statictext within w_71032_d
end type
type cb_1 from commandbutton within w_71032_d
end type
type cb_2 from commandbutton within w_71032_d
end type
end forward

global type w_71032_d from w_com010_d
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
st_2 st_2
cb_1 cb_1
cb_2 cb_2
end type
global w_71032_d w_71032_d

type variables
string is_category, is_jumin, is_graphtype, is_nlabels

end variables

on w_71032_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
end on

on w_71032_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String   ls_title

IF as_cb_div = '1' THEN
	ls_title = "조회오류"
ELSEIF as_cb_div = '2' THEN
	ls_title = "추가오류"
ELSEIF as_cb_div = '3' THEN
	ls_title = "저장오류"
ELSE
	ls_title = "오류"
END IF

IF dw_head.AcceptText() <> 1 THEN RETURN FALSE

is_category = dw_head.GetItemString(1, "category")
is_jumin = dw_head.GetItemString(1, "jumin")
is_graphtype = dw_head.GetItemString(1, "graphtype")

if dw_body.dataobject = 'd_71032_d02' then 
	dw_body.object.gr_1.graphtype = is_graphtype
	if IsNull(is_category) or Trim(is_category) = "" then
		MessageBox(ls_title,"구분 코드를 입력하십시요!")
		dw_head.SetFocus()
		dw_head.SetColumn("category")
		return false
	end if
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_title, ls_modify
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


if LenA(is_jumin) = 13 then 
	dw_body.dataobject = "d_71032_d01"
	dw_body.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_jumin)
elseif LenA(is_jumin) > 0 then
	dw_body.dataobject = "d_71032_d02"
	dw_body.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_category, is_jumin)
end if

IF il_rows > 0 THEN
	if dw_body.dataobject = 'd_71032_d02' then 
		ls_title = dw_body.getitemstring(1,"title")
		dw_body.object.gr_1.title = ls_title
	end if
elseIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF


This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)



end event

type cb_close from w_com010_d`cb_close within w_71032_d
end type

type cb_delete from w_com010_d`cb_delete within w_71032_d
end type

type cb_insert from w_com010_d`cb_insert within w_71032_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71032_d
end type

type cb_update from w_com010_d`cb_update within w_71032_d
end type

type cb_print from w_com010_d`cb_print within w_71032_d
end type

type cb_preview from w_com010_d`cb_preview within w_71032_d
end type

type gb_button from w_com010_d`gb_button within w_71032_d
end type

type cb_excel from w_com010_d`cb_excel within w_71032_d
end type

type dw_head from w_com010_d`dw_head within w_71032_d
integer x = 0
integer y = 164
integer height = 144
string dataobject = "d_71032_h01"
end type

type ln_1 from w_com010_d`ln_1 within w_71032_d
integer beginy = 324
integer endy = 324
end type

type ln_2 from w_com010_d`ln_2 within w_71032_d
integer beginy = 328
integer endy = 328
end type

type dw_body from w_com010_d`dw_body within w_71032_d
integer y = 348
integer height = 1680
string dataobject = "d_71032_d01"
end type

type dw_print from w_com010_d`dw_print within w_71032_d
end type

type st_1 from statictext within w_71032_d
integer x = 1998
integer y = 212
integer width = 251
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
string text = "그래프:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_71032_d
integer x = 2286
integer y = 208
integer width = 183
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
string text = "라인"
boolean checked = true
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
	dw_body.object.gr_1.graphtype = "12"


end event

type rb_2 from radiobutton within w_71032_d
integer x = 2514
integer y = 208
integer width = 197
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
string text = "막대"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
	dw_body.object.gr_1.graphtype = "7"

end event

type rb_3 from radiobutton within w_71032_d
integer x = 2757
integer y = 208
integer width = 197
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
string text = "파이"
boolean lefttext = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
	dw_body.object.gr_1.graphtype = "13"

end event

type st_2 from statictext within w_71032_d
integer x = 3090
integer y = 216
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
string text = "간격:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_71032_d
integer x = 3264
integer y = 200
integer width = 101
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "+"
end type

event clicked;integer li_labels

li_labels = dec(dw_body.object.gr_1.category.displayeverynlabels)
li_labels = li_labels + 1
	
dw_body.object.gr_1.category.displayeverynlabels = li_labels
end event

type cb_2 from commandbutton within w_71032_d
integer x = 3365
integer y = 200
integer width = 101
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "-"
end type

event clicked;integer li_labels

li_labels = dec(dw_body.object.gr_1.category.displayeverynlabels)
li_labels = li_labels - 1
if li_labels < 0 then li_labels = 0

dw_body.object.gr_1.category.displayeverynlabels = li_labels
end event

