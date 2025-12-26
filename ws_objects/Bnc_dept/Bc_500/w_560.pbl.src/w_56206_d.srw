$PBExportHeader$w_56206_d.srw
$PBExportComments$매장/월별 외상채권 현황
forward
global type w_56206_d from w_com010_d
end type
end forward

global type w_56206_d from w_com010_d
integer width = 3685
integer height = 2280
end type
global w_56206_d w_56206_d

type variables
String is_yymm_st, is_yymm_ed, is_brand, is_shop_cd
DataWindowChild idw_brand
end variables

on w_56206_d.create
call super::create
end on

on w_56206_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

IF TRIGGER EVENT ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_yymm_st, is_yymm_ed, is_brand, is_shop_cd)

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
/* 작성자      : 지우정보 (김진백)                                           */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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

is_yymm_st = Trim(String(dw_head.GetItemDateTime(1, "fr_yymm"),'yyyymm'))
IF IsNull(is_yymm_st) OR is_yymm_st = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_yymm")
   RETURN FALSE 
END IF

is_yymm_ed = Trim(String(dw_head.GetItemDateTime(1, "to_yymm"),'yyyymm'))
IF IsNull(is_yymm_ed) OR is_yymm_ed = "" THEN
   MessageBox(ls_title,"기준 년월을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   RETURN FALSE 
END IF

IF is_yymm_st > is_yymm_ed THEN
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_yymm")
   RETURN FALSE 
END IF

//IF DaysAfter(Date(String(is_yymm_st + '01', "@@@@/@@/@@")), Date(String(is_yymm_ed + '01', "@@@@/@@/@@"))) > 360 then
//	MessageBox("오류","기간이 1년을 넘었습니다!")
//   dw_head.SetFocus()
//   dw_head.SetColumn("to_yymm")
//	RETURN FALSE 
//END IF

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
IF IsNull(is_shop_cd) OR is_shop_cd = "" THEN is_shop_cd = is_brand + '%'

RETURN TRUE

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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
//			If Left(as_data, 1) <> ls_brand Then
//				MessageBox("입력오류", "브랜드가 다릅니다!")
//				dw_head.SetItem(al_row, "shop_cd", "")
//				dw_head.SetItem(al_row, "shop_nm", "")
//				RETURN 1
//			END IF
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = "WHERE BRAND = '" + ls_brand + "'" // SHOP_STAT = '00' "
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
			cb_retrieve.SetFocus()
//			dw_head.SetColumn("shop_cd")
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

IF is_shop_cd = is_brand + '%' THEN
	ls_shop_nm = '% 전체'
ELSE
	ls_shop_nm = is_shop_cd + " " + dw_head.GetItemString(1, "shop_nm")
END IF

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id    + "'" + &
            "t_user_id.Text   = '" + gs_user_id   + "'" + &
            "t_datetime.Text  = '" + ls_datetime  + "'" + &
            "t_yymm_st.Text   = '" + String(is_yymm_st, '@@@@/@@') + "'" + &
            "t_yymm_ed.Text   = '" + String(is_yymm_ed, '@@@@/@@') + "'" + &
				"t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_shop_cd.Text   = '" + ls_shop_nm + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56206_d","0")
end event

type cb_close from w_com010_d`cb_close within w_56206_d
end type

type cb_delete from w_com010_d`cb_delete within w_56206_d
end type

type cb_insert from w_com010_d`cb_insert within w_56206_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_56206_d
end type

type cb_update from w_com010_d`cb_update within w_56206_d
end type

type cb_print from w_com010_d`cb_print within w_56206_d
end type

type cb_preview from w_com010_d`cb_preview within w_56206_d
end type

type gb_button from w_com010_d`gb_button within w_56206_d
end type

type cb_excel from w_com010_d`cb_excel within w_56206_d
end type

type dw_head from w_com010_d`dw_head within w_56206_d
integer x = 18
integer y = 180
integer height = 144
string dataobject = "d_56206_h01"
end type

event dw_head::constructor;call super::constructor;THIS.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김진백)                                       */	
/* 작성일      : 2002.02.07                                                  */	
/* 수정일      : 2002.02.07                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		dw_head.SetItem(1, "shop_cd", "")
		dw_head.SetItem(1, "shop_nm", "")
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)	
		
END CHOOSE

end event

type ln_1 from w_com010_d`ln_1 within w_56206_d
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com010_d`ln_2 within w_56206_d
integer beginy = 356
integer endy = 356
end type

type dw_body from w_com010_d`dw_body within w_56206_d
integer x = 9
integer y = 372
integer width = 3593
integer height = 1672
string dataobject = "d_56206_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

type dw_print from w_com010_d`dw_print within w_56206_d
string dataobject = "d_56206_r01"
end type

