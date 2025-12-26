$PBExportHeader$w_55001_d.srw
$PBExportComments$인기 STYLE 판매 순위 현황
forward
global type w_55001_d from w_com010_d
end type
type rb_style from radiobutton within w_55001_d
end type
type rb_color from radiobutton within w_55001_d
end type
type st_1 from statictext within w_55001_d
end type
type rb_style2 from radiobutton within w_55001_d
end type
type rb_color2 from radiobutton within w_55001_d
end type
type rb_mc from radiobutton within w_55001_d
end type
type rb_mc2 from radiobutton within w_55001_d
end type
type st_2 from statictext within w_55001_d
end type
type st_3 from statictext within w_55001_d
end type
type rb_item from radiobutton within w_55001_d
end type
type gb_1 from groupbox within w_55001_d
end type
end forward

global type w_55001_d from w_com010_d
integer width = 3675
integer height = 2276
rb_style rb_style
rb_color rb_color
st_1 st_1
rb_style2 rb_style2
rb_color2 rb_color2
rb_mc rb_mc
rb_mc2 rb_mc2
st_2 st_2
st_3 st_3
rb_item rb_item
gb_1 gb_1
end type
global w_55001_d w_55001_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_fg

String is_brand, is_year, is_season, is_sojae, is_item, is_fr_sale_ymd, is_to_sale_ymd, is_sort_fg
String is_modify, is_dep_fg

Decimal idc_ranking


end variables

forward prototypes
public function integer wf_body_set (ref string as_modify)
end prototypes

public function integer wf_body_set (ref string as_modify);Long i
String ls_modify, ls_date, ls_date_set

For i = 1 To 14
	SELECT CONVERT(VARCHAR(8), DATEADD(DD, (:i - 1) * -1, CAST(:is_to_sale_ymd AS DATETIME)), 112)
	  INTO :ls_date
	  FROM DUAL ;
	
	If SQLCA.SQLCODE <> 0 OR IsNull(ls_date) Then Return -1
	
	ls_date_set = "sale" + String(i) + "_t.Text = '" + MidA(ls_date, 7, 2) + "' "
	ls_modify = ls_modify + ls_date_set
Next

as_modify = ls_modify

Return 0

end function

on w_55001_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_color=create rb_color
this.st_1=create st_1
this.rb_style2=create rb_style2
this.rb_color2=create rb_color2
this.rb_mc=create rb_mc
this.rb_mc2=create rb_mc2
this.st_2=create st_2
this.st_3=create st_3
this.rb_item=create rb_item
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_color
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_style2
this.Control[iCurrent+5]=this.rb_color2
this.Control[iCurrent+6]=this.rb_mc
this.Control[iCurrent+7]=this.rb_mc2
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.rb_item
this.Control[iCurrent+11]=this.gb_1
end on

