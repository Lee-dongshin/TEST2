$PBExportHeader$w_12037_d.srw
$PBExportComments$패브릭가이드
forward
global type w_12037_d from w_com010_d
end type
end forward

global type w_12037_d from w_com010_d
end type
global w_12037_d w_12037_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_item, idw_sojae
string is_brand, is_year, is_season, is_item, is_sojae

end variables

on w_12037_d.create
call super::create
end on

on w_12037_d.destroy
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

is_year = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then is_year = '%'

is_season = dw_head.GetItemString(1, "season")
if IsNull(is_season) or Trim(is_season) = "" then is_season = '%'

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then is_item = '%'

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then is_sojae = '%'

return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime
String ls_year, ls_season, ls_item, ls_sojae

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if IsNull(is_year) or Trim(is_year) = "%" then
	ls_year = '% 전체'
else
	ls_year = idw_year.GetItemString(idw_year.GetRow(), "inter_display")
end if	

if IsNull(is_season) or Trim(is_season) = "%" then
	ls_season = '% 전체'
else
	ls_season = idw_season.GetItemString(idw_season.GetRow(), "inter_display")
end if	

if IsNull(is_item) or Trim(is_item) = "%" then
	ls_item = '% 전체'
else
	ls_item = idw_item.GetItemString(idw_item.GetRow(), "item_display")
end if	

if IsNull(is_sojae) or Trim(is_sojae) = "%" then
	ls_sojae = '% 전체'
else
	ls_sojae = idw_sojae.GetItemString(idw_sojae.GetRow(), "sojae_display")
end if	


ls_modify =	"txtbrand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "' " + &	
				"txtyear.Text      = '" + ls_year + "' " + &				
            "txtseason.Text    = '" + ls_season + "' " + &								
				"txtitem.Text      = '" + ls_item + "' " + &				
            "txtsojae.Text     = '" + ls_sojae + "'"

dw_print.Modify(ls_modify)

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_item, is_sojae)

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

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_cust_nm , ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style"							// 거래처 코드
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF is_brand = LeftA(as_data, 1) and gf_style_chk(as_data, '%') = True THEN
					RETURN 0
				END IF 
			END IF
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' "
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
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
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))

								
   	ls_style =  lds_Source.GetItemString(1,"style")
	
								
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("frm_in_date")
					ib_itemchanged = False
				END IF
				Destroy  lds_Source
//			END IF
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

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_12037_d","0")
end event

type cb_close from w_com010_d`cb_close within w_12037_d
end type

type cb_delete from w_com010_d`cb_delete within w_12037_d
end type

type cb_insert from w_com010_d`cb_insert within w_12037_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_12037_d
end type

type cb_update from w_com010_d`cb_update within w_12037_d
end type

type cb_print from w_com010_d`cb_print within w_12037_d
end type

type cb_preview from w_com010_d`cb_preview within w_12037_d
end type

type gb_button from w_com010_d`gb_button within w_12037_d
end type

type cb_excel from w_com010_d`cb_excel within w_12037_d
end type

type dw_head from w_com010_d`dw_head within w_12037_d
integer x = 5
integer y = 160
integer width = 3593
integer height = 172
string dataobject = "d_12037_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.setitem(1,"inter_cd","%")
idw_year.setitem(1,"inter_nm","전체")

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1,"inter_cd","%")
idw_season.setitem(1,"inter_nm","전체")

This.GetChild("item", idw_item )
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%')
idw_item.insertrow(1)
idw_item.setitem(1,"item","%")
idw_item.setitem(1,"item_nm","전체")

This.GetChild("sojae", idw_sojae )
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%', gs_brand)
idw_sojae.insertrow(1)
idw_sojae.setitem(1,"sojae","%")
idw_sojae.setitem(1,"sojae_nm","전체")

// 해당 브랜드 선별작업 
String   ls_filter_str = ''	
if  gl_user_level   = 0  then 
	ls_filter_str = "inter_cd like '"    + gs_brand + "'" 
	idw_brand.SetFilter(ls_filter_str)
	idw_brand.Filter( )
end if
end event

event dw_head::itemchanged;call super::itemchanged;
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
   

		
CASE "brand"	     //  Popup 검색창이 존재하는 항목 
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
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_12037_d
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_d`ln_2 within w_12037_d
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_d`dw_body within w_12037_d
integer y = 348
integer width = 3570
integer height = 1656
string dataobject = "d_12037_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_12037_d
integer y = 676
integer width = 1728
integer height = 572
string dataobject = "d_12037_r01"
end type

