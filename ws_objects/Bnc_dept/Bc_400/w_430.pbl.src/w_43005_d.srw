$PBExportHeader$w_43005_d.srw
$PBExportComments$매장재고내역조회
forward
global type w_43005_d from w_com010_d
end type
type rb_1 from radiobutton within w_43005_d
end type
type rb_2 from radiobutton within w_43005_d
end type
type rb_3 from radiobutton within w_43005_d
end type
type dw_list from u_dw within w_43005_d
end type
type rb_4 from radiobutton within w_43005_d
end type
type gb_1 from groupbox within w_43005_d
end type
end forward

global type w_43005_d from w_com010_d
integer width = 3680
integer height = 2288
string title = "매장별재고내역"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
dw_list dw_list
rb_4 rb_4
gb_1 gb_1
end type
global w_43005_d w_43005_d

type variables
DataWindowChild idw_brand,  idw_year,idw_season, idw_item, idw_shop_type, idw_shop_div , idw_sojae, idw_st_brand
string is_brand, is_yymmdd,  is_shop_type, is_shop_div, is_year, is_season,  is_item, is_sojae, is_st_brand, is_consignment

end variables

on w_43005_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.dw_list=create dw_list
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.gb_1
end on

on w_43005_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.dw_list)
destroy(this.rb_4)
destroy(this.gb_1)
end on

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_list, "ScaleToRight")
dw_list.SetTransObject(SQLCA)
end event

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

is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"품번 브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
   return false
end if

if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J' or is_brand = 'M' or is_brand = 'E') then
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


is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"매장구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if


is_consignment =dw_head.GetItemString(1, "consignment")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
//string ls_option
//
//if rb_1.checked = true then 
//	ls_option = "S"
//else if 	rb_2.checked = true then 
//	ls_option = "C"
//else 
//	ls_option = 'X'
//end if	

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43005_d01 '20011215' , 'n', '1' , '1' ,'w', '%', 'k'
//il_rows = dw_list.retrieve('20011215' , 'n', '1' , '1' ,'w', '%', 'k')

dw_body.Reset()

il_rows = dw_list.retrieve(is_yymmdd, is_brand, is_shop_type, is_year, is_season, is_item, is_shop_div, is_sojae,is_st_brand, is_consignment)
IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_doc_nm, ls_nm

integer li_ret
boolean lb_exist
Pointer Old_pointer

IF GetFileSaveName("Select File", ls_doc_nm, ls_nm, "xls", "Excel Files (*.xls),*.xls") <> 1 THEN
	RETURN
END IF	
lb_exist = FileExists(ls_doc_nm)
IF lb_exist THEN 
   SetPointer(Old_pointer)
	li_ret = MessageBox("Save",  "OK to write over" + ls_doc_nm,  Question!, YesNo!)
	if li_ret = 2 then return
end if

Old_pointer = SetPointer(HourGlass!)
li_ret = dw_list.SaveAs(ls_doc_nm, Excel!, TRUE)
if li_ret <> 1 then
   SetPointer(Old_pointer)
	MessageBox("에러!", "Excel파일 쓰기 실패하였습니다.")
   return
end if
SetPointer(Old_pointer)
Run("C:\Program Files\Microsoft Office\Office\Excel.exe " + ls_doc_nm, Maximized!)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43005_d","0")
end event

event open;call super::open;dw_head.SetItem(1, "st_brand", '%')
end event

type cb_close from w_com010_d`cb_close within w_43005_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_43005_d
integer taborder = 70
end type

type cb_insert from w_com010_d`cb_insert within w_43005_d
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43005_d
end type

type cb_update from w_com010_d`cb_update within w_43005_d
integer taborder = 110
end type

type cb_print from w_com010_d`cb_print within w_43005_d
boolean visible = false
integer taborder = 80
end type

type cb_preview from w_com010_d`cb_preview within w_43005_d
integer x = 1673
integer width = 439
integer taborder = 90
string text = "EXCEL LIST(&L)"
end type

type gb_button from w_com010_d`gb_button within w_43005_d
end type

type cb_excel from w_com010_d`cb_excel within w_43005_d
integer taborder = 100
end type

type dw_head from w_com010_d`dw_head within w_43005_d
integer y = 156
integer width = 3264
integer height = 276
string dataobject = "d_43005_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')



This.GetChild("st_brand", idw_st_brand )
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


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


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')


This.GetChild("shop_div", idw_shop_div )
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', is_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

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

type ln_1 from w_com010_d`ln_1 within w_43005_d
integer beginx = 5
integer beginy = 448
integer endx = 3625
integer endy = 448
end type

type ln_2 from w_com010_d`ln_2 within w_43005_d
integer beginx = 18
integer beginy = 452
integer endx = 3639
integer endy = 452
end type

type dw_body from w_com010_d`dw_body within w_43005_d
integer x = 9
integer y = 1396
integer width = 3584
integer height = 644
integer taborder = 40
string dataobject = "d_43005_d02"
end type

type dw_print from w_com010_d`dw_print within w_43005_d
integer x = 2226
integer y = 1596
end type

type rb_1 from radiobutton within w_43005_d
integer x = 3342
integer y = 184
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

type rb_2 from radiobutton within w_43005_d
integer x = 3342
integer y = 312
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
string text = "색상별"
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_43005_d
integer x = 3342
integer y = 372
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
string text = "사이즈별"
borderstyle borderstyle = stylelowered!
end type

type dw_list from u_dw within w_43005_d
integer x = 9
integer y = 468
integer width = 3584
integer height = 928
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_43005_d01"
end type

event clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/
string ls_option, ls_shop_cd

if rb_1.checked = true then 
	ls_option = "S"
elseif 	rb_2.checked = true then 
	ls_option = "C"
elseif 	rb_4.checked = true then 
	ls_option = "A"	
else 
	ls_option = 'X'
end if	

ls_shop_cd = dw_list.GetItemString(row, "shop_cd")

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_43005_d02 '20011215' , 'n', 'ng0008' , '1' , '1' ,'w', '%', 'g', 's'

il_rows = dw_body.retrieve(is_yymmdd, is_brand, ls_shop_cd, is_shop_type, is_year, is_season, is_item, is_shop_div, ls_option, is_sojae, is_st_brand, is_consignment)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF


end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

type rb_4 from radiobutton within w_43005_d
integer x = 3342
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
string text = "품번별(차수무시)"
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_43005_d
integer x = 3319
integer y = 140
integer width = 599
integer height = 304
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

