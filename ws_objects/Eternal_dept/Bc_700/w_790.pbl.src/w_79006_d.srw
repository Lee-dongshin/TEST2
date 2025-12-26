$PBExportHeader$w_79006_d.srw
$PBExportComments$A/S 점유율 현황
forward
global type w_79006_d from w_com010_d
end type
type rb_style from radiobutton within w_79006_d
end type
type rb_cust from radiobutton within w_79006_d
end type
type rb_shop from radiobutton within w_79006_d
end type
type gb_1 from groupbox within w_79006_d
end type
end forward

global type w_79006_d from w_com010_d
rb_style rb_style
rb_cust rb_cust
rb_shop rb_shop
gb_1 gb_1
end type
global w_79006_d w_79006_d

type variables
DataWindowChild idw_brand, idw_dept_cd, idw_deal_fg, idw_year, idw_season

String is_brand, is_fr_ymd, is_to_ymd, is_dept_cd, is_year, is_season, is_sojae
String is_judg_fg, is_judg_fg2, is_deal_fg, is_sort_fg, is_rct_fr_ymd, is_rct_to_ymd

end variables

on w_79006_d.create
int iCurrent
call super::create
this.rb_style=create rb_style
this.rb_cust=create rb_cust
this.rb_shop=create rb_shop
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_style
this.Control[iCurrent+2]=this.rb_cust
this.Control[iCurrent+3]=this.rb_shop
this.Control[iCurrent+4]=this.gb_1
end on

on w_79006_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_style)
destroy(this.rb_cust)
destroy(this.rb_shop)
destroy(this.gb_1)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_dept_cd, &
									is_judg_fg, is_deal_fg, is_year, is_season, is_sojae, is_rct_fr_ymd, is_rct_to_ymd)

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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
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
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"접수 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"접수 일자를 입력하십시요!")
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

is_dept_cd = Trim(dw_head.GetItemString(1, "dept_cd"))
if IsNull(is_dept_cd) or is_dept_cd = "" then
   MessageBox(ls_title,"담당 부서를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dept_cd")
   return false
end if




is_judg_fg = Trim(dw_head.GetItemString(1, "judg_fg"))
if IsNull(is_judg_fg) or is_judg_fg = "" then
   MessageBox(ls_title,"판정 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if

is_deal_fg = Trim(dw_head.GetItemString(1, "deal_fg"))
if IsNull(is_deal_fg) or is_deal_fg = "" then
   MessageBox(ls_title,"처리 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("deal_fg")
   return false
end if

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
is_rct_fr_ymd = Trim(dw_head.GetItemString(1, "rct_fr_ymd"))
is_rct_to_ymd = Trim(dw_head.GetItemString(1, "rct_to_ymd"))

return true

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.29                                                  */	
/* 수정일      : 2002.03.29                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_judg_fg, ls_sort_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_judg_fg = '0' Then
	ls_judg_fg = ' 반송'
ELSEIf is_judg_fg = '1' Then
	ls_judg_fg = ' 수선'	
ELSEIf is_judg_fg = '2' Then
	ls_judg_fg = ' CLAIM'	
ELSEIf is_judg_fg = '3' Then
	ls_judg_fg = ' 심의중'	
ELSEIf is_judg_fg = '4' Then
	ls_judg_fg = ' 미처리'		
End If

If is_sort_fg = '1' Then
	ls_sort_nm = 'STYLE별 '
ElseIf is_sort_fg = '2' Then
	ls_sort_nm = '업체별 '
Else
	ls_sort_nm = '매장별 '
End If

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id +    "'" + &
            "t_user_id.Text  = '" + gs_user_id +   "'" + &
            "t_datetime.Text = '" + ls_datetime +  "'" + &
            "t_title.Text    = '" + ls_sort_nm + "수선 점유율 현황'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text   = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
            "t_rct_ymd.Text   = '" + String(is_rct_fr_ymd + is_rct_fr_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
            "t_dept_cd.Text  = '" + idw_dept_cd.GetItemString(idw_dept_cd.GetRow(), "dept_display") + "'" + &
            "t_judg_fg.Text  = '" + ls_judg_fg + "'" + &
            "t_deal_fg.Text  = '" + idw_deal_fg.GetItemString(idw_deal_fg.GetRow(), "inter_display") + "'"
				
dw_print.Modify(ls_modify)


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
         rb_cust.Enabled = false
         rb_shop.Enabled = false
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
		rb_cust.Enabled = true
		rb_shop.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79006_d","0")
end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_79006_d
end type

type cb_delete from w_com010_d`cb_delete within w_79006_d
end type

type cb_insert from w_com010_d`cb_insert within w_79006_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79006_d
end type

type cb_update from w_com010_d`cb_update within w_79006_d
end type

type cb_print from w_com010_d`cb_print within w_79006_d
end type

type cb_preview from w_com010_d`cb_preview within w_79006_d
end type

type gb_button from w_com010_d`gb_button within w_79006_d
end type

type cb_excel from w_com010_d`cb_excel within w_79006_d
end type

type dw_head from w_com010_d`dw_head within w_79006_d
integer x = 421
integer width = 3104
integer height = 216
string dataobject = "d_79006_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("deal_fg", idw_deal_fg)
idw_deal_fg.SetTransObject(SQLCA)
idw_deal_fg.Retrieve('798')
idw_deal_fg.InsertRow(1)
idw_deal_fg.SetItem(1, "inter_cd", '%'   )
idw_deal_fg.SetItem(1, "inter_nm", '전체')

This.GetChild("dept_cd", idw_dept_cd)
idw_dept_cd.SetTransObject(SQLCA)
idw_dept_cd.Retrieve()
idw_dept_cd.InsertRow(1)
idw_dept_cd.SetItem(1, "dept_cd", '%'   )
idw_dept_cd.SetItem(1, "dept_nm", '전체')


This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		
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

type ln_1 from w_com010_d`ln_1 within w_79006_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_79006_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_79006_d
integer y = 444
integer height = 1596
string dataobject = "d_79006_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_79006_d
string dataobject = "d_79006_r01"
end type

type rb_style from radiobutton within w_79006_d
integer x = 50
integer y = 184
integer width = 315
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
string text = "STYLE별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor    = RGB(0, 0, 255)
rb_cust.TextColor = 0
rb_shop.TextColor = 0

dw_body.DataObject  = 'd_79006_d01'
dw_print.DataObject = 'd_79006_r01'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_sort_fg = '1'

end event

type rb_cust from radiobutton within w_79006_d
integer x = 50
integer y = 264
integer width = 315
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
string text = "업체별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = 0
This.TextColor     = RGB(0, 0, 255)
rb_shop.TextColor  = 0

dw_body.DataObject  = 'd_79006_d02'
dw_print.DataObject = 'd_79006_r02'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_sort_fg = '2'

end event

type rb_shop from radiobutton within w_79006_d
integer x = 50
integer y = 344
integer width = 315
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
string text = "매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_style.TextColor = 0
rb_cust.TextColor  = 0
This.TextColor     = RGB(0, 0, 255)

dw_body.DataObject  = 'd_79006_d03'
dw_print.DataObject = 'd_79006_r03'
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

is_sort_fg = '3'

end event

type gb_1 from groupbox within w_79006_d
integer y = 136
integer width = 393
integer height = 284
integer taborder = 110
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

