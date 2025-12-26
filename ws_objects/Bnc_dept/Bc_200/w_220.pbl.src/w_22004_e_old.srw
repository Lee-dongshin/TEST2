$PBExportHeader$w_22004_e_old.srw
$PBExportComments$STYLE별 부자재 입고 등록
forward
global type w_22004_e_old from w_com010_e
end type
type cb_copy from commandbutton within w_22004_e_old
end type
type dw_out from u_dw within w_22004_e_old
end type
end forward

global type w_22004_e_old from w_com010_e
event ue_copy ( )
cb_copy cb_copy
dw_out dw_out
end type
global w_22004_e_old w_22004_e_old

type variables
DataWindowChild idw_brand, idw_house

String is_brand, is_yymmdd, is_house, is_cust_cd, is_style_no, is_new_chk

end variables

event ue_copy;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
Long i

if dw_body.AcceptText() <> 1 then return

For i = 1 To dw_body.RowCount()
	dw_body.SetItem(i, "tmp_qty1", dw_body.GetItemDecimal(i, "mi_qty"))
	
	If dw_body.GetItemDecimal(i, "tmp_qty1") = 0 Then
		dw_body.SetItem(i, "price", 0)
	Else 
		dw_body.SetItem(i, "price", dw_body.GetItemDecimal(i, "nego_price"))
	End If
Next

// itemchanged
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

dw_body.SetFocus()

end event

on w_22004_e_old.create
int iCurrent
call super::create
this.cb_copy=create cb_copy
this.dw_out=create dw_out
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copy
this.Control[iCurrent+2]=this.dw_out
end on

