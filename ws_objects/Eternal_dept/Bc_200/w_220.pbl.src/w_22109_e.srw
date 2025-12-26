$PBExportHeader$w_22109_e.srw
$PBExportComments$부자재 출고반품 등록
forward
global type w_22109_e from w_com020_e
end type
type st_remark from statictext within w_22109_e
end type
type st_remark2 from statictext within w_22109_e
end type
end forward

global type w_22109_e from w_com020_e
integer width = 3675
integer height = 2276
st_remark st_remark
st_remark2 st_remark2
end type
global w_22109_e w_22109_e

type variables
DataWindowChild idw_brand, idw_house

String is_brand, is_yymmdd, is_fr_out_ymd, is_to_out_ymd, is_house, is_cust_cd, is_smat_cd
Long il_list_row

end variables

on w_22109_e.create
int iCurrent
call super::create
this.st_remark=create st_remark
this.st_remark2=create st_remark2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_remark
this.Control[iCurrent+2]=this.st_remark2
end on

on w_22109_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_remark)
destroy(this.st_remark2)
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
				dw_head.SetColumn("smat_cd")
				ib_itemchanged = False
				lb_check = TRUE
			END IF
			Destroy  lds_Source
	CASE "smat_cd"
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
				   dw_head.SetItem(al_row, "smat_nm", "")
					RETURN 0
				END IF 
				
				IF LeftA(as_data, 2) = is_brand + '2' and gf_mat_nm(as_data, ls_cust_nm) = 0 THEN
				   dw_head.SetItem(al_row, "smat_nm", ls_cust_nm)
					RETURN 0
				END IF
			END IF
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "부자재 코드 검색" 
			gst_cd.datawindow_nm   = "d_com913" 
			gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' "			
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
				dw_head.SetItem(al_row, "smat_cd", lds_Source.GetItemString(1,"mat_cd"))
				dw_head.SetItem(al_row, "smat_nm", lds_Source.GetItemString(1,"mat_nm"))
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

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */
/* 작성일      : 2002.02.15                                                  */
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_out_ymd, is_to_out_ymd, is_house, is_cust_cd, is_smat_cd)
			 dw_body.retrieve(is_brand, is_fr_out_ymd, is_yymmdd, is_house, is_cust_cd, is_smat_cd)

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "출고 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
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
   MessageBox(ls_title,"반품 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

is_fr_out_ymd = Trim(String(dw_head.GetItemDatetime(1, "fr_out_ymd"), 'yyyymmdd'))
if IsNull(is_fr_out_ymd) or is_fr_out_ymd = "" then
   MessageBox(ls_title,"출고 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_out_ymd")
   return false
end if

is_to_out_ymd = Trim(String(dw_head.GetItemDatetime(1, "to_out_ymd"), 'yyyymmdd'))
if IsNull(is_to_out_ymd) or is_to_out_ymd = "" then
   MessageBox(ls_title,"출고 일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_out_ymd")
   return false
end if

if is_to_out_ymd < is_fr_out_ymd then
   MessageBox(ls_title,"마지막 일자가 시작 일자보다 작습니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_out_ymd")
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

is_smat_cd = Trim(dw_head.GetItemString(1, "smat_cd"))
if IsNull(is_smat_cd) or is_smat_cd = "" then
	is_smat_cd = '%'
end if

return true

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
			If dw_body.RowCount() > 0 Then
				cb_print.enabled = true
				cb_preview.enabled = true
				cb_excel.enabled = true
			End If
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
      cb_insert.enabled = false
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
			cb_insert.enabled = true
         cb_delete.enabled = true
		else
			cb_insert.enabled = false
         cb_delete.enabled = false
		end if
END CHOOSE

end event

event ue_msg;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/* ai_cb_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 6 - 삭제  */
/* al_rows     : 리턴값                                                      */
/*===========================================================================*/

String ls_msg

CHOOSE CASE ai_cb_div
   CASE 1      /* 조회 */
      CHOOSE CASE al_rows
         CASE IS > 0
            ls_msg = "조회가 완료되었습니다."
         CASE 0
            ls_msg = "조회 할 자료가 없습니다."
         CASE IS < 0
            ls_msg = "조회가 실패하였습니다."
      END CHOOSE
   CASE 2      /* 추가 */
      IF al_rows > 0 THEN
         ls_msg = "자료를 입력하십시요."
      ELSE
         ls_msg = "자료 입력이 실패했습니다."
      END IF
   CASE 3      /* 저장 */
      IF al_rows = 1 THEN
         ls_msg = "자료가 저장되었습니다."
      ELSE
         ls_msg = "자료 저장이 실패하였습니다."
      END IF
   CASE 4      /* 삭제 */
      IF al_rows > 0 THEN
         ls_msg = "자료가 삭제되었습니다."
      ELSE
         ls_msg = "자료 삭제가 실패하였습니다."
      END IF
   CASE 5      /* 조건 */
      ls_msg = "조회할 자료를 입력하세요."
   CASE 6      /* 인쇄 */
		IF al_rows = 1 THEN
         ls_msg = "인쇄가 되었습니다."
      ELSE
         ls_msg = "인쇄가 실패하였습니다."
      END IF
   CASE 7      /* dw_list Clicked */
      IF al_rows > 0 THEN
         ls_msg = "추가 버튼을 클릭하십시요."
      ELSE
         ls_msg = "적용 출고 내역을 정확히 선택하십시요."
      END IF
END CHOOSE

This.ParentWindow().SetMicroHelp(ls_msg)

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

dw_body.SetReDraw(False)

il_rows = dw_body.RowCount() + 1

dw_list.RowsCopy(il_list_row, il_list_row, Primary!, &
					  dw_body, il_rows, Primary!)

dw_body.SetItem(il_rows, "out_ymd", is_yymmdd)
dw_body.SetItem(il_rows, "qty", 0)
dw_body.SetItem(il_rows, "amt", 0)

dw_body.SetReDraw(True)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/
long     i, ll_row_count, ll_out_max
datetime ld_datetime
String   ls_color
Decimal  ldc_qty

IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// 출고번호 채번
  SELECT CAST(ISNULL(MAX(OUT_NO), '0') AS INT)
    INTO :ll_out_max
	 FROM TB_22020_H
	WHERE BRAND   = :is_brand
	  AND OUT_YMD  = :is_yymmdd
	  AND OUT_GUBN = '01'
  ;
If SQLCA.SQLCODE <> 0 Then
	MessageBox("저장오류", "입고번호 채번에 실패하였습니다!")
	Return -1
End If

ll_row_count = dw_body.RowCount()

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
		ldc_qty = dw_body.GetItemDecimal(i, "qty")
		If IsNull(ldc_qty) or ldc_qty = 0 Then
			dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
		Else
			ll_out_max++
	      dw_body.Setitem(i, "out_no", String(ll_out_max, '0000'))
	      dw_body.Setitem(i, "io_gubn", '-')
	      dw_body.Setitem(i, "reg_id", gs_user_id)
		End If
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_body.Retrieve(is_brand, is_fr_out_ymd, is_yymmdd, is_house, is_cust_cd, is_smat_cd)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event open;call super::open;Datetime ld_datetime

ld_datetime = dw_head.GetItemDatetime(1, "yymmdd")

dw_head.SetItem(1, "fr_out_ymd", ld_datetime)
dw_head.SetItem(1, "to_out_ymd", ld_datetime)
dw_head.SetItem(1, "house", '110000')

end event

event ue_title;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.14                                                  */	
/* 수정일      : 2002.02.14                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_smat_cd, ls_smat_nm

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

If is_smat_cd = '%' Then
	ls_smat_cd = '%'
	ls_smat_nm = '전체'
Else
	ls_smat_cd = String(is_smat_cd, '@@@@@@@@@-@')
	ls_smat_nm = dw_head.GetItemString(1, "smat_nm")
End If

ls_modify =	"t_pg_id.Text =    '" + is_pgm_id + "'" + &
            "t_user_id.Text =  '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + &
            "t_brand.Text =    '" + idw_brand.GetItemString(idw_brand.GetRow(), "inter_display") + "'" + &
            "t_out_ymd.Text =  '" + String(is_fr_out_ymd, '@@@@/@@/@@') + " ~~ " + String(is_to_out_ymd, '@@@@/@@/@@') + "'" + &
            "t_house.Text =    '" + idw_house.GetItemString(idw_house.GetRow(), "shop_display") + "'" + &
            "t_cust_cd.Text =  '" + is_cust_cd + "'" + &
            "t_cust_nm.Text =  '" + dw_head.GetItemString(1, "cust_nm") + "'" + &
            "t_smat_cd.Text =  '" + ls_smat_cd + " " + ls_smat_nm + "'"

dw_print.Modify(ls_modify)

end event

event pfc_preopen;call super::pfc_preopen;inv_resize.of_Register(st_remark2, "FixedToRight")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_22109_e","0")
end event

type cb_close from w_com020_e`cb_close within w_22109_e
end type

type cb_delete from w_com020_e`cb_delete within w_22109_e
boolean visible = false
end type

type cb_insert from w_com020_e`cb_insert within w_22109_e
boolean visible = false
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_22109_e
end type

type cb_update from w_com020_e`cb_update within w_22109_e
end type

type cb_print from w_com020_e`cb_print within w_22109_e
end type

type cb_preview from w_com020_e`cb_preview within w_22109_e
end type

type gb_button from w_com020_e`gb_button within w_22109_e
end type

type cb_excel from w_com020_e`cb_excel within w_22109_e
end type

type dw_head from w_com020_e`dw_head within w_22109_e
integer height = 220
string dataobject = "d_22109_h01"
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
/* 작성일      : 2002.02.15                                                  */	
/* 수정일      : 2002.02.15                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "cust_cd", "")
		This.SetItem(row, "cust_nm", "")
		This.SetItem(row, "smat_cd", "")
		This.SetItem(row, "smat_nm", "")
	CASE "yymmdd"
		If gf_iwoldate_chk(gs_user_id, is_pgm_id, LeftA(data, 4) + MidA(data, 6, 2) + MidA(data, 9, 2)) = False Then
			MessageBox("입력오류", "일자를 소급할 수 없습니다!")
			Return 1
		End If
	CASE "cust_cd", "smat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_22109_e
integer beginy = 424
integer endy = 424
end type

type ln_2 from w_com020_e`ln_2 within w_22109_e
integer beginy = 428
integer endy = 428
end type

type dw_list from w_com020_e`dw_list within w_22109_e
integer y = 508
integer width = 1769
integer height = 1532
string dataobject = "d_22109_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

IF row <= 0 THEN Return

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

//il_list_row = row
//
//Parent.Trigger Event ue_button(7, il_list_row)
//Parent.Trigger Event ue_msg(7, il_list_row)

end event

event dw_list::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

event dw_list::doubleclicked;call super::doubleclicked;/*===========================================================================*/
/* 작성자      : 지우정보      															  */	
/*===========================================================================*/

IF row <= 0 THEN Return

il_list_row = row

Parent.Trigger Event ue_insert()

end event

type dw_body from w_com020_e`dw_body within w_22109_e
integer x = 1824
integer y = 508
integer width = 1769
integer height = 1532
string dataobject = "d_22109_d02"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "qty" 
		This.SetItem(row, "amt", Double(data) * This.GetItemDecimal(row, "price"))
END CHOOSE

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.02.18                                                  */	
/* 수정일      : 2002.02.18                                                  */
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

type st_1 from w_com020_e`st_1 within w_22109_e
integer x = 1801
integer y = 508
integer height = 1532
end type

type dw_print from w_com020_e`dw_print within w_22109_e
string dataobject = "d_22109_r01"
end type

type st_remark from statictext within w_22109_e
integer x = 37
integer y = 448
integer width = 1888
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "( 추가 시 : 적용 출고 내역을 더블클릭 )"
boolean focusrectangle = false
end type

type st_remark2 from statictext within w_22109_e
integer x = 2921
integer y = 448
integer width = 645
integer height = 48
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "( 반품량 : ~'-~'로 입력 )"
alignment alignment = right!
boolean focusrectangle = false
end type

