$PBExportHeader$w_61028_d.srw
$PBExportComments$행사매출집계표
forward
global type w_61028_d from w_com010_d
end type
type rb_1 from radiobutton within w_61028_d
end type
type rb_2 from radiobutton within w_61028_d
end type
type rb_4 from radiobutton within w_61028_d
end type
type gb_1 from groupbox within w_61028_d
end type
end forward

global type w_61028_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_4 rb_4
gb_1 gb_1
end type
global w_61028_d w_61028_d

type variables
String is_brand, is_yymm, is_shop_cd
end variables

on w_61028_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_4
this.Control[iCurrent+4]=this.gb_1
end on

on w_61028_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_4)
destroy(this.gb_1)
end on

event open;call super::open;

dw_head.setitem(1, "brand", "%")
dw_head.setitem(1, "shop_cd", "%")
Trigger Event ue_retrieve()

Timer(600)
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;string   ls_title

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


is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")
if IsNull(is_yymm) or Trim(is_yymm) = "" then
   MessageBox(ls_title,"년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyymm")
   return false
end if

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"행사매장을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

return true
end event

event ue_retrieve();call super::ue_retrieve;
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if rb_1.checked = true then
	il_rows = dw_body.retrieve(is_yymm, is_shop_cd, is_brand)
elseif  rb_2.checked = true then
	il_rows = dw_body.retrieve(is_yymm, is_shop_cd, is_brand)
else
	il_rows = dw_body.retrieve(is_yymm, iS_SHOP_CD)
end if
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

//This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event timer;call super::timer;Trigger Event ue_retrieve()
end event

type cb_close from w_com010_d`cb_close within w_61028_d
end type

type cb_delete from w_com010_d`cb_delete within w_61028_d
end type

type cb_insert from w_com010_d`cb_insert within w_61028_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61028_d
end type

type cb_update from w_com010_d`cb_update within w_61028_d
end type

type cb_print from w_com010_d`cb_print within w_61028_d
end type

type cb_preview from w_com010_d`cb_preview within w_61028_d
end type

type gb_button from w_com010_d`gb_button within w_61028_d
end type

type cb_excel from w_com010_d`cb_excel within w_61028_d
end type

type dw_head from w_com010_d`dw_head within w_61028_d
integer x = 1413
integer width = 2181
integer height = 132
string dataobject = "d_61028_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowchild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('001')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_61028_d
integer beginy = 312
integer endy = 312
end type

type ln_2 from w_com010_d`ln_2 within w_61028_d
integer beginy = 316
integer endy = 316
end type

type dw_body from w_com010_d`dw_body within w_61028_d
integer y = 332
integer height = 1708
string dataobject = "d_61028_d05"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_61028_d
end type

type rb_1 from radiobutton within w_61028_d
integer x = 69
integer y = 208
integer width = 402
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
string text = "일자별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_2.textColor = rgb(0,0,0)
//rb_3.textColor = rgb(0,0,0)
rb_4.textColor = rgb(0,0,0)

dw_body.dataobject = "d_61028_d05"
dw_body.SetTransObject(SQLCA)


String ls_modify

ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)		
 
 Trigger Event ue_retrieve()
end event

type rb_2 from radiobutton within w_61028_d
integer x = 430
integer y = 208
integer width = 402
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
string text = "형태별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_1.textColor = rgb(0,0,0)
//rb_2.textColor = rgb(0,0,0)
rb_4.textColor = rgb(0,0,0)



dw_body.dataobject = "d_61028_d02"
dw_body.SetTransObject(SQLCA)

String ls_modify


ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)		
 
 Trigger Event ue_retrieve()
end event

type rb_4 from radiobutton within w_61028_d
integer x = 841
integer y = 208
integer width = 402
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
string text = "결제별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_1.textColor = rgb(0,0,0)
//rb_3.textColor = rgb(0,0,0)
rb_2.textColor = rgb(0,0,0)

dw_body.Dataobject = "d_61028_d04" 
dw_body.SetTransObject(SQLCA)

String ls_modify

ls_modify =  ' brand.Visible= 0 ' + &
				 ' shop_cd.Visible= 1 ' + &
				 ' t_1.Visible= 0 ' + &
 				 ' t_2.Visible= 1 '
				 
 dw_head.Modify(ls_modify)				
 
 Trigger Event ue_retrieve()
end event

type gb_1 from groupbox within w_61028_d
integer x = 50
integer y = 160
integer width = 1207
integer height = 136
integer taborder = 20
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

