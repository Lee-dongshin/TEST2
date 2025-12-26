$PBExportHeader$w_53080_d.srw
$PBExportComments$판매현황 조회(라운지비)
forward
global type w_53080_d from w_com010_d
end type
type rb_date from radiobutton within w_53080_d
end type
type rb_shop from radiobutton within w_53080_d
end type
type rb_sojae from radiobutton within w_53080_d
end type
type rb_item from radiobutton within w_53080_d
end type
type rb_style from radiobutton within w_53080_d
end type
type rb_mcs from radiobutton within w_53080_d
end type
type rb_style_no from radiobutton within w_53080_d
end type
type rb_mncs from radiobutton within w_53080_d
end type
type rb_mc from radiobutton within w_53080_d
end type
type rb_yymm from radiobutton within w_53080_d
end type
type rb_brand from radiobutton within w_53080_d
end type
type dw_1 from u_dw within w_53080_d
end type
type dw_detail from datawindow within w_53080_d
end type
type gb_1 from groupbox within w_53080_d
end type
end forward

global type w_53080_d from w_com010_d
integer width = 3707
integer height = 2280
rb_date rb_date
rb_shop rb_shop
rb_sojae rb_sojae
rb_item rb_item
rb_style rb_style
rb_mcs rb_mcs
rb_style_no rb_style_no
rb_mncs rb_mncs
rb_mc rb_mc
rb_yymm rb_yymm
rb_brand rb_brand
dw_1 dw_1
dw_detail dw_detail
gb_1 gb_1
end type
global w_53080_d w_53080_d

type variables
DataWindowChild idw_brand, idw_shop_div, idw_area_cd, idw_shop_type
DataWindowChild idw_season, idw_sojae, idw_item, idw_color,idw_empno, idw_st_brand

String is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_style, is_item, is_season, is_year, is_shop_type, is_chno, is_shop_cd , is_st_brand

end variables

on w_53080_d.create
int iCurrent
call super::create
this.rb_date=create rb_date
this.rb_shop=create rb_shop
this.rb_sojae=create rb_sojae
this.rb_item=create rb_item
this.rb_style=create rb_style
this.rb_mcs=create rb_mcs
this.rb_style_no=create rb_style_no
this.rb_mncs=create rb_mncs
this.rb_mc=create rb_mc
this.rb_yymm=create rb_yymm
this.rb_brand=create rb_brand
this.dw_1=create dw_1
this.dw_detail=create dw_detail
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_date
this.Control[iCurrent+2]=this.rb_shop
this.Control[iCurrent+3]=this.rb_sojae
this.Control[iCurrent+4]=this.rb_item
this.Control[iCurrent+5]=this.rb_style
this.Control[iCurrent+6]=this.rb_mcs
this.Control[iCurrent+7]=this.rb_style_no
this.Control[iCurrent+8]=this.rb_mncs
this.Control[iCurrent+9]=this.rb_mc
this.Control[iCurrent+10]=this.rb_yymm
this.Control[iCurrent+11]=this.rb_brand
this.Control[iCurrent+12]=this.dw_1
this.Control[iCurrent+13]=this.dw_detail
this.Control[iCurrent+14]=this.gb_1
end on

on w_53080_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_date)
destroy(this.rb_shop)
destroy(this.rb_sojae)
destroy(this.rb_item)
destroy(this.rb_style)
destroy(this.rb_mcs)
destroy(this.rb_style_no)
destroy(this.rb_mncs)
destroy(this.rb_mc)
destroy(this.rb_yymm)
destroy(this.rb_brand)
destroy(this.dw_1)
destroy(this.dw_detail)
destroy(this.gb_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"매장 브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_st_brand = Trim(dw_head.GetItemString(1, "st_brand"))
if IsNull(is_st_brand) or is_st_brand = "" then
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
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'Y' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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




is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))


if is_shop_div = '' or isnull(is_shop_div) then
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if


is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
if IsNull(is_shop_type) or is_shop_type = "" then
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if


is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then is_year = '%'


is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if


is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if


is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or is_style = "" then
   is_style = "%"
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN



il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_year, is_season, is_item, is_shop_type, is_style, is_st_brand)
								

If il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;dw_head.Setitem(1,'brand', '%')
dw_head.Setitem(1,'season', '%')

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column

		CASE "style"				
			IF ai_div = 1 THEN 	
				IF gf_style_chk(as_data, '%') THEN
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번코드 검색" 
			gst_cd.datawindow_nm   = "d_com011" 
			// 스타일 선별작업
			IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE  style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  brand <> 'T' and tag_price <> 0 "
				end if

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
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_preview();This.Trigger Event ue_title ()




il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_year, is_season, is_item, is_shop_type, is_style)


dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_print();

