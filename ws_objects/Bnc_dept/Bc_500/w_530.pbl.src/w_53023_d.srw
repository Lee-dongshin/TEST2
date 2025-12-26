$PBExportHeader$w_53023_d.srw
$PBExportComments$판매반품율조회
forward
global type w_53023_d from w_com010_d
end type
type dw_detail from datawindow within w_53023_d
end type
end forward

global type w_53023_d from w_com010_d
integer width = 3680
integer height = 2284
dw_detail dw_detail
end type
global w_53023_d w_53023_d

type variables
String is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_shop_div, is_shop_cd, is_opt_view
String is_style, is_chno, is_item, is_sojae
DataWindowChild idw_brand, idw_year, idw_season, idw_shop_div, idw_item, idw_sojae
end variables

on w_53023_d.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_53023_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
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
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"기간을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
  is_shop_cd = "%"
end if

is_shop_div = dw_head.GetItemString(1, "shop_div")
if IsNull(is_shop_div) or Trim(is_shop_div) = "" then
   MessageBox(ls_title,"매장구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

is_item = dw_head.GetItemString(1, "item")
if IsNull(is_item) or Trim(is_item) = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_sojae = dw_head.GetItemString(1, "sojae")
if IsNull(is_sojae) or Trim(is_sojae) = "" then
   MessageBox(ls_title,"소재를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sojae")
   return false
end if

is_opt_view = dw_head.GetItemString(1, "opt_view")
if IsNull(is_opt_view) or Trim(is_opt_view) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_view")
   return false
end if

return true

end event

event ue_retrieve();call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

IF IS_OPT_VIEW = "A" THEN
	DW_BODY.DATAOBJECT = "D_53023_D01"
	dw_body.SetTransObject(SQLCA)
	DW_PRINT.DATAOBJECT = "D_53023_R01"		
	DW_PRINT.SetTransObject(SQLCA)		
ELSEIF IS_OPT_VIEW = "B" THEN	
	DW_BODY.DATAOBJECT = "D_53023_D02"	
	dw_body.SetTransObject(SQLCA)
	DW_PRINT.DATAOBJECT = "D_53023_R02"		
	DW_PRINT.SetTransObject(SQLCA)			
ELSEIF IS_OPT_VIEW = "C" THEN	
	DW_BODY.DATAOBJECT = "D_53023_D03"		
	dw_body.SetTransObject(SQLCA)	
	DW_PRINT.DATAOBJECT = "D_53023_R03"		
	DW_PRINT.SetTransObject(SQLCA)			
ELSEif IS_OPT_VIEW = "D" 	then
	DW_BODY.DATAOBJECT = "D_53023_D04"		
	dw_body.SetTransObject(SQLCA)	
	DW_PRINT.DATAOBJECT = "D_53023_R04"		
	DW_PRINT.SetTransObject(SQLCA)			
ELSEIF IS_OPT_VIEW = "E" THEN	
	DW_BODY.DATAOBJECT = "D_53023_D06"		
	dw_body.SetTransObject(SQLCA)	
	DW_PRINT.DATAOBJECT = "D_53023_R06"		
	DW_PRINT.SetTransObject(SQLCA)			
ELSEIF IS_OPT_VIEW = "G" THEN	
	DW_BODY.DATAOBJECT = "D_53023_D07"		
	dw_body.SetTransObject(SQLCA)	
	DW_PRINT.DATAOBJECT = "D_53023_R07"		
	DW_PRINT.SetTransObject(SQLCA)				
ELSE	
	DW_BODY.DATAOBJECT = "D_53023_D05"		
	dw_body.SetTransObject(SQLCA)	
	DW_PRINT.DATAOBJECT = "D_53023_R05"		
	DW_PRINT.SetTransObject(SQLCA)			
END IF	

il_rows = dw_body.retrieve(is_brand, is_year, is_season, is_frm_ymd, is_to_ymd, is_shop_cd, is_shop_div ,is_style, is_chno, is_item, is_sojae)

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

event open;call super::open;datetime ld_datetime
string ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyymmdd")


dw_head.setitem(1, "frm_ymd" , ls_datetime)
dw_head.setitem(1, "to_ymd" , ls_datetime)
end event

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

if is_shop_cd = "%" then
	ls_shop_nm = "전체"
else
	ls_shop_nm = dw_head.getitemstring(1, "shop_nm")
end if	

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
				"t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_nm") + "'" 	 + &			
				"t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_cd1") + "'" 		+ &
				"t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" 		+ &				
				"t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'" 		+ &								
				"t_shop_cd.Text = '" + is_shop_cd + "'" 		+ &															
				"t_shop_nm.Text = '" + ls_shop_nm + "'" + &
				"t_frm_ymd.text = '" + is_frm_ymd + "'" + &
				"t_to_ymd.text = '" + is_to_ymd + "'" 
