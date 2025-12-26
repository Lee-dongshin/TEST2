$PBExportHeader$w_55036_d.srw
$PBExportComments$아이템별 입출판(기간조회용)
forward
global type w_55036_d from w_com010_d
end type
type st_1 from statictext within w_55036_d
end type
type st_2 from statictext within w_55036_d
end type
type st_3 from statictext within w_55036_d
end type
type st_4 from statictext within w_55036_d
end type
type mle_1 from multilineedit within w_55036_d
end type
end forward

global type w_55036_d from w_com010_d
integer width = 3694
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
mle_1 mle_1
end type
global w_55036_d w_55036_d

type variables
String is_fr_ymd, is_yymmdd, is_brand, is_year, is_season, is_sojae, is_item, is_dep_fg, is_gubun, is_chno_gubun, is_sale_except
string is_style_no, is_print_gubun, is_ps_chn, is_ps_except, is_plan_dc, is_ps_reord,is_plan_except, is_saip_yn, is_cost_season
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_dep_fg, idw_color, idw_size, idw_cost_season

end variables

on w_55036_d.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.mle_1
end on

on w_55036_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.mle_1)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_fr_ymd, is_yymmdd, is_brand, is_sojae, is_year, is_season, &
									is_item, is_dep_fg, is_gubun, is_chno_gubun, is_style_no, is_ps_chn, is_ps_except, is_plan_dc, is_ps_reord, is_plan_except, is_cost_season,is_sale_except)

			
			
mle_1.text = ' is_fr_ymd = ' + is_fr_ymd + &
				' is_yymmdd = ' + is_yymmdd + &
				' is_brand = ' + is_brand + &
				' is_sojae = ' + is_sojae + &
				' is_year = ' + is_year + &
				' is_season = ' + is_season + &
				' is_item = ' + is_item + &
				' is_dep_fg = ' + is_dep_fg + &
				' is_gubun = ' + is_gubun + &
				' is_chno_gubun = ' + is_chno_gubun + &
				' is_style_no = ' + is_style_no + &
				' is_ps_chn = ' + is_ps_chn + &
				' is_ps_except = ' + is_ps_except + &
				' is_plan_dc = ' + is_plan_dc + &
				' is_ps_reord = ' + is_ps_reord + &
				' is_plan_except = ' + is_plan_except


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

is_fr_ymd = Trim(String(dw_head.GetItemDatetime(1, "fr_ymd"), 'yyyymmdd'))
IF IsNull(is_fr_ymd) OR is_fr_ymd = "" THEN
	MessageBox(ls_title,"기준일자를 입력하십시요!")
	dw_head.SetFocus()
	dw_head.SetColumn("fr_ymd")
	RETURN FALSE
END IF

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
IF IsNull(is_yymmdd) OR is_yymmdd = "" THEN
	MessageBox(ls_title,"기준일자를 입력하십시요!")
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


//if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
//   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false	
//elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false		
//elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
//   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("brand")
//   return false			
//end if	




