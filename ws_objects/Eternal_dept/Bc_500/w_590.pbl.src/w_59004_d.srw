$PBExportHeader$w_59004_d.srw
$PBExportComments$출고내역조회(해외)
forward
global type w_59004_d from w_com010_d
end type
type rb_1 from radiobutton within w_59004_d
end type
type rb_2 from radiobutton within w_59004_d
end type
type rb_3 from radiobutton within w_59004_d
end type
type rb_4 from radiobutton within w_59004_d
end type
type rb_5 from radiobutton within w_59004_d
end type
type rb_6 from radiobutton within w_59004_d
end type
type gb_1 from groupbox within w_59004_d
end type
end forward

global type w_59004_d from w_com010_d
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
gb_1 gb_1
end type
global w_59004_d w_59004_d

type variables
DataWindowChild idw_house_cd, idw_shop_type, idw_out_gubn,idw_brand, idw_season, idw_item
DataWindowChild idw_sale_type, idw_color, idw_size, idw_sojae
string  is_frm_date, is_to_date, is_brand, is_country_cd
string  is_shop_cd, is_shop_type, is_sale_type, is_style, is_chno, is_year, is_season
string  is_color, is_size	, is_item, is_sojae
end variables

on w_59004_d.create
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

on w_59004_d.destroy
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

event pfc_preopen();call super::pfc_preopen;dw_body.SetTransObject(SQLCA)
inv_resize.of_Register(dw_body, "ScaleToRight")

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

if rb_1.checked = true then 
	dw_body.dataobject = 'd_59004_d01'
elseif rb_2.checked = true then 
	dw_body.dataobject = 'd_59004_d02'
elseif rb_3.checked = true then 
	dw_body.dataobject = 'd_59004_d03'
elseif rb_4.checked = true then 
	dw_body.dataobject = 'd_59004_d04'
elseif rb_5.checked = true then 
	dw_body.dataobject = 'd_59004_d05'
elseif rb_6.checked = true then 
	dw_body.dataobject = 'd_59004_d06'	
end if	

dw_body.SetTransObject(SQLCA)
//dw_print.SetTransObject(SQLCA)



/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//exec sp_42010_d01 'n', '20020216', '20020216', '%', '1', '010000', 'o1','11', '+'

dw_body.Reset()

il_rows = dw_body.retrieve(is_brand, is_frm_date, is_to_date, is_country_cd, is_shop_cd, &
									is_style, is_chno, is_color, is_size, is_item, &
									is_year, is_season, is_sojae, is_shop_type, is_sale_type)
									

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


is_frm_date = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_date) or Trim(is_frm_date) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if

