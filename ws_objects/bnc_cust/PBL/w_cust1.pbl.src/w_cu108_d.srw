$PBExportHeader$w_cu108_d.srw
$PBExportComments$평균생산기간
forward
global type w_cu108_d from w_com010_d
end type
type rb_style from radiobutton within w_cu108_d
end type
type rb_item from radiobutton within w_cu108_d
end type
type gb_1 from groupbox within w_cu108_d
end type
end forward

global type w_cu108_d from w_com010_d
integer width = 3653
integer height = 2236
rb_style rb_style
rb_item rb_item
gb_1 gb_1
end type
global w_cu108_d w_cu108_d

type variables
string is_brand, is_year, is_season, is_sojae, is_make_type
decimal idc_in_rate
DataWindowChild idw_brand, idw_season, idw_sojae, idw_make_type
end variables

on w_cu108_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_item=create rb_item
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_item
this.Control[iCurrent+3]=this.gb_1
end on

on w_cu108_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_item)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.14                                                  */	
/* 수정일      : 2001.12.14                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if



is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_make_type = Trim(dw_head.GetItemString(1, "make_type"))
if IsNull(is_make_type) or is_make_type = "" then
   MessageBox(ls_title,"생산 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("make_type")
   return false
end if

idc_in_rate = dw_head.GetItemDecimal(1, "in_rate")
if IsNull(idc_in_rate) or idc_in_rate = 0 then
   MessageBox(ls_title,"입고율을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("in_rate")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      :                                                  */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_year,is_season,is_sojae,is_make_type,idc_in_rate,gs_shop_cd)
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김 종호)                               */	
/* 작성일      : 2002.01.10                                                  */	
/* 수정일      : 2002.01.10                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime,ls_title

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	 "t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
             "t_year.Text = '" + is_year + "'" + &
				 "t_season.Text = '" + idw_season.GetItemString(idw_Season.GetRow(), "inter_display") + "'"   + &
				 "t_sojae.Text = '" + idw_sojae.GetItemString(idw_Sojae.GetRow(), "sojae_display") + "'"   + &
				 "t_make_type.Text = '" + idw_make_type.GetItemString(idw_Make_type.GetRow(), "inter_display") + "'" + &
				 "t_in_rate.Text = '" + string(idc_in_rate) + "'" 
				 
dw_print.Modify(ls_modify)
 


end event

type cb_close from w_com010_d`cb_close within w_cu108_d
end type

type cb_delete from w_com010_d`cb_delete within w_cu108_d
end type

type cb_insert from w_com010_d`cb_insert within w_cu108_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_cu108_d
end type

type cb_update from w_com010_d`cb_update within w_cu108_d
end type

type cb_print from w_com010_d`cb_print within w_cu108_d
end type

type cb_preview from w_com010_d`cb_preview within w_cu108_d
end type

type gb_button from w_com010_d`gb_button within w_cu108_d
integer width = 3602
end type

type dw_head from w_com010_d`dw_head within w_cu108_d
integer x = 462
integer width = 3136
string dataobject = "d_cu108_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%')
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("make_type", idw_make_type)
idw_make_type.SetTransObject(SQLCA)
idw_make_type.Retrieve('030')
idw_make_type.InsertRow(1)
idw_make_type.SetItem(1, "inter_cd", '%')
idw_make_type.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_cu108_d
integer endx = 3611
end type

type ln_2 from w_com010_d`ln_2 within w_cu108_d
integer endx = 3611
end type

type dw_body from w_com010_d`dw_body within w_cu108_d
integer width = 3602
integer height = 1580
string dataobject = "d_cu108_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_cu108_d
string dataobject = "d_cu108_r01"
end type

type rb_style from radiobutton within w_cu108_d
integer x = 46
integer y = 244
integer width = 334
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
string text = "품번별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_item.TextColor = 0

dw_body.DataObject = 'd_cu108_d01'
dw_print.DataObject = 'd_cu108_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_item from radiobutton within w_cu108_d
integer x = 46
integer y = 312
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
string text = "복종별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_style.TextColor = 0

dw_body.DataObject = 'd_cu108_d02'
dw_print.DataObject = 'd_cu108_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_cu108_d
integer x = 32
integer y = 188
integer width = 379
integer height = 212
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

