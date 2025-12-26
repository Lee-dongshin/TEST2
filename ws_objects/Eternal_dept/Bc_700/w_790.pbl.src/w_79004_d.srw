$PBExportHeader$w_79004_d.srw
$PBExportComments$A/S 의뢰/판정 현황
forward
global type w_79004_d from w_com010_d
end type
type dw_1 from datawindow within w_79004_d
end type
end forward

global type w_79004_d from w_com010_d
integer width = 3822
dw_1 dw_1
end type
global w_79004_d w_79004_d

type variables
DataWindowChild idw_brand, idw_judg_fg, idw_dept_cd, idw_pay_fg, idw_year, idw_season, idw_item, idw_judg_s, ldw_child

String is_brand, is_fr_ymd, is_to_ymd, is_style, is_chno, is_card_no, is_jumin, is_custom_nm
String is_judg_fg, is_dept_cd, is_sort_fg, is_fr_want, is_to_want, is_pay_fg, is_judg_l, is_judg_s
string is_shop_cd, is_cust_cd, is_go_exp, is_claim_fg, is_fr_appoint, is_to_appoint
string is_fr_go_ymd, is_to_go_ymd, is_year, is_season, is_item, is_fix_cust
String is_fr_receipt, is_to_receipt, is_fr_st_ymd, is_to_st_ymd, is_receipt_yn, is_confirm_yn, is_receipt_empno


end variables

on w_79004_d.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_79004_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3
Integer    li_sex, li_return
Boolean    lb_check
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "fix_cust"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				End If
				
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
//			Choose Case is_brand
//				Case 'J'
//					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "
//				Case 'Y'
//					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "
//				Case 'W'
//					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "		
//				Case 'I'
//					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
//													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "													 													 
//				Case Else
//					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
//													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
//													 "   AND CHANGE_GUBN = '00' "				
					//박소담주임 요청건 2012.01.18일 브랜드 상관없이 수선업체가 다 조회가능하게 요청함.
					gst_cd.default_where   = " WHERE CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "							
//			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "fix_cust", lds_Source.GetItemString(1,"custcode"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("make_type")
				ib_itemchanged = False
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	CASE "cust_cd"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				End If
				
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911" 
			Choose Case is_brand
				Case 'Y','O','D'
					gst_cd.default_where   = " WHERE BRAND in ('O','D') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND not in ('O','D') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				/* 다음컬럼으로 이동 */
