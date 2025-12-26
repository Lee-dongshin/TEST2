$PBExportHeader$w_54019_d.srw
$PBExportComments$부분RT현황조회
forward
global type w_54019_d from w_com010_d
end type
end forward

global type w_54019_d from w_com010_d
end type
global w_54019_d w_54019_d

type variables
DataWindowChild	idw_brand, idw_shop_type
String is_fr_ymd, is_to_ymd, is_style, is_fr_shop_cd, is_to_shop_cd, is_brand, is_shop_type, is_opt
end variables

on w_54019_d.create
call super::create
end on

on w_54019_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm, ls_style, ls_chno
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fr_shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "fr_shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "fr_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND     = '" + is_brand + "' " + &
			                         "  AND SHOP_STAT = '00' "
			
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
				dw_head.SetItem(al_row, "fr_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "fr_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("to_shop_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "to_shop_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "to_shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "to_shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND     = '" + is_brand + "' " + &
			                         "  AND SHOP_STAT = '00' "
			
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
				dw_head.SetItem(al_row, "to_shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "to_shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
	CASE "style"	
		
//		   IF ai_div = 1 THEN 	
//				If IsNull(as_data) or Trim(as_data) = "" Then
//				   dw_head.SetItem(al_row, "style", "")
//					RETURN 0
//				END IF     
//			END IF
			
 	   	IF ai_div = 1 THEN 	
				RETURN 0 
			END IF
			
			
			   gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "STYLE 코드 검색" 
				gst_cd.datawindow_nm   = "d_com010" 
				gst_cd.default_where   = ""		
				if gs_brand <> 'K' then
					IF Trim(as_data) <> "" THEN
						gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8) + "%' "
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
				ls_style = lds_Source.GetItemString(1,"style")

				dw_head.SetItem(al_row, "style", ls_style)
				
				/* 다음컬럼으로 이동 */
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
			

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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




is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"조회 시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"조회 마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = '%'
end if

is_fr_shop_cd = dw_head.GetItemString(1, "fr_shop_cd")
if IsNull(is_fr_shop_cd) or Trim(is_fr_shop_cd) = "" then
	is_fr_shop_cd = '%'
end if

is_to_shop_cd = dw_head.GetItemString(1, "to_shop_cd")
if IsNull(is_to_shop_cd) or Trim(is_to_shop_cd) = "" then
	is_to_shop_cd = '%'
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")

is_opt = dw_head.GetItemString(1, "opt")


return true

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54019_e","0")
end event

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "fr_ymd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_ymd",string(ld_datetime, "yyyymmdd"))



end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//exec sp_54019_d01 '20031117', '20031119' , '%', '%' ,'n', '%'


if is_opt = 'Y' then
	dw_body.DataObject = "d_54019_d02" 		
else 
  dw_body.DataObject = "d_54019_d01" 		
end if

	dw_body.SetTransObject(SQLCA)


il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_fr_shop_cd, is_to_shop_cd, is_brand, is_style, is_shop_type)
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

type cb_close from w_com010_d`cb_close within w_54019_d
end type

type cb_delete from w_com010_d`cb_delete within w_54019_d
end type

type cb_insert from w_com010_d`cb_insert within w_54019_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_54019_d
end type

type cb_update from w_com010_d`cb_update within w_54019_d
end type

type cb_print from w_com010_d`cb_print within w_54019_d
boolean visible = false
end type

type cb_preview from w_com010_d`cb_preview within w_54019_d
boolean visible = false
end type

type gb_button from w_com010_d`gb_button within w_54019_d
end type

type cb_excel from w_com010_d`cb_excel within w_54019_d
end type

type dw_head from w_com010_d`dw_head within w_54019_d
integer x = 50
integer y = 180
integer width = 3515
integer height = 232
string dataobject = "d_54019_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;String ls_fr_shop_type

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "fr_shop_cd", "")
		This.SetItem(row, "fr_shop_nm", "")
		This.SetItem(row, "to_shop_cd", "")
		This.SetItem(row, "to_shop_nm", "")
			
	CASE "fr_shop_cd", "to_shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)

	CASE "style"							     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_54019_d
end type

type ln_2 from w_com010_d`ln_2 within w_54019_d
end type

type dw_body from w_com010_d`dw_body within w_54019_d
integer y = 464
integer width = 3561
integer height = 1536
string dataobject = "d_54019_d01"
end type

type dw_print from w_com010_d`dw_print within w_54019_d
end type

