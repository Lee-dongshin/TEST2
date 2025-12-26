$PBExportHeader$w_22001_e_old.srw
$PBExportComments$원자재 입고 등록
forward
global type w_22001_e_old from w_com020_e
end type
type dw_mast from u_dw within w_22001_e_old
end type
end forward

global type w_22001_e_old from w_com020_e
dw_mast dw_mast
end type
global w_22001_e_old w_22001_e_old

type variables
DataWindowChild idw_brand, idw_house

String is_brand, is_yymmdd, is_mmat_cd, is_house, is_new_chk
Boolean lb_insert = False

end variables

on w_22001_e_old.create
int iCurrent
call super::create
this.dw_mast=create dw_mast
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mast
end on

on w_22001_e_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mast)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */ 
/* 작성일      : 2002.02.09                                                  */
/* 수정일      : 2002.02.09                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_mast.retrieve(is_mmat_cd)

il_rows = dw_list.retrieve(is_brand, is_mmat_cd, is_house)
dw_body.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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

is_yymmdd = Trim(String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd'))
if IsNull(is_yymmdd) or is_yymmdd = "" then
   MessageBox(ls_title,"입고 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_mmat_cd = Trim(dw_head.GetItemString(1, "mmat_cd"))
if IsNull(is_mmat_cd) or is_mmat_cd = "" then
   MessageBox(ls_title,"소재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mmat_cd")
   return false
end if

is_house = Trim(dw_head.GetItemString(1, "house"))
if IsNull(is_house) or is_house = "" then
   MessageBox(ls_title,"입고 창고를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("house")
   return false
end if

return true

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
String     ls_mmat_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "mmat_cd"
		is_brand = dw_head.GetItemString(1, "brand")
		
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "mmat_nm", "")
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' AND STATUS_FG IN ('10', '20') "			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "MAT_CD LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mmat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "mmat_nm", lds_Source.GetItemString(1,"mat_nm"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
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

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(dw_mast, "ScaleToRight")
dw_mast.SetTransObject(SQLCA)
dw_mast.InsertRow(0)

end event

event open;call super::open;dw_head.SetItem(1, "house", '110000')

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
Long ll_row

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
//IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
//END IF

dw_list.SelectRow(0, FALSE)
ll_row = dw_list.Find("in_ymd = '" + is_yymmdd + "' ", 1, dw_list.RowCount())
If ll_row > 0 Then
	dw_list.SelectRow(ll_row, TRUE)
End IF

dw_mast.retrieve(is_mmat_cd)

is_new_chk = 'I'			//새로운 자료

//새로운 자료를 입력하기 위해 입고일에 is_new_cnk를 넣어 조회한다.
dw_body.SetReDraw(False)
dw_body.SetFilter("")
il_rows = dw_body.Retrieve(is_brand, is_new_chk, is_mmat_cd, is_house, is_new_chk)
//dw_body.Filter()
dw_body.SetReDraw(True)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
//	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_mast.Enabled = true
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
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
				dw_mast.Enabled = true
				dw_list.Enabled = true
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
//      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_mast.Enabled = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
		else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
long     i, ll_row_count, ll_in_max, ll_rows
datetime ld_datetime
String   ls_color, ls_spec, ls_fin_yn, ls_in_no
String   ls_mat_year, ls_mat_season, ls_mat_sojae, ls_mat_chno, ls_out_seq
Decimal  ldc_price, ldc_in_sum1, ldc_tmp_qty1

IF dw_mast.AcceptText() <> 1 THEN RETURN -1
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
		If IsNull(ldc_tmp_qty1) or ldc_tmp_qty1 = 0 Then
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		Else
			ls_spec = dw_body.GetItemString(i, "spec")
			If IsNull(ls_spec) or Trim(ls_spec) = "" Then
				MessageBox("입력오류", "폭을 입력하십시요!")
				dw_body.ScrollToRow(i)
				dw_body.SetColumn("spec")
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
	
		// TB_21011_D(원자재 발주 내역)에 Setting
		ls_color    = dw_body.GetItemString (i, "color")
		ls_spec     = dw_body.GetItemString (i, "spec")
		ldc_in_sum1 = dw_body.GetItemDecimal(i, "in_sum1")
		ldc_price   = dw_body.GetItemDecimal(i, "price")
		ls_fin_yn   = dw_body.GetItemString (i, "fin_yn")
		
//		  UPDATE TB_21011_D
//			  SET SPEC     = :ls_spec,
//					IN_QTY   = :ldc_in_sum1,
//					IN_PRICE = :ldc_price,
//					FIN_YN   = :ls_fin_yn,
//					MOD_ID   = :gs_user_id,
//					MOD_DT   = :ld_datetime
//			WHERE MAT_CD = :is_mmat_cd
//			  AND COLOR  = :ls_color
//		  ;
//		If SQLCA.SQLCODE <> 0 Then
//			MessageBox("저장오류", "TB_21011_D(원자재 발주 내역) UPDATE에 실패하였습니다!")
//			rollback  USING SQLCA;
//			dw_body.SetReDraw(True)
//			Return -1
//		End If
		
		If is_new_chk = 'I' Then			//새로 입력한 DATA
//			ls_color     = dw_body.GetItemString (i, "color")
			ldc_tmp_qty1 = dw_body.GetItemDecimal(i, "tmp_qty1")
			dw_body.Setitem(i, "in_ymd",     is_yymmdd)
			ll_in_max++
			dw_body.Setitem(i, "in_no",      String(ll_in_max, '0000'))
			dw_body.SetItem(i, "ord_ymd",    dw_mast.GetItemString(1, "ord_ymd"))
			dw_body.SetItem(i, "ord_origin", is_mmat_cd)
			dw_body.SetItem(i, "cust_cd",    dw_mast.GetItemString(1, "cust_cd"))
			dw_body.SetItem(i, "unit",       dw_mast.GetItemString(1, "unit"))
			dw_body.Setitem(i, "tmp_qty",    ldc_tmp_qty1)
			dw_body.Setitem(i, "reg_id",     gs_user_id)
			dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			dw_mast.SetItem(1, "status_fg", '20')
			dw_mast.Setitem(1, "mod_id",    gs_user_id)
			dw_mast.Setitem(1, "mod_dt",    ld_datetime)
			
			// TB_22011_D(원자재 검단 내역)에 Setting
			ls_mat_year   = dw_body.GetItemString(i, "mat_year")
			ls_mat_season = dw_body.GetItemString(i, "mat_season")
			ls_mat_sojae  = dw_body.GetItemString(i, "mat_sojae")
			ls_mat_chno   = dw_body.GetItemString(i, "mat_chno")
			ls_out_seq    = dw_body.GetItemString(i, "out_seq")

			ls_in_no = string(ll_in_max,'0000')
			
			  INSERT
				 INTO TB_22011_D
						(BRAND, IN_YMD, IN_GUBN, IN_NO, MAT_CD, COLOR, TMP_QTY, QC_QTY,
						 MAT_YEAR, MAT_SEASON, MAT_SOJAE, MAT_CHNO, OUT_SEQ, REG_ID)
			  VALUES (:is_brand, :is_yymmdd, '01', :ls_in_no, :is_mmat_cd, :ls_color, :ldc_tmp_qty1, :ldc_tmp_qty1,
						 :ls_mat_year, :ls_mat_season, :ls_mat_sojae, :ls_mat_chno, :ls_out_seq, :gs_user_id)
			  ;
			If SQLCA.SQLCODE <> 0 Then
				MessageBox("저장오류", "TB_22011_D(원자재 검단 내역) INSERT에 실패하였습니다!")
				rollback  USING SQLCA;
				dw_body.SetReDraw(True)
				Return -1
			End If

		Else
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		End If
		dw_body.SetItem(i, "sil_qty", dw_body.GetItemDecimal(i, "sil_qty1"))
		dw_body.SetItem(i, "amt",     dw_body.GetItemDecimal(i, "amt1"))
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)
ll_rows = dw_mast.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 Then
   dw_body.ResetUpdate()
   dw_mast.ResetUpdate()
   commit  USING SQLCA;

	ll_rows = dw_list.retrieve(is_brand, is_mmat_cd, is_house)
	ll_rows = dw_list.Find("in_ymd = '" + is_yymmdd + "' ", 1, dw_list.RowCount())
	If ll_rows > 0 Then
		dw_list.SelectRow(0, FALSE)
		dw_list.SelectRow(ll_rows, TRUE)
		is_new_chk = 'R'
		
		dw_body.SetReDraw(False)
		dw_body.SetFilter("tmp_qty1 <> 0")
		dw_body.Retrieve(is_brand, is_yymmdd, is_mmat_cd, is_house, is_new_chk)
//		dw_body.Filter()

		dw_body.SetReDraw(True)

		dw_body.SetFocus()
	End IF
else
   rollback  USING SQLCA;
	If ll_rows <> 1 Then
		il_rows = ll_rows
	End If
end if

dw_body.SetReDraw(True)

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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
            "t_mmat_cd.Text = '" + String(is_mmat_cd, '@@@@@@@@@-@') + "'" + &
            "t_mmat_nm.Text = '" + dw_head.GetItemString(1, "mmat_nm") + "'" + &
            "t_house.Text = '" + idw_house.GetItemString(idw_house.GetRow(), "shop_display") + "'"

dw_print.Modify(ls_modify)

end event

type cb_close from w_com020_e`cb_close within w_22001_e_old
integer taborder = 120
end type

type cb_delete from w_com020_e`cb_delete within w_22001_e_old
boolean visible = false
integer taborder = 70
end type

type cb_insert from w_com020_e`cb_insert within w_22001_e_old
integer taborder = 60
boolean enabled = true
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22001_e_old
end type

type cb_update from w_com020_e`cb_update within w_22001_e_old
integer taborder = 110
end type

type cb_print from w_com020_e`cb_print within w_22001_e_old
integer taborder = 80
end type

type cb_preview from w_com020_e`cb_preview within w_22001_e_old
integer taborder = 90
end type

type gb_button from w_com020_e`gb_button within w_22001_e_old
end type

type cb_excel from w_com020_e`cb_excel within w_22001_e_old
integer taborder = 100
end type

type dw_head from w_com020_e`dw_head within w_22001_e_old
integer height = 228
string dataobject = "d_22001_h01_old"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "mmat_cd", "")
		This.SetItem(row, "mmat_nm", "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "mmat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("house", idw_house)
idw_house.SetTransObject(SQLCA)
idw_house.Retrieve()

end event

type ln_1 from w_com020_e`ln_1 within w_22001_e_old
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com020_e`ln_2 within w_22001_e_old
integer beginy = 428
integer endy = 428
end type

type dw_list from w_com020_e`dw_list within w_22001_e_old
integer y = 612
integer width = 718
integer height = 1428
integer taborder = 40
string dataobject = "d_22001_d02_old"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

IF ib_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN 1
			END IF		
		CASE 3
			RETURN 1
	END CHOOSE
END IF
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_yymmdd = This.GetItemString(row, 'in_ymd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) THEN return

is_new_chk = 'R'			//등록된 자료

dw_body.SetReDraw(False)
dw_body.SetFilter("tmp_qty1 <> 0")
il_rows = dw_body.retrieve(is_brand, is_yymmdd, is_mmat_cd, is_house, is_new_chk)
//dw_body.Filter()
dw_body.SetReDraw(True)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)
//This.of_SetRowSelect(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

end event

type dw_body from w_com020_e`dw_body within w_22001_e_old
integer x = 768
integer y = 612
integer width = 2825
integer height = 1428
integer taborder = 50
string dataobject = "d_22001_d03_old"
boolean hscrollbar = true
end type

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
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
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

Return 0
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
String ls_color
Long i

CHOOSE CASE dwo.name
	CASE "tmp_qty1" 
		If Double(data) < 0 Then
			MessageBox("입력오류", "마이너스(-)를 입력할 수 없습니다!")
			Return 1
		End If
		IF IsNull(data) or Double(data) = 0 THEN
			dw_body.SetItem(row, "spec", "")
			dw_body.SetItem(row, "price", 0)
			dw_body.SetItem(row, "sil_chk", 'N')
			dw_body.SetItem(row, "qc_qty", Double(data))
		END IF
	CASE "fin_yn" 
		ls_color = This.GetItemString(row, "color")
		For i = 1 To This.RowCount()
			If This.GetItemString(i, "color") = ls_color Then
				This.SetItem(i, "fin_yn", data)
			End IF
		Next
END CHOOSE

end event

type st_1 from w_com020_e`st_1 within w_22001_e_old
integer x = 750
integer y = 612
integer height = 1428
end type

type dw_print from w_com020_e`dw_print within w_22001_e_old
string dataobject = "d_22001_r01"
end type

type dw_mast from u_dw within w_22001_e_old
integer x = 27
integer y = 440
integer width = 3566
integer height = 164
integer taborder = 30
boolean enabled = false
string dataobject = "d_22001_d01_old"
boolean vscrollbar = false
boolean livescroll = false
end type

