$PBExportHeader$w_sh209_e.srw
$PBExportComments$A/S 등록
forward
global type w_sh209_e from w_com020_e
end type
type dw_detail from datawindow within w_sh209_e
end type
end forward

global type w_sh209_e from w_com020_e
integer height = 2056
long backcolor = 16777215
dw_detail dw_detail
end type
global w_sh209_e w_sh209_e

type variables
DataWindowChild idw_brand, idw_color, idw_size, idw_judg_fg, idw_judg_s, idw_cust_fg_s
DataWindowChild idw_decision_a, idw_decision_b, idw_decision_c, idw_decision_d 
dragobject   idrg_ver[4]

String is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm
String is_yymmdd, is_seq_no

end variables

forward prototypes
public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm)
public function boolean wf_detail_chk (long al_row)
public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm)
public function integer wf_resizepanels ()
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_name_chk (string as_user_name, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name)
public function integer wf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
end prototypes

public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm);
Return 1

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

public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm);/*===========================================================================*/
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

return true

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
  FROM VI_12020_1 A,
       TB_21010_M B
 WHERE A.MAT_CD *= B.MAT_CD
   AND A.STYLE = :as_style
   AND A.CHNO  = :as_chno
;

IF ISNULL(as_st_cust_cd) THEN RETURN 100

RETURN sqlca.sqlcode  

end function

public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3);/*============================================================*/
/* 작 성 자  : (주)지우정보 (권 진택)                         */
/* 작 성 일  : 2002/03/22                                     */
/* 수 정 일  : 2002/03/22                                     */
/* 내    용  : 회원번호가 있는지 체크한다.                    */
/*============================================================*/
String ls_jumin

SELECT JUMIN, CARD_NO, USER_NAME, SEX, TEL_NO1, TEL_NO2, TEL_NO3
  INTO :ls_jumin, :as_card_no, :as_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
  FROM beaucre.dbo.TB_71010_M
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
  FROM beaucre.dbo.TB_71010_M
 WHERE USER_NAME = :as_user_name
;

IF ls_cnt = 1 Then
	SELECT CARD_NO, JUMIN, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_card_no, :as_jumin, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM beaucre.dbo.TB_71010_M
	 WHERE USER_NAME = :as_user_name
	;
	RETURN 0
ElseIf ls_cnt > 1 Then
	RETURN -2
Else
	RETURN -1
END IF

end function

public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name);
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt
  FROM beaucre.dbo.TB_71010_M
 WHERE tel_no3 = :as_tel_no
;

IF ls_cnt = 1 Then
	SELECT CARD_NO, JUMIN, user_name, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_card_no, :as_jumin, :As_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM beaucre.dbo.TB_71010_M
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
/* 작 성 자  : (주)지우정보 (권 진택)                         */
/* 작 성 일  : 2002/03/22                                     */
/* 수 정 일  : 2002/03/22                                     */
/* 내    용  : 카드번호가 있는지 체크한다.                    */
/* RETURN    : 0: 정상, -1: 없음, -2: 중복                    */
/*============================================================*/
long ls_cnt

SELECT COUNT(JUMIN)
  INTO :ls_cnt 
  FROM beaucre.dbo.TB_71010_M
 WHERE CARD_NO = :as_card_no 
;

IF ls_cnt = 1 Then
	SELECT JUMIN, USER_NAME, SEX, TEL_NO1, TEL_NO2, TEL_NO3
	  INTO :as_jumin, :as_user_name, :ai_sex, :as_tel_no1, :as_tel_no2, :as_tel_no3
	  FROM beaucre.dbo.TB_71010_M
	 WHERE CARD_NO = :as_card_no
	;
	RETURN 0
ElseIf ls_cnt > 1 Then
	RETURN -2
Else
	RETURN -1
END IF

end function

on w_sh209_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_sh209_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
end on

event open;call super::open;//dw_detail.ShareData(dw_judg)
datetime ld_datetime
string ls_modify

