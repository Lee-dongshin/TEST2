$PBExportHeader$w_55003_d.srw
$PBExportComments$매장/품번별 판매순위
forward
global type w_55003_d from w_com010_d
end type
end forward

global type w_55003_d from w_com010_d
integer width = 3680
integer height = 2288
end type
global w_55003_d w_55003_d

type variables
DataWindowChild idw_brand, idw_season, idw_sojae, idw_item, idw_st_brand

String is_brand, is_year, is_season, is_sojae, is_item, is_st_brand
String is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, is_sort_fg
Decimal idc_ranking

end variables

on w_55003_d.create
call super::create
end on

on w_55003_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

//dw_head.SetItem(1, "brand", "%")

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.23                                                  */	
/* 수정일      : 2002.01.23                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_sojae, is_item, &
									is_fr_yymmdd, is_to_yymmdd, is_shop_cd, is_shop_type, &
									is_sort_fg, idc_ranking)

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

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주) 지우정보                                               */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String     ls_shop_nm ,ls_brand_grp
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
		
		
	select DBO.SF_INTER_CD2('001',:is_brand) 
	into :ls_brand_grp
	from dual;		
	
	ls_brand_grp = ls_brand_grp + "J"
		
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
//			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' " + &			
			gst_cd.default_where   = "WHERE  '" + ls_brand_grp + "' like '%' + brand + '%' " + & 
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.19                                                  */	
/* 수정일      : 2002.01.19                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_type, ls_sort_fg, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_nm = '전체'
Else
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If

If is_shop_type = '1' Then
	ls_shop_type = '정   상'
Else
	ls_shop_type = '정상 + 기획'
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
            "t_shop_type.Text = '" + ls_shop_type + "'" + &
            "t_ranking.Text   = '" + ls_sort_fg + String(idc_ranking) + "위 까지' "

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55003_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_55003_d
end type

type cb_delete from w_com010_d`cb_delete within w_55003_d
end type

type cb_insert from w_com010_d`cb_insert within w_55003_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55003_d
end type

type cb_update from w_com010_d`cb_update within w_55003_d
end type

type cb_print from w_com010_d`cb_print within w_55003_d
end type

type cb_preview from w_com010_d`cb_preview within w_55003_d
end type

type gb_button from w_com010_d`gb_button within w_55003_d
end type

type cb_excel from w_com010_d`cb_excel within w_55003_d
end type

type dw_head from w_com010_d`dw_head within w_55003_d
integer x = 5
integer y = 176
integer width = 3589
integer height = 320
string dataobject = "d_55003_h01"
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

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.01.24                                                  */	
/* 수정일      : 2001.01.24                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
		
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
				  						
		
		
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


end event

type ln_1 from w_com010_d`ln_1 within w_55003_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_55003_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_55003_d
integer y = 540
integer height = 1500
string dataobject = "d_55003_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;string ls_style

		ls_style = this.getitemstring(row, "style")
		gf_style_pic(ls_style,"%")

end event

type dw_print from w_com010_d`dw_print within w_55003_d
string dataobject = "d_55003_r01"
end type

