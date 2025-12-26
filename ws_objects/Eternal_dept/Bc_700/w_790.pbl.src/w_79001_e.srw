$PBExportHeader$w_79001_e.srw
$PBExportComments$A/S 등록
forward
global type w_79001_e from w_com030_e
end type
type dw_detail from u_dw within w_79001_e
end type
type dw_tel from datawindow within w_79001_e
end type
type dw_1 from datawindow within w_79001_e
end type
type dw_2 from datawindow within w_79001_e
end type
type cb_yet from commandbutton within w_79001_e
end type
type st_2 from statictext within w_79001_e
end type
type dw_judg from u_dw within w_79001_e
end type
type cb_print_info from commandbutton within w_79001_e
end type
type dw_judg_su from u_dw within w_79001_e
end type
end forward

global type w_79001_e from w_com030_e
integer width = 4512
integer height = 2740
dw_detail dw_detail
dw_tel dw_tel
dw_1 dw_1
dw_2 dw_2
cb_yet cb_yet
st_2 st_2
dw_judg dw_judg
cb_print_info cb_print_info
dw_judg_su dw_judg_su
end type
global w_79001_e w_79001_e

type variables
DataWindowChild idw_brand, idw_color, idw_size, idw_judg_fg, idw_judg_s, idw_cust_fg_s, idw_judg_b
DataWindowChild idw_decision_a, idw_decision_b, idw_decision_c, idw_decision_d 
dragobject   idrg_ver[4]

String is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm, is_rct_fr_ymd, is_rct_to_ymd
String is_yymmdd, is_seq_no

end variables

forward prototypes
public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_name_chk (string as_user_name, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm)
public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm, ref string as_receipt_ymd)
public function boolean wf_detail_chk (long al_row)
public function integer wf_resizepanels ()
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name)
public function integer wf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
end prototypes

public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : (주)지우정보 (권 진택)                         */
/* 작 성 일  : 2002/03/22                                     */
/* 수 정 일  : 2002/03/22                                     */
/* 내    용  : 회원번호가 있는지 체크한다.                    */
/*============================================================*/
String ls_jumin

SELECT JUMIN, CARD_NO, USER_NAME, SEX, TEL_NO1, TEL_NO2, TEL_NO3
  INTO :ls_jumin, :as_card_no, :as_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
  FROM TB_71010_M (nolock)
 WHERE JUMIN = :as_jumin
;

If IsNull(ls_jumin) Then Return -1

RETURN 0

end function

public function integer wf_cust_name_chk (string as_user_name, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : (주)지우정보 (권 진택)                         */
/* 작 성 일  : 2002/03/22                                     */
/* 수 정 일  : 2002/03/22                                     */
/* 내    용  : 카드번호가 있는지 체크한다.                    */
/* RETURN    : 0: 정상, -1: 없음, -2: 중복                    */
/*============================================================*/
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM TB_71010_M (nolock)
 WHERE USER_NAME = :as_user_name
;

IF ls_cnt = 1 Then
	SELECT CARD_NO, JUMIN, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_card_no, :as_jumin, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM TB_71010_M (nolock)
	 WHERE USER_NAME = :as_user_name
	;
	RETURN 0
ElseIf ls_cnt > 1 Then
	RETURN -2
Else
	RETURN -1
END IF

end function

public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm);
Return 1

end function

public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm, ref string as_receipt_ymd);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String ls_temp
Long i

/* dw_body 체크*/
// 의뢰일자
as_yymmdd = Trim(dw_body.GetItemString(1, "yymmdd"))
if IsNull(as_yymmdd) or as_yymmdd = "" then
   MessageBox("저장오류", "의뢰 일자를 입력하십시요!")
   dw_body.SetFocus()
   dw_body.SetColumn("yymmdd")
   return false
end if

// 주민번호
//as_jumin = Trim(dw_body.GetItemString(1, "jumin"))
//if IsNull(as_jumin) or as_jumin = "" then
//   MessageBox("저장오류", "주민 번호를 입력하십시요!")
//   dw_body.SetFocus()
//   dw_body.SetColumn("jumin")
//   return false
//end if

// 고객명
as_custom_nm = Trim(dw_body.GetItemString(1, "custom_nm"))
if IsNull(as_custom_nm) or as_custom_nm = "" then
   MessageBox("저장오류", "고객 명을 입력하십시요!")
   dw_body.SetFocus()
   dw_body.SetColumn("custom_nm")
   return false
end if

//// 접수 매장
//ls_temp = Trim(dw_body.GetItemString(1, "shop_cd"))
//if IsNull(ls_temp) or ls_temp = "" then
//   MessageBox("저장오류", "접수 매장을 입력하십시요!")
//   dw_body.SetFocus()
//   dw_body.SetColumn("shop_cd")
//   return false
//end if

//본사접수일자
as_receipt_ymd = dw_body.getitemstring(1, 'receipt_ymd')
if IsNull(as_receipt_ymd) or as_receipt_ymd = "" then	
	MESSAGEBOX ('저장오류','본사접수일자를 입력해 주십시요!')
	dw_body.SetFocus()
	dw_body.SetColumn("receipt_ymd")
	return false
end if

return true

end function

public function boolean wf_detail_chk (long al_row);/* dw_detail 체크*/
String ls_temp

// STYLE NO
ls_temp = Trim(dw_detail.GetItemString(al_row, "style_no"))
if IsNull(ls_temp) or ls_temp = "" then
	MessageBox("저장오류", "STYLE NO를 입력하십시요!")
	dw_detail.SetFocus()
	dw_detail.ScrollToRow(al_row)
	dw_detail.SetColumn("style_no")
	return false
end if

// COLOR
ls_temp = Trim(dw_detail.GetItemString(al_row, "color"))
if IsNull(ls_temp) or ls_temp = "" then
	MessageBox("저장오류", "제품 색상을 입력하십시요!")
	dw_detail.SetFocus()
	dw_detail.ScrollToRow(al_row)
	dw_detail.SetColumn("color")
	return false
end if

// SIZE
ls_temp = Trim(dw_detail.GetItemString(al_row, "size"))
if IsNull(ls_temp) or ls_temp = "" then
	MessageBox("저장오류", "제품 사이즈를 입력하십시요!")
	dw_detail.SetFocus()
	dw_detail.ScrollToRow(al_row)
	dw_detail.SetColumn("size")
	return false
end if

//// CLAIM 구분
//ls_temp = Trim(dw_detail.GetItemString(al_row, "claim_fg"))
//if ls_temp <> '0' then
//	// 판매 일자
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "sale_ymd"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "판매 일자를 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("sale_ymd")
//		return false
//	end if
//	
//	// 세탁 구분
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "wash_fg"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "세탁 구분을 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("wash_fg")
//		return false
//	end if
//
//	// 섬유 조성
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "tex_str"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "섬유 조성을 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("tex_str")
//		return false
//	end if
//
//	// 청구 사유
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "rcv_why"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "청구 사유를 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("rcv_why")
//		return false
//	end if
//
//	// 요구 사항
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "rcv_req"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "요구 사항을 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("rcv_req")
//		return false
//	end if
//Else
//	// 의뢰 내용
//	ls_temp = Trim(dw_detail.GetItemString(al_row, "problem"))
//	if IsNull(ls_temp) or ls_temp = "" then
//		MessageBox("저장오류", "의뢰 내용을 입력하십시요!")
//		dw_detail.SetFocus()
//		dw_detail.ScrollToRow(al_row)
//		dw_detail.SetColumn("problem")
//		return false
//	end if
//end if

Return True

end function

public function integer wf_resizepanels ();/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.26                                                  */
/*===========================================================================*/
// DataWindow 위치 및 크기 변경
Long		ll_Width

ll_Width = idrg_Ver[2].X + idrg_Ver[2].Width - st_1.X - ii_BarThickness

idrg_Ver[1].Resize (st_1.X - idrg_Ver[1].X, idrg_Ver[1].Height)

idrg_Ver[2].Move (st_1.X + ii_BarThickness, idrg_Ver[2].Y)
idrg_Ver[2].Resize (ll_Width, idrg_Ver[2].Height)
idrg_Ver[3].Move (st_1.X + ii_BarThickness, idrg_Ver[3].Y)
idrg_Ver[3].Resize (ll_Width, idrg_Ver[3].Height)
idrg_Ver[4].Move (st_1.X + ii_BarThickness, idrg_Ver[4].Y)
idrg_Ver[4].Resize (ll_Width, idrg_Ver[4].Height)

Return 1

end function

public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price);
SELECT A.YEAR, A.SEASON, A.SOJAE, A.ITEM,
       A.CUST_CD AS ST_CUST_CD,  dbo.sf_cust_nm(A.CUST_CD, 'S') AS ST_CUST_NM,
       B.CUST_CD AS MAT_CUST_CD, dbo.sf_cust_nm(B.CUST_CD, 'S') AS MAT_CUST_NM, 
		 B.MAT_CD, B.MAT_NM, A.TAG_PRICE
  INTO :as_year, :as_season, :as_sojae, :as_item,
       :as_st_cust_cd,  :as_st_cust_nm,
       :as_mat_cust_cd, :as_mat_cust_nm,
		 :as_mat_cd, :as_mat_nm, :adc_tag_price
  FROM VI_12020_1 A (nolock),
       TB_21010_M  B (nolock)
 WHERE A.MAT_CD *= B.MAT_CD
   AND A.STYLE = :as_style
   AND A.CHNO  = :as_chno
;

IF ISNULL(as_st_cust_cd) THEN RETURN 100

RETURN sqlca.sqlcode  

end function

public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name);
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM TB_71010_M (nolock)
 WHERE tel_no3 = :as_tel_no
;

IF ls_cnt = 1 Then
	SELECT CARD_NO, JUMIN, user_name, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_card_no, :as_jumin, :As_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM TB_71010_M (nolock)
	WHERE tel_no3 = :as_tel_no
	;
	RETURN 0
end if

//ElseIf ls_cnt > 1 Then
//	RETURN -2
//Else
//	RETURN -1
//END IF

end function

public function integer wf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  :  															  */
/* 작 성 일  : 															  */
/* 수 정 일  : 															  */
/* 내    용  : 카드번호가 있는지 체크한다.                    */
/* RETURN    : 0: 정상, -1: 없음, -2: 중복                    */
/*============================================================*/
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM TB_71010_M (nolock)
 WHERE CARD_NO = :as_card_no
;

IF ls_cnt = 1 Then
	SELECT JUMIN, USER_NAME, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_jumin, :as_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM TB_71010_M (nolock)
	 WHERE CARD_NO = :as_card_no
	;
	RETURN 0
ElseIf ls_cnt > 1 Then
	RETURN -2
Else
	RETURN -1
END IF

end function

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
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

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd_h"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
	is_shop_cd = '%'
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