if MidA(gs_shop_cd_1,1,2) = 'XX' then
	dw_head.setitem(1,'shop_cd_h','N' + gs_shop_div + MidA(gs_shop_cd,3,4))
	dw_head.setitem(1,'shop_nm_h',gs_shop_nm)
else
	dw_head.setitem(1,'shop_cd_h',gs_user_id)
	dw_head.setitem(1,'shop_nm_h',gs_shop_nm)
end if

is_brand = gs_brand

if gf_cdate(ld_datetime,0) then 
	dw_body.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
end if


if MidA(gs_shop_cd,3,4) <> '2000' then 
	if MidA(gs_shop_cd_1,1,2) <> 'XX' then
		ls_modify =	'brand.protect = 1'
		dw_head.Modify(ls_modify)
	end if
end if


end event

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
//inv_resize.of_Register(cb_excel,    "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close,    "FixedToRight")

/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_list,   "ScaleToBottom")
inv_resize.of_Register(dw_body,   "ScaleToRight")
inv_resize.of_Register(dw_detail, "ScaleToRight&Bottom")
inv_resize.of_Register(st_1,      "ScaleToBottom")
inv_resize.of_Register(ln_1,      "ScaleToRight")
inv_resize.of_Register(ln_2,      "ScaleToRight")

// Set the color of the bars to make them invisible
il_HiddenColor = This.BackColor
st_1.BackColor = il_HiddenColor

/* DataWindow의 Transction 정의 */
dw_list.  SetTransObject(SQLCA)
dw_body.  SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_print. SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)

/* DataWindow 사이 이동 */
idrg_Ver[1] = dw_list
idrg_Ver[2] = dw_body
idrg_Ver[3] = dw_detail

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

dw_body.  Reset()
dw_detail.Reset()

il_rows = dw_body.InsertRow(0)

dw_detail.InsertRow(0)

dw_body.SetColumn(ii_min_column_id)
dw_body.SetFocus()

dw_body.  SetRedraw(True)
dw_detail.SetRedraw(True)

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