dw_print.Modify(ls_modify)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_brand, ls_style, ls_chno , ls_bujin_chk, ls_dep_ymd, ls_dep_seq
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				ELSEIF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			ls_brand = dw_head.GetitemString(1, "brand")
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + & 
			                         "  AND SHOP_DIV  IN ('G', 'K', 'X') " + &
											 "  AND BRAND = '" + ls_brand + "'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
		CASE "style"				
			
			IF ai_div = 1 THEN 	
				IF isnull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "STYLE", "")
					RETURN 0
				END IF 
			END IF
			
			// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				if gs_brand <> 'K' then
					gst_cd.default_where   = " WHERE 1 = 1 "
				else 
					gst_cd.default_where = ""
				end if
				
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " style LIKE ~'" + as_data + "%~' "
					ELSE
						gst_cd.Item_where = ""
					END IF
				else 
					gst_cd.Item_where = ""
				end if
				
				lds_Source = Create DataStore
				OpenWithParm(W_COM200, lds_Source)

				IF Isvalid(Message.PowerObjectParm) THEN
					ib_itemchanged = True
					lds_Source = Message.PowerObjectParm

					dw_head.SetRow(al_row)
					dw_head.SetColumn(as_column)
            
				 
					dw_head.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_head.SetItem(al_row, "chno", lds_Source.GetItemString(1,"chno"))
								
      
					/* 다음컬럼으로 이동 */
					dw_head.SetColumn("chno")
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

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_head, "ScaleToRight")
dw_detail.SetTransObject(SQLCA)
end event

type cb_close from w_com010_d`cb_close within w_53023_d
end type

type cb_delete from w_com010_d`cb_delete within w_53023_d
end type

type cb_insert from w_com010_d`cb_insert within w_53023_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_53023_d
end type

type cb_update from w_com010_d`cb_update within w_53023_d
end type

type cb_print from w_com010_d`cb_print within w_53023_d
end type

type cb_preview from w_com010_d`cb_preview within w_53023_d
end type

type gb_button from w_com010_d`gb_button within w_53023_d
end type

type cb_excel from w_com010_d`cb_excel within w_53023_d
end type

type dw_head from w_com010_d`dw_head within w_53023_d
integer y = 152
integer height = 336
string dataobject = "d_53023_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
		
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

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", 'U')
idw_shop_div.SetItem(1, "inter_nm", '입점+직영몰')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("sojae", idw_sojae)
idw_sojae.SetTransObject(SQLCA)
idw_sojae.Retrieve('%',gs_brand)
idw_sojae.InsertRow(1)
idw_sojae.SetItem(1, "sojae", '%')
idw_sojae.SetItem(1, "sojae_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve('%', gs_brand)
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')

end event

type ln_1 from w_com010_d`ln_1 within w_53023_d
integer beginy = 492
integer endy = 492
end type

type ln_2 from w_com010_d`ln_2 within w_53023_d
integer beginy = 496
integer endy = 496
end type

type dw_body from w_com010_d`dw_body within w_53023_d
integer y = 508
integer height = 1532
string dataobject = "d_53023_d01"
boolean hscrollbar = true
end type

event dw_body::doubleclicked;call super::doubleclicked;string ls_style, ls_chno

dw_detail.reset()
ls_style =  dw_body.GetitemString(row,"style")	
ls_chno  =  dw_body.GetitemString(row,"chno")	


IF ls_style = "" OR isnull(ls_style) THEN		
	return
END IF

IF ls_chno = "" OR isnull(ls_chno) THEN		
		ls_chno = '%'
	END IF
	
IF dw_detail.RowCount() < 1 THEN 
	il_rows = dw_detail.retrieve(ls_style, ls_chno)
	
END IF 

dw_detail.visible = True
end event

type dw_print from w_com010_d`dw_print within w_53023_d
string dataobject = "d_53023_r01"
end type

type dw_detail from datawindow within w_53023_d
boolean visible = false
integer x = 1051
integer width = 1879
integer height = 1972
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "품번조회"
string dataobject = "d_style_pic"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