if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D' or is_brand = 'Y') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
//elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'M' or is_brand = 'E' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
elseif (gs_brand = 'O' or  gs_brand = 'D' or  gs_brand = 'Y' or  gs_brand = 'U')  and (is_brand = 'N' or is_brand = 'E' or is_brand = 'M' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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


is_cost_season = Trim(dw_head.GetItemString(1, "cost_season"))
IF IsNull(is_cost_season) OR is_cost_season = "" THEN
   MessageBox(ls_title,"원가시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cost_season")
	RETURN FALSE
END IF


//messagebox("",is_season)

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

is_saip_yn  = Trim(dw_head.GetItemString(1, "ps_saip_yn"))

if is_ps_chn <> "K" and is_saip_yn = "Y" then
	is_saip_yn = "N"
end if	


is_plan_dc = Trim(dw_head.GetItemString(1, "ps_plan_dc"))
IF IsNull(is_plan_dc) OR is_plan_dc = "" then
   MessageBox(ls_title,"품목할인 구분을 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("ps_plan_dc")
	RETURN FALSE
END IF


is_ps_reord = Trim(dw_head.GetItemString(1, "ps_reord"))
is_plan_except = Trim(dw_head.GetItemString(1, "plan_except"))

is_sale_except = Trim(dw_head.GetItemString(1, "sale_except"))

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
//
//If is_chno_gubun = '1' Then
//	ls_chno_gubun = 'STYLE NO'
//Else
//	ls_chno_gubun = 'STYLE'
//End If
//
//If is_gubun = '1' Then
//	ls_gubun = '수량'
//ElseIf is_gubun = '2' Then
//	ls_gubun = '소비자가액'
//ElseIf is_gubun = '3' Then
//	ls_gubun = '원가액'
//ElseIf is_gubun = '4' Then
//	ls_gubun = '실판가'
//End If
//
//ls_modify =	"t_pg_id.Text      = '" + is_pgm_id    + "'" + &
//            "t_user_id.Text    = '" + gs_user_id   + "'" + &
//            "t_datetime.Text   = '" + ls_datetime  + "'" + &
//            "t_yymmdd.Text     = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
//				"t_brand.Text      = '" + idw_brand.GetItemString(idw_brand.GetRow(),   "inter_display") + "'" + &
//            "t_year.Text       = '" + is_year      + "'" + &
//            "t_season.Text     = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
//            "t_sojae.Text      = '" + idw_sojae.GetItemString(idw_sojae.GetRow(),   "sojae_display") + "'" + &
//            "t_item.Text       = '" + idw_item.GetItemString(idw_item.GetRow(),     "item_display")  + "'" + &
//            "t_dep_fg.Text     = '" + idw_dep_fg.GetItemString(idw_dep_fg.GetRow(), "inter_display") + "'" + &
//            "t_chno_gubun.Text = '" + ls_chno_gubun + "'" + &
//            "t_gubun.Text      = '" + ls_gubun      + "'"
//
dw_print.Modify(ls_modify)

end event

event ue_print();
	dw_print.SetTransObject(SQLCA)
	
	
	This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()



end event

event ue_preview();
	
	This.Trigger Event ue_title ()
	
dw_print.Object.DataWindow.Print.Orientation = 1  // 0:세로, 1:가로
dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55036_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

event open;call super::open;dw_head.setitem(1,'gubun','0')
end event

type cb_close from w_com010_d`cb_close within w_55036_d
end type

type cb_delete from w_com010_d`cb_delete within w_55036_d
end type

type cb_insert from w_com010_d`cb_insert within w_55036_d
integer x = 677
integer y = 48
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55036_d
end type

type cb_update from w_com010_d`cb_update within w_55036_d
end type

type cb_print from w_com010_d`cb_print within w_55036_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_55036_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_55036_d
end type

type cb_excel from w_com010_d`cb_excel within w_55036_d
end type

type dw_head from w_com010_d`dw_head within w_55036_d
integer x = 18
integer y = 152
integer width = 4165
integer height = 384
string dataobject = "d_55036_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')


THIS.GetChild("cost_season", idw_cost_season)
idw_cost_season.SetTransObject(SQLCA)
idw_cost_season.Retrieve('003', gs_brand, '%')
idw_cost_season.InsertRow(1)
idw_cost_season.SetItem(1, "inter_cd", '%')
idw_cost_season.SetItem(1, "inter_nm", '전체')

THIS.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
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
		
		THIS.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '%')
		idw_sojae.SetItem(1, "sojae_nm", '전체')
		
		THIS.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve( data )
		idw_item.InsertRow(1)
		idw_item.SetItem(1, "item", '%')
		idw_item.SetItem(1, "item_nm", '전체')

		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child)
		ldw_child.settransobject(sqlca)
		ldw_child.retrieve('003', data, ls_year) // '%')
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "inter_cd", "%")
		ldw_child.Setitem(1, "inter_nm", "전체")
		
		
//		if data = "O" then
//			
//			dw_head.SetItem(1, "ps_chn", "A")
//			dw_head.object.ps_chn.visible = true 
//			dw_head.object.gb_2.visible = true 			
//		else 
//			
//			//dw_head.SetItem(1, "ps_chn", "A")
//			dw_head.object.ps_chn.visible = false
//			dw_head.object.gb_2.visible = false						
//			
//		end if 
		
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

type ln_1 from w_com010_d`ln_1 within w_55036_d
integer beginy = 536
integer endy = 536
end type

type ln_2 from w_com010_d`ln_2 within w_55036_d
integer beginy = 540
integer endy = 540
end type

type dw_body from w_com010_d`dw_body within w_55036_d
integer x = 9
integer y = 556
integer width = 3598
integer height = 1440
string dataobject = "d_55036_d01"
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

type dw_print from w_com010_d`dw_print within w_55036_d
integer x = 1573
integer y = 860
string dataobject = "d_55007_r01"
end type

type st_1 from statictext within w_55036_d
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

type st_2 from statictext within w_55036_d
integer x = 1047
integer y = 452
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

type st_3 from statictext within w_55036_d
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

type st_4 from statictext within w_55036_d
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

type mle_1 from multilineedit within w_55036_d
boolean visible = false
integer x = 1166
integer y = 1064
integer width = 2263
integer height = 672
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

