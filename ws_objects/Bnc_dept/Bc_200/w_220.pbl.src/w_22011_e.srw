$PBExportHeader$w_22011_e.srw
$PBExportComments$자재 이체 등록
forward
global type w_22011_e from w_com010_e
end type
type rb_mmat from radiobutton within w_22011_e
end type
type rb_smat from radiobutton within w_22011_e
end type
type gb_1 from groupbox within w_22011_e
end type
type dw_out from u_dw within w_22011_e
end type
end forward

global type w_22011_e from w_com010_e
windowstate windowstate = maximized!
rb_mmat rb_mmat
rb_smat rb_smat
gb_1 gb_1
dw_out dw_out
end type
global w_22011_e w_22011_e

type variables
DataWindowChild idw_brand, idw_house

String is_mat_gubn, is_brand, is_yymmdd, is_house, is_fr_mat_cd, is_to_mat_cd
String is_to_mat_nm, is_new_chk, is_ord_chk, is_mat_type
String is_cust_cd, is_color, is_spec, is_unit, is_mat_year, is_mat_season, is_mat_sojae, is_mat_chno, is_out_seq
Datetime id_datetime
Decimal idc_price, idc_qty

end variables

forward prototypes
public function integer wf_ord_update (string as_mat_gubn)
public function integer wf_num (ref long al_out_max, ref long al_in_max)
end prototypes

public function integer wf_ord_update (string as_mat_gubn);
If as_mat_gubn = '1' Then
	// TB_21011_D(원자재 발주 Detail)에 Setting
	If is_ord_chk = 'NEW' Then
		INSERT 
		  INTO TB_21010_M
		       ( MAT_CD,    MAT_NM,   SPEC,       UNIT,      CUST_CD,  ORD_YMD,
				   BRAND,     MAT_YEAR, MAT_SEASON, MAT_SOJAE, MAT_CHNO, OUT_SEQ, 
					STATUS_FG, REG_ID )
		VALUES ( :is_to_mat_cd, :is_to_mat_nm, :is_spec,       :is_unit,      :is_cust_cd,  :is_yymmdd, 
		         :is_brand,     :is_mat_year,  :is_mat_season, :is_mat_sojae, :is_mat_chno, :is_out_seq,
					'20',          :gs_user_id )
		;
		INSERT 
		  INTO TB_21011_D
		       ( MAT_CD,  COLOR,      SPEC,       NEGO_PRICE, 
				   BRAND,   MAT_YEAR,   MAT_SEASON, MAT_SOJAE, MAT_CHNO,   OUT_SEQ, 
					FIN_YN,  REG_ID )
		VALUES ( :is_to_mat_cd, :is_color,    :is_spec,       :idc_price, 
		         :is_brand,     :is_mat_year, :is_mat_season, :is_mat_sojae, :is_mat_chno, :is_out_seq,
					'Y',           :gs_user_id )
		;
	End If
Else
	If is_ord_chk = 'NEW' Then
		INSERT 
		  INTO TB_21000_M
		       ( MAT_CD,   MAT_NM,   UNIT,       PRICE,    MAT_TYPE, 
				   BRAND,    MAT_YEAR, MAT_SEASON, MAT_ITEM, MAT_CHNO,
					MAT_GUBN, REG_ID )
		VALUES ( :is_to_mat_cd, :is_to_mat_nm, :is_unit,       :idc_price,    :is_mat_type,
		         :is_brand,     :is_mat_year,  :is_mat_season, :is_mat_sojae, :is_mat_chno,
					'2',           :gs_user_id )
		;
	End If
End If

Return 0

end function

public function integer wf_num (ref long al_out_max, ref long al_in_max);string ls_out_brand, ls_in_brand
ls_out_brand = is_brand
ls_in_brand = LeftA(is_to_mat_cd,1) 

// 출고번호 채번
  SELECT CAST(ISNULL(MAX(OUT_NO), '0') AS INT)
	 INTO :al_out_max
	 FROM TB_22020_H
	WHERE BRAND    = :ls_out_brand
	  AND OUT_YMD  = :is_yymmdd
	  AND OUT_GUBN = '02'
  ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
	Return -1
End If

// 입고번호 채번
  SELECT CAST(ISNULL(MAX(IN_NO), '0') AS INT)
	 INTO :al_in_max
	 FROM TB_22010_H
	WHERE BRAND   = :ls_in_brand
	  AND IN_YMD  = :is_yymmdd
	  AND IN_GUBN = '02'
  ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox("저장오류", "입고번호 채번에 실패하였습니다!")
	Return -1
End If

Return 0
end function

