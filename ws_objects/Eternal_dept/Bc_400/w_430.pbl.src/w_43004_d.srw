$PBExportHeader$w_43004_d.srw
$PBExportComments$매장재고현황조회
forward
global type w_43004_d from w_com010_d
end type
end forward

global type w_43004_d from w_com010_d
integer width = 3675
integer height = 2276
string title = "매장재고현황"
end type
global w_43004_d w_43004_d

type variables
DataWindowChild idw_brand, idw_shop_type, idw_year,idw_season, idw_sojae, idw_item
string is_brand, is_yymmdd, is_shop_cd, is_shop_type, is_year, is_season, is_sojae, is_item, is_chno_gubn

end variables

on w_43004_d.create
call super::create
end on

on w_43004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                       */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_part_cd, ls_part_nm, ls_shop_nm, ls_brand
DataStore  lds_Source
Boolean    lb_check 

CHOOSE CASE as_column
		CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
			ls_brand = dw_head.getitemstring(1,"brand")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%' or shop_nm like  '%" + as_data + "%'"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("cust_type")
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

is_yymmdd = dw_head.GetItemString(1, "yymmdd")
if IsNull(is_yymmdd) or Trim(is_yymmdd) = "" then
   MessageBox(ls_title,"기준일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_TYPE = dw_head.GetItemString(1, "shop_TYPE")
if IsNull(is_shop_TYPE) or Trim(is_shop_TYPE) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_TYPE")
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

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
is_sojae = "%"
end if

//// 매장형태, 시즌 전체추가
//is_shop_type = dw_head.GetItemString(1, "shop_type")
//if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
//is_sojae = "%"
//end if
//
//is_season = dw_head.GetItemString(1, "season")
//if IsNull(is_season) or Trim(is_season) = "" then
//is_season = "%"
//end if
//// ------------------------

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
is_item = "%"
end if

is_chno_gubn = dw_head.GetItemString(1, "chno_gubn")
if IsNull(is_chno_gubn) or Trim(is_chno_gubn) = "" then
   MessageBox(ls_title,"차수구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("chno_gubn")
   return false
end if

return true

end event

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                             */	
/* 작성일      : 2001..                                                      */	
/* 수정일      : 2001..                                                      */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_44004_d01 '20011215' , 'n', '010000', '2001' ,'w', '%', 'o','417','%', '%', '%'

il_rows = dw_body.retrieve(is_yymmdd, is_brand, is_shop_cd, IS_SHOP_TYPE,  is_year, is_season, is_sojae, is_item, is_chno_gubn)
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_43004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_43004_d
end type

type cb_delete from w_com010_d`cb_delete within w_43004_d
boolean enabled = true
end type

type cb_insert from w_com010_d`cb_insert within w_43004_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_43004_d
end type

type cb_update from w_com010_d`cb_update within w_43004_d
end type

type cb_print from w_com010_d`cb_print within w_43004_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_43004_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_43004_d
end type

type cb_excel from w_com010_d`cb_excel within w_43004_d
end type

type dw_head from w_com010_d`dw_head within w_43004_d
integer height = 312
string dataobject = "d_43004_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.Setitem(1, "inter_cd", "%")
idw_year.Setitem(1, "inter_cd1", "%")
idw_year.Setitem(1, "inter_nm", "전체")


//라빠레트 시즌적용
is_brand = dw_head.getitemstring(1,'brand')
is_year = dw_head.getitemstring(1,'year')

this.getchild("season",idw_season)
idw_season.settransobject(sqlca)
idw_season.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')
idw_season.insertrow(1)
idw_season.Setitem(1, "inter_cd", "%")
idw_season.Setitem(1, "inter_nm", "전체")

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',is_brand)

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve(is_brand)

This.GetChild("shop_type", idw_shop_type )
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if

end event

event dw_head::itemchanged;
CHOOSE CASE dwo.name

   CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)


	CASE "brand", "year"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			//라빠레트 시즌적용
			dw_head.accepttext()
			is_brand = dw_head.getitemstring(1,'brand')
			is_year = dw_head.getitemstring(1,'year')
			
			this.getchild("season",idw_season)
			idw_season.settransobject(sqlca)
			idw_season.retrieve('003', is_brand, is_year)
			//idw_season.retrieve('003')
			idw_season.insertrow(1)
			idw_season.Setitem(1, "inter_cd", "%")
			idw_season.Setitem(1, "inter_nm", "전체")
			
			This.GetChild("sojae", idw_sojae)
			idw_sojae.SetTransObject(SQLCA)
			idw_sojae.Retrieve('%', is_brand)
			idw_sojae.insertrow(1)
			idw_sojae.Setitem(1, "sojae", "%")
			idw_sojae.Setitem(1, "sojae_nm", "전체")
			
			This.GetChild("item", idw_item)
			idw_item.SetTransObject(SQLCA)
			idw_item.Retrieve(is_brand)
			idw_item.insertrow(1)
			idw_item.Setitem(1, "item", "%")
			idw_item.Setitem(1, "item_nm", "전체")
		

END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_43004_d
integer beginx = 5
integer beginy = 520
integer endx = 3625
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_43004_d
integer beginx = 14
integer beginy = 524
integer endx = 3634
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_43004_d
integer y = 540
integer height = 1500
string dataobject = "d_43004_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_43004_d
integer x = 2171
integer y = 1444
boolean enabled = false
end type

