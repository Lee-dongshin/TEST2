$PBExportHeader$w_53002_e.srw
$PBExportComments$타사 매출 등록
forward
global type w_53002_e from w_com010_e
end type
end forward

global type w_53002_e from w_com010_e
integer width = 3675
integer height = 2280
end type
global w_53002_e w_53002_e

type variables
DataWindowChild idw_brand

String is_brand, is_sale_dt, is_shop_cd

end variables

on w_53002_e.create
call super::create
end on

on w_53002_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_sale_dt, is_shop_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
/* Description : 조회,추가,저장 버튼 클릭시 발생                             */
/*               Key 부분이 되는 경우는 Instance Variables로 선언하고 사용함 */
/*===========================================================================*/
string   ls_title

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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_sale_dt = String(dw_head.GetItemDatetime(1, "yymmdd"), 'yyyymmdd')
if IsNull(is_sale_dt) or Trim(is_sale_dt) = "" then
   MessageBox(ls_title,"판매일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("yymmdd")
   return false
end if

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
string     ls_shop_cd, ls_shop_nm
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"				
		is_brand = dw_head.GetItemString(1, "brand")
		IF ai_div = 1 THEN 	
			if gs_brand <> 'K' then
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_head.SetItem(al_row, "shop_nm", "")
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
					dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
					RETURN 0
				END IF 
			end if
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = " WHERE BRAND = '" + is_brand + "' " + &
										 "   AND SHOP_STAT = '00' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("yymmdd")
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
/* 작성일      : 2001.12.17                                                  */
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
Decimal ldc_sale_amt

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	If idw_status <> NotModified! Then
		If dw_body.GetItemString(i, "new_chk") = 'N' Then
			ldc_sale_amt = dw_body.GetItemDecimal(i, "sale_amt")
			If IsNull(ldc_sale_amt) or ldc_sale_amt = 0 Then
				dw_body.SetItemStatus(i, 0, Primary!, NotModified!)
			Else
				dw_body.Setitem(i, "sale_ymd", is_sale_dt)
				dw_body.Setitem(i, "shop_cd", is_shop_cd)
				dw_body.Setitem(i, "reg_id", gs_user_id)
				dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
			End If
		Else
			dw_body.Setitem(i, "mod_id", gs_user_id)
			dw_body.Setitem(i, "mod_dt", ld_datetime)
		END IF
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	dw_body.retrieve(is_brand, is_sale_dt, is_shop_cd)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_53002_e","0")
end event

type cb_close from w_com010_e`cb_close within w_53002_e
end type

type cb_delete from w_com010_e`cb_delete within w_53002_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_53002_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_53002_e
end type

type cb_update from w_com010_e`cb_update within w_53002_e
end type

type cb_print from w_com010_e`cb_print within w_53002_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_53002_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_53002_e
end type

type cb_excel from w_com010_e`cb_excel within w_53002_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_53002_e
integer height = 128
string dataobject = "d_53002_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(1, "shop_cd", "")
		This.SetItem(1, "shop_nm", "")
	CASE "yymmdd"
		//If gf_iwoldate_chk(gs_user_id, is_pgm_id, Left(data, 4) + Mid(data, 6, 2) + Mid(data, 9, 2) ) = False Then
		//	MessageBox("입력오류", "일자를 소급할 수 없습니다!")
		//	Return 1
		//End If
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_53002_e
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_53002_e
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_53002_e
integer y = 348
integer height = 1692
string dataobject = "d_53002_d01"
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.17                                                  */	
/* 수정일      : 2001.12.17                                                  */
/*===========================================================================*/
Long ll_sale_minus, ll_sale_sum

CHOOSE CASE dwo.name
	CASE "sale_amt" 
		ll_sale_minus = This.GetItemDecimal(row, "sale_minus")
		If IsNull(ll_sale_minus) Then ll_sale_minus = 0
		This.SetItem(row, "sale_sum", ll_sale_minus + Long(data))
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_53002_e
end type

