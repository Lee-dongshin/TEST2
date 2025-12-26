$PBExportHeader$w_22005_e.srw
$PBExportComments$비축용 부자재 입고 등록
forward
global type w_22005_e from w_com010_e
end type
end forward

global type w_22005_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_22005_e w_22005_e

type variables
DataWindowChild idw_brand, idw_house

String is_brand, is_yymmdd, is_house, is_fr_ord_ymd, is_to_ord_ymd, is_cust_cd, is_new_chk

end variables

on w_22005_e.create
call super::create
end on

on w_22005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;Datetime ld_datetime

ld_datetime = dw_head.GetItemDatetime(1, "yymmdd")

dw_head.SetItem(1, "fr_ord_ymd", ld_datetime)
dw_head.SetItem(1, "to_ord_ymd", ld_datetime)
dw_head.SetItem(1, "house", '110000')

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.19                                                  */	
/* 수정일      : 2002.02.19                                                  */
/*===========================================================================*/
String     ls_cust_nm 
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
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_cust_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_cust_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_cust_nm) = 0 THEN
							dw_head.SetItem(al_row, "cust_nm", ls_cust_nm)
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
				dw_head.SetColumn("style_no")
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_new_chk = 'R'
dw_body.SetFilter("in_sum <> 0")
il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_house, is_fr_ord_ymd, is_to_ord_ymd, is_cust_cd, is_new_chk)
//dw_body.Filter()

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

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
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
   MessageBox(ls_title,"입고일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house = Trim(dw_head.GetItemString(1, "house"))
if IsNull(is_house) or is_house = "" then
   MessageBox(ls_title,"입고창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_fr_ord_ymd = Trim(String(dw_head.GetItemDatetime(1, "fr_ord_ymd"), 'yyyymmdd'))
if IsNull(is_fr_ord_ymd) or is_fr_ord_ymd = "" then
   MessageBox(ls_title,"발주일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ord_ymd")
   return false
end if

is_to_ord_ymd = Trim(String(dw_head.GetItemDatetime(1, "to_ord_ymd"), 'yyyymmdd'))
if IsNull(is_to_ord_ymd) or is_to_ord_ymd = "" then
   MessageBox(ls_title,"발주일을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ord_ymd")
   return false
end if

if is_to_ord_ymd < is_fr_ord_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ord_ymd")
   return false
end if

is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
if IsNull(is_cust_cd) or is_cust_cd = "" then
   MessageBox(ls_title,"자재거래처 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

return true

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

//새로운 자료를 입력하기 위해 입고일에 is_new_cnk를 넣어 조회한다.
is_new_chk = 'I'			//새로운 자료
dw_body.SetFilter("")
il_rows = dw_body.Retrieve(is_brand, is_new_chk, is_house, is_fr_ord_ymd, is_to_ord_ymd, is_cust_cd, is_new_chk)
//dw_body.Filter()

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
//	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_in_max
datetime ld_datetime
String ls_ord_ymd, ls_ord_no, ls_no, ls_fin_yn
Decimal ldc_tmp_qty1, ldc_price

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

// Null Check
For i = 1 to ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		ldc_tmp_qty1 = dw_body.GetItemDecimal(i, "tmp_qty1")
		If Not(IsNull(ldc_tmp_qty1) or ldc_tmp_qty1 = 0) or is_new_chk <> 'I' Then
			ldc_price = dw_body.GetItemDecimal(i, "price")
			If IsNull(ldc_price) or ldc_price = 0 Then
				MessageBox("입력오류", "입고 단가를 입력하십시요!")
				dw_body.ScrollToRow(i)
				dw_body.SetColumn("price")
				dw_body.SetFocus()
				Return -1
			End If
		End If
	End If
Next

// 입고번호 채번
  SELECT CAST(ISNULL(MAX(IN_NO), '0') AS INT)
	 INTO :ll_in_max
	 FROM TB_22010_H
	WHERE BRAND   = :is_brand
	  AND IN_YMD  = :is_yymmdd
	  AND IN_GUBN = '01'
  ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox("저장오류", "입고번호 채번에 실패하였습니다!")
	Return -1
End If

dw_body.SetReDraw(False)

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		ls_ord_ymd   = dw_body.GetItemString (i, "ord_ymd")
		ls_ord_no    = dw_body.GetItemString (i, "ord_no")
		ls_no        = dw_body.GetItemString (i, "no")
		ldc_tmp_qty1 = dw_body.GetItemDecimal(i, "tmp_qty1")
		ldc_price    = dw_body.GetItemDecimal(i, "price")
		ls_fin_yn    = dw_body.GetItemString (i, "fin_yn")
		
		If dw_body.GetItemStatus(i, "fin_yn", Primary!) = DataModified! Then
			// TB_21021_D(부자재 발주 내역)에 Setting
			UPDATE TB_21021_D
				SET FIN_YN   = :ls_fin_yn,
					 MOD_ID   = :gs_user_id,
					 MOD_DT   = :ld_datetime
			 WHERE BRAND   = :is_brand
				AND ORD_YMD = :ls_ord_ymd
				AND ORD_NO  = :ls_ord_no
				AND NO      = :ls_no
			;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox("저장오류", "TB_21021_D(부자재 발주 내역) UPDATE에 실패하였습니다!")
				rollback  USING SQLCA;
				dw_body.SetReDraw(True)
				Return -1
			End if
		End If

		If is_new_chk = 'I' Then
			If IsNull(ldc_tmp_qty1) or ldc_tmp_qty1 = 0 Then
				dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
			Else
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
				dw_body.Setitem(i, "in_ymd",  is_yymmdd)
				ll_in_max++
				dw_body.Setitem(i, "in_no",   String(ll_in_max, '0000'))
				dw_body.SetItem(i, "tmp_qty", ldc_tmp_qty1)
				dw_body.SetItem(i, "sil_qty", ldc_tmp_qty1)
				dw_body.SetItem(i, "amt",     dw_body.GetItemDecimal(i, "amt1"))
				dw_body.Setitem(i, "reg_id",  gs_user_id)
			End If
		End If
	END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
	dw_body.ResetUpdate()
	commit  USING SQLCA;
	
	is_new_chk = 'R'
	dw_body.SetFilter("in_sum <> 0")
	dw_body.Retrieve(is_brand, is_yymmdd, is_house, is_fr_ord_ymd, is_to_ord_ymd, is_cust_cd, is_new_chk)
//	dw_body.Filter()
else
	rollback  USING SQLCA;
end if

dw_body.SetReDraw(True)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text =    '" + is_pgm_id + "'" + &
            "t_user_id.Text =  '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text =    '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text =   '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_house.Text =    '" + idw_house.GetItemString(idw_house.GetRow(), "shop_display") + "'" + &
            "t_ord_ymd.Text =  '" + String(is_fr_ord_ymd, '@@@@/@@/@@') + " ~~ " + String(is_to_ord_ymd, '@@@@/@@/@@') + "'" + &
            "t_cust_cd.Text =  '" + is_cust_cd + "'" + &
            "t_cust_nm.Text =  '" + dw_head.GetItemString(1, "cust_nm") + "'"

dw_print.Modify(ls_modify)


end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22005_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22005_e
end type

type cb_delete from w_com010_e`cb_delete within w_22005_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22005_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22005_e
end type

type cb_update from w_com010_e`cb_update within w_22005_e
end type

type cb_print from w_com010_e`cb_print within w_22005_e
end type

type cb_preview from w_com010_e`cb_preview within w_22005_e
end type

type gb_button from w_com010_e`gb_button within w_22005_e
end type

type cb_excel from w_com010_e`cb_excel within w_22005_e
end type

type dw_head from w_com010_e`dw_head within w_22005_e
integer height = 220
string dataobject = "d_22005_h01"
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
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "cust_cd", "")
		This.SetItem(row, "cust_nm", "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "cust_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22005_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22005_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22005_e
integer y = 444
integer height = 1596
string dataobject = "d_22005_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
/*===========================================================================*/
String ls_color
Long i

CHOOSE CASE dwo.name
	CASE "tmp_qty1" 
		IF IsNull(data) or Double(data) = 0 THEN
			dw_body.SetItem(row, "price", 0)	
		END IF
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.02.25                                                  */
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_22005_e
string dataobject = "d_22005_r01"
end type

