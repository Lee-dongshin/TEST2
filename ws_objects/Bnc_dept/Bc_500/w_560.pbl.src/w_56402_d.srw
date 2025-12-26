$PBExportHeader$w_56402_d.srw
$PBExportComments$모바일쿠폰 사용내역
forward
global type w_56402_d from w_com010_d
end type
end forward

global type w_56402_d from w_com010_d
end type
global w_56402_d w_56402_d

type variables
String is_brand, is_FRM_DATE, IS_TO_DATE, is_shop_div, is_shop_cd , is_use_gubn, is_coupon_gubn
DataWindowChild idw_brand, idw_shop_div
end variables

on w_56402_d.create
call super::create
end on

on w_56402_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/

IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_FRM_DATE, IS_TO_DATE, is_shop_div, is_shop_cd, is_use_gubn, is_coupon_gubn)

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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
IF IsNull(is_brand) OR is_brand = "" THEN
   MessageBox(ls_title,"브랜드 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   RETURN FALSE
END IF

is_FRM_DATE = dw_head.GetItemsTRING(1, "FRM_DATE")
IF IsNull(is_FRM_DATE) OR is_FRM_DATE = "" THEN
   MessageBox(ls_title,"시작 년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("FRM_DATE")
   RETURN FALSE
END IF

is_TO_DATE = dw_head.GetItemSTRING(1, "TO_DATE")
IF IsNull(is_TO_DATE) OR is_TO_DATE = "" THEN
   MessageBox(ls_title,"종료 년월일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("TO_DATE")
   RETURN FALSE
END IF

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
IF IsNull(is_shop_div) OR is_shop_div = "" THEN
   MessageBox(ls_title,"유통망 코드를 선택하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_div")
   RETURN FALSE
END IF

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN 
	is_shop_cd = '%'
END IF

is_use_gubn = dw_head.GetItemString(1, "use_gubn")
IF IsNull(is_use_gubn) OR is_use_gubn = "" THEN 
	is_use_gubn = '%'
END IF

is_coupon_gubn = dw_head.GetItemString(1, "coupon_gubn")
IF IsNull(is_use_gubn) OR is_coupon_gubn = "" THEN 
	is_coupon_gubn = '%'
END IF


RETURN TRUE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : 지우정보(김진백)                                            */	
/* 작성일      : 2002.02.04                                                  */	
/* 수정일      : 2002.02.04                                                  */
/*===========================================================================*/
DateTime ld_datetime
String ls_modify, ls_datetime, ls_shop_div

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text    = '" + is_pgm_id  + "'" + &
            "t_user_id.Text  = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_yymm.Text     = '" + String(is_FRM_DATE, '@@@@/@@/@@') + "'" + &
            "t_yymm1.Text    = '" + String(is_TO_DATE, '@@@@/@@/@@') + "'" + &				
            "t_brand.Text    = '" + idw_brand.GetItemString(idw_brand.GetRow(),       "inter_display") + "'" + &
            "t_shop_div.Text = '" + idw_shop_div.GetItemString(idw_shop_div.GetRow(), "inter_display") + "'"

dw_print.Modify(ls_modify)

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

event open;call super::open;/*===========================================================================*/
DateTime ld_datetime
String ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "YYYYMMDD")


dw_head.Setitem(1, "FRM_DATE", ls_datetime )
dw_head.Setitem(1, "TO_DATE", ls_datetime)
dw_head.Setitem(1, "shop_div", '%')

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56201_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56402_d
end type

type cb_delete from w_com010_d`cb_delete within w_56402_d
end type

type cb_insert from w_com010_d`cb_insert within w_56402_d
boolean enabled = false
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56402_d
end type

type cb_update from w_com010_d`cb_update within w_56402_d
end type

type cb_print from w_com010_d`cb_print within w_56402_d
end type

type cb_preview from w_com010_d`cb_preview within w_56402_d
end type

type gb_button from w_com010_d`gb_button within w_56402_d
end type

type cb_excel from w_com010_d`cb_excel within w_56402_d
end type

type dw_head from w_com010_d`dw_head within w_56402_d
integer y = 148
integer height = 200
string dataobject = "d_56402_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

THIS.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.06.03                                                  */	
/* 수정일      : 2002.06.03                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56402_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_56402_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_56402_d
integer x = 9
integer y = 376
integer width = 3593
integer height = 1668
string dataobject = "d_56402_d01"
boolean hscrollbar = true
end type

type dw_print from w_com010_d`dw_print within w_56402_d
integer height = 240
string dataobject = "d_56402_r01"
end type

