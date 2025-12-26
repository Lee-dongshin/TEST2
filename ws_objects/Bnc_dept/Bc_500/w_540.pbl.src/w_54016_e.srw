$PBExportHeader$w_54016_e.srw
$PBExportComments$완불통제등록(스타일)
forward
global type w_54016_e from w_com010_e
end type
end forward

global type w_54016_e from w_com010_e
end type
global w_54016_e w_54016_e

type variables
DataWindowChild idw_brand, idw_year,idw_season, idw_color
string is_brand,  is_year, is_season

end variables

on w_54016_e.create
call super::create
end on

on w_54016_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_yymmdd
Boolean    lb_check 
datetime ld_datetime
DataStore  lds_Source

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")



CHOOSE CASE as_column
	
			CASE "style"							// 거래처 코드
				gst_cd.window_title    = "스타일 코드 검색" 
				gst_cd.datawindow_nm   = "d_com012" 
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

					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
            
				 
					dw_body.SetItem(al_row, "style", lds_Source.GetItemString(1,"style"))
					dw_body.SetItem(al_row, "chno",  lds_Source.GetItemString(1,"chno"))
					dw_body.SetItem(al_row, "color", lds_Source.GetItemString(1,"color"))
					dw_body.SetItem(al_row, "size",  lds_Source.GetItemString(1,"size"))
					dw_body.SetItem(al_row, "year",  lds_Source.GetItemString(1,"year"))
					dw_body.SetItem(al_row, "season",lds_Source.GetItemString(1,"season"))
					dw_body.SetItem(al_row, "brand", MidA(lds_Source.GetItemString(1,"style"),1,1))					
					
								
  					/* 다음컬럼으로 이동 */
					dw_body.SetItem(al_row, "fr_stop_date", ls_yymmdd)										  
					dw_body.SetItem(al_row, "to_stop_date", "99999999")										  					
					dw_body.SetColumn("fr_stop_date")
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

event ue_retrieve;call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_season)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

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
   MessageBox(ls_title,"년도 코드를 입력하십시요!")
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

return true

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54016_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54016_e
end type

type cb_delete from w_com010_e`cb_delete within w_54016_e
end type

type cb_insert from w_com010_e`cb_insert within w_54016_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54016_e
end type

type cb_update from w_com010_e`cb_update within w_54016_e
end type

type cb_print from w_com010_e`cb_print within w_54016_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_54016_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_54016_e
end type

type cb_excel from w_com010_e`cb_excel within w_54016_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_54016_e
integer y = 224
integer height = 156
string dataobject = "d_54016_h01"
end type

event dw_head::constructor;
This.GetChild("brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')

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


end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child



CHOOSE CASE dwo.name

	
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

type ln_1 from w_com010_e`ln_1 within w_54016_e
end type

type ln_2 from w_com010_e`ln_2 within w_54016_e
end type

type dw_body from w_com010_e`dw_body within w_54016_e
string dataobject = "d_54016_d01"
end type

event dw_body::constructor;
  This.GetChild("color", idw_color )
  idw_color.SetTransObject(SQLCA)
  idw_color.Retrieve('%')

end event

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	CASE "style" 
      IF ib_itemchanged THEN RETURN 1
      return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE


	
end event

event dw_body::clicked;call super::clicked;string ls_style
choose case dwo.name
	case "style"
		ls_style = this.getitemstring(row, "style")
		if ls_style <> "" then		gf_style_pic(ls_style,"%")
end choose
end event

type dw_print from w_com010_e`dw_print within w_54016_e
end type

