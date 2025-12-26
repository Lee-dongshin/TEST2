$PBExportHeader$w_61051_d.srw
$PBExportComments$입출고 대비 판매율 현황
forward
global type w_61051_d from w_com010_d
end type
type rb_size from radiobutton within w_61051_d
end type
type rb_style from radiobutton within w_61051_d
end type
type rb_item from radiobutton within w_61051_d
end type
type rb_color from radiobutton within w_61051_d
end type
type st_1 from statictext within w_61051_d
end type
type st_2 from statictext within w_61051_d
end type
type st_3 from statictext within w_61051_d
end type
type st_4 from statictext within w_61051_d
end type
type gb_1 from groupbox within w_61051_d
end type
end forward

global type w_61051_d from w_com010_d
rb_size rb_size
rb_style rb_style
rb_item rb_item
rb_color rb_color
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
gb_1 gb_1
end type
global w_61051_d w_61051_d

type variables
String is_yymmdd, is_brand, is_year, is_season, is_sojae, is_item, is_dep_fg, is_gubun, is_chno_gubun
string is_style_no, is_print_gubun, is_ps_chn, is_ps_except, is_plan_dc, is_ps_reord,is_plan_except
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_fg, idw_color, idw_size

end variables

on w_61051_d.create
int iCurrent
call super::create
this.rb_size=create rb_size
this.rb_style=create rb_style
this.rb_item=create rb_item
this.rb_color=create rb_color
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_size
this.Control[iCurrent+2]=this.rb_style
this.Control[iCurrent+3]=this.rb_item
this.Control[iCurrent+4]=this.rb_color
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.gb_1
end on

on w_61051_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_size)
destroy(this.rb_style)
destroy(this.rb_item)
destroy(this.rb_color)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.gb_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

if is_print_gubun = "Y"  then 
	if rb_item.checked = true then
		dw_body.DataObject = "d_55007_d11" 
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 490
   elseif rb_style.checked = true then		 
		dw_body.DataObject = "d_55007_d12" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 800
   elseif rb_color.checked = true then		 
		dw_body.DataObject = "d_55007_d13" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 1240
   elseif rb_size.checked = true	 then	 
		dw_body.DataObject = "d_55007_d14" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 1560
	end if	
else	
	if rb_item.checked = true then
		dw_body.DataObject = "d_55007_d01" 
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 490
   elseif rb_style.checked = true then		 
		dw_body.DataObject = "d_55007_d02" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 800
   elseif rb_color.checked = true then		 
		dw_body.DataObject = "d_55007_d03" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 1240
   elseif rb_size.checked = true	 then	 
		dw_body.DataObject = "d_55007_d04" 		
		dw_body.Object.DataWindow.HorizontalScrollSplit  = 1560
	end if	

