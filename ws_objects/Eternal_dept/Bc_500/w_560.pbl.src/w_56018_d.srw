$PBExportHeader$w_56018_d.srw
$PBExportComments$매장행사기획진행조회
forward
global type w_56018_d from w_com010_d
end type
end forward

global type w_56018_d from w_com010_d
integer width = 3675
integer height = 2272
end type
global w_56018_d w_56018_d

type variables
DataWindowChild idw_brand, idw_shop_type, idw_year, idw_season, idw_color, idw_size
String  is_brand, is_shop_cd, is_shop_type, is_frm_ymd, is_to_ymd, is_opt_gubn
String  is_year, is_season, is_dotcom
end variables

on w_56018_d.create
call super::create
end on

on w_56018_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56018_d","0")
end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_date" , MidA(string(ld_datetime,"yyyymmdd"),1,6) + '01')
dw_head.SetItem(1, "to_date"  ,string(ld_datetime,"yyyymmdd"))
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_shop_type = dw_head.GetItemString(1, "shop_type")
if IsNull(is_shop_type) or Trim(is_shop_type) = "" then
   MessageBox(ls_title,"매장형태를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   return false
end if

is_frm_ymd = dw_head.GetItemString(1, "frm_date")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
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

is_opt_gubn = dw_head.GetItemString(1, "opt_gubn")
if IsNull(is_opt_gubn) or Trim(is_opt_gubn) = "" then
   MessageBox(ls_title,"조회기준을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("opt_gubn")
   return false
end if

is_dotcom = dw_head.GetItemString(1, "dotcom")

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				if gs_brand <> 'K' then
					IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
						dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
						RETURN 0
					END IF 
				end if
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE Shop_Stat = '00' " + &
			                         " and brand = '" + gs_brand + "'"
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// exec sp_56018_d01 'n','ng0006','3','2003','m','20030101','20030722', 's'

il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_shop_type, is_year, is_season, is_frm_ymd, is_to_ymd, is_opt_gubn ,is_dotcom)
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

event ue_title();call super::ue_title;
datetime ld_datetime
string   ls_modify, ls_datetime, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_shop_nm  = dw_head.getitemstring(1,"shop_nm")


ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 
				"t_shop_cd.Text  = '" + is_shop_cd + "'" + &
				"t_shop_nm.Text  = '" + ls_shop_nm + "'" + &				
				"t_frm_ymd.Text  = '" + String(is_frm_ymd , "@@@@/@@/@@") + "'" + &
				"t_to_ymd.Text   = '" + String(is_to_ymd , "@@@@/@@/@@") + "'" + &				
				"t_brand.Text    = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_shop_type.Text    = '" + idw_shop_type.GetitemString(idw_shop_type.GetRow(), "inter_display") + "'" + &				
				"t_year.Text     = '" + is_year + "'"  + &								
				"t_season.Text   = '" + idw_season.GetitemString(idw_season.GetRow(), "inter_display") + "'" 


dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_d`cb_close within w_56018_d
end type

type cb_delete from w_com010_d`cb_delete within w_56018_d
end type

type cb_insert from w_com010_d`cb_insert within w_56018_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56018_d
end type

type cb_update from w_com010_d`cb_update within w_56018_d
end type

type cb_print from w_com010_d`cb_print within w_56018_d
end type

type cb_preview from w_com010_d`cb_preview within w_56018_d
end type

type gb_button from w_com010_d`gb_button within w_56018_d
end type

type cb_excel from w_com010_d`cb_excel within w_56018_d
end type

type dw_head from w_com010_d`dw_head within w_56018_d
integer y = 164
integer height = 260
string dataobject = "d_56018_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.SetFilter("inter_cd >= '3'")
idw_shop_type.Filter()

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
end event

event dw_head::itemchanged;call super::itemchanged;String ls_year, ls_brand
DataWindowChild ldw_child

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	
	CASE "brand"
		IF ib_itemchanged THEN RETURN 1
		
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

type ln_1 from w_com010_d`ln_1 within w_56018_d
end type

type ln_2 from w_com010_d`ln_2 within w_56018_d
end type

type dw_body from w_com010_d`dw_body within w_56018_d
string dataobject = "d_56018_d01"
end type

event dw_body::constructor;call super::constructor;
This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.Retrieve('%')

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.Retrieve('%')
end event

type dw_print from w_com010_d`dw_print within w_56018_d
string dataobject = "d_56018_r01"
end type

