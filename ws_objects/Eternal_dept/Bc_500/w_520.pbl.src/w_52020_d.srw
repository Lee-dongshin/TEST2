$PBExportHeader$w_52020_d.srw
$PBExportComments$출고요청대비출고현황
forward
global type w_52020_d from w_com010_d
end type
type rb_1 from radiobutton within w_52020_d
end type
type rb_2 from radiobutton within w_52020_d
end type
type dw_1 from datawindow within w_52020_d
end type
type rb_3 from radiobutton within w_52020_d
end type
type rb_4 from radiobutton within w_52020_d
end type
type gb_1 from groupbox within w_52020_d
end type
end forward

global type w_52020_d from w_com010_d
integer width = 3680
integer height = 2292
rb_1 rb_1
rb_2 rb_2
dw_1 dw_1
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
end type
global w_52020_d w_52020_d

type variables
DataWindowChild idw_brand,    idw_season,  idw_sojae,  idw_item
DataWindowChild idw_shop_div, idw_deal_fg 
String is_brand,  is_year,   is_season,   is_sojae,   is_item 
String is_fr_ymd, is_to_ymd, is_shop_div, is_deal_fg, is_shop_cd
end variables

on w_52020_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.dw_1=create dw_1
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.rb_3
this.Control[iCurrent+5]=this.rb_4
this.Control[iCurrent+6]=this.gb_1
end on

on w_52020_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.dw_1)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.Setitem(1, "sojae",    "%") 
dw_head.Setitem(1, "deal_fg",  "%") 
dw_head.Setitem(1, "item",     "%") 
dw_head.Setitem(1, "shop_div", "%") 
dw_head.Setitem(1, "fr_ymd", Date(ld_datetime)) 
dw_head.Setitem(1, "to_ymd", Date(ld_datetime)) 

end event

event pfc_preopen;call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
dw_1.Sharedata(dw_body)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
 is_year = "%%%%"
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae    = dw_head.GetItemString(1, "sojae")
is_deal_fg  = dw_head.GetItemString(1, "deal_fg")
is_item     = dw_head.GetItemString(1, "item")
is_shop_div = dw_head.GetItemString(1, "shop_div")

is_shop_cd  = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   is_shop_cd  = "%" 
end if 

is_fr_ymd = String(dw_head.GetitemDate(1, "fr_ymd"), "yyyymmdd")
is_to_ymd = String(dw_head.GetitemDate(1, "to_ymd"), "yyyymmdd")

return true

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_shop_div, ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm) 
					dw_head.Setitem(al_row, "shop_div", MidA(as_data, 2, 1))
					RETURN 0
				END IF 
			END IF
			ls_shop_div = dw_head.GetitemString(1, "shop_div") 
			ls_brand    = dw_head.GetitemString(1, "brand") 
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand     = '" + ls_brand + "'" + & 
			                         "  AND shop_div  like '" +  ls_shop_div + "'" + &
											 "  AND shop_stat = '00' " 
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				dw_head.SetItem(al_row, "shop_div", lds_Source.GetItemString(1,"shop_div"))
				/* 다음컬럼으로 이동 */
				cb_Retrieve.SetFocus()
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

if rb_3.Checked = True or rb_4.Checked = True  THEN 
	il_rows = dw_body.retrieve(is_brand,  is_year,   is_season,   is_sojae,   is_item, &
                        is_fr_ymd, is_to_ymd, is_shop_div, is_shop_cd, is_deal_fg)
else
	dw_body.SetRedraw( False)
	il_rows = dw_1.retrieve(is_brand,  is_year,   is_season,   is_sojae,   is_item, &
									is_fr_ymd, is_to_ymd, is_shop_div, is_shop_cd, is_deal_fg)
	
	IF il_rows > 0 THEN 
		IF rb_1.Checked = True THEN 
			dw_body.SetSort("shop_cd A, style A, chno A, color A, size A")
			dw_body.Sort()
			dw_body.GroupCalc()
		ELSE 
			dw_body.SetSort("style A, chno A, color A, size A, shop_cd A")
			dw_body.Sort()
			dw_body.GroupCalc()
		END IF
	
		dw_body.SetFocus()
		
	ELSEIF il_rows = 0 THEN
		MessageBox("조회", "조회할 자료가 없습니다.")
	ELSE
		MessageBox("조회오류", "조회 실패 하였습니다.")
	END IF
	dw_body.SetRedraw(True)	
