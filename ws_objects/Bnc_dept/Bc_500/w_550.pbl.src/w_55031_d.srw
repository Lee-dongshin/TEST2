$PBExportHeader$w_55031_d.srw
$PBExportComments$주차별입출판실적
forward
global type w_55031_d from w_com010_d
end type
end forward

global type w_55031_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_55031_d w_55031_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_sojae, idw_item
String is_fr_ymd, is_to_ymd, is_shop_cd, is_shop_type, is_brand, is_year, is_season, is_sojae, is_item
String is_order, is_plan_yn, is_bujin_yn
end variables

on w_55031_d.create
call super::create
end on

on w_55031_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
	is_shop_cd = "%"
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
is_year    = dw_head.GetItemString(1, "year")
is_season  = dw_head.GetItemString(1, "season")
is_sojae   = dw_head.GetItemString(1, "sojae")
is_item    = dw_head.GetItemString(1, "item")
is_order   = dw_head.GetItemString(1, "opt_remain")
is_plan_yn = dw_head.GetItemString(1, "plan_yn")
is_bujin_yn = dw_head.GetItemString(1, "bujin_yn")


is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
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



return true

end event

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_sojae, is_item, is_shop_type, is_shop_cd, is_order, is_plan_yn, is_bujin_yn)
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				   dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " //+ &
//			                         " and brand = '" + gs_brand + "'"
         if gs_brand <> 'K' then
				IF Trim(as_data) <> "" THEN
					gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
				ELSE
					gst_cd.Item_where = ""
				END IF
			else
				gst_cd.Item_where = ""
			end if
			
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("shop_type")
				ib_itemchanged = False 
				lb_check = TRUE 
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

event ue_title();call super::ue_title;datetime ld_datetime
string ls_modify, ls_datetime, ls_shop_nm, ls_shop_type, ls_plan_yn, ls_opt_remain

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

if is_shop_cd = "%" then 
	ls_shop_nm = "전체"
else
	ls_shop_nm = dw_head.getitemstring(1, "shop_nm")
end if	

if is_shop_type = "%" then
   ls_shop_type = "전체"
elseif is_shop_type = "0" then
   ls_shop_type = "전체(기타제외)"	
elseif is_shop_type = "1" then	
   ls_shop_type = "정상"	
elseif is_shop_type = "4" then	
   ls_shop_type = "행사"	
elseif is_shop_type = "9" then	
   ls_shop_type = "기타"	
end if	

	
if is_plan_yn = "%" then
   ls_plan_yn = "전체"
elseif is_plan_yn = "N" then	
   ls_plan_yn = "정상"
elseif is_plan_yn = "Y" then		
   ls_plan_yn = "기획"	
end if

if is_order = "%" then
	ls_opt_remain = "전체"
elseif is_order = "M" then	
	ls_opt_remain = "메인"
elseif is_order = "R" then		
	ls_opt_remain = "리오더"
elseif is_order = "S" then			
	ls_opt_remain = "스팟"	
end if		
	
	
ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'" + &
				 "t_fr_ymd.Text = '" + is_fr_ymd + "'" + &
 				 "t_to_ymd.Text = '" + is_to_ymd + "'" + &
 				 "t_shop_nm.Text = '" + ls_shop_nm + "'" + &				  
 				 "t_shop_type.Text = '" + ls_shop_type + "'" +	&		  				 				 
	          "t_plan_yn.Text = '" + ls_plan_yn + "'" + &				  				 				 				 
	          "t_opt_remain.Text = '" + ls_opt_remain + "'"	+ &				  				  
	          "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'"  + &				  
	          "t_year.Text = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_nm") + "'"  + &				  				 
	          "t_season.Text = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_nm") + "'" 				 
//				  

dw_print.Modify(ls_modify)

end event

type cb_close from w_com010_d`cb_close within w_55031_d
end type

type cb_delete from w_com010_d`cb_delete within w_55031_d
end type

type cb_insert from w_com010_d`cb_insert within w_55031_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_55031_d
end type

type cb_update from w_com010_d`cb_update within w_55031_d
end type

type cb_print from w_com010_d`cb_print within w_55031_d
end type

type cb_preview from w_com010_d`cb_preview within w_55031_d
end type

type gb_button from w_com010_d`gb_button within w_55031_d
end type

type cb_excel from w_com010_d`cb_excel within w_55031_d
end type

type dw_head from w_com010_d`dw_head within w_55031_d
integer y = 156
integer width = 3552
integer height = 284
string dataobject = "d_55031_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_cd1", '%')
idw_year.SetItem(1, "inter_nm", '전체')


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

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand, ls_bf_year
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
			
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
		THIS.GetChild("sojae", idw_sojae)
		idw_sojae.SetTransObject(SQLCA)
		idw_sojae.Retrieve('%', data)
		idw_sojae.InsertRow(1)
		idw_sojae.SetItem(1, "sojae", '%')
		idw_sojae.SetItem(1, "sojae_nm", '전체')
		
		THIS.GetChild("item", idw_item)
		idw_item.SetTransObject(SQLCA)
		idw_item.Retrieve( data )
		idw_item.InsertRow(1)
		idw_item.SetItem(1, "item", '%')
		idw_item.SetItem(1, "item_nm", '전체')
		
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

type ln_1 from w_com010_d`ln_1 within w_55031_d
end type

type ln_2 from w_com010_d`ln_2 within w_55031_d
end type

type dw_body from w_com010_d`dw_body within w_55031_d
integer y = 456
integer height = 1584
string dataobject = "d_55031_d01"
end type

type dw_print from w_com010_d`dw_print within w_55031_d
string dataobject = "d_55031_r01"
end type