on w_55001_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_color)
destroy(this.st_1)
destroy(this.rb_style2)
destroy(this.rb_color2)
destroy(this.rb_mc)
destroy(this.rb_mc2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.rb_item)
destroy(this.gb_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.17                                                  */	
/* 수정일      : 2002.01.17                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_sale_ymd", ld_datetime)
dw_head.SetItem(1, "to_sale_ymd", ld_datetime)
dw_head.SetItem(1, "ranking", 10)
dw_head.SetItem(1, "sort_fg", '1')

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.17                                                  */	
/* 수정일      : 2002.01.17                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.SetReDraw(False)

dw_body.Reset()

if rb_item.checked = faLSE THEN
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, &
										is_fr_sale_ymd, is_to_sale_ymd, is_sort_fg, idc_ranking)
ELSE									
	il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, &
										is_fr_sale_ymd, is_to_sale_ymd, is_sort_fg, idc_ranking, IS_DEP_FG)
END IF									
									

IF il_rows > 0 THEN
	wf_body_set(is_modify)
	dw_body.Modify(is_modify)
	
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetReDraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.17                                                  */	
/* 수정일      : 2002.01.17                                                  */
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
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_fr_sale_ymd = String(dw_head.GetItemDatetime(1, "fr_sale_ymd"), 'yyyymmdd')
if IsNull(is_fr_sale_ymd) or Trim(is_fr_sale_ymd) = "" then
   MessageBox(ls_title,"판매 기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_sale_ymd")
   return false
end if

is_to_sale_ymd = String(dw_head.GetItemDatetime(1, "to_sale_ymd"), 'yyyymmdd')
if IsNull(is_to_sale_ymd) or Trim(is_to_sale_ymd) = "" then
   MessageBox(ls_title,"판매 기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_sale_ymd")
   return false
end if

if is_to_sale_ymd < is_fr_sale_ymd then
   MessageBox(ls_title,"마지막 일자가 시작일자 보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_sale_ymd")
   return false
end if

is_sort_fg = dw_head.GetItemString(1, "sort_fg")
if IsNull(is_sort_fg) or Trim(is_sort_fg) = "" then
   MessageBox(ls_title,"판매 순위 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sort_fg")
   return false
end if

idc_ranking = dw_head.GetItemDecimal(1, "ranking")
if IsNull(idc_ranking) or idc_ranking = 0 then
   MessageBox(ls_title,"판매 순위를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ranking")
   return false
end if

is_dep_fg = dw_head.GetItemstring(1, "dep_fg")
if IsNull(is_dep_fg) or Trim(is_dep_fg) = ""then
   MessageBox(ls_title,"부진구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
   return false
end if

return true

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         rb_style.Enabled = false
         rb_color.Enabled = false
         rb_mc.Enabled = false
         rb_style2.Enabled = false
         rb_color2.Enabled = false
         rb_mc2.Enabled = false
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
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      rb_style.Enabled = true
      rb_color.Enabled = true
      rb_mc.Enabled = true
      rb_style2.Enabled = true
      rb_color2.Enabled = true
      rb_mc2.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.19                                                  */	
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sort_fg

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_sort_fg = '1' Then
	ls_sort_fg = '기간판매 '
Else
	ls_sort_fg = '총판매 '
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_fr_sale_ymd.Text = '" + String(is_fr_sale_ymd, '@@@@/@@/@@') + "'" + &
            "t_to_sale_ymd.Text = '" + String(is_to_sale_ymd, '@@@@/@@/@@') + "'" + &
            "t_ranking.Text = '" + ls_sort_fg + String(idc_ranking) + "위 까지' " + &
				is_modify

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55001_d","0")
end event

type cb_close from w_com010_d`cb_close within w_55001_d
end type

type cb_delete from w_com010_d`cb_delete within w_55001_d
end type

type cb_insert from w_com010_d`cb_insert within w_55001_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55001_d
end type

type cb_update from w_com010_d`cb_update within w_55001_d
end type

type cb_print from w_com010_d`cb_print within w_55001_d
end type

type cb_preview from w_com010_d`cb_preview within w_55001_d
end type

type gb_button from w_com010_d`gb_button within w_55001_d
end type

type cb_excel from w_com010_d`cb_excel within w_55001_d
end type

type dw_head from w_com010_d`dw_head within w_55001_d
integer x = 1152
integer width = 2405
integer height = 316
string dataobject = "d_55001_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

THIS.GetChild("dep_fg", idw_dep_fg)
idw_dep_fg.SetTransObject(SQLCA)
idw_dep_fg.Retrieve('540')
idw_dep_fg.InsertRow(1)
idw_dep_fg.SetItem(1, "inter_cd", '%')
idw_dep_fg.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
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
				  						

END CHOOSE
end event

type ln_1 from w_com010_d`ln_1 within w_55001_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_55001_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_55001_d
integer y = 540
integer height = 1500
string dataobject = "d_55001_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;string ls_style		
ls_style = this.getitemstring(row, "style")

gf_style_color_pic(ls_style,"%", "%")

//
//String 	ls_search
//if row > 0 then 
//	choose case dwo.name
//		case 'style','style_no'
//			ls_search 	= this.getitemstring(row, "style")
//			if len(ls_search) >= 8 then gf_style_color_pic(ls_search, '%','%')
//	end choose	
//end if
end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_item

This.GetChild("item", ldw_item)
ldw_item.SetTransObject(SQLCA)
ldw_item.Retrieve('%')
ldw_item.InsertRow(1)
ldw_item.SetItem(1, "item", '%')
ldw_item.SetItem(1, "item_nm", '전체')

end event

type dw_print from w_com010_d`dw_print within w_55001_d
string dataobject = "d_55001_r01"
end type

type rb_style from radiobutton within w_55001_d
integer x = 23
integer y = 268
integer width = 384
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "STYLE NO"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor      = RGB(0, 0, 255)
rb_color.TextColor  = RGB(0, 0, 0)
rb_mc.TextColor     = RGB(0, 0, 0)
rb_style2.TextColor = RGB(0, 0, 0)
rb_color2.TextColor = RGB(0, 0, 0)
rb_mc2.TextColor    = RGB(0, 0, 0)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r01'
dw_print.SetTransObject(SQLCA)

end event

type rb_color from radiobutton within w_55001_d
integer x = 23
integer y = 328
integer width = 521
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "STYLE NO (COLOR)"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)
rb_mc.TextColor     = RGB(0, 0, 0)
rb_style2.TextColor = RGB(0, 0, 0)
rb_color2.TextColor = RGB(0, 0, 0)
rb_mc2.TextColor    = RGB(0, 0, 0)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r02'
dw_print.SetTransObject(SQLCA)

end event

type st_1 from statictext within w_55001_d
integer x = 55
integer y = 68
integer width = 1216
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "※ 판매량 = 정상 + 세일 + 기획   ※판매량순"
boolean focusrectangle = false
end type

type rb_style2 from radiobutton within w_55001_d
integer x = 585
integer y = 264
integer width = 384
integer height = 56
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

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
rb_color.TextColor  = RGB(0, 0, 0)
rb_mc.TextColor     = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)
rb_color2.TextColor = RGB(0, 0, 0)
rb_mc2.TextColor    = RGB(0, 0, 0)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d04'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r04'
dw_print.SetTransObject(SQLCA)

end event

type rb_color2 from radiobutton within w_55001_d
integer x = 585
integer y = 328
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "STYLE (COLOR)"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
rb_color.TextColor  = RGB(0, 0, 0)
rb_mc.TextColor     = RGB(0, 0, 0)
rb_style2.TextColor = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)
rb_mc2.TextColor    = RGB(0, 0, 0)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d05'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r05'
dw_print.SetTransObject(SQLCA)

end event

type rb_mc from radiobutton within w_55001_d
integer x = 23
integer y = 388
integer width = 549
integer height = 56
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "STYLE NO + COLOR"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
rb_color.TextColor  = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)
rb_style2.TextColor = RGB(0, 0, 0)
rb_color2.TextColor = RGB(0, 0, 0)
rb_mc2.TextColor    = RGB(0, 0, 0)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d03'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r03'
dw_print.SetTransObject(SQLCA)

end event

type rb_mc2 from radiobutton within w_55001_d
integer x = 585
integer y = 388
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
string text = "STYLE + COLOR"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
rb_color.TextColor  = RGB(0, 0, 0)
rb_mc.TextColor     = RGB(0, 0, 0)
rb_style2.TextColor = RGB(0, 0, 0)
rb_color2.TextColor = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)
rb_ITEM.TextColor   = RGB(0, 0, 0)

dw_head.object.t_dep_fg.visible = false
dw_head.object.dep_fg.visible = false

dw_body.DataObject = 'd_55001_d06'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r06'
dw_print.SetTransObject(SQLCA)

end event

type st_2 from statictext within w_55001_d
integer x = 55
integer y = 184
integer width = 343
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "< 차수포함 >"
boolean focusrectangle = false
end type

type st_3 from statictext within w_55001_d
integer x = 658
integer y = 184
integer width = 343
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "< 차수제외 >"
boolean focusrectangle = false
end type

type rb_item from radiobutton within w_55001_d
integer x = 585
integer y = 448
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
string text = "STYLE/ITEM별그룹"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor  = RGB(0, 0, 0)
rb_color.TextColor  = RGB(0, 0, 0)
rb_mc.TextColor     = RGB(0, 0, 0)
rb_style2.TextColor = RGB(0, 0, 0)
rb_color2.TextColor = RGB(0, 0, 0)
rb_mc2.TextColor    = RGB(0, 0, 0)
This.TextColor      = RGB(0, 0, 255)

dw_head.object.t_dep_fg.visible = true
dw_head.object.dep_fg.visible = true

dw_body.DataObject = 'd_55001_d07'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55001_r07'
dw_print.SetTransObject(SQLCA)

DataWindowChild ldw_item

dw_body.GetChild("item", ldw_item)
ldw_item.SetTransObject(SQLCA)
ldw_item.Retrieve('%')
ldw_item.InsertRow(1)
ldw_item.SetItem(1, "item", '%')
ldw_item.SetItem(1, "item_nm", '전체')

dw_print.GetChild("item", ldw_item)
ldw_item.SetTransObject(SQLCA)
ldw_item.Retrieve('%')
ldw_item.InsertRow(1)
ldw_item.SetItem(1, "item", '%')
ldw_item.SetItem(1, "item_nm", '전체')



end event

type gb_1 from groupbox within w_55001_d
integer y = 136
integer width = 1129
integer height = 380
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

