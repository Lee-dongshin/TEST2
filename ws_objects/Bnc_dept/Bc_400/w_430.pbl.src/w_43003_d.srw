$PBExportHeader$w_43003_d.srw
$PBExportComments$창고재고현황조회
forward
global type w_43003_d from w_com010_d
end type
type rb_1 from radiobutton within w_43003_d
end type
type rb_2 from radiobutton within w_43003_d
end type
type rb_3 from radiobutton within w_43003_d
end type
type rb_4 from radiobutton within w_43003_d
end type
type rb_5 from radiobutton within w_43003_d
end type
type rb_6 from radiobutton within w_43003_d
end type
type gb_1 from groupbox within w_43003_d
end type
end forward

global type w_43003_d from w_com010_d
integer width = 3698
string title = "창고재고현황"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
gb_1 gb_1
end type
global w_43003_d w_43003_d

type variables
DataWindowChild idw_house_cd, idw_brand, idw_year, idw_season, idw_sojae, idw_item, idw_color, idw_size,idw_class
string  is_yymmdd, is_brand, is_house_cd,  is_year , is_season, is_sojae, is_item, is_style_no, is_chno
string  is_color, is_size, is_class, is_opt_chi,is_style, is_consignment
end variables

on w_43003_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.gb_1
end on

on w_43003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.gb_1)
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

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
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

is_house_cd = dw_head.GetItemString(1, "house")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
	is_year = '%'
end if


if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_consignment = dw_head.GetItemString(1, "consignment")
if IsNull(is_consignment) or Trim(is_consignment) = "" then
   MessageBox(ls_title,"위탁구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("consignment")
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

is_opt_chi = dw_head.GetItemString(1, "opt_chi")
if IsNull(is_opt_chi) or Trim(is_opt_chi) = "" then
   MessageBox(ls_title,"중국구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_chi")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_option

if rb_1.checked = true then 
	ls_option = "S" //품번별
elseif rb_2.checked = true then 
	ls_option = 'C' //품번색상별
elseif rb_4.checked = true then 
	ls_option = 'A' //품번차수무시	
elseif rb_5.checked = true then 
	ls_option = 'D' //품번칼라차수무시	
elseif rb_6.checked = true then 
	ls_option = 'E' //  품번색상사이즈(차수무시)	
else	
	ls_option = 'x'
end if	

//D 품번색상(차수무시)
//E 품번색상사이즈(차수무시)

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_44004_d01 '20011215' , 'n', '010000', '2001' ,'w', '%', 'o','417','%', '%', '%'

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_house_cd, is_year, is_season, is_sojae, &
          is_item, is_style_no, is_chno, is_color,is_size, ls_option, is_opt_chi,is_consignment)
			 
dw_print.retrieve(is_yymmdd, is_brand, is_house_cd, is_year, is_season, is_sojae, &
          is_item, is_style_no, is_chno, is_color,is_size, ls_option, is_opt_chi,is_consignment)
			 
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
string ls_modify, ls_datetime, ls_opt_chi

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_opt_chi = "A" then
	ls_opt_chi = "★ 중국포함재고"
elseif is_opt_chi = "B" then
	ls_opt_chi = "★ 중국제외재고"
else
	ls_opt_chi = "★ 중국재고"
end if

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yymmdd.Text = '" + is_yymmdd + "'" + &
					"t_house_cd.Text = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'" + &
					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
					"t_opt_chi.Text = '" + ls_opt_chi + "'" 					


dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43003_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43003_d
end type

type cb_delete from w_com010_d`cb_delete within w_43003_d
end type

type cb_insert from w_com010_d`cb_insert within w_43003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43003_d
end type

type cb_update from w_com010_d`cb_update within w_43003_d
end type

type cb_print from w_com010_d`cb_print within w_43003_d
end type

type cb_preview from w_com010_d`cb_preview within w_43003_d
end type

type gb_button from w_com010_d`gb_button within w_43003_d
end type

type cb_excel from w_com010_d`cb_excel within w_43003_d
end type

type dw_head from w_com010_d`dw_head within w_43003_d
integer y = 156
integer width = 2715
integer height = 392
string dataobject = "d_43003_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('%')
idw_house_cd.insertrow(1)
idw_house_cd.Setitem(1, "shop_cd", "%")
idw_house_cd.Setitem(1, "shop_snm", "전체")

idw_house_cd.insertrow(1)
idw_house_cd.Setitem(1, "shop_cd", "000000")
idw_house_cd.Setitem(1, "shop_snm", "물류+온라인창고")

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_nm", "전체")

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)


	



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

event dw_head::itemchanged;call super::itemchanged;


CHOOSE CASE dwo.name

	CASE "brand", "year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE
		
end event

type ln_1 from w_com010_d`ln_1 within w_43003_d
integer beginx = 5
integer beginy = 548
integer endx = 3625
integer endy = 548
end type

type ln_2 from w_com010_d`ln_2 within w_43003_d
integer beginy = 552
integer endy = 552
end type

type dw_body from w_com010_d`dw_body within w_43003_d
integer x = 14
integer y = 560
integer height = 1472
string dataobject = "d_43003_d02"
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

type dw_print from w_com010_d`dw_print within w_43003_d
integer x = 1650
integer y = 1052
integer width = 1280
integer height = 556
string dataobject = "d_43003_r01"
end type

type rb_1 from radiobutton within w_43003_d
integer x = 2802
integer y = 172
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

type rb_2 from radiobutton within w_43003_d
integer x = 2802
integer y = 288
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

type rb_3 from radiobutton within w_43003_d
integer x = 2802
integer y = 416
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

type rb_4 from radiobutton within w_43003_d
integer x = 2802
integer y = 228
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

type rb_5 from radiobutton within w_43003_d
integer x = 2802
integer y = 352
integer width = 658
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
string text = "품번/색상(차수무시)별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_6 from radiobutton within w_43003_d
integer x = 2802
integer y = 476
integer width = 768
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
string text = "품번/색상/사이즈(차수X)별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type gb_1 from groupbox within w_43003_d
integer x = 2752
integer y = 132
integer width = 882
integer height = 412
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

