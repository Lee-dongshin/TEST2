$PBExportHeader$w_62030_d.srw
$PBExportComments$창고및 매장재고 증감율
forward
global type w_62030_d from w_com010_d
end type
type rb_house from radiobutton within w_62030_d
end type
type rb_shop from radiobutton within w_62030_d
end type
type rb_cost from radiobutton within w_62030_d
end type
type st_1 from statictext within w_62030_d
end type
type dw_1 from datawindow within w_62030_d
end type
end forward

global type w_62030_d from w_com010_d
rb_house rb_house
rb_shop rb_shop
rb_cost rb_cost
st_1 st_1
dw_1 dw_1
end type
global w_62030_d w_62030_d

type variables
string is_brand, is_year, is_season, is_yymmdd
datawindowchild idw_brand, idw_season

end variables

on w_62030_d.create
int iCurrent
call super::create
this.rb_house=create rb_house
this.rb_shop=create rb_shop
this.rb_cost=create rb_cost
this.st_1=create st_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_house
this.Control[iCurrent+2]=this.rb_shop
this.Control[iCurrent+3]=this.rb_cost
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_1
end on

on w_62030_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_house)
destroy(this.rb_shop)
destroy(this.rb_cost)
destroy(this.st_1)
destroy(this.dw_1)
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if
is_year   = dw_head.GetItemString(1, "year")
is_season = dw_head.GetItemString(1, "season")
is_yymmdd = dw_head.GetItemString(1, "yymmdd")

if rb_house.checked then 
	dw_body.dataobject = "d_62030_d01"
	dw_print.dataobject = "d_62030_d01"
	dw_1.dataobject = "d_62030_b01"
elseif rb_shop.checked then
	dw_body.dataobject = "d_62030_d02"	
	dw_print.dataobject = "d_62030_d02"	
	dw_1.dataobject = "d_62030_b02"	
else
	dw_body.dataobject = "d_62030_d03"	
	dw_print.dataobject = "d_62030_d03"	
	dw_1.dataobject = "d_62030_b03"	
end if
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)	
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_yymmdd)
IF il_rows > 0 THEN
	il_rows = dw_1.retrieve(is_brand, is_year, is_season, is_yymmdd)
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToBottom")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_62030_d
end type

type cb_delete from w_com010_d`cb_delete within w_62030_d
end type

type cb_insert from w_com010_d`cb_insert within w_62030_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62030_d
end type

type cb_update from w_com010_d`cb_update within w_62030_d
end type

type cb_print from w_com010_d`cb_print within w_62030_d
end type

type cb_preview from w_com010_d`cb_preview within w_62030_d
end type

type gb_button from w_com010_d`gb_button within w_62030_d
end type

type cb_excel from w_com010_d`cb_excel within w_62030_d
end type

type dw_head from w_com010_d`dw_head within w_62030_d
integer height = 140
string dataobject = "d_62030_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
	
		
//		This.GetChild("sojae", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve('%', data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "sojae", "%")
//		ldw_child.Setitem(1, "sojae_nm", "전체")
//		
//	
//		This.GetChild("item", ldw_child)
//		ldw_child.SetTransObject(SQLCA)
//		ldw_child.Retrieve(data)
//		ldw_child.insertrow(1)
//		ldw_child.Setitem(1, "item", "%")
//		ldw_child.Setitem(1, "item_nm", "전체")		
				
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', ls_brand, data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")				
		
	
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_62030_d
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_62030_d
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_62030_d
integer x = 960
integer y = 352
integer width = 2633
integer height = 1664
string dataobject = "d_62030_d01"
end type

type dw_print from w_com010_d`dw_print within w_62030_d
string dataobject = "d_62030_d01"
end type

type rb_house from radiobutton within w_62030_d
integer x = 2427
integer y = 252
integer width = 338
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
string text = "창고재고"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

type rb_shop from radiobutton within w_62030_d
integer x = 2427
integer y = 180
integer width = 338
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
string text = "매장재고"
borderstyle borderstyle = stylelowered!
end type

type rb_cost from radiobutton within w_62030_d
integer x = 2811
integer y = 180
integer width = 338
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
string text = "원가투입"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_62030_d
integer x = 3159
integer y = 224
integer width = 1029
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 기준일자기준 6개월간 데이타입니다."
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_62030_d
integer y = 352
integer width = 960
integer height = 1664
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_62030_b01"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

