$PBExportHeader$w_22110_e.srw
$PBExportComments$자재 판매 등록
forward
global type w_22110_e from w_com010_e
end type
end forward

global type w_22110_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_22110_e w_22110_e

type variables
DataWindowChild idw_brand, idw_house, idw_color1, idw_color2

String is_brand, is_yymmdd, is_mat_gubn, is_house, is_cust_cd

end variables

forward prototypes
public function integer wf_set_data (string as_chk, long al_row, string as_mat_cd, string as_color)
end prototypes

public function integer wf_set_data (string as_chk, long al_row, string as_mat_cd, string as_color);String ls_spec, ls_unit, ls_mat_year, ls_mat_season, ls_mat_sojae, ls_mat_chno, ls_out_seq
Decimal ldc_price, ldc_stock_qty, ldc_stock_amt

If as_chk = 'I' Then
	If is_mat_gubn = '1' Then
		SELECT SPEC,     UNIT,     ISNULL(IN_PRICE, 0)
		  INTO :ls_spec, :ls_unit, :ldc_price
		  FROM VI_21010_1
		 WHERE MAT_CD = :as_mat_cd
			AND COLOR  = :as_color
		;
	Else
		SELECT 'XX',     UNIT
		  INTO :ls_spec, :ls_unit
		  FROM TB_21000_M
		 WHERE MAT_CD = :as_mat_cd
		;
	End If
	
	If SQLCA.SQLCODE <> 0 THEN 
//		MessageBox("함수오류", "자재 발주내역(마스터) 조회에 실패하였습니다!")
		Return -1
	End IF
	
	
	SELECT ISNULL(STOCK_QTY, 0), ISNULL(STOCK_AMT, 0),
			 MAT_YEAR,             MAT_SEASON,           MAT_SOJAE,     MAT_CHNO,     OUT_SEQ
	  INTO :ldc_stock_qty,       :ldc_stock_amt,
			 :ls_mat_year,         :ls_mat_season,       :ls_mat_sojae, :ls_mat_chno, :ls_out_seq
	  FROM VI_29012_1
	 WHERE MAT_CD = :as_mat_cd
		AND COLOR  = :as_color
		AND HOUSE  = :is_house
	;
	
	If SQLCA.SQLCODE <> 0 THEN 
//		MessageBox("함수오류", "자재 재고내역 조회에 실패하였습니다!")
		Return -1
	End IF
	
	If is_mat_gubn = '2' Then ldc_price = ldc_stock_amt / ldc_stock_qty
	
	dw_body.SetItem(al_row, "spec",       ls_spec      )
	dw_body.SetItem(al_row, "unit",       ls_unit      )
	dw_body.SetItem(al_row, "price",      ldc_price    )
	dw_body.SetItem(al_row, "stock_qty",  ldc_stock_qty)
	dw_body.SetItem(al_row, "stock_amt",  ldc_stock_amt)
	dw_body.SetItem(al_row, "mat_year",   ls_mat_year  )
	dw_body.SetItem(al_row, "mat_season", ls_mat_season)
	dw_body.SetItem(al_row, "mat_sojae",  ls_mat_sojae )
	dw_body.SetItem(al_row, "mat_chno",   ls_mat_chno  )
	dw_body.SetItem(al_row, "out_seq",    ls_out_seq   )
Else
	dw_body.SetItem(al_row, "spec",       "")
	dw_body.SetItem(al_row, "unit",       "")
	dw_body.SetItem(al_row, "qty",        0 )
	dw_body.SetItem(al_row, "price",      0 )
	dw_body.SetItem(al_row, "stock_qty",  0 )
	dw_body.SetItem(al_row, "stock_amt",  0 )
	dw_body.SetItem(al_row, "mat_year",   "")
	dw_body.SetItem(al_row, "mat_season", "")
	dw_body.SetItem(al_row, "mat_sojae",  "")
	dw_body.SetItem(al_row, "mat_chno",   "")
	dw_body.SetItem(al_row, "out_seq",    "")
End If

Return 0

end function

on w_22110_e.create
call super::create
end on

on w_22110_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.SetItem(1, "house", '110000')

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_name, ls_mat_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "cust_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF 
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_name) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_name)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_name) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_name)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_name) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_name)
							RETURN 0
						END IF
				End Choose
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재/생산 거래처 코드 검색"
			gst_cd.datawindow_nm   = "d_com911"
			Choose Case is_brand
				Case 'J'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'Y'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
													 "   AND CUST_CODE BETWEEN '5000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
			End Choose
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "CUSTCODE LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
				dw_head.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "mat_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_body.SetItem(al_row, "mat_nm", "")
					dw_body.SetItem(al_row, "color1", "")
					dw_body.SetItem(al_row, "color2", "")
					dw_body.SetItem(al_row, "color", "")
					If wf_set_data('N', al_row, as_data, 'XX') <> 0 Then Return 1
					RETURN 0
				END IF 
				IF LeftA(as_data, 2) = is_brand + is_mat_gubn and gf_mat_nm(as_data, ls_name) = 0 THEN
				   dw_body.SetItem(al_row, "mat_nm", ls_name)
					dw_body.SetItem(al_row, "color1", "")
					dw_body.SetItem(al_row, "color2", "")
					dw_body.SetItem(al_row, "color", "")
					If wf_set_data('N', al_row, as_data, 'XX') <> 0 Then Return 1
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "자재 코드 검색" 
			If is_mat_gubn = '1' Then
				gst_cd.datawindow_nm   = "d_com020" 
			Else
				gst_cd.datawindow_nm   = "d_com913" 
			End If
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "MAT_CD LIKE '" + as_data + "%'"
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				ls_mat_cd = lds_Source.GetItemString(1,"mat_cd")
				dw_body.SetItem(al_row, "mat_cd", ls_mat_cd)
				dw_body.SetItem(al_row, "mat_nm", lds_Source.GetItemString(1,"mat_nm"))
				dw_body.SetItem(al_row, "color1", "")
				dw_body.SetItem(al_row, "color2", "")
				dw_body.SetItem(al_row, "color", "")
				If wf_set_data('N', al_row, ls_mat_cd, 'XX') <> 0 Then Return 1
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("color1")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_mat_gubn, is_house, is_cust_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"출고 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_mat_gubn = Trim(dw_head.GetItemString(1, "mat_gubn"))
if IsNull(is_mat_gubn) or is_mat_gubn = "" then
   MessageBox(ls_title,"자재 구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_gubn")
   return false
