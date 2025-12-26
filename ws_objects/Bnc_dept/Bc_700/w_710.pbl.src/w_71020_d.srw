$PBExportHeader$w_71020_d.srw
$PBExportComments$이벤트진행내역
forward
global type w_71020_d from w_com010_d
end type
type rb_1 from radiobutton within w_71020_d
end type
type rb_2 from radiobutton within w_71020_d
end type
type rb_3 from radiobutton within w_71020_d
end type
type rb_4 from radiobutton within w_71020_d
end type
type rb_5 from radiobutton within w_71020_d
end type
type rb_6 from radiobutton within w_71020_d
end type
type rb_7 from radiobutton within w_71020_d
end type
type rb_8 from radiobutton within w_71020_d
end type
end forward

global type w_71020_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
end type
global w_71020_d w_71020_d

type variables
datawindowchild idw_brand
string is_brand, id_reg_from, id_reg_to
decimal id_coupon_amt
end variables

on w_71020_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
this.Control[iCurrent+8]=this.rb_8
end on

on w_71020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
end on

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if rb_1.checked =  enabled then 
	il_rows = dw_body.retrieve(is_brand, id_reg_from, id_reg_to)
elseif rb_5.checked =  enabled then   
	il_rows = dw_body.retrieve(id_reg_from, id_reg_to)
else 
	il_rows = dw_body.retrieve(is_brand, id_reg_from, id_reg_to,id_coupon_amt)	
end if

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

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 영일)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title
string	ls_temp_dt
date		ld_Date
time		lt_Time

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

id_reg_from = String(dw_head.GetItemDateTime(1,"reg_from"), 'yyyymmdd')
if IsNull(id_reg_from) Or Trim(id_reg_from) = "" then
   MessageBox(ls_title,"From일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("id_reg_from")
	return false
end if

id_reg_to = String(dw_head.GetItemDateTime(1,"reg_to"), 'yyyymmdd')
if IsNull(id_reg_to) Or Trim(id_reg_to) = "" then
   MessageBox(ls_title,"To일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("reg_to")
	return false
end if

if id_reg_from > id_reg_to  then
	MessageBox(ls_title, "마지막 일자가 처음 일자보다 작습니다!")
   dw_head.SetFocus()
	dw_head.SetColumn("reg_to")
	return false
end if

is_brand = dw_head.GetItemString(1, "brand")

return true

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "reg_from", ld_datetime)
dw_head.SetItem(1, "reg_to", ld_datetime)
end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

//if rb_6.checked = true then  
//	dw_body.ShareData(dw_print)
//else	
//	dw_print.Retrieve( id_reg_from, id_reg_to)
//end if


if rb_6.checked = true then  
	dw_body.ShareData(dw_print)
elseif rb_5.checked =  enabled then   
	il_rows = dw_print.retrieve(id_reg_from, id_reg_to)
else 
	il_rows = dw_print.retrieve(is_brand, id_reg_from, id_reg_to,id_coupon_amt)	
end if


dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()


if rb_6.checked = true then  
	dw_body.ShareData(dw_print)
else	
	dw_print.Retrieve( id_reg_from, id_reg_to)
end if

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if rb_6.checked = true then
 ls_modify =	 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"
 dw_print.Modify(ls_modify)
end if 

end event

type cb_close from w_com010_d`cb_close within w_71020_d
end type

type cb_delete from w_com010_d`cb_delete within w_71020_d
end type

type cb_insert from w_com010_d`cb_insert within w_71020_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_71020_d
end type

type cb_update from w_com010_d`cb_update within w_71020_d
end type

type cb_print from w_com010_d`cb_print within w_71020_d
end type

type cb_preview from w_com010_d`cb_preview within w_71020_d
end type

type gb_button from w_com010_d`gb_button within w_71020_d
end type

type cb_excel from w_com010_d`cb_excel within w_71020_d
end type

type dw_head from w_com010_d`dw_head within w_71020_d
integer width = 2190
integer height = 236
string dataobject = "d_71020_h01"
end type

event dw_head::constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보(김영일)                                            */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.01.18                                                  */
/*===========================================================================*/

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

idw_brand.insertrow(1)
idw_brand.setitem(1,"inter_cd", '%')
idw_brand.setitem(1,"inter_nm",'전체')





end event

type ln_1 from w_com010_d`ln_1 within w_71020_d
end type

type ln_2 from w_com010_d`ln_2 within w_71020_d
end type

type dw_body from w_com010_d`dw_body within w_71020_d
string dataobject = "d_71020_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_71020_d
integer width = 1253
integer height = 692
string dataobject = "d_71020_d01"
end type

type rb_1 from radiobutton within w_71020_d
integer x = 2336
integer y = 180
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "전체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d01'
dw_print.DataObject = 'd_71020_d01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


end event

type rb_2 from radiobutton within w_71020_d
integer x = 2336
integer y = 244
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
string text = "2만원권"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d02'
dw_print.DataObject = 'd_71020_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

id_coupon_amt = 20000

end event

type rb_3 from radiobutton within w_71020_d
integer x = 2336
integer y = 308
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
string text = "3만원권"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d02'
dw_print.DataObject = 'd_71020_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
id_coupon_amt = 30000

end event

type rb_4 from radiobutton within w_71020_d
integer x = 2336
integer y = 368
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
string text = "5만원권"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d02'
dw_print.DataObject = 'd_71020_d02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

id_coupon_amt = 50000

end event

type rb_5 from radiobutton within w_71020_d
integer x = 2853
integer y = 188
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
string text = "보고서출력"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d05'
dw_print.DataObject = 'd_71020_d05'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)



end event

type rb_6 from radiobutton within w_71020_d
integer x = 2853
integer y = 248
integer width = 466
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
string text = "일자별사용내역"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_7.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d06'
dw_print.DataObject = 'd_71020_r06'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_7 from radiobutton within w_71020_d
integer x = 2853
integer y = 308
integer width = 494
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
string text = "매장별 회수비교"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_8.TextColor     = 0

dw_body.DataObject  = 'd_71020_d07'
dw_print.DataObject = 'd_71020_d07'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_8 from radiobutton within w_71020_d
integer x = 2853
integer y = 368
integer width = 439
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
string text = "브랜드별 비교"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor     = RGB(0, 0, 255)
rb_1.TextColor     = 0
rb_2.TextColor     = 0
rb_3.TextColor     = 0
rb_4.TextColor     = 0
rb_5.TextColor     = 0
rb_6.TextColor     = 0
rb_7.TextColor     = 0

dw_body.DataObject  = 'd_71020_d08'
dw_print.DataObject = 'd_71020_d08'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