on w_22004_e_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copy)
destroy(this.dw_out)
end on

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
	CASE "style_no"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(1, "st_cust_cd", "")
					dw_head.SetItem(1, "st_cust_nm", "")
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "품번 코드 검색"
			gst_cd.datawindow_nm   = "d_com010"
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' "
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " STYLE LIKE '" + LeftA(as_data, 8)   + "%' " + & 
									 " AND CHNO LIKE '"  + MidA(as_data, 9, 1) + "%' "
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
				dw_head.SetItem(al_row, "st_cust_cd", lds_Source.GetItemString(1,"cust_cd"))
				dw_head.SetItem(al_row, "st_cust_nm", lds_Source.GetItemString(1,"cust_nm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("style_no")
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

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
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
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"입고 일자를 입력하십시요!")
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

is_cust_cd = Trim(dw_head.GetItemString(1, "cust_cd"))
if IsNull(is_cust_cd) or is_cust_cd = "" then
   MessageBox(ls_title,"업체 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("cust_cd")
   return false
end if

is_style_no = Trim(dw_head.GetItemString(1, "style_no"))
if IsNull(is_style_no) or is_style_no = "" then
   MessageBox(ls_title,"품번 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("style_no")
   return false
end if

return true

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
il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_house, is_cust_cd, is_style_no, is_new_chk)
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

event open;call super::open;dw_head.SetItem(1, "house", '110000')

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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
il_rows = dw_body.Retrieve(is_brand, is_new_chk, is_house, is_cust_cd, is_style_no, is_new_chk)
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
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_in_max, ll_out_max, ll_rows
datetime ld_datetime
String ls_ord_ymd, ls_ord_no, ls_no, ls_fin_yn, ls_mat_cd, ls_color, ls_st_color
Decimal ldc_tmp_qty1, ldc_price, ldc_amt1

IF dw_body.AcceptText() <> 1 THEN RETURN -1

dw_out.ReSet()

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ll_row_count = dw_body.RowCount()

//// Null Check
//FOR i = 1 TO ll_row_count
//	ldc_tmp_qty1 = dw_body.GetItemDecimal(i, "tmp_qty1")
//	If IsNull(ldc_tmp_qty1) or ldc_tmp_qty1 = 0 Then
//		dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
//	End If
//NEXT

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

// 출고번호 채번
  SELECT CAST(ISNULL(MAX(OUT_NO), '0') AS INT)
	 INTO :ll_out_max
	 FROM TB_22020_H
	WHERE BRAND   = :is_brand
	  AND OUT_YMD  = :is_yymmdd
	  AND OUT_GUBN = '01'
  ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox("저장오류", "출고번호 채번에 실패하였습니다!")
	Return -1
End If

dw_body.SetReDraw(False)

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	IF idw_status = DataModified! THEN		/* Modify Record */
		ls_ord_ymd = dw_body.GetItemString (i, "ord_ymd")
		ls_ord_no  = dw_body.GetItemString (i, "ord_no")
		ls_no      = dw_body.GetItemString (i, "no")
		ldc_price  = dw_body.GetItemDecimal(i, "price")
		ls_fin_yn  = dw_body.GetItemString (i, "fin_yn")
		
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
		End if
			
		If is_new_chk = 'I' Then
			ldc_tmp_qty1 = dw_body.GetItemDecimal(i, "tmp_qty1")
			If IsNull(ldc_tmp_qty1) or ldc_tmp_qty1 = 0 Then
				dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
			Else
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
				dw_body.Setitem(i, "in_ymd",  is_yymmdd)
				ll_in_max++
				dw_body.Setitem(i, "in_no",   String(ll_in_max, '0000'))
				dw_body.SetItem(i, "tmp_qty", ldc_tmp_qty1)
				dw_body.SetItem(i, "sil_qty", ldc_tmp_qty1)
				ldc_amt1 = dw_body.GetItemDecimal(i, "amt1")
				dw_body.SetItem(i, "amt",     ldc_amt1)
				dw_body.Setitem(i, "reg_id",  gs_user_id)
				ls_mat_cd = dw_body.GetItemString(i, "mat_cd")
				ls_color  = dw_body.GetItemString(i, "color")
				
				// TB_12025_D (자재 소요량)
				  SELECT MAX(COLOR)
				    INTO :ls_st_color
				    FROM TB_12025_D
               WHERE STYLE     = LEFT(:is_style_no, 8)
                 AND CHNO      = SUBSTRING(:is_style_no, 9, 1)
                 AND MAT_CD    = :ls_mat_cd
                 AND MAT_COLOR = :ls_color
              ;

				// dw_out(TB_22020_H 원부자재 출고 내역)
				il_rows = dw_out.InsertRow(0)
				dw_out.SetItem(il_rows, "brand", is_brand)
				dw_out.SetItem(il_rows, "out_ymd", is_yymmdd)
				dw_out.SetItem(il_rows, "out_gubn", '01')
				ll_out_max++
				dw_out.SetItem(il_rows, "out_no", String(ll_out_max, '0000'))
				dw_out.SetItem(il_rows, "io_gubn", '+')
				dw_out.SetItem(il_rows, "house", is_house)
				dw_out.SetItem(il_rows, "cust_cd", dw_head.GetItemString(1, "st_cust_cd") )
				dw_out.SetItem(il_rows, "mat_cd", dw_body.GetItemString(i, "mat_cd") )
				dw_out.SetItem(il_rows, "color", dw_body.GetItemString(i, "color") )
				dw_out.SetItem(il_rows, "spec", dw_body.GetItemString(i, "spec") )
				dw_out.SetItem(il_rows, "unit", dw_body.GetItemString(i, "unit") )
				dw_out.SetItem(il_rows, "qty", ldc_tmp_qty1)
				dw_out.SetItem(il_rows, "price", ldc_price )
				dw_out.SetItem(il_rows, "amt", ldc_amt1)
				dw_out.SetItem(il_rows, "style", LeftA(is_style_no, 8) )
				dw_out.SetItem(il_rows, "st_chno", MidA(is_style_no, 9, 1) )
				dw_out.SetItem(il_rows, "st_color", ls_st_color )
				dw_out.SetItem(il_rows, "mat_year", dw_body.GetItemString(i, "mat_year") )
				dw_out.SetItem(il_rows, "mat_season", dw_body.GetItemString(i, "mat_season") )
				dw_out.SetItem(il_rows, "mat_sojae", dw_body.GetItemString(i, "mat_sojae") )
				dw_out.SetItem(il_rows, "mat_chno", dw_body.GetItemString(i, "mat_chno") )
				dw_out.SetItem(il_rows, "out_seq", dw_body.GetItemString(i, "out_seq") )
				dw_out.SetItem(il_rows, "mat_gubn", dw_body.GetItemString(i, "mat_gubn") )
				dw_out.SetItem(il_rows, "reg_id", gs_user_id )
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
	
	is_new_chk = 'R'
	dw_body.SetFilter("in_sum <> 0")
	dw_body.Retrieve(is_brand, is_yymmdd, is_house, is_cust_cd, is_style_no, is_new_chk)
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

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(cb_copy, "FixedToRight")
dw_out.SetTransObject(SQLCA)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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
			cb_copy.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_copy.enabled = false
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
		cb_copy.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.20                                                  */	
/* 수정일      : 2002.02.20                                                  */
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
            "t_cust_cd.Text =  '" + is_cust_cd + "'" + &
            "t_cust_nm.Text =  '" + dw_head.GetItemString(1, "cust_nm") + "'" + &
            "t_style_no.Text = '" + String(is_style_no, '@@@@@@@@-@') + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_22004_e_old
integer taborder = 110
end type

type cb_delete from w_com010_e`cb_delete within w_22004_e_old
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_22004_e_old
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_22004_e_old
end type

type cb_update from w_com010_e`cb_update within w_22004_e_old
integer taborder = 100
end type

type cb_print from w_com010_e`cb_print within w_22004_e_old
integer taborder = 70
end type

type cb_preview from w_com010_e`cb_preview within w_22004_e_old
integer taborder = 80
end type

type gb_button from w_com010_e`gb_button within w_22004_e_old
end type

type cb_excel from w_com010_e`cb_excel within w_22004_e_old
integer taborder = 90
end type

type dw_head from w_com010_e`dw_head within w_22004_e_old
integer height = 216
string dataobject = "d_22004_h01_old"
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
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "cust_cd", "")
		This.SetItem(row, "cust_nm", "")
		This.SetItem(row, "style_no", "")
		This.SetItem(row, "st_cust_cd", "")
		This.SetItem(row, "st_cust_nm", "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "cust_cd", "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_22004_e_old
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com010_e`ln_2 within w_22004_e_old
integer beginy = 428
integer endy = 428
end type

type dw_body from w_com010_e`dw_body within w_22004_e_old
integer y = 444
integer height = 1596
string dataobject = "d_22004_d01_old"
boolean hscrollbar = true
end type

event dw_body::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
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

type dw_print from w_com010_e`dw_print within w_22004_e_old
string dataobject = "d_22004_r01_old"
end type

type cb_copy from commandbutton within w_22004_e_old
event ue_keydown pbm_keydown
integer x = 1083
integer y = 44
integer width = 347
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "Copy(&C)"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)												  */	
/*===========================================================================*/
IF key = keyenter! THEN
	This.Triggerevent (clicked!)
END IF

end event

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)												  */	
/*===========================================================================*/
Parent.Trigger Event ue_copy()

end event

event getfocus;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)												  */	
/*===========================================================================*/
This.Weight = 700

end event

event losefocus;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)												  */	
/*===========================================================================*/
This.Weight = 400

end event

type dw_out from u_dw within w_22004_e_old
boolean visible = false
integer x = 1605
integer y = 340
integer taborder = 11
boolean bringtotop = true
string dataobject = "d_22004_d02_old"
end type