is_rct_fr_ymd = Trim(dw_head.GetItemString(1, "rct_fr_ymd"))
is_rct_to_ymd = Trim(dw_head.GetItemString(1, "rct_to_ymd"))

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_1, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name,ls_part_nm
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column
	CASE "shop_cd_h"				
		is_brand = dw_head.GetItemString(1, "brand")
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "shop_nm_h", "")
					dw_head.SetItem(al_row, "tel_no", "")					
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_custom_nm) = 0 THEN
					dw_head.SetItem(al_row, "shop_nm_h", ls_custom_nm)
					
					select tel_no
					into :ls_tel_no 
					from tb_91100_m with (nolock)
					where shop_cd = :as_data;
					
					dw_head.SetItem(al_row, "tel_no", ls_tel_no)					
					
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com918" 
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
				dw_head.SetItem(al_row, "shop_cd_h", lds_Source.GetItemString(1,"shop_cd"))
				dw_head.SetItem(al_row, "shop_nm_h", lds_Source.GetItemString(1,"shop_snm"))
				dw_head.SetItem(al_row, "tel_no", lds_Source.GetItemString(1,"tel_no"))				
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("jumin_h")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
			
CASE "card_no_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
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
					RETURN 0
				END IF 
				IF gf_cust_jumin_chk(as_data, ls_custom_nm, ls_card_no) = TRUE THEN
				   dw_head.SetItem(al_row, "card_no_h",   ls_card_no  )
				   dw_head.SetItem(al_row, "custom_nm_h", ls_custom_nm)
					RETURN 0
				ElseIf LenA(as_data) = 13 Then
					dw_head.SetItem(al_row, "card_no_h", ls_null)
					RETURN 0
				END IF 
			END IF
			
	CASE "custom_nm_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no) = TRUE THEN
					li_okyes = MessageBox("입력오류", "등록된 이름이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)
					IF li_okyes = 1 THEN	
						dw_head.SetItem(al_row, "card_no_h", ls_card_no)
						dw_head.SetItem(al_row, "jumin_h",   ls_jumin  )
						RETURN 0
					else	
						dw_head.SetItem(al_row, "card_no_h", "")
						dw_head.SetItem(al_row, "jumin_h",   "")
						RETURN 0	
					end if	
				Else
					dw_head.SetItem(al_row, "card_no_h", ls_null)
					li_okyes = MessageBox("경고", "동명이인이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)

					IF li_okyes = 1 THEN					 
							gst_cd.ai_div          = ai_div
							gst_cd.window_title    = "회원 코드 검색" 
							gst_cd.datawindow_nm   = "d_com701" 
							gst_cd.default_where   = ""
							gst_cd.Item_where      = " user_name like '" + Trim(as_data) + "%'"
		
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
					ELSE
						dw_head.SetItem(al_row, "card_no_h", "")
						dw_head.SetItem(al_row, "jumin_h",   "")
						RETURN 0	
					END IF
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

	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_cust_card_chk(as_data, ls_jumin, ls_custom_nm, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
				   dw_body.SetItem(al_row, "jumin",     ls_jumin      )
				   dw_body.SetItem(al_row, "custom_nm", ls_custom_nm  )
				   dw_body.SetItem(al_row, "sex",       String(li_sex))
				   dw_body.SetItem(al_row, "tel_no1",   ls_tel_no1    )
				   dw_body.SetItem(al_row, "tel_no2",   ls_tel_no2    )
				   dw_body.SetItem(al_row, "tel_no3",   ls_tel_no3    )
					RETURN 0
				ElseIf li_return = -2 Then
					MessageBox("입력오류", "중복된 카드번호가 있습니다! ~n~r 주민번호를 입력하십시요.")
					RETURN 0
				END IF
			END IF
			
	CASE "jumin"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_cust_jumin_chk(as_data, ls_card_no, ls_custom_nm, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
				   dw_body.SetItem(al_row, "card_no",   ls_card_no    )
				   dw_body.SetItem(al_row, "custom_nm", ls_custom_nm  )
				   dw_body.SetItem(al_row, "sex",       String(li_sex))
				   dw_body.SetItem(al_row, "tel_no1",   ls_tel_no1    )
				   dw_body.SetItem(al_row, "tel_no2",   ls_tel_no2    )
				   dw_body.SetItem(al_row, "tel_no3",   ls_tel_no3    )
					RETURN 0
				ElseIf LenA(as_data) = 13 Then
					dw_body.SetItem(al_row, "card_no", ls_null)
					RETURN 0
				END IF 
			END IF
			
	CASE "custom_nm"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				
				li_return = wf_cust_name_chk(as_data, ls_card_no, ls_jumin, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
					
					li_okyes = MessageBox("입력오류", "등록된 이름이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)
					IF li_okyes = 1 THEN	
						dw_body.SetItem(al_row, "card_no", ls_card_no    )
						dw_body.SetItem(al_row, "jumin",   ls_jumin      )
						dw_body.SetItem(al_row, "sex",     String(li_sex))
						dw_body.SetItem(al_row, "tel_no1", ls_tel_no1    )
						dw_body.SetItem(al_row, "tel_no2", ls_tel_no2    )
						dw_body.SetItem(al_row, "tel_no3", ls_tel_no3    )
						RETURN 0
					else
						dw_body.SetItem(al_row, "card_no", ""    )
						dw_body.SetItem(al_row, "jumin",   ""      )
						dw_body.SetItem(al_row, "sex",     String(li_sex))
						dw_body.SetItem(al_row, "tel_no1", ""    )
						dw_body.SetItem(al_row, "tel_no2", ""    )
						dw_body.SetItem(al_row, "tel_no3", ""    )
						RETURN 0
					end if	
				ElseIf li_return = -2 Then
				//	MessageBox("입력오류", "회원중 동명이인이 있습니다! ~n~r 주민번호를 입력하십시요.")
					
					li_okyes = MessageBox("입력오류", "동명이인이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)

					IF li_okyes = 1 THEN					 
							gst_cd.ai_div          = ai_div
							gst_cd.window_title    = "회원 코드 검색" 
							gst_cd.datawindow_nm   = "d_com701" 
							gst_cd.default_where   = ""
							gst_cd.Item_where      = " user_name like '" + Trim(as_data) + "%'"
		
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
								dw_body.SetItem(al_row, "custom_nm",  lds_Source.GetItemString(1,"user_name")   )								
								dw_body.SetItem(al_row, "card_no",  lds_Source.GetItemString(1,"card_no")   )
								dw_body.SetItem(al_row, "jumin",    lds_Source.GetItemString(1,"jumin")     )
								dw_body.SetItem(al_row, "sex",     String( lds_Source.GetItemNumber(1,"sex")))
								dw_body.SetItem(al_row, "tel_no1",  lds_Source.GetItemString(1,"tel_no1")    )
								dw_body.SetItem(al_row, "tel_no2",  lds_Source.GetItemString(1,"tel_no2")    )
								dw_body.SetItem(al_row, "tel_no3",  lds_Source.GetItemString(1,"tel_no3")    )								
								
								/* 다음컬럼으로 이동 */
								cb_retrieve.SetFocus()
				//				dw_head.SetColumn("end_ymd")
								ib_itemchanged = False 
								lb_check = TRUE 
							END IF
							Destroy  lds_Source						
					ELSE
					
						dw_body.SetItem(al_row, "card_no", ""    )
						dw_body.SetItem(al_row, "jumin",   ""      )
						dw_body.SetItem(al_row, "sex",     String(li_sex))
						dw_body.SetItem(al_row, "tel_no1", ""    )
						dw_body.SetItem(al_row, "tel_no2", ""    )
						dw_body.SetItem(al_row, "tel_no3", ""    )
						RETURN 0
					
					END IF
					
					
				ElseIf Not(IsNull(as_data) or Trim(as_data) = "") Then
					dw_body.SetItem(al_row, "card_no", ls_null)
					RETURN 0
				END IF 
			END IF
			
	CASE "custom"
			If dw_body.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			ls_card_no   = dw_body.GetItemString(al_row, "card_no"  )
			ls_jumin     = dw_body.GetItemString(al_row, "jumin"    )
			ls_custom_nm = dw_body.GetItemString(al_row, "custom_nm")
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
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "card_no",   lds_Source.GetItemString(1, "card_no")    )
				dw_body.SetItem(al_row, "jumin",     lds_Source.GetItemString(1, "jumin")      )
				dw_body.SetItem(al_row, "custom_nm", lds_Source.GetItemString(1, "user_name")  )
				dw_body.SetItem(al_row, "sex",       String(lds_Source.GetItemNumber(1, "sex")))
				dw_body.SetItem(al_row, "tel_no1",   lds_Source.GetItemString(1, "tel_no1")    )
				dw_body.SetItem(al_row, "tel_no2",   lds_Source.GetItemString(1, "tel_no2")    )
				dw_body.SetItem(al_row, "tel_no3",   lds_Source.GetItemString(1, "tel_no3")    )
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("shop_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source
			
	CASE "shop_cd"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or as_data = "" Then
					dw_body.SetItem(al_row, "shop_nm", "")
					dw_body.SetItem(al_row, "tel_no", "")					
					RETURN 0
				END IF 
				IF LeftA(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_custom_nm) = 0 THEN
					dw_body.SetItem(al_row, "shop_nm", ls_custom_nm)
					
					select tel_no
					into :ls_tel_no 
					from tb_91100_m with (nolock)
					where shop_cd = :as_data;

					dw_body.SetItem(al_row, "tel_no", ls_tel_no)					
					
					RETURN 0
				END IF 
			END IF
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com918" 
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
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
				END IF
				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("rcv_how")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source

	CASE "style_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					dw_detail.SetItem(al_row, "year",        ls_null)
					dw_detail.SetItem(al_row, "season",      ls_null)
					dw_detail.SetItem(al_row, "sojae",       ls_null)
					dw_detail.SetItem(al_row, "item",        ls_null)
					dw_detail.SetItem(al_row, "st_cust_cd",  ls_null)
					dw_detail.SetItem(al_row, "st_cust_nm",  ls_null)
					dw_detail.SetItem(al_row, "mat_cust_cd", ls_null)
					dw_detail.SetItem(al_row, "mat_cust_nm", ls_null)
					dw_detail.SetItem(al_row, "mat_cd",      ls_null)
					dw_detail.SetItem(al_row, "mat_nm",      ls_null)
					dw_detail.SetItem(al_row, "tag_price",   ls_null)
					dw_detail.SetItem(al_row, "color",       ls_null)
					dw_detail.SetItem(al_row, "size",        ls_null)
					dw_detail.SetItem(al_row, "judg_cust_fg", '0')
					RETURN 0
				END IF 

				IF LeftA(as_data, 1) = is_brand and &
					wf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1), &
					             ls_year, ls_season, ls_sojae, ls_item, &
									 ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, &
									 ls_mat_cd, ls_mat_nm, ldc_tag_price) = 0 THEN
					dw_detail.SetItem(al_row, "year",        ls_year)
					dw_detail.SetItem(al_row, "season",      ls_season)
					dw_detail.SetItem(al_row, "sojae",       ls_sojae)
					dw_detail.SetItem(al_row, "item",        ls_item)
					dw_detail.SetItem(al_row, "st_cust_cd",  ls_st_cust_cd)
					dw_detail.SetItem(al_row, "st_cust_nm",  ls_st_cust_nm)
					dw_detail.SetItem(al_row, "mat_cust_cd", ls_mat_cust_cd)
					dw_detail.SetItem(al_row, "mat_cust_nm", ls_mat_cust_nm)
					dw_detail.SetItem(al_row, "mat_cd",      ls_mat_cd)
					dw_detail.SetItem(al_row, "mat_nm",      ls_mat_nm)
					dw_detail.SetItem(al_row, "tag_price",   ldc_tag_price)
					dw_detail.SetItem(al_row, "color",       ls_null)
					dw_detail.SetItem(al_row, "size",        ls_null)
					RETURN 0
				END IF 
			END IF

			string ls_style_1
			dw_detail.accepttext()
			ls_style_1 = dw_detail.GetItemString(1, "style_no")

		//품번확인이 어려울 경우 임의의 품번을 등록후 처리함. --2012.04.20 최소영차장 요청건
      //품번이 없으면 브랜드뒤에 'XXXXXXX' 넣어서 처리함.
		if ls_style_1 <> is_brand +'XXXXXXX' then		
		
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
					dw_detail.SetRow(al_row)
					dw_detail.SetColumn(as_column)
				END IF
				ls_style_no = lds_Source.GetItemString(1,"style_no")
				IF wf_style_chk(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1), &
				                ls_year, ls_season, ls_sojae, ls_item, &
					             ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, &
									 ls_mat_cd, ls_mat_nm, ldc_tag_price) = 0 THEN
					dw_detail.SetItem(al_row, "style_no",    ls_style_no)
					dw_detail.SetItem(al_row, "year",        ls_year)
					dw_detail.SetItem(al_row, "season",      ls_season)
					dw_detail.SetItem(al_row, "sojae",       ls_sojae)
					dw_detail.SetItem(al_row, "item",        ls_item)
					dw_detail.SetItem(al_row, "st_cust_cd",  ls_st_cust_cd)
					dw_detail.SetItem(al_row, "st_cust_nm",  ls_st_cust_nm)
					dw_detail.SetItem(al_row, "mat_cust_cd", ls_mat_cust_cd)
					dw_detail.SetItem(al_row, "mat_cust_nm", ls_mat_cust_nm)
					dw_detail.SetItem(al_row, "mat_cd",      ls_mat_cd)
					dw_detail.SetItem(al_row, "mat_nm",      ls_mat_nm)
					dw_detail.SetItem(al_row, "tag_price",   ldc_tag_price)
					dw_detail.SetItem(al_row, "color",       ls_null)
					dw_detail.SetItem(al_row, "size",        ls_null)
					
					/* 다음컬럼으로 이동 */
//					dw_detail.SetColumn("color")
//					ib_itemchanged = False 
//					lb_check = TRUE 
//					ib_changed = true
//					cb_update.enabled = true
//					cb_print.enabled = false
//					cb_preview.enabled = false
//					cb_excel.enabled = false
				End If				
			END IF
		else
	      //품번이 'XXXXXXX'라면 생산업체와 자재업체 하드코딩으로 넣기
			dw_detail.SetItem(al_row, "style_no",    ls_style_1)
			dw_detail.SetItem(al_row, "year",        '')
			dw_detail.SetItem(al_row, "season",      '')
			dw_detail.SetItem(al_row, "sojae",       '')
			dw_detail.SetItem(al_row, "item",        '')

			if is_brand = 'O' then
				dw_detail.SetItem(al_row, "st_cust_cd",  'O02990')
				dw_detail.SetItem(al_row, "st_cust_nm",  '상담실제품의뢰(올리브)')
				dw_detail.SetItem(al_row, "mat_cust_cd", 'O02990')
				dw_detail.SetItem(al_row, "mat_cust_nm", '상담실제품의뢰(올리브)')
			elseif is_brand = 'N' or is_brand = 'B' or is_brand = 'I' or is_brand = 'P' then
				dw_detail.SetItem(al_row, "st_cust_cd",  'N02990')
				dw_detail.SetItem(al_row, "st_cust_nm",  '상담실제품의뢰(온앤온)')
				dw_detail.SetItem(al_row, "mat_cust_cd", 'N02990')
				dw_detail.SetItem(al_row, "mat_cust_nm", '상담실제품의뢰(온앤온)')
			end if
			
			dw_detail.SetItem(al_row, "mat_cd",      '')
			dw_detail.SetItem(al_row, "mat_nm",      '')
			dw_detail.SetItem(al_row, "tag_price",   ls_null)
			dw_detail.SetItem(al_row, "color",       ls_null)
			dw_detail.SetItem(al_row, "size",        ls_null)			
	
		end if			
					/* 다음컬럼으로 이동 */
					dw_detail.SetColumn("color")
					ib_itemchanged = False 
					lb_check = TRUE 
					ib_changed = true
					cb_update.enabled = true
					cb_print.enabled = false
					cb_preview.enabled = false
					cb_excel.enabled = false		
			Destroy  lds_Source

		
	CASE "han_mark"
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "취급주의사항 검색" 
			gst_cd.datawindow_nm   = "d_com702" 
			gst_cd.default_where   = ""
			gst_cd.Item_where      = dw_detail.GetItemString(al_row, "han_mark")
	
			lds_Source = Create DataStore
			OpenWithParm(W_COM701, lds_Source)
	
			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
					dw_detail.SetRow(al_row)
					dw_detail.SetColumn(as_column)
				END IF
				dw_detail.SetItem(al_row, "han_mark", lds_Source.GetItemString(1,"han_mark"))
				/* 다음컬럼으로 이동 */
//				dw_detail.SetColumn("color")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source
			
CASE "tel_no3"

			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_tel_no_chk(as_data, ls_card_no, ls_jumin, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_user_name)
				IF li_return = 0 THEN
						dw_body.SetItem(al_row, "card_no", ls_card_no    )
						dw_body.SetItem(al_row, "jumin",   ls_jumin      )
						dw_body.SetItem(al_row, "custom_nm",   ls_user_name)						
						dw_body.SetItem(al_row, "sex",     String(li_sex))
						dw_body.SetItem(al_row, "tel_no1", ls_tel_no1    )
						dw_body.SetItem(al_row, "tel_no2", ls_tel_no2    )
						dw_body.SetItem(al_row, "tel_no3", ls_tel_no3    )
						RETURN 0						
				END IF 
						RETURN 0						
			END IF			
			
CASE "tel"
			If dw_body.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			IF IsNull(ls_card_no) = False and Trim(ls_card_no) <> "" THEN
				gst_cd.Item_where = " tel_no3 LIKE '" + Trim(as_data) + "%'"
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
				dw_body.SetItem(al_row, "card_no",   lds_Source.GetItemString(1, "card_no")    )
				dw_body.SetItem(al_row, "jumin",     lds_Source.GetItemString(1, "jumin")      )
				dw_body.SetItem(al_row, "custom_nm", lds_Source.GetItemString(1, "user_name")  )
				dw_body.SetItem(al_row, "sex",       String(lds_Source.GetItemNumber(1, "sex")))
				dw_body.SetItem(al_row, "tel_no1",   lds_Source.GetItemString(1, "tel_no1")    )
				dw_body.SetItem(al_row, "tel_no2",   lds_Source.GetItemString(1, "tel_no2")    )
				dw_body.SetItem(al_row, "tel_no3",   lds_Source.GetItemString(1, "tel_no3")    )
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("shop_cd")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source

	CASE "fix_cust"							// 생산처 코드
	   is_brand = Trim(dw_head.GetItemString(1, "brand"))
			
			IF ai_div = 1 THEN 	// ItemChanged!  -> Call
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					dw_judg.SetItem(al_row, "fix_cust_nm", "")
					RETURN 0
				End If
				
				Choose Case is_brand
					Case 'J'
						IF (LeftA(as_data, 1) = 'N' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case 'Y'
						IF (LeftA(as_data, 1) = 'O' or LeftA(as_data, 1) = is_brand) and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
							RETURN 0
						END IF
					Case Else
						IF LeftA(as_data, 1) = is_brand and gf_cust_gubn_nm(as_data, 'S', '1', '0', ls_part_nm) = 0 THEN
							dw_judg.SetItem(al_row, "fix_cust_nm", ls_part_nm)
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
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'Y'
					gst_cd.default_where   = " WHERE BRAND IN ('O', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case 'W'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "		
				Case 'F'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "		
				Case 'B'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
													 
				Case 'L'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
													 
				Case 'P'
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
													 "   AND CHANGE_GUBN = '00' "
				Case Else
					gst_cd.default_where   = " WHERE BRAND IN ('N', '" + is_brand + "') " + &
													 "   AND CUST_CODE BETWEEN '4000' and '8999' " + &
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
				dw_judg.SetRow(al_row)
				dw_judg.SetColumn(as_column)
				dw_judg.SetItem(al_row, "fix_cust", lds_Source.GetItemString(1,"custcode"))
				dw_judg.SetItem(al_row, "fix_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				ib_itemchanged = False
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
			
CASE "tel_1"
			If dw_body.AcceptText() <> 1 Then Return 1
			ls_tel_1 = dw_head.GetItemString(al_row, "tel_1")
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com791"
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			IF IsNull(as_data) = False and Trim(as_data) <> "" THEN
				gst_cd.Item_where = " right(tel_no1,4) = '" + Trim(as_data) + "' or right(tel_no2,4) = '" + Trim(as_data) + "' or right(tel_no3,4) = '" + Trim(as_data) + "'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)
			lds_Source.SetItem(1,'tel_no1', '1111')
			
			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN
				   dw_body.SetRow(al_row)
				   dw_body.SetColumn(as_column)
				END IF
				
				string ld_brand_1, ls_custom_nm_1, ls_shop_cd_1, ls_fr_ymd, ls_to_ymd, ls_seq_no, ls_date, ls_ft_date
				long ll_rows

				dw_head.SetItem(al_row, "brand",  		lds_Source.GetItemString(1,"brand")		)
				dw_head.SetItem(al_row, "shop_cd_h", 	lds_Source.GetItemString(1,"shop_cd")	)
				dw_head.SetItem(al_row, "custom_nm_h", lds_Source.GetItemString(1,"custom_nm"))

				ls_shop_cd_1 = dw_head.getitemstring(1,'shop_cd_h')				
				select tel_no, shop_nm into :ls_tel_no, :ls_custom_nm from tb_91100_m with (nolock) where shop_cd = :ls_shop_cd_1;
		
				dw_head.SetItem(al_row, "shop_nm_h", ls_custom_nm)
				dw_head.SetItem(al_row, "tel_no", ls_tel_no)	
				
				ls_date = lds_Source.GetItemString(1,"yymmdd")
				ls_ft_date = ls_date
				ls_date = MidA(ls_date,1,4)+'-'+MidA(ls_date,5,2)+'-'+MidA(ls_date,7,2)
				dw_head.SetItem(al_row, "fr_ymd", date(ls_date))
				dw_head.SetItem(al_row, "to_ymd", date(ls_date))
				
				ld_brand_1 = dw_head.getitemstring(1,'brand')				
				ls_seq_no = lds_Source.GetItemString(1,"seq_no")				
				ls_custom_nm_1 = dw_head.getitemstring(1,'custom_nm_h')				

				dw_list.retrieve(ld_brand_1, ls_ft_date, ls_ft_date, ls_shop_cd_1, '%', '%', ls_custom_nm_1, '0', '9')
				dw_body.  retrieve(ls_ft_date, ls_seq_no)
				dw_detail.retrieve(ls_ft_date, ls_seq_no)
				ll_rows = dw_tel.retrieve(ls_ft_date, ls_seq_no)
				if ll_rows < 1 then
					dw_tel.insertrow(0)
				end if
				
				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("shop_cd")
				
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = false
				cb_retrieve.Text = "조건(&Q)"
				dw_list.Enabled = true
				dw_head.Enabled = false
				dw_body.Enabled = true
				dw_detail.Enabled = true
				cb_print_info.enabled = true
				
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

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
integer li_yet

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

select count(*)
into :li_yet
from tb_79011_d a (nolock), tb_79010_m b (nolock)
where a.YYMMDD = b.yymmdd
and a.seq_no = b.seq_no
and isnull(b.appoint_ymd,b.want_ymd) between convert(char(08),dateadd(day, -3, getdate()), 112) and convert(char(08),dateadd(day, 3, getdate()), 112)
and a.judg_fg = '4'
and a.brand =  :is_brand;

if li_yet > 0 then cb_yet.enabled = true

st_2.text = "<= 미처리건이 " + string(li_yet, "000") + "건 있습니다!"

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm, is_rct_fr_ymd, is_rct_to_ymd)

dw_body  .Reset()
dw_body.InsertRow(0)
dw_detail.Reset()

IF il_rows > 0 THEN
   dw_list.SetFocus()
ELSE
//   dw_body.InsertRow(0)
	dw_detail.InsertRow(0)
//	dw_detail.SetItem(1, "han_mark", '000000000000000')
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

on w_79001_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_tel=create dw_tel
this.dw_1=create dw_1
this.dw_2=create dw_2
this.cb_yet=create cb_yet
this.st_2=create st_2
this.dw_judg=create dw_judg
this.cb_print_info=create cb_print_info
this.dw_judg_su=create dw_judg_su
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_tel
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cb_yet
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_judg
this.Control[iCurrent+8]=this.cb_print_info
this.Control[iCurrent+9]=this.dw_judg_su
end on

on w_79001_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_tel)
destroy(this.dw_1)
destroy(this.dw_2)
destroy(this.cb_yet)
destroy(this.st_2)
destroy(this.dw_judg)
destroy(this.cb_print_info)
destroy(this.dw_judg_su)
end on

event pfc_preopen();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택) 												  */	
/* 작성일      : 2002.03.21																  */	
/* 수정일      : 2002.03.21																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert,   "FixedToRight")
inv_resize.of_Register(cb_delete,   "FixedToRight")
inv_resize.of_Register(cb_print,    "FixedToRight")
inv_resize.of_Register(cb_preview,  "FixedToRight")
inv_resize.of_Register(cb_excel,    "FixedToRight")

inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_print_info, "FixedToRight")
inv_resize.of_Register(cb_close,    "FixedToRight")
inv_resize.of_Register(cb_yet,    "FixedToRight")
inv_resize.of_Register(st_2,    "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list,   "ScaleToBottom")
inv_resize.of_Register(dw_body,   "ScaleToRight")
inv_resize.of_Register(dw_detail, "ScaleToRight")
//inv_resize.of_Register(dw_judg,   "ScaleToRight&Bottom")
inv_resize.of_Register(dw_tel,    "ScaleToRight&Bottom")
inv_resize.of_Register(st_1,      "ScaleToBottom")
inv_resize.of_Register(ln_1,      "ScaleToRight")
inv_resize.of_Register(ln_2,      "ScaleToRight")

inv_resize.of_Register(dw_head,      "ScaleToRight")

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.  SetTransObject(SQLCA)
dw_body.  SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_judg.SetTransObject(SQLCA)
dw_judg_su.SetTransObject(SQLCA)
dw_print. SetTransObject(SQLCA)
dw_tel. SetTransObject(SQLCA)
dw_1. SetTransObject(SQLCA)
dw_2. SetTransObject(SQLCA)


/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)
//dw_tel.InsertRow(0)

/* DataWindow 사이 이동 */
idrg_Ver[1] = dw_list
idrg_Ver[2] = dw_body
idrg_Ver[3] = dw_detail
idrg_Ver[4] = dw_judg
//idrg_Ver[5] = dw_tel

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
	CASE 1		/* 조회 */
		cb_retrieve.Text = "조건(&Q)"
		dw_head.Enabled = false
		dw_list.Enabled = true
		If al_rows <= 0 Then
			dw_body.Enabled = true
			dw_detail.Enabled = true
			cb_print_info.enabled = false
		End If
	CASE 2   /* 추가 */
		if al_rows > 0 then
			dw_detail.Visible = True
			dw_judg.Visible   = False
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_list.Enabled = true
				dw_body.Enabled = true
				dw_detail.Enabled = true
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
//         cb_delete.enabled = false
			dw_detail.Visible = True
			dw_judg.Visible   = False
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
		end if

   CASE 5    /* 조건 */
		dw_detail.Visible = True
		dw_judg.Visible   = False
      cb_retrieve.Text = "조회(&Q)"
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_detail.Enabled = false
      dw_head.Enabled = true
		cb_print_info.enabled = false
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
			dw_body.enabled    = true
			dw_detail.enabled  = true
			cb_print_info.enabled 		 = true
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
			cb_print_info.enabled = false			
		end if

      if al_rows >= 0 then
			dw_detail.Visible = True
			dw_judg.Visible   = False
         ib_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long	ll_cur_row

if dw_body.AcceptText() <> 1 then return

/* 추가시 수정자료가 있을때 저장여부 확인 */
if ib_changed then 
	CHOOSE CASE gf_update_yn(This.title)
		CASE 1
			IF This.Trigger Event ue_update() < 1 THEN
				RETURN
			END IF		
		CASE 2
			ib_changed = false
		CASE 3
			RETURN
	END CHOOSE
end if

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.  SetRedraw(False)
dw_detail.SetRedraw(False)
dw_tel.SetRedraw(False)

dw_body.  Reset()
dw_detail.Reset()
dw_tel.Reset()

il_rows = dw_body.InsertRow(0)

dw_detail.InsertRow(0)
dw_tel.InsertRow(0)

dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()

dw_body.  SetRedraw(True)
dw_detail.SetRedraw(True)
dw_tel.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_delete;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21																  */	
/* 수정일      : 2002.03.21																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long i, ll_row_cnt, ll_find
dwitemstatus ldw_status

ll_row_cnt = dw_detail.RowCount()

//ll_find = dw_detail.Find("Not(IsNull(judg_fg)) and Trim(judg_fg) <> '' and Trim(judg_fg) <> '0' ", 1, ll_row_cnt)
//If ll_find > 0 Then 
//	MessageBox("삭제오류", "이미 판정된 제품이 있습니다!~n~r삭제할 수 없습니다.")
//	Return
//End IF

idw_status = dw_body.GetItemStatus (1, 0, primary!)	
il_rows = dw_body.DeleteRow(1)

If il_rows > 0 Then
	For i = ll_row_cnt To 1 Step -1
		ldw_status = dw_detail.GetItemStatus(i, 0, Primary!)
		dw_detail.DeleteRow(i)
		If ldw_status <> New! and ldw_status <> NewModified! Then idw_status = ldw_status
	Next
Else
	Return
End If

il_rows = dw_body  .InsertRow(0)
			 dw_detail.InsertRow(0)
dw_body.SetFocus()

//IF dw_body.Update(TRUE, FALSE) < 1 or dw_detail.Update(TRUE, FALSE) < 1 THEN RETURN
//dw_body.  ResetUpdate()
//dw_detail.ResetUpdate()
//Commit;
//
//IF idw_status = NotModified! OR idw_status = DataModified! THEN
//	ll_cur_row = dw_list.GetSelectedRow(0)
//	if ll_cur_row > 0 THEN dw_list.DeleteRow(ll_cur_row)  //dw_list Row 삭제
//END IF

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_cur_row, ll_seq_no, ll_no_max, ll_rows,ll_row_count1,ll_rows1
datetime ld_datetime
String ls_yymmdd, ls_seq_no, ls_jumin, ls_custom_nm, ls_judg_cust_fg, ls_style_as, ls_go_gubn_as, ls_receipt_ymd, ls_go_ymd2, ls_yymmdd2
dwItemStatus ldw_status

IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_detail.AcceptText() <> 1 THEN RETURN -1
IF dw_judg.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// dw_body
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
If idw_status <> New! THEN
	If wf_data_chk(ls_yymmdd, ls_jumin, ls_custom_nm, ls_receipt_ymd) = False Then Return -1

	IF idw_status = NewModified! THEN				/* New Record */
		// 의뢰번호 채번
		SELECT CAST(ISNULL(MAX(SEQ_NO), '0') AS INT)
		  INTO :ll_seq_no
		  FROM TB_79010_M
		 WHERE YYMMDD = :ls_yymmdd
		;
		If SQLCA.SQLCODE <> 0 Then 
			MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
			Return -1
		End If
	
		ls_seq_no = String(ll_seq_no + 1, '0000')
		dw_body.Setitem(1, "seq_no", ls_seq_no )
		dw_body.Setitem(1, "brand" , is_brand  )
		dw_body.Setitem(1, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_seq_no = dw_body.GetItemString(1, "seq_no")
		dw_body.Setitem(1, "mod_id", gs_user_id )
		dw_body.Setitem(1, "mod_dt", ld_datetime)
	Else
		ls_seq_no = dw_body.GetItemString(1, "seq_no")
	END IF
	
	// dw_detail
	// 순번 채번
	SELECT CAST(ISNULL(MAX(NO), '0') AS INT)
	  INTO :ll_no_max
	  FROM TB_79011_D 
	 WHERE YYMMDD = :ls_yymmdd
		AND SEQ_NO = :ls_seq_no
	;
	If SQLCA.SQLCODE <> 0 Then
		MessageBox("저장오류", "순번 채번에 실패하였습니다!")
		Return -1
	End If

	ll_row_count = dw_detail.RowCount()
	
	For i = 0 to ll_row_count
		ls_style_as = ''
		
		ldw_status = dw_detail.GetItemStatus(i, 0, Primary!)
		IF ldw_status = NewModified! THEN				/* New Record */
	//			If wf_detail_chk(i) = False Then Return -1
			dw_detail.Setitem(i, "yymmdd", ls_yymmdd )
			dw_detail.Setitem(i, "seq_no", ls_seq_no )
			ll_no_max++
			dw_detail.Setitem(i, "no"    , String(ll_no_max, '0000') )
			dw_detail.Setitem(i, "style" , LeftA(dw_detail.GetItemString(i, "style_no"), 8)   )
			dw_detail.Setitem(i, "chno"  , MidA (dw_detail.GetItemString(i, "style_no"), 9, 1))
			
			ls_judg_cust_fg = dw_detail.GetItemString(i, "judg_cust_fg")
			If ls_judg_cust_fg = '1' Then
				dw_detail.SetItem(i, "cust_cd", dw_detail.GetItemString(i, "st_cust_cd"))
			ElseIf ls_judg_cust_fg = '2' Then
				dw_detail.SetItem(i, "cust_cd", dw_detail.GetItemString(i, "mat_cust_cd"))
			Else
				dw_detail.SetItem(i, "cust_cd", "")
			End If

			dw_detail.Setitem(i, "brand" , is_brand  )
			dw_detail.Setitem(i, "reg_id", gs_user_id)
			
			ls_style_as = LeftA(dw_detail.GetItemString(i, "style_no"), 8)			
			ls_go_gubn_as = dw_judg.GetItemString(1, "go_gubn")
			ls_yymmdd2 = dw_body.GetItemString(1, "yymmdd")
			
//			messagebox('yymmdd',ls_yymmdd2)
//			messagebox('seq_no',ls_seq_no)
//			messagebox('style',ls_style_as)
//			 
//				IF ls_go_gubn_as = "03" Then 
//					MESSAGEBOX('1','프로시져')
//					 DECLARE SP_79011_SMS_AS PROCEDURE FOR SP_79011_SMS_AS  
//								@yymmdd = :ls_yymmdd2,   
//								@seq_no = :ls_seq_no,   
//								@style = :ls_style_as
//								USING SQLCA;	
//						 execute SP_79011_SMS_AS;	
//						commit  USING SQLCA;	
//						
//				End If		
			
			
		ELSEIF ldw_status = DataModified! THEN		/* Modify Record */
	//			If wf_detail_chk(i) = False Then Return -1
			dw_detail.Setitem(i, "style" , LeftA(dw_detail.GetItemString(i, "style_no"), 8)   )
			dw_detail.Setitem(i, "chno"  , MidA (dw_detail.GetItemString(i, "style_no"), 9, 1))
			
			ls_judg_cust_fg = dw_detail.GetItemString(i, "judg_cust_fg")
			If ls_judg_cust_fg = '1' Then
				dw_detail.SetItem(i, "cust_cd", dw_detail.GetItemString(i, "st_cust_cd"))
			ElseIf ls_judg_cust_fg = '2' Then
				dw_detail.SetItem(i, "cust_cd", dw_detail.GetItemString(i, "mat_cust_cd"))
			Else
				dw_detail.SetItem(i, "cust_cd", "")
			End If
		
			dw_detail.Setitem(i, "mod_id", gs_user_id )
			dw_detail.Setitem(i, "mod_dt", ld_datetime)
			
			
		 ls_style_as = LeftA(dw_detail.GetItemString(i, "style_no"), 8)			
//		 ls_go_gubn_as = dw_detail.GetItemString(i, "go_gubn")
		 ls_go_gubn_as = dw_judg.GetItemString(1, "go_gubn")
//		 ls_go_ymd2 = dw_judg.GetItemString(1, "go_ymd2")
		 ls_yymmdd2 = dw_body.GetItemString(1, "yymmdd")
	
		 
//			IF ls_go_gubn_as = '03' Then 
//
//				 DECLARE SP_79011_SMS_AS1 PROCEDURE FOR SP_79011_SMS_AS  
//							@yymmdd = :ls_yymmdd2,   
//							@seq_no = :ls_seq_no,   
//							@style = :ls_style_as
//							USING SQLCA;	
//					 execute SP_79011_SMS_AS1;	
//
//					commit  USING SQLCA;	
//					
//			End If		

			
		END IF
	Next
	

/////////////
	ll_row_count1 = dw_tel.RowCount()
	
	For i = 1 to ll_row_count1
		ldw_status = dw_tel.GetItemStatus(i, 0, Primary!)
		IF ldw_status = NewModified! THEN				/* New Record */
			dw_tel.Setitem(i, "yymmdd", ls_yymmdd )
			dw_tel.Setitem(i, "seq_no", ls_seq_no )			
			dw_tel.Setitem(i, "brand" , is_brand  )
			dw_tel.Setitem(i, "reg_id", gs_user_id)
		ELSEIF ldw_status = DataModified! THEN		/* Modify Record */		
			dw_tel.Setitem(i, "mod_id", gs_user_id )
			dw_tel.Setitem(i, "mod_dt", ld_datetime)
		END IF		
		
	Next
End IF

il_rows = dw_body.  Update(TRUE, FALSE)
ll_rows = dw_detail.Update(TRUE, FALSE)
ll_rows1 = dw_tel.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 and ll_rows1 = 1 then
   dw_body.  ResetUpdate()
   
   dw_tel.ResetUpdate()
   commit USING SQLCA;
	
		For i = 0 to ll_row_count
		ldw_status = dw_detail.GetItemStatus(i, 0, Primary!)
		IF ldw_status = NewModified! THEN				/* New Record */
			ls_style_as = LeftA(dw_detail.GetItemString(i, "style_no"), 8)			
			ls_go_gubn_as = dw_judg.GetItemString(1, "go_gubn")
			ls_yymmdd2 = dw_body.GetItemString(1, "yymmdd")
			 
				IF ls_go_gubn_as = "03" Then 
					 DECLARE SP_79011_SMS_AS PROCEDURE FOR SP_79011_SMS_AS  
								@yymmdd = :ls_yymmdd2,   
								@seq_no = :ls_seq_no,   
								@style = :ls_style_as
								USING SQLCA;	
						 execute SP_79011_SMS_AS;	
						commit  USING SQLCA;	
						
				End If		
			
		ELSEIF ldw_status = DataModified! THEN		/* Modify Record */
		 ls_style_as = LeftA(dw_detail.GetItemString(i, "style_no"), 8)			
		 ls_go_gubn_as = dw_judg.GetItemString(1, "go_gubn")
		 ls_yymmdd2 = dw_body.GetItemString(1, "yymmdd")
	
			IF ls_go_gubn_as = '03' Then 
				 DECLARE SP_79011_SMS_AS1 PROCEDURE FOR SP_79011_SMS_AS  
							@yymmdd = :ls_yymmdd2,   
							@seq_no = :ls_seq_no,   
							@style = :ls_style_as;
					 execute SP_79011_SMS_AS1;	
					commit  USING SQLCA;	
			End If		

		END IF
	Next
	
	dw_detail.ResetUpdate()
	dw_list.Retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm, is_rct_fr_ymd, is_rct_to_ymd)
	ll_rows = dw_list.Find("yymmdd = '" + ls_yymmdd + "' and seq_no = '" + ls_seq_no + "' ", &
			            1, dw_list.RowCount() )
	dw_list.SelectRow(0, False)
	If ll_rows >= 1 Then 
		dw_list.SelectRow(ll_rows, True)
		dw_body.Retrieve(ls_yymmdd, ls_seq_no)
		dw_tel.Retrieve(ls_yymmdd, ls_seq_no)		
	End If
else
	If il_rows = 1 Then il_rows = ll_rows
   rollback USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event open;call super::open;dw_detail.ShareData(dw_judg)
Timer(60)
end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long i, ll_row_cnt
String ls_yymmdd, ls_seq_no, ls_no

dw_print.dataobject = "d_79001_r01"
dw_print. SetTransObject(SQLCA)

ll_row_cnt = dw_detail.RowCount()

IF ll_row_cnt = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	For i = 1 To ll_row_cnt
		If dw_detail.GetItemString(i, "print_yn") = 'Y' Then
			ls_yymmdd = dw_detail.GetItemString(i, "yymmdd")
			ls_seq_no = dw_detail.GetItemString(i, "seq_no")
			ls_no     = dw_detail.GetItemString(i, "no")
	
			dw_print.Retrieve(ls_yymmdd, ls_seq_no, ls_no)
			
			IF dw_print.RowCount() > 0 Then il_rows = dw_print.Print()
		End If
	Next
END IF

This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79001_e","0")
end event

event timer;call super::timer;long ll_row

ll_row = dw_2.retrieve(gs_user_id)

if ll_row > 0 then 
	dw_2.visible = true
else 	
	dw_2.visible = false
end if	
end event

type cb_close from w_com030_e`cb_close within w_79001_e
integer x = 4041
integer taborder = 120
end type

type cb_delete from w_com030_e`cb_delete within w_79001_e
integer taborder = 70
end type

type cb_insert from w_com030_e`cb_insert within w_79001_e
integer taborder = 60
boolean enabled = true
end type

type cb_retrieve from w_com030_e`cb_retrieve within w_79001_e
integer x = 3698
end type

type cb_update from w_com030_e`cb_update within w_79001_e
integer taborder = 110
end type

type cb_print from w_com030_e`cb_print within w_79001_e
integer taborder = 80
end type

type cb_preview from w_com030_e`cb_preview within w_79001_e
boolean visible = false
integer taborder = 90
end type

type gb_button from w_com030_e`gb_button within w_79001_e
integer width = 4443
end type

type cb_excel from w_com030_e`cb_excel within w_79001_e
boolean visible = false
integer taborder = 100
end type

type dw_head from w_com030_e`dw_head within w_79001_e
integer width = 4407
integer height = 220
string dataobject = "d_79001_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd_h", "card_no_h", "jumin_h", "custom_nm_h", "tel_1"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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

type ln_1 from w_com030_e`ln_1 within w_79001_e
integer beginy = 424
integer endx = 4448
integer endy = 424
end type

type ln_2 from w_com030_e`ln_2 within w_79001_e
integer beginy = 428
integer endx = 4448
integer endy = 428
end type

type dw_list from w_com030_e`dw_list within w_79001_e
integer y = 444
integer width = 837
integer height = 2068
string dataobject = "d_79001_d01"
boolean hscrollbar = true
end type

event dw_list::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
string ls_receipt_ymd 
long ll_rows
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

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'seq_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

il_rows = dw_body.  retrieve(is_yymmdd, is_seq_no)
			 dw_detail.retrieve(is_yymmdd, is_seq_no)
			 
ll_rows = dw_tel.retrieve(is_yymmdd, is_seq_no)

if ll_rows < 1 then
	   ll_rows = dw_tel.insertrow(0)
		dw_tel.SetColumn(ll_rows)	
end if		
			 
//ls_receipt_ymd =  dw_body.getitemstring(1,"receipt_ymd")
//if isnull(ls_receipt_ymd) or ls_receipt_ymd = '' then 
//	dw_body.setitem(1,"receipt_ymd", string(now(),"yyyymmdd") )
//end if

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

//// DATAWINDOW COLUMN Modify
//Integer i, li_column_count
//String  ls_column_name, ls_modify
//
//li_column_count = Integer(This.Describe("DataWindow.Column.Count"))
//
//IF li_column_count = 0 THEN RETURN
//
//FOR i=1 TO li_column_count
//	ls_column_name = This.Describe('#' + String(i) + '.Name')
//	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
//		ls_modify   = ls_modify + ls_column_name + &
//		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
//	END IF
//NEXT
//
//This.Modify(ls_modify)
end event

type dw_body from w_com030_e`dw_body within w_79001_e
integer x = 882
integer y = 444
integer width = 3561
integer height = 404
boolean enabled = false
string dataobject = "d_79001_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
String ls_time

select convert(char(20), getdate(), 112)
into :ls_time
from dual;

CHOOSE CASE dwo.name
	CASE "yymmdd", "want_ymd"
    IF gf_datechk(data) = False THEN Return 1
	 
	CASE "card_no", "jumin", "custom_nm", "shop_cd"	,"tel_no3"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
	CASE "confirm_yn"
		if data = "Y" then
			this.setitem(row, "receipt_ymd", ls_time)
		else	
			this.setitem(row, "receipt_ymd", "")			
		end if			
		
END CHOOSE

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("rcv_how", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('791')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

end event

event dw_body::ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
								
		Choose Case ls_column_name
			Case "card_no", "jumin", "custom_nm"
				ls_column_name = "custom"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type st_1 from w_com030_e`st_1 within w_79001_e
integer x = 859
integer y = 444
integer height = 2060
end type

type dw_print from w_com030_e`dw_print within w_79001_e
integer x = 567
integer y = 252
integer width = 791
integer height = 376
string dataobject = "d_79001_r01"
end type

type dw_detail from u_dw within w_79001_e
event ue_keydown pbm_dwnkey
integer x = 882
integer y = 852
integer width = 3561
integer height = 1032
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_79001_d03"
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		If ls_column_name <> 'problem' Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg,ls_seq_no, ls_no, ls_modify
String ls_saup_name, ls_brand, ls_judg_cust_fg, ls_cust_nm
Long ll_row,i, ll_row_cnt, ll_row1


IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "insert_row"
//		ls_yymmdd = dw_body.GetItemString(1, "yymmdd")
//		If IsNull(ls_yymmdd) or Trim(ls_yymmdd) = "" Then
//			MessageBox("추가오류", "의뢰 일자를 입력하십시요!")
//			dw_body.SetFocus()
//		Else
			il_rows = This.InsertRow(0)
//			This.SetItem(il_rows, "han_mark", '000000000000000')
			This.SetColumn(il_rows)
//		End If
	Case "delete_row"
		ll_row = This.GetRow()
		
		if ll_row <= 0 then return

//		ls_judg_fg = This.GetItemString(ll_row, "judg_fg")
//		If IsNull(ls_judg_fg) = False and Trim(ls_judg_fg) <> '' and Trim(ls_judg_fg) <> '0' Then 
//			MessageBox("삭제오류", "이미 판정된 제품입니다!~n~r삭제할 수 없습니다.")
//			Return
//		End IF
		
		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
		Parent.Trigger Event ue_button (4, il_rows)

Case "judg"
		IF This.AcceptText() <> 1 THEN RETURN
//		ls_yymmdd = dw_detail.GetItemString(row, "yymmdd")
//		ls_seq_no = dw_detail.GetItemString(row, "seq_no")		
//		dw_judg.retrieve(ls_yymmdd, ls_seq_no)
		dw_judg.visible = true		
		dw_judg.SetReDraw(False)
//		dw_judg.Visible = True
		This.Visible = False
		dw_judg.ScrollToRow(row)
		dw_judg.SetReDraw(True)
		if dw_judg.getitemstring(1,'pay_fg') = '6' then
			dw_judg.object.pay_kamt.visible = true
		else
			dw_judg.object.pay_kamt.visible = false
		end if

	Case "judg_su"
		IF This.AcceptText() <> 1 THEN RETURN
		ls_yymmdd = dw_detail.GetItemString(row, "yymmdd")
		ls_seq_no = dw_detail.GetItemString(row, "seq_no")
		ls_no     = dw_detail.GetItemString(row, "no")
		
		if isnull(ls_no) or ls_no = '' then
			messagebox('확인','판정처리 후 사용이 가능합니다!')
			return 0
		end if
		
		dw_judg_su.insertrow(0)
		ll_row1 = dw_judg_su.retrieve(ls_yymmdd, ls_seq_no, ls_no)
		if ll_row1 < 1 then 
			dw_judg_su.insertrow(0)
			dw_judg_su.setitem(1,'yymmdd',ls_yymmdd)
			dw_judg_su.setitem(1,'seq_no',ls_seq_no)
			dw_judg_su.setitem(1,'no',ls_no)
			dw_judg_su.setitem(1,'judg_gu','1')
		else
			dw_judg_su.retrieve(ls_yymmdd, ls_seq_no, ls_no)
		end if
		
		dw_judg_su.visible = true		
		dw_judg_su.SetReDraw(False)
//		This.Visible = False
		dw_judg_su.ScrollToRow(row)
		dw_judg_su.SetReDraw(True)
		
	Case "print_out"		
		dw_print.dataobject = "d_79001_r02"
		dw_print. SetTransObject(SQLCA)
	
		ls_yymmdd = dw_detail.GetItemString(1, "yymmdd")
		ls_seq_no = dw_detail.GetItemString(1, "seq_no")
		ls_brand  = dw_detail.GetItemString(1, "brand")	
		ls_judg_cust_fg = dw_detail.GetItemString(1, "judg_cust_fg")
		

//	if ls_judg_cust_fg = '0' then 
//		messagebox("알림!", "업체클레임 대상이 아닙니다!")	
//		return
//	end if	

		if ls_judg_cust_fg = '1' then 
			ls_cust_nm = dw_detail.GetItemString(1, "st_cust_nm")		
		elseif ls_judg_cust_fg = '2' then	
			ls_cust_nm = dw_detail.GetItemString(1, "mat_cust_nm")		
		end if	
	
		if ls_brand = "N" then 
			ls_saup_name = "(주)보끄레머천다이징"
		elseif ls_brand = "O" then 
			ls_saup_name = "올리브데올리브(주)" 
		elseif ls_brand = 'W' then 
			ls_saup_name = "W. (주)보끄레머천다이징"
		elseif ls_brand = 'B' then 
			ls_saup_name = "(주)이터널그룹-라빠레뜨"
		elseif ls_brand = 'L' then 
			ls_saup_name = "(주)이터널그룹-조이"
		elseif ls_brand = 'V' then 
			ls_saup_name = "(주)이터널그룹-레이브"
			
		elseif ls_brand = 'G' then 
			ls_saup_name = "(주)이터널뷰티"
			
			
		else	
			ls_saup_name = 'NetC (주)보끄레머천다이징'
		end if		
	
	 
	
		dw_print.Retrieve(ls_yymmdd, ls_seq_no)
			
		 ls_modify =	"t_brand.Text = '" + ls_saup_name + "'" + &
							"t_cust_nm.text = '" + ls_cust_nm + "'" 
		 dw_print.Modify(ls_modify)
		
		
		
		IF dw_print.RowCount() > 0 Then il_rows = dw_print.Print()			
		
		
	Case Else
		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)
End Choose

end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1

end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
If dwo.name <> "print_yn" Then
	ib_changed = true
	cb_update.enabled = true
	cb_print.enabled = false
	cb_preview.enabled = false
	cb_excel.enabled = false
End If

CHOOSE CASE dwo.name
	CASE "sale_ymd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color"
		This.SetItem(row, "size", "")
END CHOOSE

end event

event itemerror;call super::itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg, ls_style_no, ls_color

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

CHOOSE CASE ls_column_nm
	CASE "color"
		ls_style_no = This.GetItemString(row, "style_no")
		idw_color.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1))
		idw_color.InsertRow(1)
		idw_color.SetItem(1, "color", '')
		idw_color.SetItem(1, "color_enm", '')
	CASE "size"
		ls_style_no = This.GetItemString(row, "style_no")
		ls_color    = This.GetItemString(row, "color"   )
		idw_size.Retrieve(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1), ls_color)
		idw_size.InsertRow(1)
		idw_size.SetItem(1, "size", '')
		idw_size.SetItem(1, "size_nm", '')