on w_22011_e.create
int iCurrent
call super::create
this.rb_mmat=create rb_mmat
this.rb_smat=create rb_smat
this.gb_1=create gb_1
this.dw_out=create dw_out
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_mmat
this.Control[iCurrent+2]=this.rb_smat
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_out
end on

on w_22011_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_mmat)
destroy(this.rb_smat)
destroy(this.gb_1)
destroy(this.dw_out)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

is_new_chk = 'R'
dw_body.SetFilter("tmp_qty <> 0")
il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_house, is_fr_mat_cd, is_to_mat_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/
String     ls_mat_nm 
Boolean    lb_check 
DataStore  lds_Source

is_brand    = dw_head.GetItemString(1, "brand")

CHOOSE CASE as_column
	CASE "fr_mat_cd"
		IF ai_div = 1 THEN
			IF IsNull(as_data) or Trim(as_data) = "" Then
				dw_head.SetItem(al_row, "fr_mat_nm", "")
				RETURN 0
			END IF
			IF LeftA(as_data, 2) = is_brand + is_mat_gubn and gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
				dw_head.SetItem(al_row, "fr_mat_nm", ls_mat_nm)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		If is_mat_gubn = '1' Then
			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
		Else
			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
		End If
//		gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' "
		gst_cd.default_where   = ""
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
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
			END IF
			dw_head.SetItem(al_row, "fr_mat_cd", lds_Source.GetItemString(1,"mat_cd"))
			dw_head.SetItem(al_row, "fr_mat_nm", lds_Source.GetItemString(1,"mat_nm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("to_mat_cd")
			ib_itemchanged = False 
			lb_check = TRUE 
		END IF
		Destroy  lds_Source
	CASE "to_mat_cd"
		is_ord_chk = 'ORD'
		dw_head.Object.to_mat_nm.Protect = 1
		dw_head.Object.to_mat_nm.BackGround.Color = RGB(192, 192, 192)
		IF ai_div = 1 THEN
			IF IsNull(as_data) or Trim(as_data) = "" Then
				dw_head.SetItem(al_row, "to_mat_nm", "")
				RETURN 0
			END IF
			IF LenA(as_data) = 10 and LeftA(as_data, 2) = is_brand + is_mat_gubn Then
				If gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					dw_head.SetItem(al_row, "to_mat_nm", ls_mat_nm)
				Else
					dw_head.SetItem(al_row, "to_mat_nm", "")
					is_ord_chk = 'NEW'
					dw_head.Object.to_mat_nm.Protect = 0
					dw_head.Object.to_mat_nm.BackGround.Color = RGB(255, 255, 255)
				End If
				RETURN 0
			END IF
		END IF
		gst_cd.ai_div          = ai_div
		If is_mat_gubn = '1' Then
			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
		Else
			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
		End If
		gst_cd.default_where   = ""
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
				dw_head.SetRow(al_row)
				dw_head.SetColumn(as_column)
			END IF
			dw_head.SetItem(al_row, "to_mat_cd", lds_Source.GetItemString(1,"mat_cd"))
			dw_head.SetItem(al_row, "to_mat_nm", lds_Source.GetItemString(1,"mat_nm"))
			/* 다음컬럼으로 이동 */
			cb_retrieve.SetFocus()
//				dw_head.SetColumn("to_mat_cd")
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
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
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


is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"이체 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_house = Trim(dw_head.GetItemString(1, "house"))
if IsNull(is_house) or is_house = "" then
   MessageBox(ls_title,"창고 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

is_fr_mat_cd = Trim(dw_head.GetItemString(1, "fr_mat_cd"))
if IsNull(is_fr_mat_cd) or is_fr_mat_cd = "" then
   MessageBox(ls_title,"FROM 자재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_mat_cd")
   return false
end if

is_to_mat_cd = Trim(dw_head.GetItemString(1, "to_mat_cd"))
if IsNull(is_to_mat_cd) or is_to_mat_cd = "" then
   MessageBox(ls_title,"TO 자재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_mat_cd")
   return false
end if

if is_to_mat_cd = is_fr_mat_cd then
   MessageBox(ls_title,"같은 자재 코드로 이체할 수 없습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_mat_cd")
   return false
end if

is_to_mat_nm = Trim(dw_head.GetItemString(1, "to_mat_nm"))
if IsNull(is_to_mat_nm) or is_to_mat_nm = "" then
   MessageBox(ls_title,"TO 자재 명을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_mat_nm")
   return false
end if

return true

end event

event open;call super::open;is_mat_gubn = '1'

dw_head.SetItem(1, "house", '110000')

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

is_new_chk = 'I'
dw_body.SetFilter("stock_qty <> 0")
il_rows = dw_body.Retrieve(is_brand, is_new_chk, is_house, is_fr_mat_cd, is_to_mat_cd)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(1)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.04                                                  */	
/* 수정일      : 2002.03.04                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_in_max, ll_out_max, ll_rows
Decimal ldc_amt
String ls_mat_year

IF dw_body.AcceptText() <> 1 THEN RETURN -1

dw_out.ReSet()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(id_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

// 출고번호 & 입고번호 채번
If wf_num(ll_out_max, ll_in_max) <> 0 Then Return -1

dw_body.SetReDraw(False)

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		If is_new_chk = 'I' Then
			
			idc_qty = dw_body.GetItemDecimal(i, "tmp_qty")
			If IsNull(idc_qty) or idc_qty = 0 Then
				dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
			Else
				is_cust_cd    = dw_body.GetItemString (i, "cust_cd")
				is_color      = dw_body.GetItemString (i, "color")
				is_spec       = dw_body.GetItemString (i, "spec")
				is_unit       = dw_body.GetItemString (i, "unit")
				
				ls_mat_year   = MidA(is_to_mat_cd, 3, 1)
				gf_get_inter_sub('002', ls_mat_year, '1', is_mat_year)
				
				is_mat_season = MidA(is_to_mat_cd, 4, 1)
				is_mat_sojae  = MidA(is_to_mat_cd, 5, 1)
				is_mat_chno   = MidA(is_to_mat_cd, 10, 1)
				
				is_out_seq    = dw_body.GetItemString (i, "out_seq")
				idc_price     = dw_body.GetItemDecimal(i, "price")
				ldc_amt       = dw_body.GetItemDecimal(i, "amt1")
				is_mat_type   = dw_body.GetItemString (i, "mat_type")		//부자재용 
				
				If wf_ord_update(is_mat_gubn) <> 0 Then 
					rollback  USING SQLCA;
					dw_body.SetReDraw(True)
					Return -1
				End If
				dw_body.Setitem(i, "brand",    MidA(is_to_mat_cd, 1, 1))
				
				dw_body.Setitem(i, "in_ymd",    is_yymmdd)
				ll_in_max++
				dw_body.Setitem(i, "in_no",     String(ll_in_max, '0000'))
				dw_body.SetItem(i, "sil_qty",   idc_qty)
				dw_body.SetItem(i, "amt",       ldc_amt)
//				dw_body.SetItem(i, "out_price", idc_price)
//				dw_body.SetItem(i, "out_amt",   ldc_amt)
				dw_body.Setitem(i, "reg_id",    gs_user_id)
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
				
				// dw_out(TB_22020_H 원부자재 출고 내역)
				is_mat_year   = dw_body.GetItemString (i, "mat_year")
				is_mat_season = dw_body.GetItemString (i, "mat_season")
				is_mat_sojae  = dw_body.GetItemString (i, "mat_sojae")
				is_mat_chno   = dw_body.GetItemString (i, "mat_chno")

				il_rows = dw_out.InsertRow(0)
				dw_out.SetItem(il_rows, "brand",      is_brand)
				dw_out.SetItem(il_rows, "out_ymd",    is_yymmdd)
				dw_out.SetItem(il_rows, "out_gubn",   '02')
				ll_out_max++
				dw_out.SetItem(il_rows, "out_no",     String(ll_out_max, '0000'))
				dw_out.SetItem(il_rows, "io_gubn",    '+')
				dw_out.SetItem(il_rows, "house",      is_house)
				dw_out.SetItem(il_rows, "cust_cd",    is_cust_cd)
				dw_out.SetItem(il_rows, "mat_cd",     is_fr_mat_cd)
				dw_out.SetItem(il_rows, "color",      is_color)
				dw_out.SetItem(il_rows, "spec",       is_spec)
				dw_out.SetItem(il_rows, "unit",       is_unit)
				dw_out.SetItem(il_rows, "qty",        idc_qty)
				dw_out.SetItem(il_rows, "price",      idc_price)
				dw_out.SetItem(il_rows, "amt",        ldc_amt)
				dw_out.SetItem(il_rows, "mat_year",   is_mat_year)
				dw_out.SetItem(il_rows, "mat_season", is_mat_season)
				dw_out.SetItem(il_rows, "mat_sojae",  is_mat_sojae)
				dw_out.SetItem(il_rows, "mat_chno",   is_mat_chno)
				dw_out.SetItem(il_rows, "out_seq",    is_out_seq)
				dw_out.SetItem(il_rows, "mat_gubn",   is_mat_gubn)
				dw_out.SetItem(il_rows, "reg_id",     gs_user_id )
			End If
		End If
	END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
ll_rows = dw_out. Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 then
	dw_body.ResetUpdate()
	dw_out.ResetUpdate()
	commit  USING SQLCA;

	dw_head.Object.to_mat_nm.Protect = 1
	dw_head.Object.to_mat_nm.BackGround.Color = RGB(192, 192, 192)
	
	is_new_chk = 'R'
	dw_body.SetFilter("tmp_qty <> 0")
	dw_body.Retrieve(is_brand, is_yymmdd, is_house, is_fr_mat_cd, is_to_mat_cd)
//	dw_body.Filter()
else
	rollback  USING SQLCA;
	If il_rows = 1 Then il_rows = ll_rows
end if

dw_body.SetReDraw(True)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_preopen;call super::pfc_preopen;dw_out.SetTransObject(SQLCA)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         rb_mmat.Enabled = false
         rb_smat.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				rb_mmat.Enabled = false
				rb_smat.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
		rb_mmat.Enabled = true
		rb_smat.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.09                                                  */	
/* 수정일      : 2002.03.09                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text = '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_yymmdd.Text = '" + String(is_yymmdd, '@@@@/@@/@@') + "'" + &
            "t_house.Text = '" + idw_house.GetItemString(idw_house.GetRow(), "shop_display") + "'" + &
            "t_mat_cd.Text = '" + String(is_fr_mat_cd, '@@@@@@@@@-@') + " " + dw_head.GetItemString(1, "fr_mat_nm") + &
				             " ~~ " + String(is_to_mat_cd, '@@@@@@@@@-@') + " " + dw_head.GetItemString(1, "to_mat_nm") + "'"

dw_print.Modify(ls_modify)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22011_e","0")
end event

type cb_close from w_com010_e`cb_close within w_22011_e
end type

type cb_delete from w_com010_e`cb_delete within w_22011_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_22011_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22011_e
end type

type cb_update from w_com010_e`cb_update within w_22011_e
end type

type cb_print from w_com010_e`cb_print within w_22011_e
end type

type cb_preview from w_com010_e`cb_preview within w_22011_e
end type

type gb_button from w_com010_e`gb_button within w_22011_e
end type

type cb_excel from w_com010_e`cb_excel within w_22011_e
end type

type dw_head from w_com010_e`dw_head within w_22011_e
integer x = 503
integer width = 3054
integer height = 220
string dataobject = "d_22011_h01"
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
/* 작성일      : 2002.03.02                                                  */	
/* 수정일      : 2002.03.02                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "brand", "mat_gubn"
		This.SetItem(1, "fr_mat_cd", "")
		This.SetItem(1, "fr_mat_nm", "")
		This.SetItem(1, "to_mat_cd", "")
		This.SetItem(1, "to_mat_nm", "")
	CASE "fr_mat_cd", "to_mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22011_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22011_e
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22011_e
integer y = 444
integer height = 1596
string dataobject = "d_22011_d01"
boolean hscrollbar = true
end type

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

type dw_print from w_com010_e`dw_print within w_22011_e
integer x = 274
integer y = 648
string dataobject = "d_22011_r01"
end type

type rb_mmat from radiobutton within w_22011_e
integer x = 46
integer y = 208
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "원자재 이체"
boolean checked = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_smat.TextColor = 0

dw_body.DataObject = 'd_22011_d01'
dw_body.SetTransObject(SQLCA)
Parent.Trigger Event ue_init(dw_body)

dw_print.DataObject = 'd_22011_r01'
dw_print.SetTransObject(SQLCA)

is_mat_gubn = '1'

dw_head.SetItem(1, "fr_mat_cd", "")
dw_head.SetItem(1, "fr_mat_nm", "")
dw_head.SetItem(1, "to_mat_cd", "")
dw_head.SetItem(1, "to_mat_nm", "")

end event

type rb_smat from radiobutton within w_22011_e
integer x = 46
integer y = 316
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "부자재 이체"
borderstyle borderstyle = stylelowered!
end type

event clicked;This.TextColor = RGB(0, 0, 255)
rb_mmat.TextColor = 0

dw_body.DataObject = 'd_22011_d02'
dw_body.SetTransObject(SQLCA)
Parent.Trigger Event ue_init(dw_body)

dw_print.DataObject = 'd_22011_r02'
dw_print.SetTransObject(SQLCA)

is_mat_gubn = '2'

dw_head.SetItem(1, "fr_mat_cd", "")
dw_head.SetItem(1, "fr_mat_nm", "")
dw_head.SetItem(1, "to_mat_cd", "")
dw_head.SetItem(1, "to_mat_nm", "")

end event

type gb_1 from groupbox within w_22011_e
integer y = 136
integer width = 480
integer height = 284
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type dw_out from u_dw within w_22011_e
boolean visible = false
integer x = 1394
integer y = 300
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_22011_d03"
end type