end if

is_house = Trim(dw_head.GetItemString(1, "house"))
if IsNull(is_house) or is_house = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
if IsNull(is_cust_cd) or is_cust_cd = "" then
   MessageBox(ls_title,"거래처 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

return true

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	If is_mat_gubn = '1' Then
		dw_body.Object.color1.Visible = 1
		dw_body.Object.color1_nm.Visible = 1
		dw_body.Object.color2.Visible = 0
		dw_body.Object.color2_nm.Visible = 0
	Else
		dw_body.Object.color1.Visible = 0
		dw_body.Object.color1_nm.Visible = 0
		dw_body.Object.color2.Visible = 1
		dw_body.Object.color2_nm.Visible = 1
	End If
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_out_max
datetime ld_datetime
Decimal ldc_qty

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// 출고 번호 채번
SELECT ISNULL(MAX(OUT_NO), 0)
  INTO :ll_out_max
  FROM TB_22020_H
 WHERE BRAND = :is_brand
   AND OUT_YMD = :is_yymmdd
	AND OUT_GUBN = '05'
;

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ldc_qty = dw_body.GetItemDecimal(i, "qty")
		If IsNull(ldc_qty) or ldc_qty = 0 Then
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		Else
			dw_body.SetItem(i, "brand", is_brand)
			dw_body.SetItem(i, "out_ymd", is_yymmdd)
			dw_body.SetItem(i, "out_gubn", '05')
			ll_out_max++
			dw_body.SetItem(i, "out_no", String(ll_out_max, '0000'))
			dw_body.SetItem(i, "io_gubn", '+')
			dw_body.SetItem(i, "house", is_house)
			dw_body.SetItem(i, "cust_cd", is_cust_cd)
			dw_body.SetItem(i, "amt", dw_body.GetItemDecimal(i, "amt1"))
			dw_body.SetItem(i, "mat_gubn", is_mat_gubn)
			dw_body.Setitem(i, "reg_id", gs_user_id)
		End If
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_body.Retrieve(is_brand, is_yymmdd, is_mat_gubn, is_house, is_cust_cd)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22110_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22110_e
end type

type cb_delete from w_com010_e`cb_delete within w_22110_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22110_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22110_e
end type

type cb_update from w_com010_e`cb_update within w_22110_e
end type

type cb_print from w_com010_e`cb_print within w_22110_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_22110_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_22110_e
end type

type cb_excel from w_com010_e`cb_excel within w_22110_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_22110_e
integer height = 220
string dataobject = "d_22110_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house)
idw_house.SetTransObject(SQLCA)
idw_house.Retrieve()

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "cust_cd", "")
		This.SetItem(1, "cust_nm", "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End IF
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22110_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22110_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22110_e
integer y = 444
integer height = 1596
string dataobject = "d_22110_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("color1", idw_color1)
idw_color1.SetTransObject(SQLCA)
idw_color1.InsertRow(0)

This.GetChild("color1_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("color2", idw_color2)
idw_color2.SetTransObject(SQLCA)
idw_color2.Retrieve()

This.GetChild("color2_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.13                                                  */	
/* 수정일      : 2002.03.13                                                  */
/*===========================================================================*/
Decimal ldc_qty
Long i, ll_find
String ls_mat_cd, ls_null

SetNull(ls_null)

CHOOSE CASE dwo.name
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color1", "color2"
		ll_find = 0
		ls_mat_cd = This.GetItemString(row, "mat_cd")
		
		For i = 1 To This.RowCount()
			If i <> row And This.GetItemStatus(i, 0, Primary!) = NewModified! Then
				If This.GetItemString(i, "mat_cd") = ls_mat_cd And This.GetItemString(i, "color") = data Then 
					ll_find = i
					Exit
				End If
			End If
		Next
		If ll_find = 0 Then
			If wf_set_data('I', row, ls_mat_cd, data) <> 0 Then Return 2
			This.SetItem(row, "color", data)
		Else
			MessageBox("입력오류", "이미 입력된 자료입니다!")
//			This.SetItem(row, dwo.name, ls_null)
			Return 2
		End If
		
	CASE "qty"
		If Dec(data) > This.GetItemDecimal(row, "stock_qty") Then
			MessageBox("입력오류", "재고수량보다 많습니다!")
			Return 1
		End If
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;
CHOOSE CASE dwo.name
	CASE "color1"
		idw_color1.Retrieve(This.GetItemString(row, "mat_cd"))
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_22110_e
end type

