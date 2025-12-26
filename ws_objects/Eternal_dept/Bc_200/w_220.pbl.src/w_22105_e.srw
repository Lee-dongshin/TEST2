$PBExportHeader$w_22105_e.srw
$PBExportComments$부자재 출고 등록
forward
global type w_22105_e from w_com010_e
end type
end forward

global type w_22105_e from w_com010_e
integer width = 3675
integer height = 2280
windowstate windowstate = maximized!
end type
global w_22105_e w_22105_e

type variables
DataWindowChild idw_brand, idw_house
String is_brand, is_house, is_style, is_chno, is_cust_cd, is_out_ymd, is_out_no

end variables

on w_22105_e.create
call super::create
end on

on w_22105_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;dw_head.SetItem(1, "house", '110000')

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.25                                                  */	
/* 수정일      : 2002.03.11                                                  */
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

is_out_no = '&'
//dw_body.SetFilter("stock_qty <> 0")
dw_body.SetFilter("")
il_rows = dw_body.Retrieve(is_brand, is_house, is_style, is_chno, is_cust_cd, is_out_ymd, is_out_no)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(1)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.11                                                  */	
/* 수정일      : 2002.03.11                                                  */
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

is_house = Trim(dw_head.GetItemString(1, "house"))
if IsNull(is_house) or is_house = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

ls_style_no = Trim(dw_head.GetItemString(1, "style_no"))
if IsNull(ls_style_no) or ls_style_no = "" then
   MessageBox(ls_title,"품번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if
is_style = MidA(ls_style_no,1,8)
is_chno  = MidA(ls_style_no,9,1)

is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
if IsNull(is_cust_cd) or is_cust_cd = "" then
   MessageBox(ls_title,"거래처 코드가 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

is_out_ymd = Trim(String(dw_head.GetItemDateTime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_out_ymd) or is_out_ymd = "" then
   MessageBox(ls_title,"출고일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

//is_out_no = Trim(String(dw_head.GetItemDecimal(1, "out_no"), '0000'))
//if IsNull(is_out_no) or is_out_no = "" then
//   is_out_no = '&'
//end if

return true

end event

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.11                                                  */	
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_out_no = '%'
dw_body.SetFilter("qty <> 0")
il_rows = dw_body.retrieve(is_brand, is_house, is_style, is_chno, is_cust_cd, is_out_ymd, is_out_no)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "style_no"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
				   dw_head.SetItem(al_row, "cust_cd", "")
				   dw_head.SetItem(al_row, "cust_nm", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com010"
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "STYLE LIKE '" + LeftA(as_data, 8)   + "%' " + &
				                "AND  CHNO LIKE '" + MidA(as_data, 9, 1) + "%' "
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
				dw_head.SetItem(al_row, "cust_cd",  lds_Source.GetItemString(1,"cust_cd"))
				dw_head.SetItem(al_row, "cust_nm",  lds_Source.GetItemString(1,"cust_nm"))
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

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.11                                                  */	
/* 수정일      : 2002.03.11                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_out_max
Decimal ldc_qty
datetime ld_datetime

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

SELECT CAST(ISNULL(MAX(OUT_NO), '0') AS INT)
  INTO :ll_out_max
  FROM TB_22020_H
 WHERE OUT_YMD  = :is_out_ymd
	AND OUT_GUBN = '01';
				
ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN				/* New Record */
//	   IF dw_body.GetItemString(i, "gubun_flag") = '1' THEN
	   IF is_out_no = '&' THEN
			ldc_qty = dw_body.GetItemDecimal(i, "qty")
			If dw_body.GetItemString(i, "update_yn") = 'N' or IsNull(ldc_qty) or ldc_qty = 0 Then
				dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
			Else
				ll_out_max++
				dw_body.Setitem(i, "out_no", String(ll_out_max, '0000'))
				dw_body.Setitem(i, "reg_id", gs_user_id )
				dw_body.Setitem(i, "reg_dt", ld_datetime)
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			End If
		ELSE
			dw_body.Setitem(i, "mod_id", gs_user_id )
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF;	
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;

	is_out_no = '%'
	dw_body.SetFilter("qty <> 0")
	dw_body.Retrieve(is_brand, is_house, is_style, is_chno, is_cust_cd, is_out_ymd, is_out_no)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows
end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22105_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22105_e
end type

type cb_delete from w_com010_e`cb_delete within w_22105_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22105_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22105_e
end type

type cb_update from w_com010_e`cb_update within w_22105_e
end type

type cb_print from w_com010_e`cb_print within w_22105_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_22105_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_22105_e
end type

type cb_excel from w_com010_e`cb_excel within w_22105_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_22105_e
integer height = 224
string dataobject = "d_22105_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "style_no", "")
		This.SetItem(row, "cust_cd",  "")
		This.SetItem(row, "cust_nm",  "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house)
idw_house.SetTransObject(SQLCA)
idw_house.Retrieve()

end event

type ln_1 from w_com010_e`ln_1 within w_22105_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22105_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22105_e
integer y = 444
integer height = 1596
string dataobject = "d_22105_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
/*===========================================================================*/
Decimal ld_qty
CHOOSE CASE dwo.name
	CASE "qty" 
		IF IsNull(data) THEN 
			ld_qty = 0
		ELSE
			ld_qty = Dec(Data)
		END IF
		If ld_qty > This.GetItemDecimal(row, "stock_qty") Then
			MessageBox("입력오류", "재고량보다 많습니다!")
			Return 1
		End If
		This.SetItem(row, "amt", ld_qty * This.GetItemDecimal(row, "price"))
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.12                                                  */	
/* 수정일      : 2002.03.12                                                  */
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

type dw_print from w_com010_e`dw_print within w_22105_e
end type

