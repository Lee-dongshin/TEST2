$PBExportHeader$w_55008_d.srw
$PBExportComments$월별년도시즌매출
forward
global type w_55008_d from w_com010_d
end type
end forward

global type w_55008_d from w_com010_d
integer width = 3671
integer height = 2256
end type
global w_55008_d w_55008_d

type variables
DataWindowChild  idw_brand, idw_year, idw_season, idw_shop_type,idw_st_brand
String is_brand, is_yyyy, is_year, is_season, is_shop_type, is_opt_view, is_st_brand
end variables

on w_55008_d.create
call super::create
end on

on w_55008_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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


is_st_brand = dw_head.GetItemString(1, "st_brand")
if IsNull(is_st_brand) or Trim(is_st_brand) = "" then
   MessageBox(ls_title,"품번브랜드 코드를 입력하십시요!")
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




is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_yyyy = dw_head.GetItemString(1, "yyyy")
if IsNull(is_yyyy) or Trim(is_yyyy) = "" then
   MessageBox(ls_title,"판매년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yyyy")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"조회구분을 입력하세요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if


return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yyyy, is_brand, is_year, is_season, gs_lang, is_shop_type, is_st_brand)
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

event ue_print();
This.Trigger Event ue_title()

dw_print.retrieve(is_yyyy, is_brand, is_year, is_season, gs_lang, is_shop_type,is_st_brand)

IF dw_print.RowCount() = 0 Then
   MessageBox("Print Error","인쇄할 자료가 없습니다 !")
   il_rows = 0
ELSE
   il_rows = dw_print.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)
end event

event ue_preview();
This.Trigger Event ue_title ()

dw_print.retrieve(is_yyyy, is_brand, is_year, is_season, gs_lang, is_shop_type,is_st_brand)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.22                                                  */	
/* 수정일      : 2002.01.22                                                  */
/*===========================================================================*/
Datetime ld_datetime
String ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
            "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
            "t_yyyy.Text = '" + is_yyyy + "'" + &
            "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'"


dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_55008_d
fontcharset fontcharset = defaultcharset!
end type

type cb_delete from w_com010_d`cb_delete within w_55008_d
fontcharset fontcharset = defaultcharset!
end type

type cb_insert from w_com010_d`cb_insert within w_55008_d
fontcharset fontcharset = defaultcharset!
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55008_d
integer width = 357
fontcharset fontcharset = defaultcharset!
end type

type cb_update from w_com010_d`cb_update within w_55008_d
integer x = 37
fontcharset fontcharset = defaultcharset!
end type

type cb_print from w_com010_d`cb_print within w_55008_d
fontcharset fontcharset = defaultcharset!
string text = "출력(&P)"
end type

type cb_preview from w_com010_d`cb_preview within w_55008_d
integer width = 384
fontcharset fontcharset = defaultcharset!
end type

type gb_button from w_com010_d`gb_button within w_55008_d
end type

type cb_excel from w_com010_d`cb_excel within w_55008_d
fontcharset fontcharset = defaultcharset!
end type

type dw_head from w_com010_d`dw_head within w_55008_d
integer y = 148
integer height = 216
string dataobject = "d_55008_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("st_brand", idw_st_brand )
idw_st_brand.SetTransObject(SQLCA)
idw_st_brand.Retrieve('001')
idw_st_brand.InsertRow(1)
idw_st_brand.SetItem(1, "inter_cd", '%')
idw_st_brand.SetItem(1, "inter_nm", '전체')


THIS.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '0')
idw_shop_type.SetItem(1, "inter_nm", '기타제외')




end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child


CHOOSE CASE dwo.name
	CASE "opt_view"	     //  Popup 검색창이 존재하는 항목 
	   if data = "A" then
			dw_body.dataobject = "d_55008_d01"
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_55008_r01"
			dw_print.SetTransObject(SQLCA)			
		else 	
			dw_body.dataobject = "d_55008_d02"
			dw_body.SetTransObject(SQLCA)
			dw_print.dataobject = "d_55008_r03"
			dw_print.SetTransObject(SQLCA)						
		end if	
		
	
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

type ln_1 from w_com010_d`ln_1 within w_55008_d
integer beginy = 364
integer endy = 364
end type

type ln_2 from w_com010_d`ln_2 within w_55008_d
integer beginy = 368
integer endy = 368
end type

type dw_body from w_com010_d`dw_body within w_55008_d
integer y = 372
integer height = 1644
string dataobject = "d_55008_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_55008_d
string dataobject = "d_55008_r01"
end type

