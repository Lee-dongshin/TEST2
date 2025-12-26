$PBExportHeader$w_43007_d.srw
$PBExportComments$품번별창고재고내역
forward
global type w_43007_d from w_com010_e
end type
type rb_1 from radiobutton within w_43007_d
end type
type rb_2 from radiobutton within w_43007_d
end type
type rb_3 from radiobutton within w_43007_d
end type
type gb_1 from groupbox within w_43007_d
end type
end forward

global type w_43007_d from w_com010_e
string title = "품번별창고재고내역"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_43007_d w_43007_d

type variables
DataWindowChild idw_brand, idw_year,idw_season, idw_item, idw_house_cd, idw_sojae
string is_brand, is_house_cd, is_year, is_season, is_item, is_style_no, is_sojae

end variables

on w_43007_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.gb_1
end on

on w_43007_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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



is_house_cd = dw_head.GetItemString(1, "house_cd")
if IsNull(is_house_cd) or Trim(is_house_cd) = "" then
   MessageBox(ls_title,"창고코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house_cd")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
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


return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
string ls_option

if rb_1.checked = true then 
	ls_option = "S"
elseif 	rb_2.checked = true then 
	ls_option = "C"
else 
	ls_option = "X"
end if	

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43007_d01 'n', '010000', '1' ,'w', '805', '%','%','a'

il_rows = dw_body.retrieve(is_brand, is_house_cd, is_year,  is_season, is_style_no, is_sojae, is_item, ls_option)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_house_cd.Text = '" + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'" + &
					"t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
					"t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
					"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &					
					"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43007_d","0")
end event

type cb_close from w_com010_e`cb_close within w_43007_d
end type

type cb_delete from w_com010_e`cb_delete within w_43007_d
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_43007_d
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_43007_d
end type

type cb_update from w_com010_e`cb_update within w_43007_d
end type

type cb_print from w_com010_e`cb_print within w_43007_d
end type

type cb_preview from w_com010_e`cb_preview within w_43007_d
end type

type gb_button from w_com010_e`gb_button within w_43007_d
end type

type cb_excel from w_com010_e`cb_excel within w_43007_d
end type

type dw_head from w_com010_e`dw_head within w_43007_d
integer x = 151
integer y = 176
integer width = 2830
integer height = 284
string dataobject = "d_43007_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')


This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)


This.GetChild("house_cd", idw_house_cd )
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve('911')

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

	CASE "brand","year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
		
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
		//	idw_sojae.insertrow(1)
		//	idw_sojae.Setitem(1, "sojae", "%")
		//	idw_sojae.Setitem(1, "sojae_nm", "전체")
		//	
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
		//	idw_item.insertrow(1)
		//	idw_item.Setitem(1, "item", "%")
		//	idw_item.Setitem(1, "item_nm", "전체")
		
END CHOOSE
		
end event

type ln_1 from w_com010_e`ln_1 within w_43007_d
integer beginx = 14
integer beginy = 484
integer endx = 3634
integer endy = 484
end type

type ln_2 from w_com010_e`ln_2 within w_43007_d
integer beginx = 5
integer beginy = 488
integer endx = 3625
integer endy = 488
end type

type dw_body from w_com010_e`dw_body within w_43007_d
integer y = 508
integer height = 1532
string dataobject = "d_43007_d01"
end type

type dw_print from w_com010_e`dw_print within w_43007_d
integer x = 2450
integer y = 1412
string dataobject = "d_43007_r01"
end type

type rb_1 from radiobutton within w_43007_d
integer x = 3090
integer y = 224
integer width = 402
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

type rb_2 from radiobutton within w_43007_d
integer x = 3090
integer y = 292
integer width = 402
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
string text = "칼라"
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_43007_d
integer x = 3090
integer y = 360
integer width = 402
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
string text = "사이즈"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_43007_d
integer x = 3003
integer y = 144
integer width = 599
integer height = 336
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = styleraised!
end type

