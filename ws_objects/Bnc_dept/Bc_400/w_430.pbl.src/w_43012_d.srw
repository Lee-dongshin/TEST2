$PBExportHeader$w_43012_d.srw
$PBExportComments$전체수불현황
forward
global type w_43012_d from w_com010_d
end type
type gb_1 from groupbox within w_43012_d
end type
type rb_1 from radiobutton within w_43012_d
end type
type rb_4 from radiobutton within w_43012_d
end type
type rb_2 from radiobutton within w_43012_d
end type
type rb_3 from radiobutton within w_43012_d
end type
type rb_5 from radiobutton within w_43012_d
end type
end forward

global type w_43012_d from w_com010_d
integer width = 3685
integer height = 2248
gb_1 gb_1
rb_1 rb_1
rb_4 rb_4
rb_2 rb_2
rb_3 rb_3
rb_5 rb_5
end type
global w_43012_d w_43012_d

type variables
DataWindowChild idw_brand, idw_frm_year, idw_frm_season, idw_to_year, idw_to_season,idw_item, idw_sojae, idw_color, idw_size
string is_brand,  is_frm_year, is_frm_season, is_yymmdd,is_to_year, is_to_season, is_sojae, is_item, is_style, is_chno, is_color, is_size

end variables

on w_43012_d.create
int iCurrent
call super::create
this.gb_1=create gb_1
this.rb_1=create rb_1
this.rb_4=create rb_4
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_5=create rb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.rb_4
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_5
end on

on w_43012_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.rb_1)
destroy(this.rb_4)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_5)
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



