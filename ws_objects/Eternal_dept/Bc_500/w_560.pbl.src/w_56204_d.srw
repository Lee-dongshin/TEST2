$PBExportHeader$w_56204_d.srw
$PBExportComments$매장/일별 매출 관리대장
forward
global type w_56204_d from w_com010_d
end type
end forward

global type w_56204_d from w_com010_d
integer width = 3675
integer height = 2276
end type
global w_56204_d w_56204_d

type variables
String is_brand, is_shop_cd, is_shop_type, is_yymmdd_st, is_yymmdd_ed, is_year, is_season
DataWindowChild idw_brand, idw_season, idw_shop_type
end variables

on w_56204_d.create
call super::create
end on

on w_56204_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/

IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_shop_cd, is_shop_type, is_yymmdd_st, is_yymmdd_ed, is_year, is_season)

IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

THIS.TRIGGER EVENT ue_button(1, il_rows)
THIS.TRIGGER EVENT ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
String ls_title

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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE 
END IF

is_yymmdd_st = Trim(String(dw_head.GetItemDate(1, "fr_ymd"),'yyyymmdd'))
IF IsNull(is_yymmdd_st) OR is_yymmdd_st = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   RETURN FALSE 
END IF

is_yymmdd_ed = Trim(String(dw_head.GetItemDate(1, "to_ymd"),'yyyymmdd'))
IF IsNull(is_yymmdd_ed) OR is_yymmdd_ed = "" THEN
   MessageBox(ls_title,"기준 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
   RETURN FALSE 
END IF

IF is_yymmdd_st > is_yymmdd_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd_ed")
   RETURN FALSE 
END IF

IF DaysAfter(Date(String(is_yymmdd_st, "@@@@/@@/@@")), Date(String(is_yymmdd_ed, "@@@@/@@/@@"))) > 59 then
	MessageBox(ls_title,"기간이 60일을 넘었습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd_st")
	RETURN FALSE 
END IF

is_year = Trim(dw_head.GetItemString(1, "year"))
IF IsNull(is_year) OR is_year = "" THEN
   MessageBox(ls_title,"시즌 년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   RETURN FALSE
END IF

is_season = Trim(dw_head.GetItemString(1, "season"))
IF IsNull(is_season) OR is_season = "" THEN
   MessageBox(ls_title,"시즌 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   RETURN FALSE
END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = '%'

is_shop_type = Trim(dw_head.GetItemString(1, "shop_type"))
IF IsNull(is_shop_type) OR is_shop_type = "" THEN
   MessageBox(ls_title,"매장 형태를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_type")
   RETURN FALSE 
END IF

RETURN TRUE

end event

event ue_popup;call super::ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.01.21                                                  */	
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
String    ls_shop_nm, ls_brand, ls_shop_div
Boolean   lb_check 
DataStore lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		ls_brand = Trim(dw_head.GetItemString(1, "brand"))
		IF ai_div = 1 THEN
			IF IsNull(as_data) or Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 0
			END IF 
			If LeftA(as_data, 1) <> ls_brand Then
				MessageBox("입력오류", "브랜드가 다릅니다!")
				dw_head.SetItem(al_row, "shop_cd", "")
				dw_head.SetItem(al_row, "shop_nm", "")
				RETURN 1
			END IF
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "' AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = CREATE DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = TRUE
			lds_Source = Message.PowerObjectParm
			dw_head.SetRow(al_row)
			dw_head.SetColumn(as_column)
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("shop_type")
			ib_itemchanged = FALSE 
			lb_check = TRUE
		ELSE
			lb_check = FALSE
		END IF
		DESTROY  lds_Source
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

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.05                                                  */	
/* 수정일      : 2002.02.05                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_sale_type, ls_shop_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime  = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

IF is_shop_cd = '%' THEN
	ls_shop_nm = '전체'
ELSE
	ls_shop_nm = dw_head.GetItemString(1, "shop_nm")
END IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymmdd_st.Text = '" + String(is_yymmdd_st, '@@@@/@@/@@') + "'" + &
            "t_yymmdd_ed.Text = '" + String(is_yymmdd_ed, '@@@@/@@/@@') + "'" + &
            "t_year.Text      = '" + is_year      + "'" + &
            "t_shop_cd.Text   = '" + is_shop_cd   + "'" + &
            "t_shop_nm.Text   = '" + ls_shop_nm   + "'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(),         "inter_display") + "'" + &
            "t_season.Text    = '" + idw_season.GetItemString(idw_season.GetRow(),       "inter_display") + "'" + &
            "t_shop_type.Text = '" + idw_shop_type.GetItemString(idw_shop_type.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56204_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56204_d
end type

type cb_delete from w_com010_d`cb_delete within w_56204_d
end type

type cb_insert from w_com010_d`cb_insert within w_56204_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56204_d
end type

type cb_update from w_com010_d`cb_update within w_56204_d
end type

type cb_print from w_com010_d`cb_print within w_56204_d
end type

type cb_preview from w_com010_d`cb_preview within w_56204_d
end type

type gb_button from w_com010_d`gb_button within w_56204_d
end type

type cb_excel from w_com010_d`cb_excel within w_56204_d
end type

type dw_head from w_com010_d`dw_head within w_56204_d
integer height = 224
string dataobject = "d_56204_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("season", idw_season)
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')

THIS.GetChild("shop_type", idw_shop_type)
idw_shop_type.SetTransObject(SQLCA)
idw_shop_type.Retrieve('911')
idw_shop_type.InsertRow(1)
idw_shop_type.SetItem(1, "inter_cd", '%')
idw_shop_type.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */
/* 작성일      : 2002.01.21                                                  */
/* 수정일      : 2002.01.21                                                  */
/*===========================================================================*/
CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목
		IF ib_itemchanged THEN RETURN 1
		RETURN PARENT.TRIGGER EVENT ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56204_d
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_d`ln_2 within w_56204_d
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_d`dw_body within w_56204_d
integer y = 444
integer height = 1596
string dataobject = "d_56204_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56204_d
string dataobject = "d_56204_r01"
end type

