$PBExportHeader$w_59003_d.srw
$PBExportComments$재고현황조회(해외)
forward
global type w_59003_d from w_com010_d
end type
type gb_1 from groupbox within w_59003_d
end type
type rb_1 from radiobutton within w_59003_d
end type
type rb_3 from radiobutton within w_59003_d
end type
type rb_4 from radiobutton within w_59003_d
end type
type rb_2 from radiobutton within w_59003_d
end type
end forward

global type w_59003_d from w_com010_d
string title = "창고재고현황"
gb_1 gb_1
rb_1 rb_1
rb_3 rb_3
rb_4 rb_4
rb_2 rb_2
end type
global w_59003_d w_59003_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_sojae, idw_item, idw_color, idw_size, idw_class, idw_shop_cd

string  is_yymmdd, is_brand, is_country_cd,  is_year , is_season, is_sojae, is_item, is_style_no, is_chno, is_shop_cd
string  is_color, is_size, is_class, is_style
end variables

on w_59003_d.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_2=create rb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_2
end on

on w_59003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_2)
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_country_cd = dw_head.GetItemString(1, "country_cd")
if IsNull(is_country_cd) or Trim(is_country_cd) = "" then
   MessageBox(ls_title,"국가코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("country_cd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd = ''
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
//   MessageBox(ls_title,"제품년도를 입력하십시요!")
   is_year = "%"
//   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
is_sojae = "%"
end if


is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
is_item = "%"
end if

is_style_no = dw_head.GetItemString(1, "style_no")
if IsNull(is_style_no) or Trim(is_style_no) = "" then
is_style_no = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
is_chno = "%"
end if

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
is_color = "%"
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
is_size = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_country_f, ls_country_t, ls_shop_f, ls_shop_t

if rb_1.checked = true then 
	dw_body.dataobject = 'd_59003_d01'
	dw_print.dataobject = 'd_59003_r01'
elseif rb_2.checked = true then 
	dw_body.dataobject = 'd_59003_d02'
	dw_print.dataobject = 'd_59003_r02'
elseif rb_3.checked = true then 
	dw_body.dataobject = 'd_59003_d03'
	dw_print.dataobject = 'd_59003_r03'
elseif rb_4.checked = true then 
	dw_body.dataobject = 'd_59003_d04'
	dw_print.dataobject = 'd_59003_r04'
end if	

dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_44004_d01 '20011215' , 'n', '010000', '2001' ,'w', '%', 'o','417','%', '%', '%'

if is_country_cd = '00' or is_country_cd = '전체' then
	ls_country_f = '  '
	ls_country_t = 'zz'
else
	ls_country_f = is_country_cd
	ls_country_t = is_country_cd
end if

if is_shop_cd = '' or isnull(is_shop_cd) then
	ls_shop_f = '      '
	ls_shop_t = 'zzzzzz'
else
	ls_shop_f = is_shop_cd
	ls_shop_t = is_shop_cd
end if

il_rows = dw_body.retrieve(is_yymmdd, is_brand, ls_country_f, ls_country_t, ls_shop_f, ls_shop_t, is_year, &
          is_season, is_sojae, is_item, is_style_no, is_chno, is_color, is_size)

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
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_country_cd, ls_country_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_country_cd = dw_head.getitemstring(1, 'contry')

select inter_nm into :ls_country_nm from tb_91011_c where inter_grp='000' and inter_cd = :ls_country_cd;

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymmdd.Text = '" + is_yymmdd + "'" + &
					"t_country_cd.Text = '" + ls_country_nm + "'" + &
					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 



dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_59003_d","0")
end event

event open;call super::open;dw_head.setitem(1,'country_cd','전체')
//dw_head.setitem(1,'shop_cd','전체')
end event

type cb_close from w_com010_d`cb_close within w_59003_d
end type

type cb_delete from w_com010_d`cb_delete within w_59003_d
end type

type cb_insert from w_com010_d`cb_insert within w_59003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_59003_d
end type

type cb_update from w_com010_d`cb_update within w_59003_d
end type

type cb_print from w_com010_d`cb_print within w_59003_d
end type

type cb_preview from w_com010_d`cb_preview within w_59003_d
end type

type gb_button from w_com010_d`gb_button within w_59003_d
end type

type cb_excel from w_com010_d`cb_excel within w_59003_d
end type

type dw_head from w_com010_d`dw_head within w_59003_d
integer x = 18
integer y = 156
integer width = 2839
integer height = 316
string dataobject = "d_59003_h01"
end type

event dw_head::constructor;call super::constructor;string ls_country_cd, ls_country_cd_f, ls_country_cd_t

This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_cd", idw_shop_cd )
idw_shop_cd.SetTransObject(SQLCA)
idw_shop_cd.Retrieve('  ', 'zz')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('gs_brand')

This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')

This.GetChild("size", idw_size )
idw_size.SetTransObject(SQLCA)
idw_size.Retrieve('%')

This.GetChild("class", idw_class )
idw_class.SetTransObject(SQLCA)
idw_class.Retrieve('401')



// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;string ls_country_cd, ls_country_cd_f, ls_country_cd_t

string ls_year, ls_brand
DataWindowChild ldw_child

dw_head.accepttext()
ls_country_cd = dw_head.getitemstring(1, 'country_cd')	

choose case dwo.name
	case 'country_cd'
		//국가 선택에 따라 매장이 나오게			
		if ls_country_cd = '00' or ls_country_cd = '전체' then
			ls_country_cd_f = '  '
			ls_country_cd_t = 'zz'
		else
			ls_country_cd_f = ls_country_cd
			ls_country_cd_t = ls_country_cd
		end if
		idw_shop_cd.reset()
		idw_shop_cd.Retrieve(ls_country_cd_f, ls_country_cd_t)


	CASE "brand"
		IF ib_itemchanged THEN RETURN 1

	
		This.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.insertrow(1)
		idw_sojae.Setitem(1, "sojae", "%")
		idw_sojae.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve(data)
		idw_item.insertrow(1)
		idw_item.Setitem(1, "item", "%")
		idw_item.Setitem(1, "item_nm", "전체")		
			
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
			
end choose


end event

type ln_1 from w_com010_d`ln_1 within w_59003_d
integer beginx = 5
integer beginy = 472
integer endx = 3625
integer endy = 472
end type

type ln_2 from w_com010_d`ln_2 within w_59003_d
integer beginy = 468
integer endy = 468
end type

type dw_body from w_com010_d`dw_body within w_59003_d
integer y = 484
integer width = 3602
integer height = 1536
string dataobject = "d_59003_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;This.of_SetSort(false)
end event

event dw_body::doubleclicked;call super::doubleclicked;//
//	
//dw_detail.reset()
//is_style =  dw_body.GetitemString(row,"style")	
//is_chno  =  dw_body.GetitemString(row,"chno")	
//
//
//IF is_style = "" OR isnull(is_style) THEN		
//	return
//END IF
//
//IF is_chno = "" OR isnull(is_chno) THEN		
//		is_chno = '%'
//	END IF
//	
//IF dw_detail.RowCount() < 1 THEN 
//	il_rows = dw_detail.retrieve(is_style, is_chno)
//	
//END IF 
//
//dw_detail.visible = True
//
end event

type dw_print from w_com010_d`dw_print within w_59003_d
integer x = 1650
integer y = 1052
integer width = 1280
integer height = 556
string dataobject = "d_59003_r01"
end type

type gb_1 from groupbox within w_59003_d
integer x = 2871
integer y = 144
integer width = 727
integer height = 312
integer taborder = 30
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

type rb_1 from radiobutton within w_59003_d
integer x = 2921
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
string text = "품번별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_3 from radiobutton within w_59003_d
integer x = 2921
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
string text = "품번/색상별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_4 from radiobutton within w_59003_d
integer x = 2921
integer y = 368
integer width = 576
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
string text = "품번/색상/사이즈별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_2 from radiobutton within w_59003_d
integer x = 2921
integer y = 248
integer width = 521
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
string text = "품번(차수무시)별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