end if	

	dw_body.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_sojae, is_year, is_season, &
									is_item, is_dep_fg, is_gubun, is_chno_gubun, is_style_no, is_ps_chn, is_ps_except, is_plan_dc, is_ps_reord, is_plan_except)


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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
IF IsNull(is_yymmdd) OR is_yymmdd = "" THEN
	MessageBox(ls_title,"기준일을 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("yymmdd")
	RETURN FALSE
END IF

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
	MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("brand")
	RETURN FALSE
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
	RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
	RETURN FALSE
END IF

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
IF IsNull(is_sojae) OR is_sojae = "" THEN
   MessageBox(ls_title,"소재를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
	RETURN FALSE
END IF

is_item = Trim(dw_head.GetItemString(1, "item"))
IF IsNull(is_item) OR is_item = "" THEN
   MessageBox(ls_title,"품종을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
	RETURN FALSE
END IF

is_dep_fg = Trim(dw_head.GetItemString(1, "dep_fg"))
IF IsNull(is_dep_fg) OR is_dep_fg = "" then
   MessageBox(ls_title,"부진구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dep_fg")
	RETURN FALSE
END IF

is_gubun = Trim(dw_head.GetItemString(1, "gubun"))
IF IsNull(is_gubun) OR is_gubun = "" then
   MessageBox(ls_title,"조회 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("gubun")
	RETURN FALSE
END IF

is_chno_gubun = Trim(dw_head.GetItemString(1, "chno_gubun"))
IF IsNull(is_chno_gubun) OR is_chno_gubun = "" then
   MessageBox(ls_title,"차수 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_gubun")
	RETURN FALSE
END IF

 
is_print_gubun = Trim(dw_head.GetItemString(1, "print_type"))
IF IsNull(is_print_gubun) OR is_print_gubun = "" then
   MessageBox(ls_title,"출력 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("print_type")
	RETURN FALSE
END IF

is_ps_except = Trim(dw_head.GetItemString(1, "ps_except"))
IF IsNull(is_ps_except) OR is_ps_except = "" then
   MessageBox(ls_title,"품종제외 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ps_except")
	RETURN FALSE
END IF


is_style_no = Trim(dw_head.GetItemString(1, "style_no"))
IF IsNull(is_style_no) OR is_style_no = "" then
   is_style_no = "%"	
END IF
is_ps_chn = Trim(dw_head.GetItemString(1, "ps_chn"))

is_plan_dc = Trim(dw_head.GetItemString(1, "ps_plan_dc"))
IF IsNull(is_plan_dc) OR is_plan_dc = "" then
   MessageBox(ls_title,"품목할인 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ps_plan_dc")
	RETURN FALSE
END IF


is_ps_reord = Trim(dw_head.GetItemString(1, "ps_reord"))
is_plan_except = Trim(dw_head.GetItemString(1, "plan_except"))

RETURN TRUE

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_chno_gubun, ls_gubun

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_chno_gubun = '1' Then
	ls_chno_gubun = 'STYLE NO'
Else
	ls_chno_gubun = 'STYLE'
End If

If is_gubun = '1' Then
	ls_gubun = '수량'
ElseIf is_gubun = '2' Then
	ls_gubun = '소비자가액'
ElseIf is_gubun = '3' Then
	ls_gubun = '원가액'
ElseIf is_gubun = '4' Then
	ls_gubun = '실판가'
End If

ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
            "t_user_id.Text    = '" + gs_user_id   + "'" + &
            "t_datetime.Text   = '" + ls_datetime  + "'" + &
            "t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
				"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
            "t_year.Text       = '" + is_year      + "'" + &
            "t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text      = '" + idw_sojae.GetItemString(idw_sojae.GetRow(),   "sojae_display") + "'" + &
            "t_item.Text       = '" + idw_item.GetItemString(idw_item.GetRow(),     "item_display")  + "'" + &
            "t_dep_fg.Text     = '" + idw_dep_fg.GetItemString(idw_dep_fg.GetRow(), "inter_display") + "'" + &
            "t_chno_gubun.Text = '" + ls_chno_gubun + "'" + &
            "t_gubun.Text      = '" + ls_gubun      + "'"

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
         dw_head.Enabled  = false
         rb_item.Enabled  = false
         rb_style.Enabled = false
         rb_color.Enabled = false
         rb_size.Enabled  = false
         dw_body.Enabled  = true
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
      dw_body.Enabled  = false
      dw_head.Enabled  = true
		rb_item.Enabled  = true
		rb_style.Enabled = true
		rb_color.Enabled = true
		rb_size.Enabled  = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
	
END CHOOSE

end event

event ue_print();if is_print_gubun = "Y"  then 
	if rb_item.checked = true then
		dw_print.DataObject = "d_55007_r11" 
   elseif rb_style.checked = true then		 
		dw_print.DataObject = "d_55007_r12" 		
   elseif rb_color.checked = true then		 
		dw_print.DataObject = "d_55007_r13" 		
   elseif rb_size.checked = true	 then	 
		dw_print.DataObject = "d_55007_r14" 		
	end if	
else	
	if rb_item.checked = true then
		dw_print.DataObject = "d_55007_r01" 
   elseif rb_style.checked = true then		 
		dw_print.DataObject = "d_55007_r02" 		
   elseif rb_color.checked = true then		 
		dw_print.DataObject = "d_55007_r03" 		
   elseif rb_size.checked = true	 then	 
		dw_print.DataObject = "d_55007_r04" 		
	end if	

end if	

	dw_print.SetTransObject(SQLCA)
	
	
	This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_preview;if is_print_gubun = "Y"  then 
	if rb_item.checked = true then
		dw_print.DataObject = "d_55007_r11" 
   elseif rb_style.checked = true then		 
		dw_print.DataObject = "d_55007_r12" 		
   elseif rb_color.checked = true then		 
		dw_print.DataObject = "d_55007_r13" 		
   elseif rb_size.checked = true	 then	 
		dw_print.DataObject = "d_55007_r14" 		
	end if	
else	
	if rb_item.checked = true then
		dw_print.DataObject = "d_55007_r01" 
   elseif rb_style.checked = true then		 
		dw_print.DataObject = "d_55007_r02" 		
   elseif rb_color.checked = true then		 
		dw_print.DataObject = "d_55007_r03" 		
   elseif rb_size.checked = true	 then	 
		dw_print.DataObject = "d_55007_r04" 		
	end if	

end if	

	dw_print.SetTransObject(SQLCA)
	
	This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55007_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event open;call super::open;if gs_user_id = 'PURITA' then 
	dw_head.Modify("brand.Protect=1")	
	dw_head.setitem(1, 'ps_chn','K')
	dw_head.Modify("ps_chn.Protect=1")
end if 
end event

type cb_close from w_com010_d`cb_close within w_61051_d
end type

type cb_delete from w_com010_d`cb_delete within w_61051_d
end type

type cb_insert from w_com010_d`cb_insert within w_61051_d
integer x = 677
integer y = 48
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61051_d
end type

type cb_update from w_com010_d`cb_update within w_61051_d
end type

type cb_print from w_com010_d`cb_print within w_61051_d
end type

type cb_preview from w_com010_d`cb_preview within w_61051_d
end type

type gb_button from w_com010_d`gb_button within w_61051_d
end type

type cb_excel from w_com010_d`cb_excel within w_61051_d
end type

type dw_head from w_com010_d`dw_head within w_61051_d
integer x = 521
integer y = 152
integer width = 3067
integer height = 384
string dataobject = "d_55007_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

THIS.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

THIS.GetChild("dep_fg", idw_dep_fg)
idw_dep_fg.SetTransObject(SQLCA)
idw_dep_fg.Retrieve('541')
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

type ln_1 from w_com010_d`ln_1 within w_61051_d
integer beginy = 536
integer endy = 536
end type

type ln_2 from w_com010_d`ln_2 within w_61051_d
integer beginy = 540
integer endy = 540
end type

type dw_body from w_com010_d`dw_body within w_61051_d
integer x = 9
integer y = 556
integer width = 3598
integer height = 1488
string dataobject = "d_55007_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;//string ls_style
//choose case dwo.name
//	case "style"
//		ls_style = this.getitemstring(row, "style")
//		gf_style_pic(ls_style,"%")
//end choose
end event

type dw_print from w_com010_d`dw_print within w_61051_d
integer x = 1573
integer y = 860
string dataobject = "d_55007_r01"
end type

type rb_size from radiobutton within w_61051_d
integer x = 59
integer y = 436
integer width = 411
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
string text = "COLOR/SIZE별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_item.TextColor = RGB(0,0,0)
rb_style.TextColor = RGB(0,0,0)
rb_color.TextColor = RGB(0,0,0)
This.TextColor = RGB(0,0,255)

dw_body.DataObject = "d_55007_d04"
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = "d_55007_r04"
dw_print.SetTransObject(SQLCA)

end event

type rb_style from radiobutton within w_61051_d
integer x = 59
integer y = 284
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
string text = "STYLE별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_item.TextColor = RGB(0,0,0)
This.TextColor = RGB(0,0,255)
rb_color.TextColor = RGB(0,0,0)
rb_size.TextColor = RGB(0,0,0)

dw_body.DataObject = "d_55007_d02"
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = "d_55007_r02"
dw_print.SetTransObject(SQLCA)

end event

type rb_item from radiobutton within w_61051_d
integer x = 59
integer y = 208
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
string text = "품종별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;THIS.TextColor = RGB(0,0,255)
rb_style.TextColor = RGB(0,0,0)
rb_color.TextColor = RGB(0,0,0)
rb_size.TextColor = RGB(0,0,0)

dw_body.DataObject = "d_55007_d01"
dw_body.SetTransObject(SQLCA)


dw_print.DataObject = "d_55007_r01"
dw_print.SetTransObject(SQLCA)

end event

type rb_color from radiobutton within w_61051_d
integer x = 59
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
long backcolor = 67108864
string text = "COLOR별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_item.TextColor = RGB(0,0,0)
rb_style.TextColor = RGB(0,0,0)
This.TextColor = RGB(0,0,255)
rb_size.TextColor = RGB(0,0,0)

dw_body.DataObject = "d_55007_d03"
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = "d_55007_r03"
dw_print.SetTransObject(SQLCA)

end event

type st_1 from statictext within w_61051_d
integer x = 78
integer y = 40
integer width = 1275
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
string text = "정상판매 = 정상+기획,  기타판매 = 행사+기타"
boolean focusrectangle = false
end type

type st_2 from statictext within w_61051_d
integer x = 1042
integer y = 456
integer width = 741
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "※구분: B-부진, D-품목할인"
boolean focusrectangle = false
end type

type st_3 from statictext within w_61051_d
integer x = 78
integer y = 96
integer width = 809
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "출고기간 = 기준일- 최초출고일"
boolean focusrectangle = false
end type

type st_4 from statictext within w_61051_d
integer x = 1371
integer y = 40
integer width = 635
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
string text = "※샘플판매,유니폼 제외"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_61051_d
integer x = 14
integer y = 148
integer width = 507
integer height = 372
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

