$PBExportHeader$w_54021_e.srw
$PBExportComments$RT 회전율
forward
global type w_54021_e from w_com010_e
end type
end forward

global type w_54021_e from w_com010_e
integer width = 3685
integer height = 2260
end type
global w_54021_e w_54021_e

type variables
DataWindowChild idw_brand, idw_year, idw_season
String is_brand, is_frm_ymd, is_to_ymd, is_year, is_season

end variables

on w_54021_e.create
call super::create
end on

on w_54021_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime


IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "frm_ymd",string(ld_datetime, "yyyymmdd"))
dw_head.SetItem(1, "to_ymd",string(ld_datetime, "yyyymmdd"))

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

is_frm_ymd = dw_head.GetItemString(1, "frm_ymd")
if IsNull(is_frm_ymd) or Trim(is_frm_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("frm_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"종료일자를 입력하십시요!")
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

return true
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
			gst_cd.default_where   = "WHERE Shop_Stat = '00' "
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
				dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_nm"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("end_ymd")
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
Long     i
Dec      ldc_rate
String   ls_deal
dwobject ldw_object

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

// '20031101', '20031130' , 'n', '%', '%'

//messagebox("", is_frm_ymd + '/' + is_to_ymd + '/' + is_brand + '/' + is_year + '/' + is_season )

dw_body.setredraw(False)
il_rows = dw_body.retrieve(is_frm_ymd, is_to_ymd, is_brand, is_year, is_season)


FOR i = 1 TO il_rows 
	ldc_rate = dw_body.GetitemDecimal(i, "deal_rate")
	ls_deal = dw_body.GetitemString(i, "deal_Type") 
	IF isnull(ls_deal) THEN 
      dw_body.SetItem(i, "deal_type", "X")
      dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	END IF
NEXT 



dw_body.Setredraw(True)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.25                                                  */	
/* 수정일      : 2002.01.25                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF
dw_body.setredraw(False)


FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "deal_typ", 'X')
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */ 
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if



dw_body.setredraw(True)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_54021_e","0")
end event

type cb_close from w_com010_e`cb_close within w_54021_e
end type

type cb_delete from w_com010_e`cb_delete within w_54021_e
end type

type cb_insert from w_com010_e`cb_insert within w_54021_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_54021_e
end type

type cb_update from w_com010_e`cb_update within w_54021_e
end type

type cb_print from w_com010_e`cb_print within w_54021_e
end type

type cb_preview from w_com010_e`cb_preview within w_54021_e
end type

type gb_button from w_com010_e`gb_button within w_54021_e
end type

type cb_excel from w_com010_e`cb_excel within w_54021_e
end type

type dw_head from w_com010_e`dw_head within w_54021_e
integer y = 160
integer height = 164
string dataobject = "d_54021_h01"
end type

event dw_head::constructor;call super::constructor;
This.GetChild("brand", idw_brand )
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("year", idw_year )
idw_year.SetTransObject(SQLCA)
idw_year.Retrieve('002')
idw_year.insertrow(1)
idw_year.setitem(1, "inter_cd","%")
idw_year.setitem(1, "inter_cd1","%")
idw_year.setitem(1, "inter_nm","전체")

This.GetChild("season", idw_season )
idw_season.SetTransObject(SQLCA)
idw_season.Retrieve('003')
idw_season.insertrow(1)
idw_season.setitem(1, "inter_cd","%")
idw_season.setitem(1, "inter_nm","전체")


end event

type ln_1 from w_com010_e`ln_1 within w_54021_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_54021_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_54021_e
integer x = 14
integer y = 348
integer height = 1680
string dataobject = "d_54021_d01"
end type

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_54021_e
end type

