$PBExportHeader$w_sh132_d.srw
$PBExportComments$호텔행사판매내역
forward
global type w_sh132_d from w_com010_d
end type
type rb_1 from radiobutton within w_sh132_d
end type
type rb_2 from radiobutton within w_sh132_d
end type
type dw_1 from datawindow within w_sh132_d
end type
type dw_2 from datawindow within w_sh132_d
end type
type st_1 from statictext within w_sh132_d
end type
type dw_3 from datawindow within w_sh132_d
end type
type rb_4 from radiobutton within w_sh132_d
end type
type gb_1 from groupbox within w_sh132_d
end type
end forward

global type w_sh132_d from w_com010_d
integer width = 2985
integer height = 2064
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
dw_2 dw_2
st_1 st_1
dw_3 dw_3
rb_4 rb_4
gb_1 gb_1
end type
global w_sh132_d w_sh132_d

type variables
String is_yymm , is_brand, is_shop_cd

end variables

on w_sh132_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.dw_2=create dw_2
this.st_1=create st_1
this.dw_3=create dw_3
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_3
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.gb_1
end on

on w_sh132_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.st_1)
destroy(this.dw_3)
destroy(this.rb_4)
destroy(this.gb_1)
end on

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

if MidA(gs_shop_cd,3,4) = '2000' then
	messagebox("주의!", '행사 매장에서는 사용할 수 없습니다!')
	return false
end if	

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

dw_1.reset()
//dw_2.reset()
dw_3.reset()
dw_body.reset()

dw_1.retrieve(is_yymm, is_shop_cd, is_brand)
//dw_2.retrieve(gs_brand, is_yymm, gs_shop_cd, "1")
dw_3.retrieve(is_yymm, iS_SHOP_CD)
il_rows = dw_body.retrieve(is_yymm, is_shop_cd, is_brand)

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

event open;call super::open;
dw_head.setitem(1, "brand", "%")
dw_head.setitem(1, "shop_cd", "%")
Trigger Event ue_retrieve()
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
dw_1.SetTransObject(SQLCA)

inv_resize.of_Register(dw_2, "ScaleToRight&Bottom")
dw_2.SetTransObject(SQLCA)

inv_resize.of_Register(dw_3, "ScaleToRight&Bottom")
dw_3.SetTransObject(SQLCA)

end event

type cb_close from w_com010_d`cb_close within w_sh132_d
end type

type cb_delete from w_com010_d`cb_delete within w_sh132_d
end type

type cb_insert from w_com010_d`cb_insert within w_sh132_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_sh132_d
end type

type cb_update from w_com010_d`cb_update within w_sh132_d
end type

type cb_print from w_com010_d`cb_print within w_sh132_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_sh132_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_sh132_d
end type

type dw_head from w_com010_d`dw_head within w_sh132_d
integer x = 27
integer y = 296
integer width = 2176
integer height = 96
string dataobject = "d_sh132_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowchild ldw_child 

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.retrieve('001')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '%')
ldw_child.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_sh132_d
integer beginy = 396
integer endy = 396
end type

type ln_2 from w_com010_d`ln_2 within w_sh132_d
integer beginy = 400
integer endy = 400
end type

type dw_body from w_com010_d`dw_body within w_sh132_d
integer y = 408
integer height = 1412
string dataobject = "d_sh132_d05"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_sh132_d
end type

type rb_1 from radiobutton within w_sh132_d
integer x = 50
integer y = 212
integer width = 274
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
string text = "일자별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.textColor = Rgb(0,0,255)
rb_2.textColor = rgb(0,0,0)
//rb_3.textColor = rgb(0,0,0)
rb_4.textColor = rgb(0,0,0)

dw_body.Visible = True 
dw_1.Visible = False
//dw_2.Visible = False
dw_3.Visible = False
st_1.visible = false

String ls_modify

ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)				 
end event

type rb_2 from radiobutton within w_sh132_d
integer x = 320
integer y = 212
integer width = 288
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


dw_1.Visible = True 
dw_body.Visible = False
//dw_2.Visible = false
dw_3.Visible = False
st_1.visible = false

String ls_modify


ls_modify =  ' brand.Visible= 1 ' + &
				 ' shop_cd.Visible= 0 ' + &
				 ' t_1.Visible= 1 ' + &
 				 ' t_2.Visible= 0 '
				 
 dw_head.Modify(ls_modify)				
end event

type dw_1 from datawindow within w_sh132_d
boolean visible = false
integer y = 408
integer width = 2894
integer height = 1520
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh132_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within w_sh132_d
boolean visible = false
integer y = 408
integer width = 2894
integer height = 1520
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh102_d03"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sh132_d
boolean visible = false
integer x = 1262
integer y = 208
integer width = 1408
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711935
long backcolor = 67108864
string text = "◈ 목표비에 판매금액은 정상판매금액 입니다!"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_sh132_d
boolean visible = false
integer y = 408
integer width = 2894
integer height = 1520
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh132_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_4 from radiobutton within w_sh132_d
integer x = 585
integer y = 212
integer width = 274
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

dw_body.Visible = false
dw_1.Visible = False
//dw_2.Visible = False
dw_3.Visible = true
st_1.visible = true

String ls_modify

ls_modify =  ' brand.Visible= 0 ' + &
				 ' shop_cd.Visible= 1 ' + &
				 ' t_1.Visible= 0 ' + &
 				 ' t_2.Visible= 1 '
				 
 dw_head.Modify(ls_modify)				 
end event

type gb_1 from groupbox within w_sh132_d
integer x = 27
integer y = 152
integer width = 882
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