//				dw_head.SetColumn("make_type")
				ib_itemchanged = False
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source					
	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_cd", "")

					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_custom_nm) = 0 THEN

					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
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
	
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("cust_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
					
	CASE "style_no"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
					Return 0
				End If
				IF LeftA(as_data, 1) = is_brand and gf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1)) = TRUE THEN
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE NO 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + LeftA(as_data, 8)   + "%' " + &
				               " AND  CHNO LIKE '" + MidA(as_data, 9, 1) + "%' "
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
				dw_head.SetItem(al_row, "style_no", lds_Source.GetItemString(1,"style_no"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("card_no_h")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source
	CASE "card_no_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "jumin_h",     "")
//				   dw_head.SetItem(al_row, "custom_nm_h", "")
					RETURN 0
				END IF 
				IF gf_cust_card_chk(as_data, ls_jumin, ls_custom_nm) = TRUE THEN
				   dw_head.SetItem(al_row, "jumin_h",     ls_jumin    )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				END IF 
			END IF
	CASE "jumin_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "card_no_h",   "")
//				   dw_head.SetItem(al_row, "custom_nm_h", "")
					RETURN 0
				END IF 
				IF gf_cust_jumin_chk(as_data, ls_custom_nm, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h",   ls_card_no  )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				ElseIf LenA(as_data) = 13 Then
					dw_head.SetItem(al_row, "card_no_h", "")
					RETURN 0
				END IF 
			END IF
	CASE "custom_nm_h"
			IF ai_div = 1 THEN 	
//				IF IsNull(as_data) or Trim(as_data) = "" THEN
//				   dw_head.SetItem(al_row, "card_no_h", "")
//				   dw_head.SetItem(al_row, "jumin_h",   "")
//					RETURN 0
//				END IF 
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h", ls_card_no)
				   dw_head.SetItem(al_row, "jumin_h",   ls_jumin  )
					RETURN 0
				Else
					dw_head.SetItem(al_row, "card_no_h", "")
					RETURN 0
				END IF 
			END IF
	CASE "custom_h"
			If dw_head.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			ls_card_no   = dw_head.GetItemString(al_row, "card_no_h"  )
			ls_jumin     = dw_head.GetItemString(al_row, "jumin_h"    )
			ls_custom_nm = dw_head.GetItemString(al_row, "custom_nm_h")
			IF IsNull(ls_card_no) = False and Trim(ls_card_no) <> "" THEN
				gst_cd.Item_where = " CARD_NO LIKE '" + Trim(ls_card_no) + "%' AND "
			ELSE
				gst_cd.Item_where = ""
			END IF
			IF IsNull(ls_jumin) = False and Trim(ls_jumin) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " JUMIN LIKE '" + Trim(ls_jumin) + "%' AND "
			END IF
			IF IsNull(ls_custom_nm) = False and Trim(ls_custom_nm) <> "" THEN
				gst_cd.Item_where = gst_cd.Item_where + " USER_NAME LIKE '" + Trim(ls_custom_nm) + "%' "
			ELSE
				gst_cd.Item_where = LeftA(gst_cd.Item_where, LenA(gst_cd.Item_where) - 4)
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
				dw_head.SetItem(al_row, "card_no_h",   lds_Source.GetItemString(1,"card_no")  )
				dw_head.SetItem(al_row, "jumin_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"user_name"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
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

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String   ls_title, ls_style_no

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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_fr_ymd = Trim(String(dw_head.GetItemDate(1, "fr_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ymd) or is_fr_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = Trim(String(dw_head.GetItemDate(1, "to_ymd"), 'yyyymmdd'))
if IsNull(is_to_ymd) or is_to_ymd = "" then
   MessageBox(ls_title,"의뢰 일자를 입력하십시요!")
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

ls_style_no = Trim(dw_head.GetItemString(1, "style_no"))
if IsNull(ls_style_no) or ls_style_no = "" then
	is_style = '%'
	is_chno  = '%'
Else
	is_style = LeftA(ls_style_no, 8)
	is_chno  = MidA (ls_style_no, 9, 1)
end if

is_card_no = Trim(dw_head.GetItemString(1, "card_no_h"))
if IsNull(is_card_no) or is_card_no = "" then
	is_card_no = '%'
end if

is_jumin = Trim(dw_head.GetItemString(1, "jumin_h"))
if IsNull(is_jumin) or is_jumin = "" then
	is_jumin = '%'
end if

is_custom_nm = Trim(dw_head.GetItemString(1, "custom_nm_h"))
if IsNull(is_custom_nm) or is_custom_nm = "" then
	is_custom_nm = '%'
end if

is_judg_fg = Trim(dw_head.GetItemString(1, "judg_fg"))
if IsNull(is_judg_fg) or is_judg_fg = "" then
   MessageBox(ls_title,"조회 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("judg_fg")
   return false
end if

is_judg_l = Trim(dw_head.GetItemString(1, "judg_l"))
if IsNull(is_judg_l) or is_judg_l = "" then
	is_judg_l = '%'
end if

is_judg_s = Trim(dw_head.GetItemString(1, "judg_s"))
if IsNull(is_judg_s) or is_judg_s = "" then
	is_judg_s = '%'
end if

is_pay_fg = Trim(dw_head.GetItemString(1, "pay_fg"))
if IsNull(is_pay_fg) or is_pay_fg = "" then
   MessageBox(ls_title,"수선비지급 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("pay_fg")
   return false
end if

is_dept_cd = Trim(dw_head.GetItemString(1, "dept_cd"))
if IsNull(is_dept_cd) or is_dept_cd = "" then
   MessageBox(ls_title,"부서 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("dept_cd")
   return false
end if

is_sort_fg = Trim(dw_head.GetItemString(1, "sort_fg"))
if IsNull(is_sort_fg) or is_sort_fg = "" then
   MessageBox(ls_title,"정렬 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("sort_fg")
   return false
end if

is_fr_want = Trim(dw_head.GetItemString(1, "fr_want"))
if IsNull(is_fr_want) or is_fr_want = "" then
    is_fr_want = " "
end if

is_to_want = Trim(dw_head.GetItemString(1, "to_want"))
if IsNull(is_to_want) or is_to_want = "" then
    is_to_want = "zzzzzzzz"
end if

is_fr_appoint = Trim(dw_head.GetItemString(1, "fr_appoint"))
if IsNull(is_fr_appoint) or is_fr_appoint = "" then
    is_fr_appoint = " "
end if

is_to_appoint = Trim(dw_head.GetItemString(1, "to_appoint"))
if IsNull(is_to_appoint) or is_to_appoint = "" then
    is_to_appoint = "zzzzzzzz"
end if

is_fr_go_ymd = Trim(dw_head.GetItemString(1, "fr_go_ymd"))
if IsNull(is_fr_go_ymd) or is_fr_go_ymd = "" then
    is_fr_go_ymd = " "
end if

is_to_go_ymd = Trim(dw_head.GetItemString(1, "to_go_ymd"))
if IsNull(is_to_go_ymd) or is_to_go_ymd = "" then
    is_to_go_ymd = "zzzzzzzz"
end if


is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
is_fix_cust = Trim(dw_head.GetItemString(1, "fix_cust"))
is_go_exp  = Trim(dw_head.GetItemString(1, "go_exp"))
is_claim_fg = Trim(dw_head.GetItemString(1, "claim_fg"))

is_year = Trim(dw_head.GetItemString(1, "year"))
if IsNull(is_year) or is_year = "" then
   MessageBox(ls_title,"제품년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("year")
   return false
end if

is_season = Trim(dw_head.GetItemString(1, "season"))
if IsNull(is_season) or is_season = "" then
   MessageBox(ls_title,"제품시즌을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("season")
   return false
end if

is_item = Trim(dw_head.GetItemString(1, "item"))
if IsNull(is_item) or is_item = "" then
   MessageBox(ls_title,"품종을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("item")
   return false
end if

is_fr_receipt = Trim(dw_head.GetItemString(1, "fr_receipt"))
if IsNull(is_fr_receipt) or is_fr_receipt = "" then
    is_fr_receipt = " "
end if

is_to_receipt = Trim(dw_head.GetItemString(1, "to_receipt"))
if IsNull(is_to_receipt) or is_to_receipt = "" then
    is_to_receipt = "zzzzzzzz"
end if

is_fr_st_ymd = Trim(dw_head.GetItemString(1, "fr_st_ymd"))
if IsNull(is_fr_st_ymd) or is_fr_st_ymd = "" then
    is_fr_st_ymd = " "
end if

is_to_st_ymd = Trim(dw_head.GetItemString(1, "to_st_ymd"))
if IsNull(is_to_st_ymd) or is_to_st_ymd = "" then
    is_to_st_ymd = "zzzzzzzz"
end if

is_receipt_empno = Trim(dw_head.GetItemString(1, "receipt_empno"))
if IsNull(is_receipt_empno) or is_receipt_empno = "" then
    is_receipt_empno = "%"
end if

is_receipt_yn = Trim(dw_head.GetItemString(1, "receipt_yn"))
is_confirm_yn = Trim(dw_head.GetItemString(1, "confirm_yn"))

return true
end event

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
String ls_sort

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

If is_sort_fg = '1' Then
	dw_body.SetSort("yymmdd A, seq_no A, no A")
ElseIf is_sort_fg = '2' Then
	dw_body.SetSort("style_no A")
ElseIf is_sort_fg = '3' Then
	dw_body.SetSort("cust_cd A")
Elseif is_sort_fg = '4' Then
	dw_body.SetSort("shop_cd A")
Elseif is_sort_fg = '5' Then
   dw_body.SetSort("want_ymd A")	
else	
   dw_body.SetSort("appoint_ymd A")		
End If

il_rows = dw_body.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_style, is_chno, is_card_no, is_jumin, is_custom_nm, &
                           is_judg_fg, is_dept_cd, is_fr_want, is_to_want, is_pay_fg, is_shop_cd, is_cust_cd, is_go_exp, is_claim_fg, is_fr_appoint, is_to_appoint, is_fr_go_ymd, is_to_go_ymd, is_year, is_season, is_item, is_fr_receipt,is_to_receipt, is_fr_st_ymd,is_to_st_ymd, is_receipt_yn, is_confirm_yn, is_fix_cust, is_judg_l, is_judg_s, is_receipt_empno)
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

event ue_title();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_style_no, ls_card_no, ls_jumin, ls_custom_nm, ls_sort_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_style = '%' Then
	ls_style_no = '% 전체'
Else
	ls_style_no = String(is_style + is_chno, '@@@@@@@@-@')
End If

If is_card_no = '%' Then
	ls_card_no = '% 전체'
Else
	ls_card_no = String(is_card_no, '@@@@-@@@@-@@@@-@@@@')
End If

If is_jumin = '%' Then
	ls_jumin = '% 전체'
Else
	ls_jumin = String(is_jumin, '@@@@@@-@@@@@@@')
End If

If is_custom_nm = '%' Then
	ls_custom_nm = '% 전체'
Else
	ls_custom_nm = is_custom_nm
End If

If is_sort_fg = '1' Then
	ls_sort_nm = '접수일자별 '
ElseIf is_sort_fg = '2' Then
	ls_sort_nm = 'STYLE NO별 '
ElseIf is_sort_fg = '3' Then
	ls_sort_nm = '업체별 '
Else
	ls_sort_nm = '매장별 '
End If

ls_modify =	"t_pg_id.Text     = '" + is_pgm_id +    "'" + &
            "t_user_id.Text   = '" + gs_user_id +   "'" + &
            "t_datetime.Text  = '" + ls_datetime +  "'" + &
            "t_title.Text     = '" + ls_sort_nm + "A/S 의뢰/판정 현황'" + &
            "t_brand.Text     = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text    = '" + String(is_fr_ymd + is_to_ymd, '@@@@/@@/@@ ~~ @@@@/@@/@@') + "'" + &
            "t_style_no.Text  = '" + ls_style_no + "'" + &
            "t_card_no.Text   = '" + ls_card_no +   "'" + &
            "t_jumin.Text     = '" + ls_jumin +     "'" + &
            "t_custom_nm.Text = '" + ls_custom_nm + "'" + &
            "t_judg_fg.Text   = '" + idw_judg_fg.GetItemString(idw_judg_fg.GetRow(), "inter_display") + "'" + &
            "t_dept_cd.Text   = '" + idw_dept_cd.GetItemString(idw_dept_cd.GetRow(), "dept_display") + "'"
				
dw_print.Modify(ls_modify)


if is_claim_fg = "01" then
	dw_print.object.t_claim_fg.text = "업체클레임"
elseif is_claim_fg = "02" then
	dw_print.object.t_claim_fg.text = "물류클레임"
else
	dw_print.object.t_claim_fg.text = "전체"
	
end if

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79004_d","0")
end event

type cb_close from w_com010_d`cb_close within w_79004_d
end type

type cb_delete from w_com010_d`cb_delete within w_79004_d
end type

type cb_insert from w_com010_d`cb_insert within w_79004_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_79004_d
end type

type cb_update from w_com010_d`cb_update within w_79004_d
end type

type cb_print from w_com010_d`cb_print within w_79004_d
end type

type cb_preview from w_com010_d`cb_preview within w_79004_d
end type

type gb_button from w_com010_d`gb_button within w_79004_d
end type

type cb_excel from w_com010_d`cb_excel within w_79004_d
end type

type dw_head from w_com010_d`dw_head within w_79004_d
integer y = 160
integer width = 3730
integer height = 676
string dataobject = "d_79004_h01"
end type

event dw_head::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.28                                                  */	
/* 수정일      : 2002.03.28                                                  */
/*===========================================================================*/
String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		Send(Handle(This), 256, 9, long(0,0))
		Return 1
   CASE KeyF12!
      char lc_kb[256]
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (128)
      SetKeyboardState (lc_kb)
      Send (Handle (this), 256, 9, 0)
      GetKeyboardState (lc_kb)
      lc_kb[17] = CharA (0)
      SetKeyboardState (lc_kb)
	CASE KeyF1!
		// Column.Protect = True Then Return
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
								
		Choose Case ls_column_name
			Case "card_no_h", "jumin_h", "custom_nm_h"
				ls_column_name = "custom_h"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("judg_fg", idw_judg_fg)
idw_judg_fg.SetTransObject(SQLCA)
idw_judg_fg.Retrieve('799')
idw_judg_fg.InsertRow(1)
idw_judg_fg.SetItem(1, "inter_cd", '%')
idw_judg_fg.SetItem(1, "inter_nm", '전체')

This.GetChild("pay_fg", idw_pay_fg)
idw_pay_fg.SetTransObject(SQLCA)
idw_pay_fg.Retrieve('797')
idw_pay_fg.InsertRow(1)
idw_pay_fg.SetItem(1, "inter_cd", '%')
idw_pay_fg.SetItem(1, "inter_nm", '전체')


This.GetChild("dept_cd", idw_dept_cd)
idw_dept_cd.SetTransObject(SQLCA)
idw_dept_cd.Retrieve()
idw_dept_cd.InsertRow(1)
idw_dept_cd.SetItem(1, "dept_cd", '%')
idw_dept_cd.SetItem(1, "dept_nm", '전체')

This.GetChild("item", idw_item)
idw_item.SetTransObject(SQLCA)
idw_item.Retrieve()
idw_item.InsertRow(1)
idw_item.SetItem(1, "item", '%')
idw_item.SetItem(1, "item_nm", '전체')


This.GetChild("year", idw_year )
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

This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.Retrieve('796','%')
idw_judg_s.InsertRow(1)
idw_judg_s.SetItem(1, "inter_cd", '')
idw_judg_s.SetItem(1, "inter_nm", '')
end event

event dw_head::itemchanged;call super::itemchanged;string ls_year, ls_brand
DataWindowChild ldw_child1

CHOOSE CASE dwo.name
	CASE "card_no_h", "jumin_h", "custom_nm_h", "shop_cd", "cust_cd", "fix_cust"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "brand"	
		
		ls_year = this.getitemstring(row, "year")	
		this.getchild("season",ldw_child1)
		ldw_child1.settransobject(sqlca)
		ldw_child1.retrieve('003', data, ls_year) // '%')
		ldw_child1.insertrow(1)
		ldw_child1.Setitem(1, "inter_cd", "%")
		ldw_child1.Setitem(1, "inter_nm", "전체")
		
  CASE  "year"
		IF ib_itemchanged THEN RETURN 1
		ls_brand = this.getitemstring(row, "brand")
	
		this.getchild("season",ldw_child1)
		ldw_child1.settransobject(sqlca)
		ldw_child1.retrieve('003', ls_brand, data)
		ldw_child1.insertrow(1)
		ldw_child1.Setitem(1, "inter_cd", "%")
		ldw_child1.Setitem(1, "inter_nm", "전체")				
				
END CHOOSE


end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;String ls_judg_l

CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
		idw_judg_s.InsertRow(1)
		idw_judg_s.SetItem(1, "inter_cd", '')
		idw_judg_s.SetItem(1, "inter_nm", '')		
END CHOOSE


		

end event

type ln_1 from w_com010_d`ln_1 within w_79004_d
integer beginy = 836
integer endy = 836
end type

type ln_2 from w_com010_d`ln_2 within w_79004_d
integer beginy = 840
integer endy = 840
end type

type dw_body from w_com010_d`dw_body within w_79004_d
integer y = 852
integer width = 3602
integer height = 1172
string dataobject = "d_79004_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::clicked;call super::clicked;///*===========================================================================*/
///* 작성자      : (주)지우정보 (동은아빠)                                     */	
///* 작성일      : 2002.03.04                                                  */	
///* 수정일      : 2002.03.04                                                  */
///*===========================================================================*/
String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'style','style_no'
			ls_search 	= this.GetItemString(row,string(dwo.name))
			if LenA(ls_search) >= 8 then gf_style_pic(ls_search, '%')
	end choose	
end if

end event

event dw_body::doubleclicked;call super::doubleclicked;String 	ls_search
if row > 0 then 
	choose case dwo.name
		case 'problem'
			ls_search 	= this.GetItemString(row,'problem')
			dw_1.visible = true
			dw_1.reset()
			dw_1.insertrow(0)
			dw_1.setitem(1, "detail", ls_search)
			
			
		case 'result'
			ls_search 	= this.GetItemString(row,'result')
			if LenA(ls_search) = 6 then gf_shop_pic(ls_search)			
			dw_1.visible = true
			dw_1.reset()
			dw_1.insertrow(0)
			dw_1.setitem(1, "detail", ls_search)
			
	end choose	
end if
end event

type dw_print from w_com010_d`dw_print within w_79004_d
integer x = 59
integer y = 744
string dataobject = "d_79004_r01"
end type

type dw_1 from datawindow within w_79004_d
boolean visible = false
integer x = 1344
integer y = 904
integer width = 2057
integer height = 652
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "상세보기"
string dataobject = "d_79004_d02"
boolean controlmenu = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

