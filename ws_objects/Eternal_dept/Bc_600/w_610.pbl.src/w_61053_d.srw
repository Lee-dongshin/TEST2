$PBExportHeader$w_61053_d.srw
$PBExportComments$복종별 인기 STYLE 순위
forward
global type w_61053_d from w_com010_d
end type
type dw_temp from u_dw within w_61053_d
end type
end forward

global type w_61053_d from w_com010_d
dw_temp dw_temp
end type
global w_61053_d w_61053_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_shop_div

String is_brand, is_year, is_season, is_sojae, is_fr_yymmdd, is_to_yymmdd
String is_shop_cd, is_shop_type, is_sort_fg, is_style_opt
Decimal idc_ranking

end variables

forward prototypes
public subroutine wf_body_set ()
end prototypes

public subroutine wf_body_set ();String ls_item_chk = ' ', ls_item, ls_item_nm, ls_modify, ls_text
Long i, j = 0, k = 0, ll_temp_cnt, ll_row_chk

dw_body.SetReDraw(False)

dw_body.Reset()

For i = 1 to idc_ranking
	dw_body.InsertRow(0)
Next

ll_temp_cnt  = dw_temp.RowCount()

For i = 1 to ll_temp_cnt
	ls_item = dw_temp.GetItemString(i, "item")
	If ls_item_chk <> ls_item Then
		k++
		ls_item_nm = dw_temp.GetItemString(i, "item_nm")
		ls_modify = ls_modify + "item_" + String(k) + "_t.Text = '" + ls_item + " " + ls_item_nm + "' "
		j = 0
	ElseIf j = idc_ranking Then 
		i = dw_temp.Find("item > '" + ls_item + "'", i, ll_temp_cnt)
		IF i = 0 Then Exit
		k++
		ls_item    = dw_temp.GetItemString(i, "item")
		ls_item_nm = dw_temp.GetItemString(i, "item_nm")
		ls_modify = ls_modify + "item_" + String(k) + "_t.Text = '" + ls_item + " " + ls_item_nm + "' "
		j = 0
	End If
	j++
	dw_body.SetItem(j, "style_color_" + String(k), dw_temp.GetItemString(i, "style_color") )
	dw_body.SetItem(j, "qty_" + String(k), dw_temp.GetItemDecimal(i, "sale_qty") )
	ls_item_chk = ls_item
Next

dw_body.Modify(ls_modify)

For i = idc_ranking to 1 Step -1
	If dw_body.GetItemStatus(i, 0, Primary!) = New! Then 
		dw_body.DeleteRow(i)
	Else
		Exit
	End If
Next

ls_modify = ' '
For i = 26 to 1 Step -1
	ls_text = Trim(dw_body.Describe("item_" + String(i) + "_t.text"))
	If IsNull(ls_text) or ls_text = "" Then
		ls_modify = ls_modify + "item_" + String(i) + "_t.Visible = False " + &
										"mc_" + String(i) + "_t.Visible = False " + &
										"q_" + String(i) + "_t.Visible = False " + &
										"style_color_" + String(i) + ".Visible = False " + &
										"qty_" + String(i) + ".Visible = False "
//	Else
//		ls_modify = ls_modify + "item_" + String(i) + "_t.Visible = true " + &
//										"mc_" + String(i) + "_t.Visible = true " + &
//										"q_" + String(i) + "_t.Visible = true " + &
//										"style_color_" + String(i) + ".Visible = true " + &
//										"qty_" + String(i) + ".Visible = true "
	End IF
Next

dw_body.Modify(ls_modify)

dw_body.SetReDraw(True)

end subroutine

on w_61053_d.create
int iCurrent
call super::create
this.dw_temp=create dw_temp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_temp
end on