is_frm_year = dw_head.GetItemString(1, "frm_year")
if IsNull(is_frm_year) or Trim(is_frm_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_year")
   return false
end if

is_to_year = dw_head.GetItemString(1, "to_year")
if IsNull(is_to_year) or Trim(is_to_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_year")
   return false
end if


is_frm_season = dw_head.GetItemString(1, "frm_season")
if IsNull(is_frm_season) or Trim(is_frm_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_season")
   return false
end if

is_to_season = dw_head.GetItemString(1, "to_season")
if IsNull(is_to_season) or Trim(is_to_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_season")
   return false
end if

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
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

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
is_style = "%"
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
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

string ls_option

if rb_1.checked = true then 
	ls_option = "S"
elseif rb_2.checked = true then 
	ls_option = 'c'
elseif rb_4.checked = true then 
	ls_option = 'A'	
else	
	ls_option = 'x'
end if	

//exec sp_43012_d01 '20011215' , 'n', '1' ,'w','1', 'w', '%', '%'

if rb_5.checked = true then
	dw_body.dataobject = "d_43012_d01"
	dw_body.SetTransObject(SQLCA)
	dw_print.dataobject = "d_43012_r01"
	dw_print.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_frm_year,  is_frm_season, is_to_year,  is_to_season, is_sojae, is_item)
else
	dw_body.dataobject = "d_43012_d02"
	dw_body.SetTransObject(SQLCA)
	dw_print.dataobject = "d_43012_r01"
	dw_print.SetTransObject(SQLCA)
	il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_frm_year,  is_frm_season, is_to_year,  is_to_season, is_sojae, is_item, is_style, is_chno, is_color, is_size, ls_option)
	dw_print.retrieve(is_yymmdd, is_brand, is_frm_year,  is_frm_season, is_to_year,  is_to_season, is_sojae, is_item, is_style, is_chno, is_color, is_size, ls_option)
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime, ls_yearseason

ls_yearseason =  idw_frm_year.GetItemString(idw_frm_year.GetRow(), "inter_display") + '/' + &
					  idw_frm_season.GetItemString(idw_frm_season.GetRow(), "inter_display") + ' - ' + &
					  idw_to_year.GetItemString(idw_to_year.GetRow(), "inter_display") + '/' + &
					  idw_to_season.GetItemString(idw_to_season.GetRow(), "inter_display") 
					  
IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =		"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
					"t_yearseason.Text = '" + ls_yearseason + "'" + &					
					"t_yymmdd.Text = '" + is_yymmdd + "'" + &										
					"t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'"  + &
					"t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" 					

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43012_d","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno ,ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				// 스타일 선별작업
				IF  gl_user_level = 0 then 
					gst_cd.default_where   = "WHERE   style like '" + gs_brand + "%'"	
				else 	
					gst_cd.default_where   = " WHERE  tag_price <> 0 "
				end if
				
			if gs_brand <> "K" then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
				ELSE
					gst_cd.Item_where = ""
				END IF
			else 
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "style LIKE  '" + as_data + "%' and style like 'K%' "
				ELSE
					gst_cd.Item_where = "style like 'K%'"
				END IF
				
			end if					
				
			

				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
					ls_style =  lds_Source.GetItemString(1,"style")
					ls_chno  = lds_Source.GetItemString(1,"chno")
					
//					il_rows = dw_color.retrieve(ls_style, ls_chno)
		
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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

type cb_close from w_com010_d`cb_close within w_43012_d
end type

type cb_delete from w_com010_d`cb_delete within w_43012_d
end type

type cb_insert from w_com010_d`cb_insert within w_43012_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43012_d
end type

type cb_update from w_com010_d`cb_update within w_43012_d
end type

type cb_print from w_com010_d`cb_print within w_43012_d
end type

type cb_preview from w_com010_d`cb_preview within w_43012_d
end type

type gb_button from w_com010_d`gb_button within w_43012_d
end type

type cb_excel from w_com010_d`cb_excel within w_43012_d
end type

type dw_head from w_com010_d`dw_head within w_43012_d
integer y = 156
integer width = 2853
integer height = 352
string dataobject = "d_43012_h01"
boolean livescroll = false
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("frm_year", idw_frm_year )
idw_frm_year.SetTransObject(SQLCA)
idw_frm_year.Retrieve('002')

This.GetChild("to_year", idw_to_year )
idw_to_year.SetTransObject(SQLCA)
idw_to_year.Retrieve('002')

//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_frm_year = dw_head.getitemstring(1,'frm_year')
is_to_year = dw_head.getitemstring(1,'to_year')


This.GetChild("frm_season", idw_frm_season )
idw_frm_season.SetTransObject(SQLCA)
idw_frm_season.retrieve('003', is_brand, is_frm_year)
//idw_frm_season.Retrieve('003')

This.GetChild("to_season", idw_to_season )
idw_to_season.SetTransObject(SQLCA)
idw_to_season.retrieve('003', is_brand, is_to_year)
//idw_to_season.Retrieve('003')


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

	CASE "brand", "frm_year", "to_year"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1

			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_frm_year = dw_head.getitemstring(1,'frm_year')
			is_to_year = dw_head.getitemstring(1,'to_year')			
			
			This.GetChild("frm_season", idw_frm_season )
			idw_frm_season.SetTransObject(SQLCA)
			idw_frm_season.retrieve('003', is_brand, is_frm_year)
			//idw_frm_season.Retrieve('003')
			
			This.GetChild("to_season", idw_to_season )
			idw_to_season.SetTransObject(SQLCA)
			idw_to_season.retrieve('003', is_brand, is_to_year)
			//idw_to_season.Retrieve('003')

			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)

	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		if LenA(data) = 8 then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		end if

END CHOOSE
		
end event

type ln_1 from w_com010_d`ln_1 within w_43012_d
integer beginx = 14
integer beginy = 516
integer endx = 3634
integer endy = 516
end type

type ln_2 from w_com010_d`ln_2 within w_43012_d
integer beginy = 512
integer endy = 512
end type

type dw_body from w_com010_d`dw_body within w_43012_d
integer x = 9
integer y = 524
integer height = 1480
string dataobject = "d_43012_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_43012_d
integer x = 9
integer y = 12
string dataobject = "d_43012_r01"
end type

type gb_1 from groupbox within w_43012_d
integer x = 2889
integer y = 144
integer width = 713
integer height = 356
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

type rb_1 from radiobutton within w_43012_d
integer x = 2944
integer y = 248
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
borderstyle borderstyle = stylelowered!
end type

event clicked;//Parent.Trigger Event ue_retrieve()	//조회
dw_head.object.style_t.visible = true
dw_head.object.style.visible = true
dw_head.object.cb_style.visible = true
dw_head.object.chno.visible = true
dw_head.object.color_t.visible = true
dw_head.object.color.visible = true
dw_head.object.size.visible = true

end event

type rb_4 from radiobutton within w_43012_d
integer x = 2944
integer y = 304
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

event clicked;//Parent.Trigger Event ue_retrieve()	//조회
dw_head.object.style_t.visible = true
dw_head.object.style.visible = true
dw_head.object.cb_style.visible = true
dw_head.object.chno.visible = true
dw_head.object.color_t.visible = true
dw_head.object.color.visible = true
dw_head.object.size.visible = true
end event

type rb_2 from radiobutton within w_43012_d
integer x = 2944
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
long textcolor = 33554432
long backcolor = 67108864
string text = "품번/색상별"
borderstyle borderstyle = stylelowered!
end type

event clicked;//Parent.Trigger Event ue_retrieve()	//조회
dw_head.object.style_t.visible = true
dw_head.object.style.visible = true
dw_head.object.cb_style.visible = true
dw_head.object.chno.visible = true
dw_head.object.color_t.visible = true
dw_head.object.color.visible = true
dw_head.object.size.visible = true
end event

type rb_3 from radiobutton within w_43012_d
integer x = 2944
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

event clicked;//Parent.Trigger Event ue_retrieve()	//조회
dw_head.object.style_t.visible = true
dw_head.object.style.visible = true
dw_head.object.cb_style.visible = true
dw_head.object.chno.visible = true
dw_head.object.color_t.visible = true
dw_head.object.color.visible = true
dw_head.object.size.visible = true
end event

type rb_5 from radiobutton within w_43012_d
integer x = 2944
integer y = 188
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
string text = "품종/아이템별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;//Parent.Trigger Event ue_retrieve()	//조회
dw_head.object.style_t.visible = false
dw_head.object.style.visible = false
dw_head.object.cb_style.visible = false
dw_head.object.chno.visible = false
dw_head.object.color_t.visible = false
dw_head.object.color.visible = false
dw_head.object.size.visible = false


end event

