$PBExportHeader$w_56013_d.srw
$PBExportComments$매출대장(일자별집계)
forward
global type w_56013_d from w_com010_d
end type
end forward

global type w_56013_d from w_com010_d
integer width = 3675
integer height = 2284
end type
global w_56013_d w_56013_d

type variables
DataWindowChild idw_brand, idw_season, idw_jup_gubn, idw_shop_type, idw_house_cd

String is_brand, is_year,    is_season,    is_jup_gubn, is_flag
String is_yymm,  is_shop_cd, is_shop_type, is_house_cd, is_to_yymm

end variables

on w_56013_d.create
call super::create
end on

on w_56013_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.Setitem(1, "year",      '')
dw_head.Setitem(1, "season",    '%')
dw_head.Setitem(1, "jup_gubn",  '%')
dw_head.Setitem(1, "flag",      '%')
dw_head.Setitem(1, "house_cd",  '%')
dw_head.Setitem(1, "shop_type", '%')

dw_head.SetColumn("year")
dw_head.SetColumn("season")
dw_head.SetColumn("jup_gubn")
dw_head.SetColumn("flag")
dw_head.SetColumn("house_cd")
dw_head.SetColumn("shop_type")

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.31                                                  */	
/* 수정일      : 2002.05.31                                                  */
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

is_shop_cd   = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_year  = dw_head.GetItemString(1, "year")
if IsNull(is_year) or Trim(is_year) = "" then
	is_year = '%'
end if

is_season    = dw_head.GetItemString(1, "season")
is_jup_gubn     = dw_head.GetItemString(1, "jup_gubn")
is_flag      = dw_head.GetItemString(1, "flag")
is_shop_type = dw_head.GetItemString(1, "shop_type")
is_house_cd      = dw_head.GetItemString(1, "house_cd")

is_yymm       = String(dw_head.GetItemDateTime(1, "yymm"), "yyyymm")
is_to_yymm    = String(dw_head.GetItemDateTime(1, "to_yymm"), "yyyymm")

return true

end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.31                                                  */	
/* 수정일      : 2002.05.31                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm, is_to_yymm, is_shop_cd, is_shop_type, is_brand, &
                           is_year, is_season,  is_jup_gubn,  is_flag, is_house_cd)
									
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

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.12.18                                                  */	
/* 수정일      : 2001.12.18                                                  */
/*===========================================================================*/
String     ls_shop_nm 
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
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' " + & 
											 "  AND shop_seq  < '5000'"
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event ue_title;call super::ue_title;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.05.31                                                  */	
/* 수정일      : 2002.05.31                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_year, ls_flag

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")
IF is_year = '%' THEN 
   ls_year = "전체"
ELSE 
   ls_year = is_year + '년도'
END IF

If is_flag = '1' Then
	ls_flag = '출고'
ElseIf is_flag = '2' Then
	ls_flag = '반품'
Else
	ls_flag = '전체'
End If

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text    = '브랜드 : " + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymm.Text     = '년  월 : " + String(is_yymm, '@@@@/@@') + "'" + &
            "t_shop.Text = '매  장 : [" + is_shop_cd + "] " + dw_head.GetitemString(1, "shop_nm") + "'" + &
				"t_shop_type.Text = '매장형태 : " + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'" + &
				"t_year.Text = '년  도 : " + ls_year + "'" + &
				"t_season.Text = '시  즌 : " + idw_season.GetItemString(idw_season.GetRow(), "inter_display") + "'" + &
				"t_jup_gubn.Text = '전표구분 : " + idw_jup_gubn.GetItemString(idw_jup_gubn.GetRow(), "inter_display") + "'" + &
				"t_flag.Text = '조회구분 : " + ls_flag + "'" + &
				"t_house_cd.Text = '창  고 : " + idw_house_cd.GetItemString(idw_house_cd.GetRow(), "shop_display") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56013_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56013_d
end type

type cb_delete from w_com010_d`cb_delete within w_56013_d
end type

type cb_insert from w_com010_d`cb_insert within w_56013_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56013_d
end type

type cb_update from w_com010_d`cb_update within w_56013_d
end type

type cb_print from w_com010_d`cb_print within w_56013_d
end type

type cb_preview from w_com010_d`cb_preview within w_56013_d
end type

type gb_button from w_com010_d`gb_button within w_56013_d
end type

type cb_excel from w_com010_d`cb_excel within w_56013_d
boolean visible = false
end type

type dw_head from w_com010_d`dw_head within w_56013_d
integer height = 320
string dataobject = "d_56013_h01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003', gs_brand, '%')
idw_season.insertRow(1)
idw_season.Setitem(1, "inter_cd", '%')
idw_season.Setitem(1, "inter_nm", '전체')

This.GetChild("jup_gubn", idw_jup_gubn)
idw_jup_gubn.SetTransObject(SQLCA)
idw_jup_gubn.Retrieve('025')
idw_jup_gubn.insertRow(1)
idw_jup_gubn.Setitem(1, "inter_cd", '%')
idw_jup_gubn.Setitem(1, "inter_nm", '전체')

This.GetChild("house_cd", idw_house_cd)
idw_house_cd.SetTransObject(SQLCA)
idw_house_cd.Retrieve()
idw_house_cd.insertRow(1)
idw_house_cd.Setitem(1, "shop_cd", '%')
idw_house_cd.Setitem(1, "shop_snm", '전체')

This.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.insertRow(1)
idw_shop_type.Setitem(1, "inter_cd", '%')
idw_shop_type.Setitem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.05.31                                                  */	
/* 수정일      : 2002.05.31                                                  */
/*===========================================================================*/
String ls_year, ls_brand
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

type ln_1 from w_com010_d`ln_1 within w_56013_d
integer beginy = 520
integer endy = 520
end type

type ln_2 from w_com010_d`ln_2 within w_56013_d
integer beginy = 524
integer endy = 524
end type

type dw_body from w_com010_d`dw_body within w_56013_d
integer y = 540
integer height = 1500
string dataobject = "d_56013_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56013_d
string dataobject = "d_56013_r01"
end type

