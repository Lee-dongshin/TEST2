$PBExportHeader$w_55005_t.srw
$PBExportComments$매장별 손익보고서
forward
global type w_55005_t from w_com010_d
end type
type rb_shop from radiobutton within w_55005_t
end type
type rb_sale from radiobutton within w_55005_t
end type
type rb_season from radiobutton within w_55005_t
end type
type rb_sale_season from radiobutton within w_55005_t
end type
type rb_season_sale from radiobutton within w_55005_t
end type
type rb_shop_day from radiobutton within w_55005_t
end type
type rb_make_type from radiobutton within w_55005_t
end type
type rb_shopseason from radiobutton within w_55005_t
end type
type rb_shop_month from radiobutton within w_55005_t
end type
type rb_yymmseason from radiobutton within w_55005_t
end type
type rb_shopseasonyymm from radiobutton within w_55005_t
end type
type rb_yymmddseason from radiobutton within w_55005_t
end type
type rb_style_no from radiobutton within w_55005_t
end type
type gb_1 from groupbox within w_55005_t
end type
end forward

global type w_55005_t from w_com010_d
integer width = 3657
integer height = 2244
rb_shop rb_shop
rb_sale rb_sale
rb_season rb_season
rb_sale_season rb_sale_season
rb_season_sale rb_season_sale
rb_shop_day rb_shop_day
rb_make_type rb_make_type
rb_shopseason rb_shopseason
rb_shop_month rb_shop_month
rb_yymmseason rb_yymmseason
rb_shopseasonyymm rb_shopseasonyymm
rb_yymmddseason rb_yymmddseason
rb_style_no rb_style_no
gb_1 gb_1
end type
global w_55005_t w_55005_t

type variables
DataWindowChild idw_brand, idw_season, idw_shop_div, idw_st_brand

String is_brand, is_fr_yymmdd, is_to_yymmdd, is_year, is_season, is_st_brand
String is_shop_div, is_shop_cd, is_sale_type1, is_sale_type2
string is_sale_type3, is_sale_type4, is_sale_type9, is_except_eshop, is_dotcom, is_opt_goods
end variables

on w_55005_t.create
int iCurrent
call super::create
this.rb_shop=create rb_shop
this.rb_sale=create rb_sale
this.rb_season=create rb_season
this.rb_sale_season=create rb_sale_season
this.rb_season_sale=create rb_season_sale
this.rb_shop_day=create rb_shop_day
this.rb_make_type=create rb_make_type
this.rb_shopseason=create rb_shopseason
this.rb_shop_month=create rb_shop_month
this.rb_yymmseason=create rb_yymmseason
this.rb_shopseasonyymm=create rb_shopseasonyymm
this.rb_yymmddseason=create rb_yymmddseason
this.rb_style_no=create rb_style_no
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_shop
this.Control[iCurrent+2]=this.rb_sale
this.Control[iCurrent+3]=this.rb_season
this.Control[iCurrent+4]=this.rb_sale_season
this.Control[iCurrent+5]=this.rb_season_sale
this.Control[iCurrent+6]=this.rb_shop_day
this.Control[iCurrent+7]=this.rb_make_type
this.Control[iCurrent+8]=this.rb_shopseason
this.Control[iCurrent+9]=this.rb_shop_month
this.Control[iCurrent+10]=this.rb_yymmseason
this.Control[iCurrent+11]=this.rb_shopseasonyymm
this.Control[iCurrent+12]=this.rb_yymmddseason
this.Control[iCurrent+13]=this.rb_style_no
this.Control[iCurrent+14]=this.gb_1
end on