return true

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.20                                                  */	
/* 수정일      : 2002.03.20                                                  */
/*===========================================================================*/
String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name
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
				IF gf_cust_card_chk(as_data, ls_jumin, ls_custom_nm, ls_tel_no3) = TRUE THEN
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
				IF gf_cust_jumin_chk(as_data, ls_custom_nm, ls_card_no, ls_tel_no3) = TRUE THEN
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
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no, ls_tel_no3) = TRUE THEN
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
					dw_body.SetColumn("want_ymd")
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
					dw_body.SetColumn("want_ymd")
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
								dw_body.SetColumn("want_ymd")
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
				dw_body.SetColumn("want_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
//				cb_excel.enabled = false
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
//				cb_excel.enabled = false
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
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "STYLE NO 검색" 
			gst_cd.datawindow_nm   = "d_com010" 
			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' and tag_price <> 0 "
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
					dw_detail.SetColumn("color")
					ib_itemchanged = False 
					lb_check = TRUE 
					ib_changed = true
					cb_update.enabled = true
					cb_print.enabled = false
					cb_preview.enabled = false
//					cb_excel.enabled = false
				End If
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
						dw_body.SetColumn("want_ymd")
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
				dw_body.SetColumn("want_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
//				cb_excel.enabled = false
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

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm)

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

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long i, ll_row_count, ll_cur_row, ll_seq_no, ll_no_max, ll_rows
datetime ld_datetime
String ls_yymmdd, ls_seq_no, ls_jumin, ls_custom_nm, ls_judg_cust_fg, ls_judg_fg, ls_problem
dwItemStatus ldw_status

IF dw_body  .AcceptText() <> 1 THEN RETURN -1
IF dw_detail.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// dw_body
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
If idw_status <> New! THEN
	If wf_data_chk(ls_yymmdd, ls_jumin, ls_custom_nm) = False Then Return -1

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
		dw_body.Setitem(1, "shop_cd", gs_shop_cd)
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
	
	For i = 1 to ll_row_count
		
//		ls_judg_fg = dw_detail.getitemstring(i, "judg_fg")
//		ls_problem  = dw_detail.getitemstring(i, "problem")		
//		
//		if ls_judg_fg = "5"  and (isnull(ls_problem) = TRUE or len(ls_problem) < 2 )then
//			messagebox("알림!", "유통불량의 경우 등록 사유를 Remark란에 반드시 입력하셔야 합니다!")
//			Return -1			
//		end if	
		
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
		END IF
	Next
End IF

il_rows = dw_body.  Update(TRUE, FALSE)
ll_rows = dw_detail.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows = 1 then
   dw_body.  ResetUpdate()
   dw_detail.ResetUpdate()
   commit USING SQLCA;
	dw_list.Retrieve(is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_card_no, is_jumin, is_custom_nm)
	ll_rows = dw_list.Find("yymmdd = '" + ls_yymmdd + "' and seq_no = '" + ls_seq_no + "' ", &
			            1, dw_list.RowCount() )
	dw_list.SelectRow(0, False)
	If ll_rows >= 1 Then 
		dw_list.SelectRow(ll_rows, True)
		dw_body.Retrieve(ls_yymmdd, ls_seq_no)
	End If
else
	If il_rows = 1 Then il_rows = ll_rows
   rollback USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건, 7 - click */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/
datetime ld_datetime
string ls_yymmdd

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_list.Enabled = true
         dw_body.Enabled = true
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
//			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
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
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
//            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
      cb_insert.enabled = false
//      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_list.Enabled = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
//         cb_delete.enabled = true
         cb_print.enabled = true
         cb_preview.enabled = true
		else
//         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
         cb_insert.enabled = true
      end if
END CHOOSE

ls_yymmdd = dw_body.getitemstring(1,"yymmdd")
if ls_yymmdd = "" or isnull(ls_yymmdd) then 
	if gf_cdate(ld_datetime,0) then 
		dw_body.setitem(1,"yymmdd",string(ld_datetime,"yyyymmdd"))
	end if
end if
end event

type cb_close from w_com020_e`cb_close within w_sh209_e
end type

type cb_delete from w_com020_e`cb_delete within w_sh209_e
end type

event cb_delete::clicked;//
return
end event

type cb_insert from w_com020_e`cb_insert within w_sh209_e
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_sh209_e
end type

type cb_update from w_com020_e`cb_update within w_sh209_e
end type

type cb_print from w_com020_e`cb_print within w_sh209_e
end type

type cb_preview from w_com020_e`cb_preview within w_sh209_e
end type

type gb_button from w_com020_e`gb_button within w_sh209_e
long backcolor = 16777215
end type

type dw_head from w_com020_e`dw_head within w_sh209_e
integer width = 2843
integer height = 232
string dataobject = "d_sh209_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/
long ll_b_cnt

CHOOSE CASE dwo.name
	CASE "shop_cd_h" ,"card_no_h", "jumin_h" //, "custom_nm_h"	//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		


	CASE "brand"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
			dw_head.accepttext()
			gs_brand = dw_head.getitemstring(1,'brand')
			is_brand = dw_head.getitemstring(1,'brand')
			select isnull(count(brand),0)
			into	:ll_b_cnt
			from tb_91100_m  with (nolock) 
			where shop_cd like '%' + substring(:gs_shop_cd_1,3,4)
					and brand = :gs_brand;	
					
			if ll_b_cnt = 0 then 
				messagebox('브랜드확인!','복합매장 대상에 없는 브랜드 입니다!')
				dw_body.reset()
				return 0
			end if

			gs_shop_cd = gs_brand + gs_shop_div + MidA(gs_shop_cd_1,3,4)
			
			if MidA(gs_shop_cd_1,1,2) = 'XX' then
				dw_head.setitem(1,'shop_cd_h',gs_brand + gs_shop_div + MidA(gs_shop_cd,3,4))
				dw_head.setitem(1,'shop_nm_h',gs_shop_nm)
			else
				dw_head.setitem(1,'shop_cd_h',gs_user_id)
				dw_head.setitem(1,'shop_nm_h',gs_shop_nm)
			end if
			Trigger Event ue_retrieve()
	
END CHOOSE

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

type ln_1 from w_com020_e`ln_1 within w_sh209_e
integer beginy = 400
integer endy = 400
end type

type ln_2 from w_com020_e`ln_2 within w_sh209_e
integer beginy = 404
integer endy = 404
end type

type dw_list from w_com020_e`dw_list within w_sh209_e
integer y = 416
integer width = 288
integer height = 1412
string dataobject = "d_sh209_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
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

is_yymmdd = This.GetItemString(row, 'yymmdd') /* DataWindow에 Key 항목을 가져온다 */
is_seq_no = This.GetItemString(row, 'seq_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

il_rows = dw_body.retrieve(is_yymmdd, is_seq_no)
			 dw_detail.retrieve(is_yymmdd, is_seq_no)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event dw_list::constructor;call super::constructor;/*===========================================================================*/
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

type dw_body from w_com020_e`dw_body within w_sh209_e
integer x = 311
integer y = 416
integer width = 2546
integer height = 324
string dataobject = "d_sh209_d02"
end type

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child


This.GetChild("rcv_how", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('791')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.03.21                                                  */	
/* 수정일      : 2002.03.21                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "yymmdd", "want_ymd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "card_no", "jumin", "shop_cd"	,"tel_no3"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

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

type st_1 from w_com020_e`st_1 within w_sh209_e
integer x = 288
integer y = 432
integer width = 23
end type

type dw_print from w_com020_e`dw_print within w_sh209_e
integer x = 1678
integer y = 548
string dataobject = "d_sh209_r01"
end type

type dw_detail from datawindow within w_sh209_e
event ue_keydown pbm_dwnkey
integer x = 311
integer y = 744
integer width = 2546
integer height = 1080
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_sh209_d03"
boolean vscrollbar = true
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

event buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report, ls_yymmdd, ls_judg_fg,ls_seq_no, ls_no, ls_modify
String ls_saup_name, ls_brand, ls_judg_cust_fg, ls_cust_nm
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

event constructor;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child


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

///////////////////////////////////////
/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/

//This.SetRowFocusIndicator(Hand!)

This.GetChild("judg_l", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('795')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '')

This.GetChild("judg_s", idw_judg_s)
idw_judg_s.SetTransObject(SQLCA)
idw_judg_s.InsertRow(0)

This.GetChild("judg_s_nm", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('796')

//This.GetChild("dept_cd", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve()
//ldw_child.InsertRow(1)
//ldw_child.SetItem(1, "dept_cd", '')
//ldw_child.SetItem(1, "dept_nm", '')

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







end event

event editchanged;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
//cb_excel.enabled = false

end event

event itemfocuschanged;/*===========================================================================*/
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
//	cb_excel.enabled = false
End If

CHOOSE CASE dwo.name
	CASE "sale_ymd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "style_no"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	CASE "color"
		This.SetItem(row, "size", "")
//	CASE "judg_fg"
//		if data = "5" then 
//			dw_body.setitem(1, "custom_nm","매장용")
//		
//		elseif data = "4" then 	
//			dw_body.setitem(1, "custom_nm","")	
//		
//		else				
//			dw_body.setitem(1, "custom_nm","")		
//			messagebox("경고!", "매장에서 선택 등록 하능한 판정구분이 아닙니다!")
////			this.setitem(row, "judg_fg", "4")
//			return 1
//		end if	

END CHOOSE

end event

