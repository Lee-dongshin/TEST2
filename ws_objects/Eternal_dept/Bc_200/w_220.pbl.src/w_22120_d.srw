$PBExportHeader$w_22120_d.srw
$PBExportComments$원자재 매입 집계현황
forward
global type w_22120_d from w_com010_d
end type
type dw_1 from datawindow within w_22120_d
end type
type rb_brand from radiobutton within w_22120_d
end type
type rb_month from radiobutton within w_22120_d
end type
type cbx_58 from checkbox within w_22120_d
end type
end forward

global type w_22120_d from w_com010_d
integer width = 3675
integer height = 2252
dw_1 dw_1
rb_brand rb_brand
rb_month rb_month
cbx_58 cbx_58
end type
global w_22120_d w_22120_d

type variables
string is_brand, is_year, is_mat_item, is_gubn
datawindowchild idw_brand
end variables

on w_22120_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.rb_brand=create rb_brand
this.rb_month=create rb_month
this.cbx_58=create cbx_58
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.rb_brand
this.Control[iCurrent+3]=this.rb_month
this.Control[iCurrent+4]=this.cbx_58
end on

on w_22120_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.rb_brand)
destroy(this.rb_month)
destroy(this.cbx_58)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")


/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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
is_year  = dw_head.GetItemString(1, "year")
is_mat_item  = dw_head.GetItemString(1, "mat_item")
is_gubn  = dw_head.GetItemString(1, "gubn")
return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if dw_body.visible then
	il_rows = dw_body.retrieve(is_brand, is_year, is_mat_item, is_gubn)
else
	il_rows = dw_1.retrieve(is_brand, is_year, is_mat_item, is_gubn)
end if
IF il_rows > 0 THEN

ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

if dw_body.visible then
	dw_print.dataobject = dw_body.dataobject
else
	dw_print.dataobject = dw_1.dataobject
end if

dw_print.SetTransObject(SQLCA)
il_rows = dw_print.retrieve(is_brand, is_year, is_mat_item)
dw_print.inv_printpreview.of_SetZoom()

end event

type cb_close from w_com010_d`cb_close within w_22120_d
end type

type cb_delete from w_com010_d`cb_delete within w_22120_d
end type

type cb_insert from w_com010_d`cb_insert within w_22120_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_22120_d
end type

type cb_update from w_com010_d`cb_update within w_22120_d
end type

type cb_print from w_com010_d`cb_print within w_22120_d
end type

type cb_preview from w_com010_d`cb_preview within w_22120_d
end type

type gb_button from w_com010_d`gb_button within w_22120_d
end type

type cb_excel from w_com010_d`cb_excel within w_22120_d
end type

type dw_head from w_com010_d`dw_head within w_22120_d
integer height = 160
string dataobject = "d_22120_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_22120_d
integer beginy = 356
integer endy = 356
end type

type ln_2 from w_com010_d`ln_2 within w_22120_d
integer beginy = 360
integer endy = 360
end type

type dw_body from w_com010_d`dw_body within w_22120_d
integer y = 380
integer height = 1640
string dataobject = "d_22120_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_22120_d
string dataobject = "d_22120_d01"
end type

type dw_1 from datawindow within w_22120_d
boolean visible = false
integer x = 5
integer y = 380
integer width = 3589
integer height = 1640
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_22120_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_brand from radiobutton within w_22120_d
integer x = 2409
integer y = 188
integer width = 334
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
string text = "브랜드별"
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.visible = false
	dw_1.visible = true
end if
end event

type rb_month from radiobutton within w_22120_d
integer x = 2816
integer y = 184
integer width = 334
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
string text = "월별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if this.checked then
	dw_body.visible = true
	dw_1.visible = false
end if

end event

type cbx_58 from checkbox within w_22120_d
integer x = 2414
integer y = 268
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "58인치 기준"
borderstyle borderstyle = stylelowered!
end type

event clicked;
	if dw_1.dataobject = 'd_22120_d02' then 
		dw_1.dataobject = 'd_22120_d04'
	else
		dw_1.dataobject = 'd_22120_d02'
	end if
	dw_1.SetTransObject(SQLCA)

	if dw_body.dataobject = 'd_22120_d01' then 
		dw_body.dataobject = 'd_22120_d03'
	else
		dw_body.dataobject = 'd_22120_d01'
	end if
	dw_body.SetTransObject(SQLCA)



end event