END CHOOSE

end event

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.InsertRow(0)

This.GetChild("color_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.InsertRow(0)

This.GetChild("size_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve()

This.GetChild("wash_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('792')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("rcv_why", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('793')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("rcv_req", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('794')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

end event

type dw_tel from datawindow within w_79001_e
event ue_keydown pbm_dwnkey
integer x = 882
integer y = 1896
integer width = 3552
integer height = 604
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_79001_d05"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		If ls_column_name <> 'problem' Then
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
	CASE KeyDownArrow!
		IF This.GetRow() = This.RowCount() THEN
		   This.InsertRow(This.GetRow() + 1)
		END IF
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

event buttonclicked;string ls_column_nm,ls_report,ls_column_value
Long ll_row,i, ll_row_cnt

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Choose Case ls_column_nm
	Case "insert"
			il_rows = This.InsertRow(0)
			This.SetColumn(il_rows)
	Case "delete"
		ll_row = This.GetRow()
		
		if ll_row <= 0 then return

		idw_status = This.GetItemStatus(ll_row, 0, Primary!)
		il_rows = This.DeleteRow(ll_row)
		This.SetFocus()
		Parent.Trigger Event ue_button (4, il_rows)		
		
	Case "no1"
		this.object.tel_ymd_01.visible = 1
		this.object.tel_ymd_01.visible = 1
		this.object.tel_fr_time_01.visible = 1
		this.object.tel_to_time_01.visible = 1
		this.object.tel_empno_01.visible = 1
		this.object.COUNSEL_01.visible = 1
		
		this.object.tel_ymd_02.visible = 0
		this.object.tel_ymd_02.visible = 0
		this.object.tel_fr_time_02.visible = 0
		this.object.tel_to_time_02.visible = 0
		this.object.tel_empno_02.visible = 0
		this.object.COUNSEL_02.visible = 0

		this.object.tel_ymd_03.visible = 0
		this.object.tel_ymd_03.visible = 0
		this.object.tel_fr_time_03.visible = 0
		this.object.tel_to_time_03.visible = 0
		this.object.tel_empno_03.visible = 0
		this.object.COUNSEL_03.visible = 0
		
		this.object.tel_ymd_04.visible = 0
		this.object.tel_ymd_04.visible = 0
		this.object.tel_fr_time_04.visible = 0
		this.object.tel_to_time_04.visible = 0
		this.object.tel_empno_04.visible = 0
		this.object.COUNSEL_04.visible = 0
		
	Case "no2"
		this.object.tel_ymd_01.visible = 0
		this.object.tel_ymd_01.visible = 0
		this.object.tel_fr_time_01.visible = 0
		this.object.tel_to_time_01.visible = 0
		this.object.tel_empno_01.visible = 0
		this.object.COUNSEL_01.visible = 0
		
		this.object.tel_ymd_02.visible = 1
		this.object.tel_ymd_02.visible = 1
		this.object.tel_fr_time_02.visible = 1
		this.object.tel_to_time_02.visible = 1
		this.object.tel_empno_02.visible = 1
		this.object.COUNSEL_02.visible = 1

		this.object.tel_ymd_03.visible = 0
		this.object.tel_ymd_03.visible = 0
		this.object.tel_fr_time_03.visible = 0
		this.object.tel_to_time_03.visible = 0
		this.object.tel_empno_03.visible = 0
		this.object.COUNSEL_03.visible = 0
		
		this.object.tel_ymd_04.visible = 0
		this.object.tel_ymd_04.visible = 0
		this.object.tel_fr_time_04.visible = 0
		this.object.tel_to_time_04.visible = 0
		this.object.tel_empno_04.visible = 0
		this.object.COUNSEL_04.visible = 0		
		
	Case "no3"
		this.object.tel_ymd_01.visible = 0
		this.object.tel_ymd_01.visible = 0
		this.object.tel_fr_time_01.visible = 0
		this.object.tel_to_time_01.visible = 0
		this.object.tel_empno_01.visible = 0
		this.object.COUNSEL_01.visible = 0
		
		this.object.tel_ymd_02.visible = 0
		this.object.tel_ymd_02.visible = 0
		this.object.tel_fr_time_02.visible = 0
		this.object.tel_to_time_02.visible = 0
		this.object.tel_empno_02.visible = 0
		this.object.COUNSEL_02.visible = 0

		this.object.tel_ymd_03.visible = 1
		this.object.tel_ymd_03.visible = 1
		this.object.tel_fr_time_03.visible = 1
		this.object.tel_to_time_03.visible = 1
		this.object.tel_empno_03.visible = 1
		this.object.COUNSEL_03.visible = 1
		
		this.object.tel_ymd_04.visible = 0
		this.object.tel_ymd_04.visible = 0
		this.object.tel_fr_time_04.visible = 0
		this.object.tel_to_time_04.visible = 0
		this.object.tel_empno_04.visible = 0
		this.object.COUNSEL_04.visible = 0				
		
	Case "no4"		
		this.object.tel_ymd_01.visible = 0
		this.object.tel_ymd_01.visible = 0
		this.object.tel_fr_time_01.visible = 0
		this.object.tel_to_time_01.visible = 0
		this.object.tel_empno_01.visible = 0
		this.object.COUNSEL_01.visible = 0
		
		this.object.tel_ymd_02.visible = 0
		this.object.tel_ymd_02.visible = 0
		this.object.tel_fr_time_02.visible = 0
		this.object.tel_to_time_02.visible = 0
		this.object.tel_empno_02.visible = 0
		this.object.COUNSEL_02.visible = 0

		this.object.tel_ymd_03.visible = 0
		this.object.tel_ymd_03.visible = 0
		this.object.tel_fr_time_03.visible = 0
		this.object.tel_to_time_03.visible = 0
		this.object.tel_empno_03.visible = 0
		this.object.COUNSEL_03.visible = 0
		
		this.object.tel_ymd_04.visible = 1
		this.object.tel_ymd_04.visible = 1
		this.object.tel_fr_time_04.visible = 1
		this.object.tel_to_time_04.visible = 1
		this.object.tel_empno_04.visible = 1
		this.object.COUNSEL_04.visible = 1						

End Choose
end event

event editchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;string ls_time

select convert(char(20), getdate(), 108)
into :ls_time
from dual;


CHOOSE CASE dwo.name
	CASE "tel_ymd_01"
		if LenA(data) = 8 then
			this.setitem(row, "tel_fr_time_01", ls_time)
		end if	
	CASE "tel_ymd_02"
		if LenA(data) = 8 then
		
			this.setitem(row, "tel_fr_time_02", ls_time)
		end if	
	CASE "tel_ymd_03"
		if LenA(data) = 8 then
			
			this.setitem(row, "tel_fr_time_03", ls_time)
		end if	
	CASE "tel_ymd_04"
		if LenA(data) = 8 then
			
			this.setitem(row, "tel_fr_time_04", ls_time)
		end if			

END CHOOSE

end event

type dw_1 from datawindow within w_79001_e
boolean visible = false
integer x = 1920
integer y = 524
integer width = 1893
integer height = 1972
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "미처리건 내역"
string dataobject = "d_79001_d06"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_receipt_ymd 
long ll_rows
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

is_yymmdd = This.GetItemString(row, 'b_yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'b_seq_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

il_rows = dw_body.  retrieve(is_yymmdd, is_seq_no)
			 dw_detail.retrieve(is_yymmdd, is_seq_no)
			 
ll_rows = dw_tel.retrieve(is_yymmdd, is_seq_no)

if ll_rows < 1 then
	   ll_rows = dw_tel.insertrow(0)
		dw_tel.SetColumn(ll_rows)	
end if		
			 
//ls_receipt_ymd =  dw_body.getitemstring(1,"receipt_ymd")
//if isnull(ls_receipt_ymd) or ls_receipt_ymd = '' then 
//	dw_body.setitem(1,"receipt_ymd", string(now(),"yyyymmdd") )
//end if

this.visible = false

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type dw_2 from datawindow within w_79001_e
boolean visible = false
integer x = 1408
integer y = 628
integer width = 2395
integer height = 1200
integer taborder = 60
boolean bringtotop = true
boolean titlebar = true
string title = "상담예약알림"
string dataobject = "d_79001_d07"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;string ls_receipt_ymd 
long ll_rows
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

is_yymmdd = This.GetItemString(row, 'b_yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'b_seq_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

il_rows = dw_body.  retrieve(is_yymmdd, is_seq_no)
			 dw_detail.retrieve(is_yymmdd, is_seq_no)
			 
ll_rows = dw_tel.retrieve(is_yymmdd, is_seq_no)

if ll_rows < 1 then
	   ll_rows = dw_tel.insertrow(0)
		dw_tel.SetColumn(ll_rows)	
end if		
			 
//ls_receipt_ymd =  dw_body.getitemstring(1,"receipt_ymd")
//if isnull(ls_receipt_ymd) or ls_receipt_ymd = '' then 
//	dw_body.setitem(1,"receipt_ymd", string(now(),"yyyymmdd") )
//end if

this.visible = false

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)
end event

type cb_yet from commandbutton within w_79001_e
integer x = 1774
integer y = 44
integer width = 434
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "미처리건 조회"
end type

event clicked;long ll_rows


ll_rows = dw_1.retrieve(is_brand)

IF ll_rows > 0 THEN
   dw_1.visible = true
ELSE
   dw_1.visible = false
END IF
end event

type st_2 from statictext within w_79001_e
integer x = 2213
integer y = 60
integer width = 882
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 79741120
long bordercolor = 255
boolean focusrectangle = false
end type

type dw_judg from u_dw within w_79001_e
event ue_keydown pbm_dwnkey
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 1403
integer y = 488
integer width = 2341
integer height = 1752
integer taborder = 11
boolean bringtotop = true
boolean titlebar = true
string title = "판정"
string dataobject = "d_79001_d04"
boolean vscrollbar = false
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		If LeftA(ls_column_name,2) <> 're' then //quest'  Then //or ls_column_name <> 'result'
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
		
	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

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

This.GetChild("pay_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('797')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("deal_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('798')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("claim_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79A')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("CUST_FG_L", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79B')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')


This.GetChild("CUST_FG_S", idw_cust_fg_s)
idw_cust_fg_s.SetTransObject(SQLCA)
idw_cust_fg_s.InsertRow(0)

This.GetChild("decision_a", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79D')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("decision_b", idw_decision_b)
idw_decision_b.SetTransObject(SQLCA)
idw_decision_b.InsertRow(0)

This.GetChild("decision_c", idw_decision_c)
idw_decision_c.SetTransObject(SQLCA)
idw_decision_c.InsertRow(0)

This.GetChild("decision_d", idw_decision_d)
idw_decision_d.SetTransObject(SQLCA)
idw_decision_d.InsertRow(0)


This.GetChild("go_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79H')

dw_judg.object.pay_kamt.visible = false
dw_judg.setitem(1,'pay_kamt',0)



end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg, ls_gubn, ls_go_ymd, ls_go_ymd2
Long ll_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

ls_gubn = dw_judg.getitemstring(row,'go_gubn')
ls_go_ymd = dw_judg.getitemstring(row,'go_ymd')
ls_go_ymd2 = dw_judg.getitemstring(row,'go_ymd2')

Choose Case ls_column_nm
	Case "ok"
		IF This.AcceptText() <> 1 THEN RETURN
		if ls_gubn = '01' or ls_gubn = '02' or ls_gubn = '03' or ls_gubn = '04' then
			if isnull(ls_go_ymd) or ls_go_ymd = '' or LenA(ls_go_ymd) <> 8 then
				if isnull(ls_go_ymd2) or ls_go_ymd2 = '' or LenA(ls_go_ymd2) <> 8 then
					messagebox('확인','고객발송일을 입력해 주세요!')
					return 0
				end if
			end if
		elseif ls_gubn = '' or isnull(ls_gubn) then
				if ls_go_ymd = '' or LenA(ls_go_ymd) <> 8 then
					messagebox('확인','행랑발송일을 형식이 틀립니다. 확인해 주세요!')
					return 0
				end if
		end if
		
		dw_detail.Visible = True
		This.     Visible = False
	Case "copy1"
		This.SetItem(row, "request", This.GetItemString(row, "problem"))
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
	Case "copy2"
		This.SetItem(row, "result",  This.GetItemString(row, "problem"))
		ib_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
	Case "fix_cust"
		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)		
	Case Else
		Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)
End Choose
end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = true
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

string ls_pay_fg

dw_judg.accepttext()

CHOOSE CASE dwo.name
	CASE "judg_ymd", "cn_ymd", "st_ymd", "pr_ymd", "ed_ymd", "go_ymd"
		If gf_datechk(data) = False Then Return 1
	CASE "judg_l" 
//		This.SetItem(1, "judg_s", "")
	CASE "judg_cust_fg" 
		This.SetItem(1, "cust_emp", "")
	CASE "cust_fg_l" 
		This.SetItem(1, "cust_fg_s", "")		
	CASE "decision_a" 
		This.SetItem(1, "decision_b", "")				
	CASE "decision_b" 
		This.SetItem(1, "decision_c", "")				
	CASE "decision_c" 
		This.SetItem(1, "decision_d", "")	
	CASE "fix_cust"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "pay_fg" //지급구분이 여섯번째이면 pay_kamt를 활성화 시킴
		ls_pay_fg = dw_judg.getitemstring(1,'pay_fg')
		if isnull(ls_pay_fg) or ls_pay_fg = '' then
			ls_pay_fg = ''
		end if
		if dw_judg.getitemstring(1,'pay_fg') = '6' then			
			dw_judg.object.pay_kamt.visible = true
		else
			dw_judg.object.pay_kamt.visible = false
			dw_judg.setitem(1,'pay_kamt',0)
		end if
END CHOOSE




end event

event itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String ls_judg_l, LS_CUST_FG_L, ls_decision_a, ls_decision_b, ls_decision_c, ls_decision_d
datawindow ldw_child

CHOOSE CASE dwo.name
	CASE "judg_s"
		ls_judg_l = This.GetItemString(row, "judg_l")
		idw_judg_s.Retrieve('796', ls_judg_l)
		idw_judg_s.InsertRow(1)
		idw_judg_s.SetItem(1, "inter_cd", '') 
		idw_judg_s.SetItem(1, "inter_nm", '')

	CASE "cust_fg_s"
		LS_CUST_FG_L = This.GetItemString(row, "CUST_FG_L")
		idw_cust_fg_s.Retrieve('79C', LS_CUST_FG_L)
		idw_cust_fg_s.InsertRow(1)
		idw_cust_fg_s.SetItem(1, "inter_cd", '')
		idw_cust_fg_s.SetItem(1, "inter_nm", '')		
		
	CASE "decision_b"
		ls_decision_a = This.GetItemString(row, "decision_a")
		idw_decision_b.Retrieve('79E', ls_decision_a)
		idw_decision_b.InsertRow(1)
		idw_decision_b.SetItem(1, "inter_cd", '')
		idw_decision_b.SetItem(1, "inter_nm", '')		
		
	CASE "decision_c"
		ls_decision_b = This.GetItemString(row, "decision_b")
		idw_decision_c.Retrieve('79F', ls_decision_b)
		idw_decision_c.InsertRow(1)
		idw_decision_c.SetItem(1, "inter_cd", '')
		idw_decision_c.SetItem(1, "inter_nm", '')		
		
	CASE "decision_d"
		ls_decision_c = This.GetItemString(row, "decision_c")
		idw_decision_d.Retrieve('79G', ls_decision_c)
		idw_decision_d.InsertRow(1)
		idw_decision_d.SetItem(1, "inter_cd", '')
		idw_decision_d.SetItem(1, "inter_nm", '')				
				
		
END CHOOSE

end event

type cb_print_info from commandbutton within w_79001_e
integer x = 3264
integer y = 44
integer width = 434
integer height = 92
integer taborder = 130
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "안내문 인쇄"
end type

event clicked;Open(w_79001_p)

//Long ll_row_cnt
//String ls_yymmdd, ls_seq_no, ls_person_nm
//integer li_cnt
//
//li_cnt = messagebox("선택","현재 고객만 출력 하시려면 '예(Y)'를, 전체고객을 선택 출력 '아니오(N)'를 선택하세요!", Exclamation!, YesNoCancel!)
//
//IF li_cnt = 1 then
//	dw_print.dataobject = "d_79001_r03"
//	dw_print.SetTransObject(SQLCA)
//	
//	ll_row_cnt = dw_body.RowCount()
//	
//	IF ll_row_cnt = 0 Then
//		//출력물이 없을때
//		MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
//		il_rows = 0
//	ELSE
//		//출력물이 있을때
//		ls_yymmdd = dw_body.GetItemString(dw_body.getrow(), "yymmdd")
//		ls_seq_no = dw_body.GetItemString(dw_body.getrow(), "seq_no")
//		dw_print.Retrieve(ls_yymmdd, ls_seq_no)
//
//		select person_nm 
//		into :ls_person_nm 
//		from TB_93010_M with (nolock)
//		where person_id = :gs_user_id;
//		
//		dw_print.object.t_jik.text = ls_person_nm
//		
//		if dw_print.getitemstring(1, 'amt') = '무상' then
//			dw_print.object.t_11.visible = false
//		end if
//		
//		IF dw_print.RowCount() > 0 Then il_rows = dw_print.Print()
//	END IF
//	
//ELSEIF li_cnt = 2 then
//	open(w_79001_p)
//END IF
end event

type dw_judg_su from u_dw within w_79001_e
event ue_keydown pbm_dwnkey
event ue_syscommand pbm_syscommand
boolean visible = false
integer x = 1678
integer y = 708
integer width = 1915
integer height = 672
integer taborder = 21
boolean bringtotop = true
boolean titlebar = true
string title = "수선실판정"
string dataobject = "d_79001_d09"
boolean vscrollbar = false
end type

event ue_keydown;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
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
		If LeftA(ls_column_name,2) <> 're' then //quest'  Then //or ls_column_name <> 'result'
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
		End If
		
	CASE KeyUpArrow!, KeyDownArrow!, KeyPageUp!, KeyPageDown!
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

event ue_syscommand;/* DataWindow 위치 이동 금지 */
uint a

a = message.wordparm

CHOOSE CASE a
      CASE 61456, 61458
         message.processed = true
         message.returnvalue = 0
END CHOOSE

return

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_gubn, ls_go_ymd, ls_invoice_no, ls_judg_gu, ls_seq_no, ls_no
Long ll_row, ll_rows
datetime ld_datetime

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

// Column.Protect = True Then Return
ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

IF This.AcceptText() <> 1 THEN RETURN
ls_gubn       = dw_judg_su.getitemstring(row,'go_gubn')
ls_go_ymd     = dw_judg_su.getitemstring(row,'go_ymd')
ls_invoice_no = dw_judg_su.getitemstring(row,'invoice_no')
ls_judg_gu    = dw_judg_su.getitemstring(row,'judg_gu')
ls_yymmdd     = dw_detail.GetItemString(row, "yymmdd")
ls_seq_no     = dw_detail.GetItemString(row, "seq_no")
ls_no         = dw_detail.GetItemString(row, "no")

Choose Case ls_column_nm
	Case "ok"
		if ls_gubn <> '' or isnull(ls_gubn)  then
			if isnull(ls_go_ymd) or ls_go_ymd = '' or LenA(ls_go_ymd) <> 8 then
				messagebox('확인','발송일자를 입력해 주세요!')
				return 0
			end if
		end if
		
		if ls_gubn = '2' then
			if isnull(ls_invoice_no) or ls_invoice_no = '' then
				messagebox('확인','송장번호를 입력해 주세요!')
				return 0
			end if
		end if

		if ls_gubn = '1' then      //행랑
			update tb_79011_d 
			set go_gubn = '01', go_ymd = :ls_go_ymd
			from tb_79011_d 
			where yymmdd = :ls_yymmdd 
					and seq_no = :ls_seq_no
					and no = :ls_no;
		elseif ls_gubn = '2' then  //택배
			update tb_79011_d 
			set go_gubn = '03', go_ymd2 = :ls_go_ymd, invoice_no = :ls_invoice_no
			from tb_79011_d 
			where yymmdd = :ls_yymmdd 
					and seq_no = :ls_seq_no
					and no = :ls_no;
		elseif ls_gubn = '3' then  //퀵
			update tb_79011_d 
			set go_gubn = '04', go_ymd2 = :ls_go_ymd
			from tb_79011_d 
			where yymmdd = :ls_yymmdd 
					and seq_no = :ls_seq_no
					and no = :ls_no;
		end if	
		
		if ls_judg_gu = '2' then
			update tb_79011_d 
			set judg_fg = '1'
			from tb_79011_d 
			where yymmdd = :ls_yymmdd 
					and seq_no = :ls_seq_no
					and no = :ls_no;
		end if


		//-----
		idw_status = dw_judg_su.GetItemStatus(1, 0, Primary!)
		IF idw_status = NewModified! THEN				/* New Record */							
			dw_judg_su.Setitem(1, "reg_id", gs_user_id)
			dw_judg_su.Setitem(1, "reg_dt", ld_datetime)
		ELSEIF idw_status = DataModified! THEN		/* Modify Record */
			dw_judg_su.Setitem(1, "mod_id", gs_user_id )
			dw_judg_su.Setitem(1, "mod_dt", ld_datetime)
		END IF
		
		
		ll_rows = dw_judg_su.Update(TRUE, FALSE)
		if ll_rows = 1 then
			dw_judg_su.ResetUpdate()
			commit USING SQLCA;	
		else
			rollback USING SQLCA;
		end if
		//----
		dw_judg_su.Visible = false		
		dw_detail.retrieve(ls_yymmdd,ls_seq_no)
	Case "cancle"
		dw_judg_su.Visible = false	
		
End Choose



return il_rows
//-----
end event

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw일경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

This.GetChild("judg_a", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('79I')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_b", idw_judg_b)
idw_judg_b.SetTransObject(SQLCA)
idw_judg_b.Retrieve('79J','%')
idw_judg_b.InsertRow(1)
idw_judg_b.SetItem(1, "inter_cd", '')
idw_judg_b.SetItem(1, "inter_nm", '')

dw_judg_su.setitem(1,'judg_gu','1')
dw_judg_su.setitem(1,'go_gubn','1')





end event

event dberror;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09																  */	
/* 수정일      : 1999.11.09																  */
/*===========================================================================*/

string ls_message_string

CHOOSE CASE sqldbcode
	CASE 2627
		ls_message_string = "같은 코드값은 입력할 수 없습니다!"
	CASE 515
		ls_message_string = "코드값은 반드시 입력하셔야 합니다!"
	CASE -1
		ls_message_string = "데이타 베이스와 연결이 끊어졌습니다!"
	CASE ELSE
		ls_message_string = "에러코드(" + String(sqldbcode) + ")" + &
		   				     "~n" + "에러메세지("+sqlerrtext+")" 
END CHOOSE

This.ScrollTorow(row)
This.SetRow(row)
This.SetFocus()

MessageBox(parent.title, ls_message_string)
return 1
end event

event editchanged;call super::editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = true
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.27                                                  */	
/* 수정일      : 2002.03.27                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


end event

event itemerror;return 1
end event

event itemfocuschanged;call super::itemfocuschanged;String ls_judg_a

CHOOSE CASE dwo.name
	CASE "judg_b"
		ls_judg_a = This.GetItemString(row, "judg_a")
		idw_judg_b.Retrieve('79j', ls_judg_a)
		idw_judg_b.InsertRow(1)
		idw_judg_b.SetItem(1, "inter_cd", '')
		idw_judg_b.SetItem(1, "inter_nm", '')
END CHOOSE



end event