on w_61053_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_temp)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.24                                                  */	
/* 수정일      : 2002.01.24                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd", ld_datetime)
dw_head.SetItem(1, "to_yymmdd", ld_datetime)

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.24                                                  */	
/* 수정일      : 2002.01.24                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.DataObject = 'd_55004_d01'
dw_body.SetTransObject(SQLCA)

il_rows = dw_temp.retrieve(is_brand, is_year, is_season, is_sojae, is_fr_yymmdd, is_to_yymmdd, &
									is_shop_cd, is_shop_type, is_sort_fg, idc_ranking, is_style_opt)
									
IF il_rows > 0 THEN
	wf_body_set()
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
/* 작성일      : 2002.01.24                                                  */	
/* 수정일      : 2002.01.24                                                  */
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

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_sojae = Trim(dw_head.GetItemString(1, "sojae"))
if IsNull(is_sojae) or is_sojae = "" then
   MessageBox(ls_title,"소재유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_fr_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "fr_yymmdd"), 'yyyymmdd'))
if IsNull(is_fr_yymmdd) or is_fr_yymmdd = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymmdd")
   return false
end if

is_to_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "to_yymmdd"), 'yyyymmdd'))
if IsNull(is_to_yymmdd) or is_to_yymmdd = "" then
   MessageBox(ls_title,"기준일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

if is_to_yymmdd < is_fr_yymmdd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymmdd")
   return false
end if

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then is_shop_cd = '%'

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
if IsNull(is_shop_type) or is_shop_type = "" then 
   MessageBox(ls_title,"매장 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_sort_fg = Trim(dw_head.GetItemString(1, "sort_fg"))
if IsNull(is_sort_fg) or is_sort_fg = "" then
   MessageBox(ls_title,"판매 순위를 입력하십시요!")
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

is_style_opt = dw_head.GetItemString(1, "style_opt")
if IsNull(is_style_opt) or is_style_opt = "" then
   MessageBox(ls_title,"조회구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_opt")
   return false
end if

return true

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand    = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) <> ls_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' " + &
											 "  AND SHOP_STAT = '00' "
											 
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
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

event pfc_preopen;call super::pfc_preopen;dw_temp.SetTransObject(SQLCA)

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.06.07                                                  */	
/* 수정일      : 2002.06.07                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_text, ls_shop_cd, ls_shop_type, ls_ranking
Long i

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_cd = '% 전체'
Else
	ls_shop_cd = is_shop_cd + dw_head.GetItemString(1, "shop_nm")
End If

If is_shop_type = '1' Then
	ls_shop_type = '정상'
Else
	ls_shop_type = '정상 + 기획'
End If

If is_sort_fg = '1' Then
	ls_ranking = "기간판매 수량순 "
ElseIf is_sort_fg = '2' Then
	ls_ranking = "기간판매 판매율순 "
ElseIf is_sort_fg = '2' Then
	ls_ranking = "누계판매 수량순 "
Else
	ls_ranking = "누계판매 판매율순 "
End If
ls_ranking = ls_ranking + String(idc_ranking) + "위까지"

ls_modify =	"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text     = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_fr_yymmdd.Text = '" + String(is_fr_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_to_yymmdd.Text = '" + String(is_to_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_shop_cd.Text   = '" + ls_shop_cd + "'" + &
            "t_shop_type.Text = '" + ls_shop_type + "'" + &
            "t_ranking.Text   = '" + ls_ranking + "'"

for i = 1 To 26
	ls_modify = ls_modify + "item_" + String(i) + "_t.Text = '" + Trim(dw_body.Describe("item_" + String(i) + "_t.Text")) + "' "
Next

dw_print.Modify(ls_modify)

ls_modify = ''
For i = 26 to 1 Step -1
	ls_text = Trim(dw_body.Describe("item_" + String(i) + "_t.text"))
	If IsNull(ls_text) or ls_text = "" Then
		ls_modify = ls_modify + "item_" + String(i) + "_t.Visible = False " + &
										"mc_" + String(i) + "_t.Visible = False " + &
										"q_" + String(i) + "_t.Visible = False " + &
										"style_color_" + String(i) + ".Visible = False " + &
										"qty_" + String(i) + ".Visible = False " + &
										"item_" + String(i) + "_t.X = 0 " + &
										"mc_" + String(i) + "_t.X = 0 " + &
										"q_" + String(i) + "_t.X = 0 " + &
										"style_color_" + String(i) + ".X = 0 " + &
										"qty_" + String(i) + ".X = 0 "
										
//	Else
//		ls_modify = ls_modify + "item_" + String(i) + "_t.Visible = true " + &
//										"mc_" + String(i) + "_t.Visible = true " + &
//										"q_" + String(i) + "_t.Visible = true " + &
//										"style_color_" + String(i) + ".Visible = true " + &
//										"qty_" + String(i) + ".Visible = true "
	End IF
Next

dw_print.Modify(ls_modify)

end event

event ue_preview;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

dw_print.DataObject = 'd_55004_r01'
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title ()

dw_body.ShareData(dw_print)

dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print;call super::ue_print;/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

dw_print.DataObject = 'd_55004_r01'
dw_print.SetTransObject(SQLCA)

This.Trigger Event ue_title()

dw_body.ShareData(dw_print)

IF dw_print.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_61053_d
end type

type cb_delete from w_com010_d`cb_delete within w_61053_d
end type

type cb_insert from w_com010_d`cb_insert within w_61053_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_61053_d
end type

type cb_update from w_com010_d`cb_update within w_61053_d
end type

type cb_print from w_com010_d`cb_print within w_61053_d
end type

type cb_preview from w_com010_d`cb_preview within w_61053_d
end type

type gb_button from w_com010_d`gb_button within w_61053_d
end type

type cb_excel from w_com010_d`cb_excel within w_61053_d
end type

type dw_head from w_com010_d`dw_head within w_61053_d
integer height = 316
string dataobject = "d_55004_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd1", '%')
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
string ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "brand"
		If LeftA(dw_head.GetItemString(1, "shop_cd"), 1) <> data Then
			dw_head.SetItem(1, "shop_cd", "")
			dw_head.SetItem(1, "shop_nm", "")			
			
		End If
		If LeftA(dw_head.GetItemString(1, "shop_cd"), 1) <> data Then
			dw_head.SetItem(1, "shop_cd", "")
			dw_head.SetItem(1, "shop_nm", "")
		End If
		
		
		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
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
		 		
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_61053_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_61053_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_61053_d
integer y = 540
integer height = 1500
string dataobject = "d_55004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search, ls_search2, ls_style, ls_color

//style_color_1
if row > 0 then 
	choose case MidA(dwo.name,1,11)
		case 'style_color'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			ls_style = MidA(ls_search,1,8)
			ls_color = MidA(ls_search,10,2) 
			if LenA(ls_search) >= 8 then  gf_style_color_size_pic(ls_style, '%','%','0','K')		

//		case 'shop_cd' //,'shop_nm'
//			ls_search 	= this.GetItemString(row,'shop_cd')
//			ls_search2 	= this.GetItemString(row,'shop_nm')
//			if len(ls_search) = 6 then  gf_shoplife_info(ls_search, ls_search2)				
	end choose	
end if

end event

type dw_print from w_com010_d`dw_print within w_61053_d
string dataobject = "d_55004_r01"
end type

type dw_temp from u_dw within w_61053_d
boolean visible = false
integer x = 165
integer y = 780
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_55004_d02"
end type

