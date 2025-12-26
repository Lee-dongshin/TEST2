$PBExportHeader$w_55013_d.srw
$PBExportComments$매장별 판매 순위현황
forward
global type w_55013_d from w_com010_d
end type
type rb_1 from radiobutton within w_55013_d
end type
type rb_2 from radiobutton within w_55013_d
end type
type rb_3 from radiobutton within w_55013_d
end type
type rb_4 from radiobutton within w_55013_d
end type
type gb_1 from groupbox within w_55013_d
end type
end forward

global type w_55013_d from w_com010_d
integer width = 3685
integer height = 2276
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
gb_1 gb_1
end type
global w_55013_d w_55013_d

type variables
DataWindowChild idw_brand, idw_season, idw_shop_type

String is_yymmdd_st, is_yymmdd_ed, is_brand, is_shop_type, is_shop_div1, is_shop_div2
String is_year, is_season, is_sort_fg = '1'

end variables

on w_55013_d.create
int iCurrent
call super::create
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.gb_1
end on

on w_55013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymmdd_st, is_yymmdd_ed, is_brand, is_shop_type, is_shop_div1, is_shop_div2, &
									is_year, is_season)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
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
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE 
END IF

is_yymmdd_st = Trim(String(dw_head.GetItemDate(dw_head.Getrow(), "fr_ymd"),'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"시작 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE 
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(dw_head.Getrow(), "to_ymd"),'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"마지막 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE 
END IF

IF is_yymmdd_st > is_yymmdd_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE 
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN is_year = '%'

is_season = dw_head.GetItemString(1, "season")
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   RETURN FALSE 
END IF

is_shop_div1 = Trim(dw_head.GetItemString(1, "shop_div1"))
is_shop_div2 = Trim(dw_head.GetItemString(1, "shop_div2"))

IF is_shop_div1 = 'K' AND is_shop_div2 = 'G' THEN
   MessageBox(ls_title,"유통망을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div1")
   RETURN FALSE 
END IF

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
IF IsNull(is_shop_type) OR is_shop_type = "" THEN
   MessageBox(ls_title,"매장 형태를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE 
END IF

RETURN TRUE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm, ls_title, ls_shop_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_title = '매장 월별 판매 누계 현황'

If is_sort_fg = '1' Then
	ls_title = ls_title + " (판매실판액 순)"
ElseIf is_sort_fg = '2' Then
	ls_title = ls_title + " (판매수량 순)"
ElseIf is_sort_fg = '3' Then
	ls_title = ls_title + " (판매율 순)"
Else
	ls_title = ls_title + " (회전율 순)"
End If

If is_shop_div1 = 'G' Then
	ls_shop_div = '백화점 '
End If
If is_shop_div2 = 'K' Then
	ls_shop_div = ls_shop_div + '대리점'
End If

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_title.Text     = '" + ls_title  + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
            "t_yymmdd_st.Text = '" + String(is_yymmdd_st, '@@@@/@@/@@') + "'" + &
            "t_yymmdd_ed.Text = '" + String(is_yymmdd_ed, '@@@@/@@/@@') + "'" + &
            "t_year.Text      = '" + is_year      + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(),       "inter_display") + "'" + &
            "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
            "t_shop_div.Text  = '" + ls_shop_div + "'"

dw_print.Modify(ls_modify)

end event

event open;call super::open;is_sort_fg = '1'
dw_body.SetSort("sale_amt D")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55013_d
end type

type cb_delete from w_com010_d`cb_delete within w_55013_d
end type

type cb_insert from w_com010_d`cb_insert within w_55013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55013_d
end type

type cb_update from w_com010_d`cb_update within w_55013_d
end type

type cb_print from w_com010_d`cb_print within w_55013_d
end type

type cb_preview from w_com010_d`cb_preview within w_55013_d
end type

type gb_button from w_com010_d`gb_button within w_55013_d
end type

type cb_excel from w_com010_d`cb_excel within w_55013_d
end type

type dw_head from w_com010_d`dw_head within w_55013_d
integer x = 855
integer y = 176
integer width = 3081
string dataobject = "d_55013_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name


	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
	
//		This.GetChild("sojae", idw_sojae)
//		idw_sojae.SetTransObject(SQLCA)
//		idw_sojae.Retrieve('%', data)
//		idw_sojae.insertrow(1)
//		idw_sojae.Setitem(1, "sojae", "%")
//		idw_sojae.Setitem(1, "sojae_nm", "전체")
//		
//		This.GetChild("item", idw_item)
//		idw_item.SetTransObject(SQLCA)
//		idw_item.Retrieve(data)
//		idw_item.insertrow(1)
//		idw_item.Setitem(1, "item", "%")
//		idw_item.Setitem(1, "item_nm", "전체")		
		
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

type ln_1 from w_com010_d`ln_1 within w_55013_d
integer beginy = 428
integer endy = 428
end type

type ln_2 from w_com010_d`ln_2 within w_55013_d
integer beginy = 432
integer endy = 432
end type

type dw_body from w_com010_d`dw_body within w_55013_d
integer x = 9
integer y = 448
integer width = 3593
integer height = 1592
string dataobject = "d_55013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55013_d
integer x = 1019
integer y = 276
string dataobject = "d_55013_r01"
end type

type rb_1 from radiobutton within w_55013_d
integer x = 41
integer y = 228
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
string text = "판매실판액"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;THIS.TextColor = RGB(0,0,255)
rb_2.TextColor = RGB(0,0,0)
rb_3.TextColor = RGB(0,0,0)
rb_4.TextColor = RGB(0,0,0)

is_sort_fg = '1'

dw_body.SetSort("sale_silamt D")
dw_body.Sort()


end event

type rb_2 from radiobutton within w_55013_d
integer x = 41
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
string text = "판매수량"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0,0,0)
THIS.TextColor = RGB(0,0,255)
rb_3.TextColor = RGB(0,0,0)
rb_4.TextColor = RGB(0,0,0)

is_sort_fg = '2'

dw_body.SetSort("sale_qty D")
dw_body.Sort()

end event

type rb_3 from radiobutton within w_55013_d
integer x = 512
integer y = 228
integer width = 265
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
string text = "판매율"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0,0,0)
rb_2.TextColor = RGB(0,0,0)
THIS.TextColor = RGB(0,0,255)
rb_4.TextColor = RGB(0,0,0)

is_sort_fg = '3'

dw_body.SetSort("sale_rate D")
dw_body.Sort()

end event

type rb_4 from radiobutton within w_55013_d
integer x = 512
integer y = 308
integer width = 265
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
string text = "회전율"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_1.TextColor = RGB(0,0,0)
rb_2.TextColor = RGB(0,0,0)
rb_3.TextColor = RGB(0,0,0)
THIS.TextColor = RGB(0,0,255)

is_sort_fg = '4'

dw_body.SetSort("rot_rate D")
dw_body.Sort()

end event

type gb_1 from groupbox within w_55013_d
integer x = 9
integer y = 164
integer width = 818
integer height = 232
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "정렬"
borderstyle borderstyle = stylelowered!
end type