This.Trigger Event ue_title()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.18                                                  */	
/* 수정일      : 2002.03.18                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_year, ls_season, ls_brand, ls_shop_div, ls_shop_type, ls_item

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")



If is_year = '%' Then
	ls_year = '전체'
Else
	ls_year = is_year
End If



If is_shop_div = '%' Then
	ls_shop_div = '전체'
Elseif is_shop_div = 'O' Then
	ls_shop_div = '온라인'
Elseif is_shop_div = 'F' Then
	ls_shop_div = '오프라인'
End If

If is_shop_type = '%' Then
	ls_shop_type = '전체'
Elseif is_shop_type = '1' Then
	ls_shop_type = '정상'
Elseif is_shop_type = '3' Then
	ls_shop_type = '기획'
Elseif is_shop_type = '4' Then
	ls_shop_type = '행사'
Elseif is_shop_type = '9' Then
	ls_shop_type = '기타'
End If

If is_season = '%' then
	ls_season = '% 전체'
else 
	ls_season = idw_season.GetItemString(idw_season.GetRow(), "inter_display")
end if


ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
				"t_user_id.Text = '" + gs_user_id + "'" + &
				"t_datetime.Text = '" + ls_datetime + "'" + &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_yymmdd.Text = '" + String(is_fr_ymd, '@@@@/@@/@@') + ' - ' + String(is_to_ymd, '@@@@/@@/@@') + "'" + &
				"t_shop_div.Text = '" + ls_shop_div + "'" + &
				"t_shop_type.Text = '" + ls_shop_type + "'" + &
				"t_year.Text = '" + ls_year + "'" + &
				"t_season.Text = '" + ls_season + "'" + &
				"t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'"
			
dw_print.Modify(ls_modify)

end event

event pfc_preopen();call super::pfc_preopen;/* DataWindow의 Transction 정의 */
dw_detail.SetTransObject(SQLCA)

inv_resize.of_Register(dw_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_head, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_1.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_53080_d
end type

type cb_delete from w_com010_d`cb_delete within w_53080_d
end type

type cb_insert from w_com010_d`cb_insert within w_53080_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53080_d
end type

type cb_update from w_com010_d`cb_update within w_53080_d
end type

type cb_print from w_com010_d`cb_print within w_53080_d
end type

type cb_preview from w_com010_d`cb_preview within w_53080_d
end type

type gb_button from w_com010_d`gb_button within w_53080_d
end type

type cb_excel from w_com010_d`cb_excel within w_53080_d
end type

type dw_head from w_com010_d`dw_head within w_53080_d
integer y = 304
integer width = 3525
integer height = 292
string dataobject = "d_53080_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("st_brand", idw_st_brand)
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')



// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

event dw_head::itemchanged;

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		if LenA(data) > 0 then
			IF ib_itemchanged THEN RETURN 1
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
      end if			

		
END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_53080_d
integer beginy = 596
integer endy = 596
end type

type ln_2 from w_com010_d`ln_2 within w_53080_d
long linecolor = 0
integer beginy = 596
integer endy = 596
end type

type dw_body from w_com010_d`dw_body within w_53080_d
integer x = 14
integer y = 608
integer height = 1432
string dataobject = "d_53080_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_shop_nm
is_shop_cd = this.getitemstring(row,"shop_cd")
ls_shop_nm = this.getitemstring(row,"shop_nm")

CHOOSE CASE dwo.name   // 매장코드에 km 사이트 link를 위해 shop_nm 에만 더블클릭 이벤트
	CASE "shop_nm"

		IF LenA(is_shop_cd) = 6  THEN		
			il_rows = dw_1.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_div, is_year, is_season, is_item, is_shop_type, is_style, is_shop_cd)
		
		
			if il_rows > 0 then 
				dw_1.title = ls_shop_nm
				dw_1.visible = true
				dw_1.SetFocus()
				
			end if
		
		END IF
END CHOOSE
   
end event

