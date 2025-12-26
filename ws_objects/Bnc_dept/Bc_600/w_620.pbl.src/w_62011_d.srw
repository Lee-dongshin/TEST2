$PBExportHeader$w_62011_d.srw
$PBExportComments$매장/품번별 판매순위(이미지포함)
forward
global type w_62011_d from w_com010_d
end type
type dw_1 from datawindow within w_62011_d
end type
end forward

global type w_62011_d from w_com010_d
integer width = 3698
integer height = 2280
dw_1 dw_1
end type
global w_62011_d w_62011_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item,idw_st_brand

String is_brand, is_year, is_season, is_sojae, is_item, is_st_brand
String is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_sale_type, is_sort_fg
Decimal idc_ranking

end variables

forward prototypes
public function long wf_body_set (long al_rows)
end prototypes

public function long wf_body_set (long al_rows);/* dw_body에 dw_1에서 조회된 data를 셋팅 */
Long i, ll_col_cnt = 0, ll_rows
ll_rows = dw_body.InsertRow(0)
For i = 1 To al_rows
	ll_col_cnt++
	If ll_col_cnt > 5    Then
		ll_rows = dw_body.InsertRow(0)
		If ll_rows <= 0 Then Return -1
		ll_col_cnt = 1
	End If
	dw_body.SetItem(ll_rows, "style" + String(ll_col_cnt), dw_1.GetItemString(i, "style"))
	dw_body.SetItem(ll_rows, "chno" + String(ll_col_cnt), dw_1.GetItemString(i, "chno"))
	dw_body.SetItem(ll_rows, "tag_price" + String(ll_col_cnt), dw_1.GetItemdecimal(i,"tag_price"))
	dw_body.SetItem(ll_rows, "mat_cd" + String(ll_col_cnt), dw_1.GetItemString(i, "mat_cd"))
	dw_body.SetItem(ll_rows, "mat_nm" + String(ll_col_cnt), dw_1.GetItemString(i, "mat_nm"))	
	dw_body.SetItem(ll_rows, "style_pic" + String(ll_col_cnt), dw_1.GetItemString(i, "style_pic"))
	dw_body.SetItem(ll_rows, "fr_yymmdd",  is_fr_yymmdd ) 
	dw_body.SetItem(ll_rows, "to_yymmdd",  is_to_yymmdd ) 
	dw_body.SetItem(ll_rows, "shop_cd",  is_shop_cd ) 
	dw_body.SetItem(ll_rows, "sale_type",  is_sale_type ) 
	dw_body.SetItem(ll_rows, "sort_fg",  is_sort_fg ) 
	dw_body.SetItem(ll_rows, "no",  i ) 
	
Next

Return ll_rows


end function

on w_62011_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_62011_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_yymmdd", ld_datetime)
dw_head.SetItem(1, "to_yymmdd", ld_datetime)

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_1.retrieve(is_brand,is_year,is_season,is_sojae,is_item,is_fr_yymmdd,is_to_yymmdd,is_shop_cd,is_sale_type,is_sort_fg,idc_ranking,is_st_brand)
dw_body.Reset()

dw_body.SetRedraw(False)
IF il_rows > 0 THEN
	If wf_body_set(il_rows) <= 0 Then 
		MessageBox("조회오류", "데이터 셋팅에 실패 하였습니다.")
		il_rows = -1
	Else
		This.Trigger Event ue_title()
	   dw_body.SetFocus()
	End If
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF
dw_body.SetRedraw(True)

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
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

is_st_brand = Trim(dw_head.GetItemString(1, "st_brand"))
if IsNull(is_st_brand) or is_st_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
   return false
end if



is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
	is_year = "%"
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
   MessageBox(ls_title,"소재 유형을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"복종 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
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

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then is_shop_cd = '%'

is_sale_type = Trim(dw_head.GetItemString(1, "sale_type"))
if IsNull(is_sale_type) or is_sale_type = "" then
   MessageBox(ls_title,"판매 형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sale_type")
   return false
end if

is_sort_fg = Trim(dw_head.GetItemString(1, "sort_fg"))
if IsNull(is_sort_fg) or is_sort_fg = "" then
   MessageBox(ls_title,"조회순서를 입력하십시요!")
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

return true

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand And gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &
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

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.19                                                  */	
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sale_type, ls_sort_fg, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_nm = '전체'
Else
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If

If is_sale_type = '1' Then
	ls_sale_type = '정   상'
Elseif is_sale_type = '2' then
	ls_sale_type = '정상 + 세일'
else
	ls_sale_type = '정상 + 기획'
End If

If is_sort_fg = '1' Then
	ls_sort_fg = '기간판매 수량순 '
ElseIf is_sort_fg = '2' Then
	ls_sort_fg = '기간판매 판매율순 '
ElseIf is_sort_fg = '3' Then
	ls_sort_fg = '누계판매 수량순 '
Else
	ls_sort_fg = '누계판매 판매율순 '
End If

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id + "'" + &
            "t_user_id.Text   = '" + gs_user_id + "'" + &
            "t_datetime.Text  = '" + ls_datetime + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text      = '" + is_year + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_sojae.Text     = '" + idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display") + "'" + &
            "t_item.Text      = '" + idw_item.GetItemString(idw_item.GetRow(), "item_display") + "'" + &
            "t_fr_yymmdd.Text = '" + String(is_fr_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_to_yymmdd.Text = '" + String(is_to_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_shop_cd.Text   = '" + is_shop_cd + "'" + &
            "t_shop_nm.Text   = '" + ls_shop_nm + "'" + &
            "t_sale_type.Text = '" + ls_sale_type + "'" + &
            "t_ranking.Text   = '" + ls_sort_fg + String(idc_ranking) + "위 까지' "

dw_print.Modify(ls_modify)


end event

event pfc_preopen();call super::pfc_preopen;dw_1.SetTransObject(SQLCA)
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_62011_d","0")
end event

type cb_close from w_com010_d`cb_close within w_62011_d
end type

type cb_delete from w_com010_d`cb_delete within w_62011_d
end type

type cb_insert from w_com010_d`cb_insert within w_62011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_62011_d
end type

type cb_update from w_com010_d`cb_update within w_62011_d
end type

type cb_print from w_com010_d`cb_print within w_62011_d
end type

type cb_preview from w_com010_d`cb_preview within w_62011_d
end type

type gb_button from w_com010_d`gb_button within w_62011_d
end type

type cb_excel from w_com010_d`cb_excel within w_62011_d
end type

type dw_head from w_com010_d`dw_head within w_62011_d
integer x = 5
integer width = 3589
integer height = 316
string dataobject = "d_62011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("st_brand", idw_st_brand)
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')


This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')


This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;

string ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")

		This.GetChild("sojae", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve('%', data)
		ldw_child.insertrow(1)
		ldw_child.Setitem(1, "sojae", "%")
		ldw_child.Setitem(1, "sojae_nm", "전체")
		
	
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
		 				
		
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_62011_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_62011_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_62011_d
integer x = 14
integer y = 540
integer height = 1500
string dataobject = "d_62011_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_62011_d
integer x = 151
integer y = 736
string dataobject = "d_62011_r01"
end type

type dw_1 from datawindow within w_62011_d
boolean visible = false
integer x = 283
integer y = 864
integer width = 3232
integer height = 544
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_62011_d03"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