is_country_cd = dw_head.GetItemString(1, "country_cd")
if IsNull(is_country_cd) or Trim(is_country_cd) = "" then
   MessageBox(ls_title,"국가를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("country_cd")
   return false
elseif is_country_cd = '전체' then
	is_country_cd = '%'
end if



is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then is_shop_cd = "%"

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then is_style = "%"

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then is_chno = "%"

is_color = dw_head.GetItemString(1, "color")
if IsNull(is_color) or Trim(is_color) = "" then
   MessageBox(ls_title,"색상을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("color")
   return false
end if

is_size = dw_head.GetItemString(1, "size")
if IsNull(is_size) or Trim(is_size) = "" then
   MessageBox(ls_title,"사이즈를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("size")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then is_year = '%'

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then is_season = '%'

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_sale_type = dw_head.GetItemString(1, "sale_type")
if IsNull(is_sale_type) or Trim(is_sale_type) = "" then
   MessageBox(ls_title,"판매 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_brand
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
	CASE "style"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
				IF gf_style_chk(as_data, '%') = True THEN
				   dw_head.SetItem(al_row, "chno", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
				dw_head.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("chno")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source

CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
			ls_brand = dw_head.getitemstring(1, "brand")
			
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			IF  gl_user_level >= 50 then 
					gst_cd.default_where   = "WHERE   shop_cd like '" + ls_brand + "%'"	
				else 	
					gst_cd.default_where   = "WHERE Shop_Stat = '00' "
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF 
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("year")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
END CHOOSE

IF ai_div = 1 THEN 
	IF lb_check THEN
      RETURN 2 
	ELSE
		RETURN 1
	END IF
END IF

RETURN 0

end event

event open;call super::open;Datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_date",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "year","%")
dw_head.SetItem(1, "season","%")
dw_head.SetItem(1, "jup_gubn","%")
dw_head.SetItem(1, "out_gubn","%")
dw_head.SetItem(1, "shop_type","%")
dw_head.SetItem(1, "sale_type","%")
dw_head.setitem(1, "country_cd","전체")
end event

event ue_print();///*===========================================================================*/
///* 작성자      : (주)지우정보                                                */	
///* 작성일      : 2002.01.03                                                  */	
///* 수정일      : 2002.01.03                                                  */
///*===========================================================================*/
//Long   i 
//String ls_shop_type, ls_out_no, ls_shop_cd, ls_yymmdd, ls_print, ls_inout_gubn, ls_out_gubn
//
//if cbx_laser.checked then
//	dw_print.DataObject = "d_com420_A"
//	dw_print.SetTransObject(SQLCA)
//ELSE
//	dw_print.DataObject = "d_com420"
//	dw_print.SetTransObject(SQLCA)
//END IF	
//
//FOR i = 1 TO dw_1.RowCount() 
//	ls_print = dw_1.getitemstring(i, "print_out")
//	IF ls_print = "Y"  THEN 
//		ls_yymmdd     = dw_1.GetitemString(i, "yymmdd")			 
//		ls_out_no     = dw_1.GetitemString(i, "out_no")
//		ls_shop_cd    = dw_1.GetitemString(i, "shop_cd") 
//		ls_shop_type  = dw_1.GetitemString(i, "shop_type")
//		ls_inout_gubn = dw_1.GetitemString(i, "inout_gubn")
//		If ls_inout_gubn = "+" THEN 
//			ls_out_gubn = "1"
//		else
//			ls_out_gubn = "2"
//		end if	
//
//		il_rows = dw_print.Retrieve(is_brand, ls_yymmdd, ls_shop_cd, ls_shop_type, ls_out_no, ls_out_gubn)
//		IF dw_print.RowCount() > 0 Then
//			il_rows = dw_print.Print()
//		END IF
//	END IF 	
//NEXT 
//	
//This.Trigger Event ue_msg(6, il_rows)
//
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_42010_d","0")
end event

event ue_button(integer ai_cb_div, long al_rows);

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

type cb_close from w_com010_d`cb_close within w_59004_d
integer taborder = 110
end type

type cb_delete from w_com010_d`cb_delete within w_59004_d
integer taborder = 60
end type

type cb_insert from w_com010_d`cb_insert within w_59004_d
integer taborder = 50
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_59004_d
end type

type cb_update from w_com010_d`cb_update within w_59004_d
integer taborder = 100
end type

type cb_print from w_com010_d`cb_print within w_59004_d
boolean visible = false
integer x = 1947
integer width = 576
integer taborder = 70
string text = "거래명세서인쇄(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_59004_d
boolean visible = false
integer taborder = 80
end type

type gb_button from w_com010_d`gb_button within w_59004_d
end type

type cb_excel from w_com010_d`cb_excel within w_59004_d
integer x = 2523
integer taborder = 90
end type

type dw_head from w_com010_d`dw_head within w_59004_d
integer height = 280
string dataobject = "d_59004_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003',gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

This.GetChild("sale_type", idw_sale_type )
idw_sale_type.SetTransObject(SQLCA)
idw_sale_type.Retrieve('011')
idw_sale_type.InsertRow(1)
idw_sale_type.SetItem(1, "inter_cd", '%')
idw_sale_type.SetItem(1, "inter_nm", '전체')

This.GetChild("color", idw_color )
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')
idw_color.InsertRow(1)
idw_color.SetItem(1, "color", '%')
idw_color.SetItem(1, "color_enm", '전체')

This.GetChild("size", idw_size )
idw_size.SetTransObject(SQLCA)
idw_size.Retrieve('%')
idw_size.InsertRow(1)
idw_size.SetItem(1, "size", '%')
idw_size.SetItem(1, "size_nm", '전체')


This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
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

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd", "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


	CASE "brand"
		IF ib_itemchanged THEN RETURN 1

	
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
		This.GetChild("item", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "item", "%")
		ldw_child.Setitem(1, "item_nm", "전체")		
			
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

type ln_1 from w_com010_d`ln_1 within w_59004_d
integer beginx = -5
integer beginy = 576
integer endx = 3616
integer endy = 576
end type

type ln_2 from w_com010_d`ln_2 within w_59004_d
integer beginy = 580
integer endy = 580
end type

type dw_body from w_com010_d`dw_body within w_59004_d
integer y = 596
integer width = 3593
integer height = 1412
integer taborder = 40
string dataobject = "d_59004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_59004_d
integer x = 2418
integer y = 1632
string dataobject = "d_com420"
end type

type rb_1 from radiobutton within w_59004_d
integer x = 73
integer y = 484
integer width = 251
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

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_2 from radiobutton within w_59004_d
integer x = 379
integer y = 484
integer width = 283
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
string text = "일자별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_3 from radiobutton within w_59004_d
integer x = 718
integer y = 484
integer width = 279
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
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_4 from radiobutton within w_59004_d
integer x = 1051
integer y = 484
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
string text = "품번(차수무시)별"
borderstyle borderstyle = stylelowered!
end type

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_5 from radiobutton within w_59004_d
integer x = 1682
integer y = 484
integer width = 320
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

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type rb_6 from radiobutton within w_59004_d
integer x = 2057
integer y = 484
integer width = 320
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

event clicked;Parent.Trigger Event ue_retrieve()	//조회
end event

type gb_1 from groupbox within w_59004_d
integer x = 23
integer y = 428
integer width = 3570
integer height = 140
integer taborder = 40
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