end if

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	" t_pg_id.Text = '" + is_pgm_id + "'" + &
            " t_user_id.Text = '" + gs_user_id + "'" + &
            " t_datetime.Text = '" + ls_datetime + "'" + & 
				" t_ymd.Text = '" + String(is_fr_ymd + is_to_ymd, "@@@@/@@/@@ ~~ @@@@/@@/@@") + "'" + &
				" t_brand.Text = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + & 
				" t_season.Text = '" + is_year + "년도 " + idw_season.GetitemString(idw_season.GetRow(), "inter_display") + "'" + & 
				" t_shop_div.Text = '유통망 :" + idw_shop_div.GetitemString(idw_shop_div.GetRow(), "inter_display") + "'" + & 
				" t_sojae.Text = '소재 :" + idw_sojae.GetitemString(idw_sojae.GetRow(), "sojae_display") + "'" + & 
				" t_item.Text = '품종 :" + idw_item.GetitemString(idw_item.GetRow(), "item_display") + "'" + & 
				" t_deal_fg.Text = '배분구분 :" + idw_deal_fg.GetitemString(idw_deal_fg.GetRow(), "inter_display") + "'" 

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_52020_d","0")
end event

type cb_close from w_com010_d`cb_close within w_52020_d
integer taborder = 120
end type

type cb_delete from w_com010_d`cb_delete within w_52020_d
integer taborder = 70
end type

type cb_insert from w_com010_d`cb_insert within w_52020_d
integer taborder = 60
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_52020_d
integer taborder = 30
end type

type cb_update from w_com010_d`cb_update within w_52020_d
integer taborder = 110
end type

type cb_print from w_com010_d`cb_print within w_52020_d
integer taborder = 80
end type

type cb_preview from w_com010_d`cb_preview within w_52020_d
integer taborder = 90
end type

type gb_button from w_com010_d`gb_button within w_52020_d
end type

type cb_excel from w_com010_d`cb_excel within w_52020_d
integer taborder = 100
end type

type dw_head from w_com010_d`dw_head within w_52020_d
integer x = 407
integer width = 3090
integer height = 272
integer taborder = 20
string dataobject = "d_52020_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA) 
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA) 
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA) 
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.insertRow(1)
idw_sojae.Setitem(1, "sojae", "%")
idw_sojae.Setitem(1, "sojae_nm", "전체")

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA) 
idw_item.Retrieve('%',gs_brand)
idw_item.insertRow(1)
idw_item.Setitem(1, "item", "%")
idw_item.Setitem(1, "item_nm", "전체")

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA) 
idw_shop_div.Retrieve('910')
idw_shop_div.insertRow(1)
idw_shop_div.Setitem(1, "inter_cd", "%")
idw_shop_div.Setitem(1, "inter_nm", "전체")

This.GetChild("deal_fg", idw_deal_fg)
idw_deal_fg.SetTransObject(SQLCA) 
idw_deal_fg.Retrieve('521')
idw_deal_fg.insertRow(1)
idw_deal_fg.Setitem(1, "inter_cd", "%")
idw_deal_fg.Setitem(1, "inter_nm", "전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if


end event

event dw_head::itemchanged;call super::itemchanged;DataWindowChild ldw_child
string ls_year, ls_brand

IF ib_itemchanged THEN RETURN 1

CHOOSE CASE dwo.name


	CASE "brand"	     //  Popup 검색창이 존재하는 항목 
//		IF ib_itemchanged THEN RETURN 1
		
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
	
	ls_brand = this.getitemstring(row, "brand")

	this.getchild("season",ldw_child)
	ldw_child.settransobject(sqlca)
	ldw_child.retrieve('003', ls_brand, data)
	ldw_child.insertrow(1)
	ldw_child.Setitem(1, "inter_cd", "%")
	ldw_child.Setitem(1, "inter_nm", "전체")
		
	
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_52020_d
integer beginy = 448
integer endy = 448
end type

type ln_2 from w_com010_d`ln_2 within w_52020_d
integer beginy = 452
integer endy = 452
end type

