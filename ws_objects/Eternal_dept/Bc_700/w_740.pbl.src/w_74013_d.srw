$PBExportHeader$w_74013_d.srw
$PBExportComments$매장 고객별 구매조회
forward
global type w_74013_d from w_com010_d
end type
end forward

global type w_74013_d from w_com010_d
integer height = 2340
end type
global w_74013_d w_74013_d

type variables
DataWindowChild idw_brand, idw_year, idw_season, idw_area, idw_shop_div

String is_style, is_fr_ymd, is_to_ymd, is_brand, is_year, is_season, is_area, is_shop_div, is_shop_cd, is_vip

end variables

on w_74013_d.create
call super::create
end on

on w_74013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_year, is_season,is_area,is_shop_div,is_shop_cd, is_vip)

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
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
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

is_style = Trim(dw_head.GetItemString(1, "style"))

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"판매 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

if is_to_ymd < is_fr_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   return false
end if

is_brand = "W"

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

is_area = Trim(dw_head.GetItemString(1, "area"))
if IsNull(is_area) or is_area = "" then
   MessageBox(ls_title,"지역 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("area")
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
is_vip = Trim(dw_head.GetItemString(1, "vip"))
return true

end event

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.04.08                                                  */	
/* 수정일      : 2002.04.08                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_vip

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF


if is_vip = '2' then
	ls_vip = 'VIP 회원'
else 
	ls_vip = '전체회원'
end if


ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_yymmdd.Text   = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_year.Text     = '" + idw_year.GetItemString(idw_year.GetRow(), "inter_display") + "'" + &
            "t_season.Text   = '" + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
				"t_vip.Text = '" + ls_vip + "'"

dw_print.Modify(ls_modify)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징                                        */	
/* 작성일      : 2002.04.16                                                  */	
/* 수정일      : 2002.04.16                                                  */
/*===========================================================================*/
String     ls_shop_nm,ls_style, ls_chno
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
			gst_cd.default_where   = "WHERE  brand like '" + "W"  +  "%'" + &
			                         "  AND  Shop_Stat = '00' " + &
											 "  AND  SHOP_DIV IN ('G', 'K') "			
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
//				dw_head.SetColumn("end_ymd")
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

event open;call super::open;dw_head.Setitem(1,"year","%")
dw_head.Setitem(1,"season","%")
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_74013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_74013_d
end type

type cb_delete from w_com010_d`cb_delete within w_74013_d
end type

type cb_insert from w_com010_d`cb_insert within w_74013_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_74013_d
end type

type cb_update from w_com010_d`cb_update within w_74013_d
end type

type cb_print from w_com010_d`cb_print within w_74013_d
end type

type cb_preview from w_com010_d`cb_preview within w_74013_d
integer width = 384
end type

type gb_button from w_com010_d`gb_button within w_74013_d
end type

type cb_excel from w_com010_d`cb_excel within w_74013_d
integer x = 2153
end type

type dw_head from w_com010_d`dw_head within w_74013_d
integer height = 196
string dataobject = "d_74013_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '%')
idw_brand.SetItem(1, "inter_nm", '전체')

This.GetChild("year", idw_year)
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.InsertRow(1)
idw_year.SetItem(1, "inter_cd", '%')
idw_year.SetItem(1, "inter_nm", '전체')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.InsertRow(1)
idw_season.SetItem(1, "inter_cd", '%')
idw_season.SetItem(1, "inter_nm", '전체')

This.GetChild("area", idw_area)
idw_area.SetTransObject(SQLCA)
idw_area.Retrieve('090')
idw_area.InsertRow(1)
idw_area.SetItem(1, "inter_cd", '%')
idw_area.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)보끄레머천다이징(김종호)                                */	
/* 작성일      : 2002.01.05                                                  */	
/* 수정일      : 2002.01.05                                                  */
/* event       : itemchanged(dw_head)                                        */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

CHOOSE CASE dwo.name
	CASE "style"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_74013_d
integer beginy = 384
integer endy = 384
end type

type ln_2 from w_com010_d`ln_2 within w_74013_d
integer beginx = 5
integer beginy = 380
integer endx = 3625
integer endy = 380
end type

type dw_body from w_com010_d`dw_body within w_74013_d
integer y = 400
integer height = 1716
string dataobject = "d_74013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_74013_d
integer height = 588
string dataobject = "d_74013_r01"
end type