type dw_print from w_com010_d`dw_print within w_53080_d
integer x = 1070
integer y = 792
string dataobject = "d_53080_r01"
end type

type rb_date from radiobutton within w_53080_d
integer x = 23
integer y = 200
integer width = 283
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
string text = "일  자"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor        = RGB(0, 0, 255)
rb_yymm.TextColor     = 0
rb_shop.TextColor    = 0
rb_sojae.TextColor     = 0
rb_item.TextColor    = 0
rb_style.TextColor       = 0
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0



dw_body.DataObject  = 'd_53080_d01'
dw_print.DataObject = 'd_53080_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_shop from radiobutton within w_53080_d
integer x = 567
integer y = 200
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
long backcolor = 80269524
string text = "매  장"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_sojae.TextColor     = 0
rb_item.TextColor    = 0
rb_style.TextColor       = 0
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0

dw_body.DataObject  = 'd_53080_d03'
dw_print.DataObject = 'd_53080_r03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_sojae from radiobutton within w_53080_d
integer x = 855
integer y = 200
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
string text = "소  재"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_item.TextColor    = 0
rb_style.TextColor       = 0
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0



dw_body.DataObject  = 'd_53080_d04'
dw_print.DataObject = 'd_53080_r04'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_item from radiobutton within w_53080_d
integer x = 1143
integer y = 200
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
string text = "품  종"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_style.TextColor       = 0
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0


dw_body.DataObject  = 'd_53080_d05'
dw_print.DataObject = 'd_53080_r05'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_style from radiobutton within w_53080_d
integer x = 1431
integer y = 200
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
string text = "STYLE"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
rb_item.TextColor       = 0
This.TextColor        = RGB(0, 0, 255)
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0




dw_body.DataObject  = 'd_53080_d06'
dw_print.DataObject = 'd_53080_r06'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mcs from radiobutton within w_53080_d
integer x = 2066
integer y = 200
integer width = 407
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
string text = "STYLE+CL+SZ"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
rb_item.TextColor       = 0
rb_style.TextColor       = 0
rb_mc.TextColor 			= 0
This.TextColor        = RGB(0, 0, 255)
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0

dw_body.DataObject  = 'd_53080_d08'
dw_print.DataObject = 'd_53080_r08'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_style_no from radiobutton within w_53080_d
integer x = 2478
integer y = 200
integer width = 325
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
string text = "STYLE_NO"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
rb_item.TextColor       = 0
rb_style.TextColor       = 0
rb_mc.TextColor 			= 0
rb_mcs.TextColor 			= 0
This.TextColor        = RGB(0, 0, 255)
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0



dw_body.DataObject  = 'd_53080_d09'
dw_print.DataObject = 'd_53080_r09'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mncs from radiobutton within w_53080_d
integer x = 2807
integer y = 200
integer width = 466
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
string text = "STYLE_NO+CL+SZ"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
rb_item.TextColor       = 0
rb_style.TextColor       = 0
rb_mc.TextColor 			= 0
rb_mcs.TextColor 			= 0
rb_style_no.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_brand.TextColor     = 0



dw_body.DataObject  = 'd_53080_d10'
dw_print.DataObject = 'd_53080_r10'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_mc from radiobutton within w_53080_d
integer x = 1719
integer y = 200
integer width = 343
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
string text = "STYLE+CL"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     = 0
rb_item.TextColor       = 0
rb_style.TextColor       = 0
This.TextColor        = RGB(0, 0, 255)
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0


dw_body.DataObject  = 'd_53080_d07'
dw_print.DataObject = 'd_53080_r07'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)
end event

type rb_yymm from radiobutton within w_53080_d
integer x = 311
integer y = 200
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
long backcolor = 80269524
string text = "월 별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_date.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)
rb_shop.TextColor    = 0
rb_sojae.TextColor     = 0
rb_item.TextColor    = 0
rb_style.TextColor       = 0
rb_mc.TextColor      = 0
rb_mcs.TextColor = 0
rb_style_no.TextColor     = 0
rb_mncs.TextColor     = 0
rb_brand.TextColor     = 0

dw_body.DataObject  = 'd_53080_d02'
dw_print.DataObject = 'd_53080_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type rb_brand from radiobutton within w_53080_d
integer x = 3278
integer y = 200
integer width = 311
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

event clicked;rb_date.TextColor     = 0
rb_yymm.TextColor     = 0
rb_shop.TextColor     = 0
rb_sojae.TextColor     	= 0
rb_item.TextColor       = 0
rb_style.TextColor      = 0
rb_mc.TextColor 			= 0
rb_mcs.TextColor 			= 0
rb_style_no.TextColor   = 0
rb_mncs.TextColor     = 0
This.TextColor        = RGB(0, 0, 255)



dw_body.DataObject  = 'd_53080_d11'
dw_print.DataObject = 'd_53080_r11'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

end event

type dw_1 from u_dw within w_53080_d
boolean visible = false
integer x = 699
integer y = 676
integer width = 2912
integer height = 1364
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string dataobject = "d_53080_d06_02"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event clicked;call super::clicked;String ls_style


dw_detail.reset()
ls_style =  dw_1.GetitemString(row,"style")	
is_chno =  dw_1.GetitemString(row,"chno")	


IF ls_style = "" OR isnull(ls_style) THEN		
	return
END IF

IF is_chno = "" OR isnull(is_chno) THEN		
		is_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(ls_style, is_chno)
	
END IF 

dw_detail.visible = True
end event

event constructor;call super::constructor;This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)
end event

type dw_detail from datawindow within w_53080_d
boolean visible = false
integer x = 681
integer y = 388
integer width = 1925
integer height = 1832
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "스타일정보"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;dw_detail.visible = false
end event

type gb_1 from groupbox within w_53080_d
integer y = 140
integer width = 3602
integer height = 156
integer taborder = 120
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