type dw_body from w_com010_d`dw_body within w_52020_d
integer x = 0
integer width = 3598
integer height = 1584
integer taborder = 50
string dataobject = "d_52020_d04"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_52020_d
string dataobject = "d_52020_r01"
end type

type rb_1 from radiobutton within w_52020_d
event ue_keydown pbm_keydown
integer x = 37
integer y = 184
integer width = 320
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
string text = "매장별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	return 1 
END IF 


end event

event clicked;This.TextColor = Rgb(0,0,255)
rb_2.TextColor = Rgb(0,0,0)
rb_3.TextColor = Rgb(0,0,0)
rb_4.TextColor = Rgb(0,0,0)


dw_Print.DataObject = "d_52020_r01" 
dw_Print.SetTransObject(SQLCA)

dw_body.SetRedraw(False)
dw_body.DataObject  = "d_52020_d01" 
dw_body.SetTransObject(SQLCA)
dw_1.Sharedata(dw_body)
IF dw_head.Enabled = False THEN 
	dw_body.SetSort("shop_cd A, style A, chno A, color A, size A")
	dw_body.Sort()
	dw_body.GroupCalc()
END IF 
dw_body.SetRedraw(True)

end event

type rb_2 from radiobutton within w_52020_d
event ue_keydown pbm_keydown
integer x = 37
integer y = 248
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
string text = "제품별"
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;IF key = KeyEnter! THEN
	Send(Handle(This), 256, 9, long(0,0))
	return 1 
END IF 


end event

event clicked;This.TextColor = Rgb(0,0,255)
rb_1.TextColor = Rgb(0,0,0)
rb_3.TextColor = Rgb(0,0,0)
rb_4.TextColor = Rgb(0,0,0)
dw_Print.DataObject = "d_52020_r02" 
dw_Print.SetTransObject(SQLCA)

dw_body.SetRedraw(False)
dw_body.DataObject  = "d_52020_d02" 
dw_body.SetTransObject(SQLCA)
dw_1.Sharedata(dw_body)
IF dw_head.Enabled = False THEN 
	dw_body.SetSort("style A, chno A, color A, size A, shop_cd A")
	dw_body.Sort()
	dw_body.GroupCalc()
END IF 
dw_body.SetRedraw(True)

end event

type dw_1 from datawindow within w_52020_d
boolean visible = false
integer x = 1349
integer y = 368
integer width = 411
integer height = 432
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_52020_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_52020_d
integer x = 37
integer y = 312
integer width = 357
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
string text = "배분차수별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = Rgb(0,0,255)
rb_1.TextColor = Rgb(0,0,0)
rb_2.TextColor = Rgb(0,0,0)
rb_4.TextColor = Rgb(0,0,0)

dw_Print.DataObject = "d_52020_r03" 
dw_Print.SetTransObject(SQLCA)

dw_body.SetRedraw(False)
dw_body.DataObject  = "d_52020_d03" 
dw_body.SetTransObject(SQLCA)

dw_body.SetRedraw(True)

end event

type rb_4 from radiobutton within w_52020_d
integer x = 37
integer y = 372
integer width = 357
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
string text = "일자매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = Rgb(0,0,255)
rb_1.TextColor = Rgb(0,0,0)
rb_2.TextColor = Rgb(0,0,0)
rb_3.TextColor = Rgb(0,0,0)

dw_Print.DataObject = "d_52020_r04" 
dw_Print.SetTransObject(SQLCA)

dw_body.SetRedraw(False)
dw_body.DataObject  = "d_52020_d04" 
dw_body.SetTransObject(SQLCA)

dw_body.SetRedraw(True)

end event

type gb_1 from groupbox within w_52020_d
integer x = 14
integer y = 144
integer width = 398
integer height = 292
integer taborder = 10
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