on w_55005_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_shop)
destroy(this.rb_sale)
destroy(this.rb_season)
destroy(this.rb_sale_season)
destroy(this.rb_season_sale)
destroy(this.rb_shop_day)
destroy(this.rb_make_type)
destroy(this.rb_shopseason)
destroy(this.rb_shop_month)
destroy(this.rb_yymmseason)
destroy(this.rb_shopseasonyymm)
destroy(this.rb_yymmddseason)
destroy(this.rb_style_no)
destroy(this.gb_1)
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
dw_head.SetItem(1, "st_brand", "%")

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_st_brand = Trim(dw_head.GetItemString(1, "st_brand"))
if IsNull(is_st_brand) or is_st_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("st_brand")
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

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
	is_year = '%'
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
if IsNull(is_shop_div) or is_shop_div = "" then
   MessageBox(ls_title,"유통망 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
	is_shop_cd = '%'
end if

is_sale_type1 = Trim(dw_head.GetItemString(1, "sale_type1"))
if IsNull(is_sale_type1) or is_sale_type1 = "" then
	is_sale_type1 = '0'
end if

is_sale_type2 = Trim(dw_head.GetItemString(1, "sale_type2"))
if IsNull(is_sale_type2) or is_sale_type2 = "" then
	is_sale_type2 = '0'
end if

is_sale_type3 = Trim(dw_head.GetItemString(1, "sale_type3"))
if IsNull(is_sale_type3) or is_sale_type3 = "" then
	is_sale_type3 = '0'
end if

is_sale_type4 = Trim(dw_head.GetItemString(1, "sale_type4"))
if IsNull(is_sale_type4) or is_sale_type4 = "" then
	is_sale_type4 = '0'
end if

is_sale_type9 = Trim(dw_head.GetItemString(1, "sale_type9"))
if IsNull(is_sale_type9) or is_sale_type9 = "" then
	is_sale_type4 = '0'
end if

is_except_eshop = dw_head.GetItemString(1, "except_eshop")
is_dotcom = dw_head.GetItemString(1, "dotcom")
is_opt_goods = dw_head.GetItemString(1, "opt_goods")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_shop_div,ls_brand_grp
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		
		select DBO.SF_INTER_CD2('001',:ls_brand)
		into :ls_brand_grp
		from dual;		
		
		ls_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
//				If Left(as_data, 1) <> ls_brand Then
//					MessageBox("입력오류", "브랜드가 다릅니다!")
//					dw_head.SetItem(al_row, "shop_cd", "")
//					dw_head.SetItem(al_row, "shop_nm", "")
//					Return 1
//				End If
				If ls_shop_div <> '%' Then
					If MidA(as_data, 2, 1) <> ls_shop_div Then
						MessageBox("입력오류", "유통망이 다릅니다!")
						dw_head.SetItem(al_row, "shop_cd", "")
						dw_head.SetItem(al_row, "shop_nm", "")
						Return 1
					End If
				End If
					
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			//gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' " + &
			gst_cd.default_where   = "WHERE  '" + ls_brand_grp + "' like '%' + brand + '%' " + & 			
			                         "  AND SHOP_DIV LIKE '" + ls_shop_div + "' " + &
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_year, is_season, &
									is_shop_div, is_shop_cd, is_sale_type1, is_sale_type2, is_sale_type3, is_sale_type4, is_sale_type9, is_except_eshop, is_dotcom, is_opt_goods, is_st_brand)

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

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.28                                                  */	
/* 수정일      : 2002.01.28                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_shop_cd = '%' Then
	ls_shop_nm = '전체'
Else
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
End If

If is_sale_type1 = '1' Then
	ls_sale_type = ls_sale_type + '√정상   '
Else
	ls_sale_type = ls_sale_type + '□정상   '
End If

If is_sale_type2 = '2' Then
	ls_sale_type = ls_sale_type + '√세일   '
Else
	ls_sale_type = ls_sale_type + '□세일   '
End If

If is_sale_type3 = '3' Then
	ls_sale_type = ls_sale_type + '√기획   '
Else
	ls_sale_type = ls_sale_type + '□기획   '
End If

If is_sale_type4 = '4' Then
	ls_sale_type = ls_sale_type + '√행사'
Else
	ls_sale_type = ls_sale_type + '□행사'
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_fr_yymmdd.Text = '" + String(is_fr_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_to_yymmdd.Text = '" + String(is_to_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_year.Text = '" + is_year + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" + &
            "t_shop_cd.Text = '" + is_shop_cd + "'" + &
            "t_shop_nm.Text = '" + ls_shop_nm + "'" + &
            "t_sale_type.Text = '" + ls_sale_type + "'"

dw_print.Modify(ls_modify)

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
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
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_55005_d","0")
end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
end event

type cb_close from w_com010_d`cb_close within w_55005_t
end type

type cb_delete from w_com010_d`cb_delete within w_55005_t
end type

type cb_insert from w_com010_d`cb_insert within w_55005_t
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55005_t
end type

type cb_update from w_com010_d`cb_update within w_55005_t
end type

type cb_print from w_com010_d`cb_print within w_55005_t
end type

type cb_preview from w_com010_d`cb_preview within w_55005_t
end type

type gb_button from w_com010_d`gb_button within w_55005_t
integer width = 3584
end type

type cb_excel from w_com010_d`cb_excel within w_55005_t
end type

type dw_head from w_com010_d`dw_head within w_55005_t
integer x = 5
integer width = 3534
integer height = 400
string dataobject = "d_55005_h01t"
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

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", 'U')
idw_shop_div.SetItem(1, "inter_nm", '입점+직영')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String ls_year, ls_brand
DataWindowChild ldw_child


cb_print.enabled   = false
cb_preview.enabled = false
cb_excel.enabled   = false
dw_body.Reset()

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
				  						
		
	CASE "shop_div"
		If data <> '%' Then
			If MidA(dw_head.GetItemString(1, "shop_cd"), 2, 1) <> data Then
				dw_head.SetItem(1, "shop_cd", "")
				dw_head.SetItem(1, "shop_nm", "")
			End If
			If MidA(dw_head.GetItemString(1, "shop_cd"), 2, 1) <> data Then
				dw_head.SetItem(1, "shop_cd", "")
				dw_head.SetItem(1, "shop_nm", "")
			End If
		End IF
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_55005_t
boolean visible = false
integer beginy = 872
integer endy = 872
end type

type ln_2 from w_com010_d`ln_2 within w_55005_t
boolean visible = false
integer beginy = 876
integer endy = 876
end type

type dw_body from w_com010_d`dw_body within w_55005_t
integer y = 588
integer width = 3570
integer height = 1420
string dataobject = "d_55005_d13t"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_55005_t
integer x = 814
integer y = 888
string dataobject = "d_55005_r13t"
end type

type rb_shop from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 40
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
string text = "매장별"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 255)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		 = RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)


dw_body.DataObject = 'd_55005_d01'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r01'
dw_print.SetTransObject(SQLCA)

end event

type rb_sale from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 100
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
string text = "판매형태별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 255)
rb_season.TextColor    		 = RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d02'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r02'
dw_print.SetTransObject(SQLCA)

end event

type rb_season from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 160
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
string text = "년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 255) 
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)


dw_body.DataObject = 'd_55005_d03'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r03'
dw_print.SetTransObject(SQLCA)

end event

type rb_sale_season from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 220
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
string text = "판매형태/시즌"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 255) 
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d04'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r04'
dw_print.SetTransObject(SQLCA)

end event

type rb_season_sale from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 280
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
string text = "시즌/판매형태"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 255) 
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)


dw_body.DataObject = 'd_55005_d05'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r05'
dw_print.SetTransObject(SQLCA)

end event

type rb_shop_day from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 340
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
string text = "일자/매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 255)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)


dw_body.DataObject = 'd_55005_d06'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r06'
dw_print.SetTransObject(SQLCA)

end event

type rb_make_type from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 456
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
string text = "생산형태별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 255) 
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d07'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r07'
dw_print.SetTransObject(SQLCA)

end event

type rb_shopseason from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 516
integer width = 466
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
string text = "매장년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 255)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d08'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r08'
dw_print.SetTransObject(SQLCA)

end event

type rb_shop_month from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 396
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
string text = "월/매장별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 255)
rb_make_type.TextColor 		 = RGB(0, 0, 0)
rb_shopseason.TextColor     = RGB(0, 0, 0)
rb_yymmseason.TextColor  = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)  
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d09'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r09'
dw_print.SetTransObject(SQLCA)

end event

type rb_yymmseason from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 576
integer width = 466
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
string text = "월/년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 0)
rb_shopseason.TextColor    = RGB(0, 0, 0)
rb_yymmseason.TextColor   = RGB(0, 0, 255)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)      
rb_yymmddseason.TextColor   = RGB(0, 0, 0)

dw_body.DataObject = 'd_55005_d10'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r10'
dw_print.SetTransObject(SQLCA)

end event

type rb_shopseasonyymm from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 640
integer width = 466
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
string text = "매장월년도시즌"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 0)
rb_shopseason.TextColor    = RGB(0, 0, 0)
rb_yymmseason.TextColor    = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor           	= RGB(0, 0, 255)
rb_yymmddseason.TextColor   = RGB(0, 0, 0)


dw_body.DataObject = 'd_55005_d11'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r11'
dw_print.SetTransObject(SQLCA)

end event

type rb_yymmddseason from radiobutton within w_55005_t
boolean visible = false
integer x = 27
integer y = 700
integer width = 466
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
string text = "일/년도시즌별"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 0)
rb_shopseason.TextColor    = RGB(0, 0, 0)
rb_yymmseason.TextColor   = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)        	
rb_yymmddseason.TextColor   = RGB(0, 0, 255)

dw_body.DataObject = 'd_55005_d12'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r12'
dw_print.SetTransObject(SQLCA)

end event

type rb_style_no from radiobutton within w_55005_t
boolean visible = false
integer x = 32
integer y = 764
integer width = 466
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
string text = "품번생산정보"
borderstyle borderstyle = stylelowered!
end type

event clicked;rb_shop.TextColor        	= RGB(0, 0, 0)
rb_sale.TextColor        	= RGB(0, 0, 0)
rb_season.TextColor    		= RGB(0, 0, 0)
rb_sale_season.TextColor 	= RGB(0, 0, 0)
rb_season_sale.TextColor 	= RGB(0, 0, 0)
rb_shop_day.TextColor    	= RGB(0, 0, 0)
rb_shop_month.TextColor    = RGB(0, 0, 0)
rb_make_type.TextColor 		= RGB(0, 0, 0)
rb_shopseason.TextColor    = RGB(0, 0, 0)
rb_yymmseason.TextColor   = RGB(0, 0, 0)
rb_shopseasonyymm.TextColor   = RGB(0, 0, 0)        	
rb_yymmddseason.TextColor   = RGB(0, 0, 255)

dw_body.DataObject = 'd_55005_d13t'
dw_body.SetTransObject(SQLCA)
dw_print.DataObject = 'd_55005_r13t'
dw_print.SetTransObject(SQLCA)

end event

type gb_1 from groupbox within w_55005_t
boolean visible = false
integer x = 5
integer width = 539
integer height = 848
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

