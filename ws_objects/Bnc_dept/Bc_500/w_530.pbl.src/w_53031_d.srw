$PBExportHeader$w_53031_d.srw
$PBExportComments$호텔행사실적조회
forward
global type w_53031_d from w_com010_d
end type
type rb_1 from radiobutton within w_53031_d
end type
type rb_2 from radiobutton within w_53031_d
end type
type rb_3 from radiobutton within w_53031_d
end type
type gb_1 from groupbox within w_53031_d
end type
type dw_1 from datawindow within w_53031_d
end type
type dw_3 from datawindow within w_53031_d
end type
end forward

global type w_53031_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
dw_1 dw_1
dw_3 dw_3
end type
global w_53031_d w_53031_d

type variables
String is_yymm , is_brand, is_shop_cd

end variables

event open;call super::open;
dw_head.setitem(1, "brand", "%")
dw_head.setitem(1, "shop_cd", "%")

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)

inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
dw_3.SetTransObject(SQLCA)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                             */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_brand = dw_head.GetItemString(1, "brand")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")

return true
end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_yymm, is_shop_cd, is_brand)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_53031_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
this.dw_1=create dw_1
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.dw_3
end on

on w_53031_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
destroy(this.dw_1)
destroy(this.dw_3)
end on

type cb_close from w_com010_d`cb_close within w_53031_d
end type

type cb_delete from w_com010_d`cb_delete within w_53031_d
end type

type cb_insert from w_com010_d`cb_insert within w_53031_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53031_d
end type

type cb_update from w_com010_d`cb_update within w_53031_d
end type

type cb_print from w_com010_d`cb_print within w_53031_d
end type

type cb_preview from w_com010_d`cb_preview within w_53031_d
end type

type gb_button from w_com010_d`gb_button within w_53031_d
end type

type cb_excel from w_com010_d`cb_excel within w_53031_d
end type

type dw_head from w_com010_d`dw_head within w_53031_d
integer x = 32
integer y = 316
integer width = 2213
integer height = 108
string dataobject = "d_53031_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowchild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('001')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_53031_d
end type

type ln_2 from w_com010_d`ln_2 within w_53031_d
end type

type dw_body from w_com010_d`dw_body within w_53031_d
string tag = "d_sh132_d02"
string dataobject = "d_53031_d01"
end type

type dw_print from w_com010_d`dw_print within w_53031_d
integer x = 1445
integer y = 568
string dataobject = "d_53031_d01"
end type

type rb_1 from radiobutton within w_53031_d
integer x = 251
integer y = 220
integer width = 439
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
string text = "일자/브랜드별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_2.textColor = rgb(0,0,0)
rb_3.textColor = rgb(0,0,0)
 

dw_body.DataObject  = 'd_53031_d01'
dw_print.DataObject = 'd_53031_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

is_brand = dw_head.GetItemString(1, "brand")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")

dw_body.retrieve(is_yymm, is_shop_cd, is_brand)

String ls_modify

ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)				 
end event

type rb_2 from radiobutton within w_53031_d
integer x = 745
integer y = 216
integer width = 357
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
string text = "판매형태별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_1.textColor = rgb(0,0,0)
rb_3.textColor = rgb(0,0,0)


dw_body.DataObject  = 'd_53031_d02'
dw_print.DataObject = 'd_53031_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

is_brand = dw_head.GetItemString(1, "brand")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")

dw_body.retrieve(is_yymm, is_shop_cd, is_brand)

String ls_modify


ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)				
end event

type rb_3 from radiobutton within w_53031_d
integer x = 1157
integer y = 220
integer width = 411
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결재수단별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_1.textColor = rgb(0,0,0)
rb_2.textColor = rgb(0,0,0)

dw_body.DataObject  = 'd_53031_d03'
dw_print.DataObject = 'd_53031_d03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_yymm = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")

is_brand = dw_head.GetItemString(1, "brand")
is_shop_cd = dw_head.GetItemString(1, "shop_cd")

dw_body.retrieve(is_yymm, iS_SHOP_CD,is_brand)



String ls_modify

ls_modify =  ' brand.Visible= 0 ' + &
				 ' shop_cd.Visible= 1 ' + &
				 ' t_1.Visible= 0 ' + &
 				 ' t_2.Visible= 1 '
				 
 dw_head.Modify(ls_modify)				 
end event

type gb_1 from groupbox within w_53031_d
integer x = 165
integer y = 160
integer width = 1449
integer height = 148
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

type dw_1 from datawindow within w_53031_d
integer x = 5
integer y = 468
integer width = 3589
integer height = 1572
integer taborder = 40
string title = "none"
string dataobject = "d_53031_d02"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within w_53031_d
integer x = 5
integer y = 468
integer width = 3589
integer height = 1572
integer taborder = 40
string title = "none"
string dataobject = "d_53031_d03"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

