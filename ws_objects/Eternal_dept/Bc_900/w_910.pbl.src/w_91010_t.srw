$PBExportHeader$w_91010_t.srw
$PBExportComments$매장 등록
forward
global type w_91010_t from w_com010_e
end type
type tab_1 from tab within w_91010_t
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_91010_t
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_empb from u_dw within w_91010_t
end type
type dw_empd from u_dw within w_91010_t
end type
type dw_empl from u_dw within w_91010_t
end type
type dw_custl from u_dw within w_91010_t
end type
type dw_custb from u_dw within w_91010_t
end type
end forward

global type w_91010_t from w_com010_e
event type boolean ue_nullcheck ( string as_cb_div )
tab_1 tab_1
dw_empb dw_empb
dw_empd dw_empd
dw_empl dw_empl
dw_custl dw_custl
dw_custb dw_custb
end type
global w_91010_t w_91010_t

type variables
String is_shop_cd, is_ed_dt, is_pay_way
DateTime id_datetime
Boolean lb_changed

end variables

forward prototypes
public function integer wf_cust_info (string as_cust_cd, ref string as_cust_nm, ref string as_cust_snm, ref string as_saup_no, ref string as_upte, ref string as_jongmok, ref string as_tel_no, ref string as_fax_no, ref string as_cust_zip, ref string as_cust_addr)
public function integer wf_shop_cd (string as_brand, string as_shop_div, ref string as_shop_cd)
public subroutine wf_empb_reset (long al_row, string as_flag)
public function integer wf_emp_info (string as_sale_emp, ref string as_sale_empnm, ref string as_jumn_no, ref string as_cust_cd)
public function integer wf_empb_emp ()
public subroutine wf_body_reset (long al_row, string as_flag)
public function integer wf_custb_cust ()
public function integer wf_empb_cust ()
public function integer wf_body_cust ()
end prototypes

event ue_nullcheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
String ls_null_chk

//IF as_cb_div = '1' THEN
//	ls_title = "조회오류"
//ELSEIF as_cb_div = '2' THEN
//	ls_title = "추가오류"
//ELSEIF as_cb_div = '3' THEN
//	ls_title = "저장오류"
//ELSE
//	ls_title = "오류"
//END IF

IF as_cb_div = '1' THEN				// dw_body의 Null Check
	IF dw_body.AcceptText() <> 1 THEN RETURN FALSE
	
	ls_null_chk = Trim(dw_body.GetItemString(1, "cust_cd"))
	if IsNull(ls_null_chk) or ls_null_chk = "" then
		MessageBox("저장오류","매장의 거래처 코드를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("cust_cd")
		return false
	end if

	ls_null_chk = Trim(dw_body.GetItemString(1, "cust_name"))
	if IsNull(ls_null_chk) or ls_null_chk = "" then
		MessageBox("저장오류","매장의 거래처 명을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("cust_name")
		return false
	end if

	ls_null_chk = Trim(dw_body.GetItemString(1, "cust_sname"))
	if IsNull(ls_null_chk) or ls_null_chk = "" then
		MessageBox("저장오류","매장의 거래처 약칭명을 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("cust_sname")
		return false
	end if

	ls_null_chk = Trim(dw_body.GetItemString(1, "saup_no"))
	if IsNull(ls_null_chk) or ls_null_chk = "" then
		MessageBox("저장오류","매장의 사업자 번호를 입력하십시요!")
		dw_body.SetFocus()
		dw_body.SetColumn("saup_no")
		return false
	end if
ElseIf as_cb_div = '2' THEN		// dw_empb의 Null Check
	IF dw_empb.AcceptText() <> 1 THEN RETURN FALSE
	
	ls_null_chk = Trim(dw_empb.GetItemString(1, "st_dt"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "시작 일자를 입력하십시요!")
		dw_empb.SetColumn("st_dt")
		dw_empb.SetFocus()
		rollback  USING SQLCA;
		Return False
	End If
	
	ls_null_chk = Trim(dw_empb.GetItemString(1, "sale_emp"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "판매 사원 코드를 입력하십시요!")
		dw_empb.SetColumn("sale_emp")
		dw_empb.SetFocus()
		rollback  USING SQLCA;
		Return False
	End If

	ls_null_chk = Trim(dw_empb.GetItemString(1, "emp_cust"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "판매 사원의 거래처 코드를 입력하십시요!")
		dw_empb.SetColumn("emp_cust")
		dw_empb.SetFocus()
		Return False
	End If

	ls_null_chk = Trim(dw_empb.GetItemString(1, "cust_nm"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "판매 사원의 거래처 명을 입력하십시요!")
		dw_empb.SetColumn("cust_nm")
		dw_empb.SetFocus()
		Return False
	End If

	ls_null_chk = Trim(dw_empb.GetItemString(1, "cust_snm"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "판매 사원의 거래처 약칭명을 입력하십시요!")
		dw_empb.SetColumn("cust_snm")
		dw_empb.SetFocus()
		Return False
	End If

	ls_null_chk = Trim(dw_empb.GetItemString(1, "saup_no"))
	If IsNull(ls_null_chk) or ls_null_chk = "" Then
		MessageBox("저장오류", "판매 사원의 사업자 번호를 입력하십시요!")
		dw_empb.SetColumn("saup_no")
		dw_empb.SetFocus()
		Return False
	End If
End IF

return true

end event

public function integer wf_cust_info (string as_cust_cd, ref string as_cust_nm, ref string as_cust_snm, ref string as_saup_no, ref string as_upte, ref string as_jongmok, ref string as_tel_no, ref string as_fax_no, ref string as_cust_zip, ref string as_cust_addr);/* 거래처 정보를 읽어온다 */

  SELECT CUST_NAME,	CUST_SNAME,	SAUP_NO,		UPTE,		JONGMOK,
			TEL_NO,		FAX_NO,		CUST_ZIP,	CUST_ADDR
    INTO :as_cust_nm, :as_cust_snm, :as_saup_no,  :as_upte,     :as_jongmok,
	      :as_tel_no,  :as_fax_no,   :as_cust_zip, :as_cust_addr
    FROM VI_91102_1 
	WHERE CUSTCODE = :as_cust_cd ;
	
Return SQLCA.SQLCODE

end function

public function integer wf_shop_cd (string as_brand, string as_shop_div, ref string as_shop_cd);String ls_shop_seq

/* 새로운 매장 코드를 구해온다 */

  SELECT RIGHT(MAX(SHOP_CD), 4)
    INTO :ls_shop_seq
    FROM TB_91100_M
	WHERE SHOP_CD LIKE :as_brand + :as_shop_div + '%' ;

If ls_shop_seq = '9999' Then 
	MessageBox("경고", "데이터가 포화상태입니다!")
	Return 1
End If

If IsNull(ls_shop_seq) Then ls_shop_seq = '0000'
	
as_shop_cd = as_brand + as_shop_div + String(Long(ls_shop_seq) + 1, '0000')

Return 0

end function

public subroutine wf_empb_reset (long al_row, string as_flag);/* dw_empb의 거래처 관련 column을 리셋 */
/* as_flag ('C':거래처 코드까지 리셋)  */

If as_flag = 'C' Then
	dw_empb.SetItem(al_row, "emp_cust", "")
	dw_empb.SetItem(al_row, "cust_cd", "")
End If
dw_empb.SetItem(al_row, "cust_name", "")
dw_empb.SetItem(al_row, "cust_sname", "")
dw_empb.SetItem(al_row, "saup_no", "")
dw_empb.SetItem(al_row, "upte", "")
dw_empb.SetItem(al_row, "jongmok", "")

end subroutine

public function integer wf_emp_info (string as_sale_emp, ref string as_sale_empnm, ref string as_jumn_no, ref string as_cust_cd);/* 매장 수수료 사원 정보를 읽어온다 */

  SELECT SALE_EMPNM,			JUMN_NO,			CUST_CD
    INTO :as_sale_empnm,	:as_jumn_no,	:as_cust_cd
    FROM TB_91102_M 
	WHERE SALE_EMP = :as_sale_emp ;
	
Return SQLCA.SQLCODE

end function

public function integer wf_empb_emp ();String ls_sale_emp, ls_sale_empnm, ls_jumn_no, ls_cust_cd

ls_sale_emp   = dw_empb.GetItemString(1, "sale_emp")
ls_sale_empnm = dw_empb.GetItemString(1, "sale_empnm")
ls_jumn_no    = dw_empb.GetItemString(1, "jumn_no")
ls_cust_cd    = dw_empb.GetItemString(1, "emp_cust")

  INSERT
    INTO TB_91102_M
	      ( SALE_EMP,			SALE_EMPNM,			JUMN_NO,
			  CUST_CD,			REG_ID )
  VALUES ( :ls_sale_emp,	:ls_sale_empnm,	:ls_jumn_no,
  			  :ls_cust_cd,		:gs_user_id ) ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE TB_91102_M
		  SET SALE_EMPNM = :ls_sale_empnm,	JUMN_NO = :ls_jumn_no,
				CUST_CD    = :ls_cust_cd,		MOD_ID  = :gs_user_id,	MOD_DT = :id_datetime
		WHERE SALE_EMP   = :ls_sale_emp ;
		
	If SQLCA.SQLCODE <> 0 Then Return -1
	
ElseIf SQLCA.SQLCODE <> 0 Then
	Return -2
end if

Return SQLCA.SQLCODE

end function

public subroutine wf_body_reset (long al_row, string as_flag);/* dw_body의 거래처 관련 column을 리셋 */
/* as_flag ('C':거래처 코드까지 리셋)  */
String ls_null



If as_flag = 'C' Then
	dw_body.SetItem(al_row, "cust_cd", "")
End If
dw_body.SetItem(al_row, "cust_name", "")
dw_body.SetItem(al_row, "cust_sname", "")
dw_body.SetItem(al_row, "saup_no", "")
dw_body.SetItem(al_row, "upte", "")
dw_body.SetItem(al_row, "jongmok", "")
dw_body.SetItem(al_row, "tel_no", "")
dw_body.SetItem(al_row, "fax_no", "")
dw_body.SetItem(al_row, "cust_zip", "")
dw_body.SetItem(al_row, "cust_addr", "")

end subroutine

public function integer wf_custb_cust ();String ls_cust_cd
Decimal ldc_grt_amt, ldc_rent_grt, ldc_rent_amt, ldc_inte_amt

ls_cust_cd   = dw_body.GetItemString (1, "cust_cd")
ldc_grt_amt  = dw_custb.GetItemDecimal(1, "grt_amt")
ldc_rent_grt = dw_custb.GetItemDecimal(1, "rent_grt")
ldc_rent_amt = dw_custb.GetItemDecimal(1, "rent_amt")
ldc_inte_amt = dw_custb.GetItemDecimal(1, "inte_amt")

  UPDATE MIS.DBO.TSB04
	  SET GRTM          = ISNULL(:ldc_grt_amt, 0),	RENT_GRTM = ISNULL(:ldc_rent_grt, 0),
	  		MNTH_RENT_AMT = ISNULL(:ldc_rent_amt, 0),	INTE_AMT  = ISNULL(:ldc_inte_amt, 0)
	WHERE CUST_CODE = RIGHT(:ls_cust_cd, 4)
	  AND SHOP_TYPE = SUBSTRING(:ls_cust_cd, 2, 1)
	  AND BRAND     = LEFT(:ls_cust_cd, 1) ;

If SQLCA.SQLCODE <> 0 Then Return -1

Return SQLCA.SQLCODE

end function

public function integer wf_empb_cust ();String ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, ls_bank

ls_cust_cd  = dw_empb.GetItemString(1, "emp_cust")
ls_cust_nm  = dw_empb.GetItemString(1, "cust_nm")
ls_cust_snm = dw_empb.GetItemString(1, "cust_snm")
ls_saup_no  = dw_empb.GetItemString(1, "saup_no")
ls_upte     = dw_empb.GetItemString(1, "upte")
ls_jongmok  = dw_empb.GetItemString(1, "jongmok")
ls_bank     = dw_empb.GetItemString(1, "bank")

  INSERT
    INTO MIS.DBO.TSB04
	      ( CUST_CODE,					SHOP_TYPE,							BRAND,
			  CUSTCODE, 					CUST_NAME, 							CUST_SNAME,
			  SAUP_NO, 						UPTE, 								JONGMOK,
			  BANK,							UID,									IDATE )
  VALUES ( RIGHT(:ls_cust_cd, 4),	SUBSTRING(:ls_cust_cd, 2, 1),	LEFT(:ls_cust_cd, 1),
  			  :ls_cust_cd, 				:ls_cust_nm, 						:ls_cust_snm,
			  :ls_saup_no, 				:ls_upte, 							:ls_jongmok,
			  :ls_bank,						:gs_user_id,						CONVERT(VARCHAR(10), :id_datetime, 102) ) ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE MIS.DBO.TSB04
		  SET CUSTCODE = :ls_cust_cd,	CUST_NAME = :ls_cust_nm,	CUST_SNAME = :ls_cust_snm,
				SAUP_NO  = :ls_saup_no,	UPTE      = :ls_upte,		JONGMOK    = :ls_jongmok,
				BANK     = :ls_bank,		UID       = :gs_user_id,	IDATE      = CONVERT(VARCHAR(10), :id_datetime, 102)
		WHERE CUST_CODE = RIGHT(:ls_cust_cd, 4)
		  AND SHOP_TYPE = SUBSTRING(:ls_cust_cd, 2, 1)
		  AND BRAND     = LEFT(:ls_cust_cd, 1) ;
		  
	If SQLCA.SQLCODE <> 0 Then Return -1
	
ElseIf SQLCA.SQLCODE <> 0 Then
	Return -2
end if

Return SQLCA.SQLCODE

end function

public function integer wf_body_cust ();String ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok
String ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_shop_div
String ls_ownr_nm, ls_ownr_idno, ls_area_cd, ls_appv_cond, ls_empno
String ls_shop_class, ls_shop_stat, ls_open_ymd, ls_chg_ymd
String ls_vat_way, ls_amt_fg			//, ls_sugm_dd1, ls_sugm_dd2, ls_sugm_mm1, ls_sugm_mm2

ls_cust_cd    = dw_body.GetItemString(1, "cust_cd")
ls_cust_nm    = dw_body.GetItemString(1, "cust_name")
ls_cust_snm   = dw_body.GetItemString(1, "cust_sname")
ls_saup_no    = dw_body.GetItemString(1, "saup_no")
ls_upte       = dw_body.GetItemString(1, "upte")
ls_jongmok    = dw_body.GetItemString(1, "jongmok")
ls_tel_no     = dw_body.GetItemString(1, "tel_no")
ls_fax_no     = dw_body.GetItemString(1, "fax_no")
ls_cust_zip   = dw_body.GetItemString(1, "cust_zip")
ls_cust_addr  = dw_body.GetItemString(1, "cust_addr")
ls_shop_div   = dw_body.GetItemString(1, "shop_div")
ls_ownr_nm    = dw_body.GetItemString(1, "owner_nm")
ls_ownr_idno  = dw_body.GetItemString(1, "ownr_idno")
ls_area_cd    = dw_body.GetItemString(1, "area_cd")
ls_appv_cond  = dw_body.GetItemString(1, "appv_cond")
ls_empno      = dw_body.GetItemString(1, "empno")
ls_shop_class = dw_body.GetItemString(1, "shop_class")
ls_shop_stat  = dw_body.GetItemString(1, "shop_stat")
ls_open_ymd   = dw_body.GetItemString(1, "open_ymd")
ls_chg_ymd    = dw_body.GetItemString(1, "change_date")
//ls_sugm_mm1  = dw_body.GetItemString(1, "sugm_mm1")
//ls_sugm_mm2  = dw_body.GetItemString(1, "sugm_mm2")
//ls_sugm_dd1   = dw_body.GetItemString(1, "sugm_dd1")
//ls_sugm_dd2   = dw_body.GetItemString(1, "sugm_dd2")
ls_vat_way    = dw_body.GetItemString(1, "vat_way")
ls_amt_fg     = dw_body.GetItemString(1, "amt_fg")

  INSERT
    INTO MIS.DBO.TSB04
	      ( CUST_CODE,					SHOP_TYPE,							BRAND,
			  CUSTCODE, 					CUST_NAME, 							CUST_SNAME,
			  SAUP_NO, 						UPTE, 								JONGMOK, 
			  TEL_NO, 						FAX_NO, 								CUST_ZIP, 
			  CUST_ADDR,					OWNR_NAME,							OWNR_IDNO,
			  APPV_COND,					AREA_CODE,							EMPNO,
			  SHOP_CLASS,					CHANGE_GUBN,						CHANGE_DATE,
			  OPEN_DATE,					CLOSE_DATE,
			  VAT_WAY,						AMT_GUBN,							SHOP_GUBN,
			  UID,							IDATE )
  VALUES ( RIGHT(:ls_cust_cd, 4),	SUBSTRING(:ls_cust_cd, 2, 1),	LEFT(:ls_cust_cd, 1),
  			  :ls_cust_cd, 				:ls_cust_nm, 						:ls_cust_snm,
			  :ls_saup_no, 				:ls_upte, 							:ls_jongmok,
			  :ls_tel_no, 					:ls_fax_no, 						:ls_cust_zip, 
			  :ls_cust_addr,				:ls_ownr_nm,						:ls_ownr_idno,
			  :ls_appv_cond,				:ls_area_cd,						:ls_empno,
			  :ls_shop_class,				:ls_shop_stat,						:ls_chg_ymd, 
			  :ls_open_ymd,				(CASE LEFT(:ls_shop_stat, 1) WHEN '1' THEN :ls_chg_ymd ELSE '' END),
			  :ls_vat_way,					:ls_amt_fg,							(CASE :ls_shop_div
			  																			WHEN 'A' THEN '01' 
			  																			WHEN 'G' THEN '02' 
			  																			WHEN 'K' THEN '03' 
			  																			WHEN 'T' THEN '04' 
			  																			WHEN 'Z' THEN '05' 
																						ELSE '' END),
			  :gs_user_id,					CONVERT(VARCHAR(10), :id_datetime, 102) ) ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE MIS.DBO.TSB04
		  SET CUSTCODE   = :ls_cust_cd,		CUST_NAME   = :ls_cust_nm,		CUST_SNAME  = :ls_cust_snm,
				SAUP_NO    = :ls_saup_no,		UPTE        = :ls_upte,			JONGMOK     = :ls_jongmok,
				TEL_NO     = :ls_tel_no,		FAX_NO      = :ls_fax_no,		CUST_ZIP    = :ls_cust_zip, 
				CUST_ADDR  = :ls_cust_addr,	OWNR_NAME   = :ls_ownr_nm,		OWNR_IDNO   = :ls_ownr_idno,
				APPV_COND  = :ls_appv_cond,	AREA_CODE   = :ls_area_cd,		EMPNO       = :ls_empno,
				SHOP_CLASS = :ls_shop_class,	CHANGE_GUBN = :ls_shop_stat,	CHANGE_DATE = :ls_chg_ymd,
				OPEN_DATE  = :ls_open_ymd,		CLOSE_DATE  = (CASE LEFT(:ls_shop_stat, 1) WHEN '1' THEN :ls_chg_ymd ELSE '' END),
				VAT_WAY    = :ls_vat_way,		AMT_GUBN    = :ls_amt_fg,		SHOP_GUBN   = (CASE :ls_shop_div
			  																									  WHEN 'A' THEN '01' 
			  																									  WHEN 'G' THEN '02' 
									  																			  WHEN 'K' THEN '03' 
			  																									  WHEN 'T' THEN '04' 
			  																									  WHEN 'Z' THEN '05' 
																												  ELSE '' END),
				UID        = :gs_user_id,		IDATE       = CONVERT(VARCHAR(10), :id_datetime, 102)
		WHERE CUST_CODE = RIGHT(:ls_cust_cd, 4)
		  AND SHOP_TYPE = SUBSTRING(:ls_cust_cd, 2, 1)
		  AND BRAND     = LEFT(:ls_cust_cd, 1) ;

	If SQLCA.SQLCODE <> 0 Then Return -1

ElseIf SQLCA.SQLCODE <> 0 Then 
	Return -2
end if

Return SQLCA.SQLCODE

end function

on w_91010_t.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_empb=create dw_empb
this.dw_empd=create dw_empd
this.dw_empl=create dw_empl
this.dw_custl=create dw_custl
this.dw_custb=create dw_custb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_empb
this.Control[iCurrent+3]=this.dw_empd
this.Control[iCurrent+4]=this.dw_empl
this.Control[iCurrent+5]=this.dw_custl
this.Control[iCurrent+6]=this.dw_custb
end on

on w_91010_t.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_empb)
destroy(this.dw_empd)
destroy(this.dw_empl)
destroy(this.dw_custl)
destroy(this.dw_custb)
end on

event pfc_preopen;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택) 												  */	
/* 작성일      : 2001.11.04																  */	
/* 수정일      : 1999.11.04																  */
/*===========================================================================*/

of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")

/* Data window Resize */
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_custl, "ScaleToBottom")
inv_resize.of_Register(dw_custb, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_empl, "ScaleToBottom")
inv_resize.of_Register(dw_empb, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_empd, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_body.SetTransObject(SQLCA)
dw_custl.SetTransObject(SQLCA)
dw_custb.SetTransObject(SQLCA)
dw_empl.SetTransObject(SQLCA)
dw_empb.SetTransObject(SQLCA)
dw_empd.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

end event

event ue_popup;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/* 비  고      : dw_head와 dw_body용                                         */
/*===========================================================================*/
String     ls_shop_cd, ls_shop_nm, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok
String     ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr
String     ls_sale_empnm, ls_jumn_no, ls_cust_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd"
		IF ai_div = 1 THEN 	
			IF gf_shop_nm(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 코드 검색" 
		gst_cd.datawindow_nm   = "d_com912" 
		gst_cd.default_where   = ""		//WHERE SHOP_STAT = '00' 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " SHOP_CD LIKE '" + as_data + "%' "
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
			dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			dw_head.SetColumn("end_ymd")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
		
	CASE "cust_cd"
		ls_shop_cd = Trim(dw_body.GetItemString(al_row, "shop_cd"))
		If IsNull(ls_shop_cd) or LenA(ls_shop_cd) <> 6 Then
			MessageBox("입력오류", "브랜드와 유통망을 먼저 입력하십시요!")
			wf_body_reset(al_row, 'C')
			dw_body.SetColumn("brand")
			Return 1
		End If
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				wf_body_reset(al_row, 'C')
				RETURN 0
			END IF 
			If LenA(as_data) = 6 Then
				If LeftA(ls_shop_cd, 1) <> LeftA(as_data, 1) or RightA(ls_shop_cd, 4) <> RightA(as_data, 4) Then
					MessageBox("입력오류", "매장코드와 거래처코드의 앞의 1자리와 뒤의 4자리가 같아야합니다!")
					Return 1
				End If
			End If
			IF wf_cust_info(as_data, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
			                ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr) = 0 THEN
				dw_body.SetItem(al_row, "cust_name", ls_cust_nm)
				dw_body.SetItem(al_row, "cust_sname", ls_cust_snm)
				dw_body.SetItem(al_row, "saup_no", ls_saup_no)
				dw_body.SetItem(al_row, "upte", ls_upte)
				dw_body.SetItem(al_row, "jongmok", ls_jongmok)
				dw_body.SetItem(al_row, "tel_no", ls_tel_no)
				dw_body.SetItem(al_row, "fax_no", ls_fax_no)
				dw_body.SetItem(al_row, "cust_zip", ls_cust_zip)
				dw_body.SetItem(al_row, "cust_addr", ls_cust_addr)
				RETURN 0
			ElseIf LenA(as_data) = 6 Then
				wf_body_reset(al_row, 'N')
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "거래처 코드 검색" 
		gst_cd.datawindow_nm   = "d_com911" 
		gst_cd.default_where   = " WHERE BRAND     = ~'" + LeftA(ls_shop_cd, 1)  + "~' " + &
										 "   AND CUST_CODE = ~'" + RightA(ls_shop_cd, 4) + "~' " 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%' "
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_body.SetRow(al_row)
			dw_body.SetColumn(as_column)
			dw_body.SetItem(al_row, "cust_cd", lds_Source.GetItemString(1,"custcode"))
			dw_body.SetItem(al_row, "cust_name", lds_Source.GetItemString(1,"cust_name"))
			dw_body.SetItem(al_row, "cust_sname", lds_Source.GetItemString(1,"cust_sname"))
			dw_body.SetItem(al_row, "saup_no", lds_Source.GetItemString(1,"saup_no"))
			dw_body.SetItem(al_row, "upte", lds_Source.GetItemString(1,"upte"))
			dw_body.SetItem(al_row, "jongmok", lds_Source.GetItemString(1,"jongmok"))
			dw_body.SetItem(al_row, "tel_no", lds_Source.GetItemString(1,"tel_no"))
			dw_body.SetItem(al_row, "fax_no", lds_Source.GetItemString(1,"fax_no"))
			dw_body.SetItem(al_row, "cust_zip", lds_Source.GetItemString(1,"cust_zip"))
			dw_body.SetItem(al_row, "cust_addr", lds_Source.GetItemString(1,"cust_addr"))
			/* 다음컬럼으로 이동 */
			dw_body.SetColumn("cust_name")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
		
	CASE "empno"
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				dw_body.SetItem(al_row, "emp_nm", "")
				RETURN 0
			END IF 
			IF gf_emp_nm(as_data, ls_shop_nm) = 0 THEN
				dw_body.SetItem(al_row, "emp_nm", ls_shop_nm)
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "사원 코드 검색" 
		gst_cd.datawindow_nm   = "d_com931" 
		gst_cd.default_where   = " WHERE EMP_YN = 'Y' "
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " PERSON_ID LIKE '" + as_data + "%' "
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_body.SetRow(al_row)
			dw_body.SetColumn(as_column)
			dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"person_id"))
			dw_body.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"person_nm"))
			/* 다음컬럼으로 이동 */
			dw_body.SetColumn("open_ymd")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
	CASE "sale_emp"
		IF ai_div = 1 THEN 	
			If IsNull(as_data) or Trim(as_data) = "" Then
				dw_empb.SetItem(al_row, "sale_empnm", "")
				RETURN 0
			END IF 
			IF wf_emp_info(as_data, ls_sale_empnm, ls_jumn_no, ls_cust_cd) = 0 THEN
				dw_empb.SetItem(al_row, "sale_empnm", ls_sale_empnm)
				dw_empb.SetItem(al_row, "jumn_no", ls_jumn_no)
				If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then
					If wf_cust_info(ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
										 ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr) = 0 Then
						dw_empb.SetItem(al_row, "emp_cust", ls_cust_cd)
						dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
						dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
						dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
						dw_empb.SetItem(al_row, "upte", ls_upte)
						dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
					Else
						wf_empb_reset(al_row, 'C')
					End If
				Else
					wf_empb_reset(al_row, 'C')
				End If
				RETURN 0
			ElseIf LenA(as_data) = 6 Then
				dw_empb.SetItem(al_row, "sale_empnm", "")
				dw_empb.SetItem(al_row, "jumn_no", "")
				wf_empb_reset(al_row, 'C')
				Return 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "매장 수수료 사원 코드 검색" 
		gst_cd.datawindow_nm   = "d_com914" 
		gst_cd.default_where   = ""		//WHERE SHOP_STAT = '00' 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " SALE_EMP LIKE '" + as_data + "%' "
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_empb.SetRow(al_row)
			dw_empb.SetColumn(as_column)
			dw_empb.SetItem(al_row, "sale_emp", lds_Source.GetItemString(1,"sale_emp"))
			dw_empb.SetItem(al_row, "sale_empnm", lds_Source.GetItemString(1,"sale_empnm"))
			dw_empb.SetItem(al_row, "jumn_no", lds_Source.GetItemString(1,"jumn_no"))
			ls_cust_cd = lds_Source.GetItemString(1,"cust_cd")
			
			If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then
				If wf_cust_info(ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
									 ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr) = 0 Then
					dw_empb.SetItem(al_row, "emp_cust", ls_cust_cd)
					dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
					dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
					dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
					dw_empb.SetItem(al_row, "upte", ls_upte)
					dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
				Else
					wf_empb_reset(al_row, 'C')
				End If
			Else
				wf_empb_reset(al_row, 'C')
			End If
			/* 다음컬럼으로 이동 */
			dw_empb.SetColumn("jumn_no")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
	CASE "emp_cust"
		ls_shop_cd = Trim(dw_empb.GetItemString(al_row, "sale_emp"))
		If IsNull(ls_shop_cd) or LenA(ls_shop_cd) <> 6 Then
			MessageBox("입력오류", "판매 사원 코드를 먼저 입력하십시요!")
			wf_empb_reset(al_row, 'C')
			Return 1
		End If
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				wf_empb_reset(al_row, 'C')
				RETURN 0
			END IF 
			If LenA(as_data) = 6 Then
				If LeftA(ls_shop_cd, 1) <> LeftA(as_data, 1) or RightA(ls_shop_cd, 4) <> RightA(as_data, 4) Then
					MessageBox("입력오류", "매장코드와 거래처코드의 앞의 1자리와 뒤의 4자리가 같아야합니다!")
					Return 1
				End If
			End If
			IF wf_cust_info(as_data, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
			                ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr) = 0 THEN
//				dw_empb.SetItem(al_row, "emp_cust", as_data)
				dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
				dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
				dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
				dw_empb.SetItem(al_row, "upte", ls_upte)
				dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
				RETURN 0
			ElseIf LenA(as_data) = 6 Then
				wf_empb_reset(al_row, 'N')
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "거래처 코드 검색" 
		gst_cd.datawindow_nm   = "d_com911" 
		gst_cd.default_where   = " WHERE BRAND     = ~'" + LeftA(ls_shop_cd, 1)  + "~' " + &
										 "   AND CUST_CODE = ~'" + RightA(ls_shop_cd, 4) + "~' " 
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%' "
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_empb.SetRow(al_row)
			dw_empb.SetColumn(as_column)
			dw_empb.SetItem(al_row, "emp_cust", lds_Source.GetItemString(1,"custcode"))
			dw_empb.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_name"))
			dw_empb.SetItem(al_row, "cust_snm", lds_Source.GetItemString(1,"cust_sname"))
			dw_empb.SetItem(al_row, "saup_no", lds_Source.GetItemString(1,"saup_no"))
			dw_empb.SetItem(al_row, "upte", lds_Source.GetItemString(1,"upte"))
			dw_empb.SetItem(al_row, "jongmok", lds_Source.GetItemString(1,"jongmok"))
			/* 다음컬럼으로 이동 */
			dw_empb.SetColumn("cust_nm")
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
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
Long ll_rows
String ls_ed_dt, ls_pay_way

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_shop_cd)
			 dw_custl.Retrieve(is_shop_cd)
ll_rows = dw_custb.Retrieve(is_shop_cd)

IF il_rows > 0 THEN
	If ll_rows = 0 Then dw_custb.InsertRow(0)
END IF

ll_rows = dw_empl.Retrieve(is_shop_cd)
dw_empb.Reset()
dw_empd.DataObject = 'd_91010_d06'
dw_empd.SetTransObject(SQLCA)

dw_body.SetFocus()

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_keycheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
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

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd"))
if IsNull(is_shop_cd) or is_shop_cd = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

return true

end event

event ue_insert;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/

if dw_body.AcceptText() <> 1 then return

/* 변경된 자료가 있을때 저장여부를 확인*/
IF ib_changed THEN 
   CHOOSE CASE gf_update_yn(This.title)
	   CASE 1
		   IF This.Trigger Event ue_update() < 1 THEN
			   return
		   END IF		
	   CASE 3
		   return
   END CHOOSE
END IF

ib_changed = false
lb_changed = false
cb_update.enabled = false

dw_head.Reset()
dw_body.Reset()
dw_custl.Reset()
dw_custb.Reset()
dw_empl.Reset()
dw_empb.Reset()
dw_empd.DataObject = 'd_91010_d06'
dw_empd.SetTransObject(SQLCA)

dw_head.InsertRow(0)
il_rows = dw_body.InsertRow(0)
dw_custl.InsertRow(0)
dw_custb.InsertRow(0)

dw_body.SetItem(1, "shop_stat", '00')
dw_body.SetItem(1, "area_cd",   '99')
dw_body.SetItem(1, "vat_way",   '2')
dw_body.SetItem(1, "amt_fg",    '2')

dw_custl.SetItem(1, "vat_way",  '2')
dw_custl.SetItem(1, "amt_fg",   '2')

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.27                                                  */	
/* 수정일      : 2001.12.27                                                  */
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
         dw_custl.Enabled = true
         dw_custb.Enabled  = true
         dw_empl.Enabled  = true
         dw_empb.Enabled  = true
         dw_empd.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
			lb_changed = false
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
				dw_body.Enabled = true
				dw_custl.Enabled = true
				dw_custb.Enabled  = true
				dw_empl.Enabled  = true
				dw_empb.Enabled  = true
				dw_empd.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			lb_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
			cb_excel.enabled = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> New! and idw_status <> NewModified! then
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
      lb_changed = false
      dw_body.Enabled = false
		dw_custl.Enabled = false
		dw_custb.Enabled  = false
		dw_empl.Enabled  = false
		dw_empb.Enabled  = false
		dw_empd.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
dwItemStatus ldw_status_empb
long         i, ll_row_count, ll_rows_custb, ll_rows_empb, ll_rows_empd, ll_cur_row
Integer      li_chk
String       ls_shop_stat

IF dw_body.AcceptText()  <> 1 THEN RETURN -1
IF dw_custl.AcceptText() <> 1 THEN RETURN -1
IF dw_custb.AcceptText() <> 1 THEN RETURN -1
IF dw_empl.AcceptText()  <> 1 THEN RETURN -1
IF dw_empb.AcceptText()  <> 1 THEN RETURN -1
IF dw_empd.AcceptText()  <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(id_datetime) = FALSE THEN
	Return 0
END IF

// dw_custl가 변경되었으면 dw_custl의 data를 dw_body에 셋팅
idw_status = dw_custl.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! or idw_status = DataModified! THEN
	dw_body.SetItem(1, "sugm_mm1",   dw_custl.GetItemString(1, "sugm_mm1"))
	dw_body.SetItem(1, "sugm_dd1",   dw_custl.GetItemString(1, "sugm_dd1"))
	dw_body.SetItem(1, "sugm_rate1", dw_custl.GetItemDecimal(1, "sugm_rate1"))
	dw_body.SetItem(1, "sugm_mm2",   dw_custl.GetItemString(1, "sugm_mm2"))
	dw_body.SetItem(1, "sugm_dd2",   dw_custl.GetItemString(1, "sugm_dd2"))
	dw_body.SetItem(1, "sugm_rate2", dw_custl.GetItemDecimal(1, "sugm_rate2"))
	dw_body.SetItem(1, "slip_ymd",   dw_custl.GetItemString(1, "slip_ymd"))
	dw_body.SetItem(1, "vat_way",    dw_custl.GetItemString(1, "vat_way"))
	dw_body.SetItem(1, "amt_fg",     dw_custl.GetItemString(1, "amt_fg"))
	dw_body.SetItem(1, "pos_yn",     dw_custl.GetItemString(1, "pos_yn"))
End If

// dw_body 저장
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */

	// dw_body의 거래처 코드 Null Check
	IF Trigger Event ue_nullcheck('1') = FALSE THEN RETURN -1
	
	// 매장의 거래처 코드 내역을 거래처 마스터에 셋팅
	li_chk = wf_body_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(매장MASTER) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "거래처 마스터(매장MASTER) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if

	ls_shop_stat = dw_body.GetItemString(1, "shop_stat")
	If LeftA(ls_shop_stat, 1) = '1' Then 
		dw_body.SetItem(1, "close_ymd", dw_body.GetItemString(1, "change_date") )
	Else
		dw_body.SetItem(1, "close_ymd", "" )
	End If
	dw_body.SetItem(1, "shop_seq", RightA(is_shop_cd, 4))
	dw_body.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */

	// dw_body의 거래처 코드 Null Check
	IF Trigger Event ue_nullcheck('1') = FALSE THEN RETURN -1
	
	// 매장의 거래처 코드 내역을 거래처 마스터에 셋팅
	li_chk = wf_body_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(매장MASTER) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "거래처 마스터(매장MASTER) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if

	ls_shop_stat = dw_body.GetItemString(1, "shop_stat")
	If LeftA(ls_shop_stat, 1) = '1' Then 
		dw_body.SetItem(1, "close_ymd", dw_body.GetItemString(1, "change_date") )
	Else
		dw_body.SetItem(1, "close_ymd", "" )
	End If
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", id_datetime)
END IF

il_rows = dw_body.Update(TRUE, FALSE)

// dw_custb 저장
idw_status = dw_custb.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */

	// 매장의 거래처 코드 내역을 거래처 DETAIL에 셋팅
	li_chk = wf_custb_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(매장DETAIL) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if
	dw_custb.Setitem(1, "shop_cd", is_shop_cd)
	dw_custb.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */

	// 매장의 거래처 코드 내역을 거래처 DETAIL에 셋팅
	li_chk = wf_custb_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(매장DETAIL) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if
	dw_custb.Setitem(1, "mod_id", gs_user_id)
	dw_custb.Setitem(1, "mod_dt", id_datetime)
END IF

ll_rows_custb = dw_custb.Update(TRUE, FALSE)

// dw_empb 저장
idw_status = dw_empb.GetItemStatus(1, 0, Primary!)
ldw_status_empb = idw_status
IF idw_status = NewModified! THEN				/* New Record */
	// dw_empb의 거래처 코드 Null Check
	IF Trigger Event ue_nullcheck('2') = FALSE THEN RETURN -1

	// 판매 사원 코드 내역을 판매 사원 마스터에 셋팅
	li_chk = wf_empb_emp()
	If li_chk = -1 Then
		MessageBox("저장오류", "판매 사원 마스터 UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "판매 사원 마스터 INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if
	
	// 판매 사원의 거래처 코드 내역을 거래처 마스터에 셋팅
	li_chk = wf_empb_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(판매 사원) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "거래처 마스터(판매 사원) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if
	
	is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
	If IsNull(is_ed_dt) or is_ed_dt = "" Then 
		is_ed_dt = '99999999'
	End If
	dw_empb.SetItem(1, "ed_dt", is_ed_dt)
	dw_empb.Setitem(1, "shop_cd", is_shop_cd)
	dw_empb.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
	// dw_empb의 거래처 코드 Null Check
	IF Trigger Event ue_nullcheck('2') = FALSE THEN RETURN -1
	
	// 판매 사원 코드 내역을 판매 사원 마스터에 셋팅
	li_chk = wf_empb_emp()
	If li_chk = -1 Then
		MessageBox("저장오류", "판매 사원 마스터 UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "판매 사원 마스터 INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if

	// 판매 사원의 거래처 코드 내역을 거래처 마스터에 셋팅
	li_chk = wf_empb_cust()
	If li_chk = -1 Then
		MessageBox("저장오류", "거래처 마스터(판매 사원) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	ElseIf li_chk = -2 Then
		MessageBox("저장오류", "거래처 마스터(판매 사원) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	end if
	
	is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
	If IsNull(is_ed_dt) or is_ed_dt = "" Then 
		is_ed_dt = '99999999'
	End If
	
	dw_empb.SetItem(1, "ed_dt", is_ed_dt)
	dw_empb.Setitem(1, "mod_id", gs_user_id)
	dw_empb.Setitem(1, "mod_dt", id_datetime)
	// dw_empd에 변경사항 셋팅
	ll_row_count = dw_empd.RowCount()
	
	For i = 1 to ll_row_count
		dw_empd.SetItem(i, "ed_dt", is_ed_dt)
		dw_empd.Setitem(i, "sale_emp", dw_empb.GetItemString(1, "sale_emp"))
	Next
END IF

ll_rows_empb = dw_empb.Update(TRUE, FALSE)

// dw_empd 저장
ll_row_count = dw_empd.RowCount()

For i = 1 to ll_row_count
	dw_empd.SetItem(i, "seq_no", i)
	idw_status = dw_empd.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
		is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
		If IsNull(is_ed_dt) or is_ed_dt = "" Then 
			is_ed_dt = '99999999'
		End If
		dw_empd.SetItem(i, "ed_dt", is_ed_dt)
		dw_empd.Setitem(i, "shop_cd", is_shop_cd)
		dw_empd.Setitem(i, "pay_way", dw_empb.GetItemString(1, "pay_way"))
		dw_empd.Setitem(i, "sale_emp", dw_empb.GetItemString(1, "sale_emp"))
		dw_empd.Setitem(i, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_empd.Setitem(i, "mod_id", gs_user_id)
		dw_empd.Setitem(i, "mod_dt", id_datetime)
	END IF
Next

ll_rows_empd = dw_empd.Update(TRUE, FALSE)

if il_rows = 1 and ll_rows_custb = 1 and ll_rows_empb = 1 and ll_rows_empd = 1 then
   dw_body.ResetUpdate()
   dw_custb.ResetUpdate()
   dw_empb.ResetUpdate()
   dw_empd.ResetUpdate()
   commit  USING SQLCA;

	/* dw_empl에 추가되거나 수정된 내용를 반영 */  
	if il_rows = 1 and ll_rows_custb = 1 and ll_rows_empb = 1 and ll_rows_empd = 1 then
		IF ldw_status_empb = NewModified! THEN
			ll_cur_row = dw_empl.GetSelectedRow(0)+1
			dw_empl.InsertRow(ll_cur_row)
			dw_empl.Setitem(ll_cur_row, "ed_dt", dw_empb.GetItemString(1, "ed_dt"))
			dw_empl.Setitem(ll_cur_row, "sale_emp", dw_empb.GetItemString(1, "sale_emp"))
			dw_empl.Setitem(ll_cur_row, "sale_empnm", dw_empb.GetItemString(1, "sale_empnm"))
			dw_empl.SelectRow(0, FALSE)
			dw_empl.SelectRow(ll_cur_row, TRUE)
			dw_empl.SetRow(ll_cur_row)
		ELSEIF ldw_status_empb = DataModified! THEN
			ll_cur_row = dw_empl.GetSelectedRow(0)
			dw_empl.Setitem(ll_cur_row, "ed_dt", dw_empb.GetItemString(1, "ed_dt"))
			dw_empl.Setitem(ll_cur_row, "sale_emp", dw_empb.GetItemString(1, "sale_emp"))
			dw_empl.Setitem(ll_cur_row, "sale_empnm", dw_empb.GetItemString(1, "sale_empnm"))
		END IF
	END IF
	
	This.Trigger Event ue_button(3, 1)
	This.Trigger Event ue_msg(3, 1)
	return 1
else
   rollback  USING SQLCA;
	This.Trigger Event ue_button(3, -1)
	This.Trigger Event ue_msg(3, -1)
	return -1
end if


end event

event pfc_postopen;call super::pfc_postopen;dw_head.SetColumn("shop_cd")
dw_head.SetFocus()

end event

type cb_close from w_com010_e`cb_close within w_91010_t
integer taborder = 160
end type

type cb_delete from w_com010_e`cb_delete within w_91010_t
boolean visible = false
integer taborder = 100
end type

type cb_insert from w_com010_e`cb_insert within w_91010_t
integer taborder = 90
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91010_t
end type

type cb_update from w_com010_e`cb_update within w_91010_t
integer taborder = 140
end type

type cb_print from w_com010_e`cb_print within w_91010_t
boolean visible = false
integer taborder = 110
end type

type cb_preview from w_com010_e`cb_preview within w_91010_t
boolean visible = false
integer taborder = 120
end type

type gb_button from w_com010_e`gb_button within w_91010_t
end type

type cb_excel from w_com010_e`cb_excel within w_91010_t
boolean visible = false
integer taborder = 130
end type

type dw_head from w_com010_e`dw_head within w_91010_t
integer height = 128
string dataobject = "d_91010_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_91010_t
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_e`ln_2 within w_91010_t
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_e`dw_body within w_91010_t
integer y = 348
integer height = 688
string dataobject = "d_91010_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

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

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('001')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')

This.GetChild("upte", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('914')

This.GetChild("jongmok", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('915')

This.GetChild("area_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('090')

This.GetChild("appv_cond", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('923')

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')

This.GetChild("shop_class", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('922')

This.GetChild("shop_stat", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('913')

end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
String ls_shop_chk

CHOOSE CASE dwo.name
	CASE "brand" 
		ls_shop_chk = This.GetItemString(row, "shop_div")

		If IsNull(ls_shop_chk) or Trim(ls_shop_chk) = "" Then Return 0
		If wf_shop_cd(data, ls_shop_chk, is_shop_cd) <> 0 Then Return 1
		
		This.SetItem(row, "shop_cd", is_shop_cd)
		wf_body_reset(row, 'C')
	CASE "shop_div" 
		ls_shop_chk = This.GetItemString(row, "brand")
		
		If IsNull(ls_shop_chk) or Trim(ls_shop_chk) = "" Then Return 0
		If wf_shop_cd(ls_shop_chk, data, is_shop_cd) <> 0 Then Return 1

		This.SetItem(row, "shop_cd", is_shop_cd)
		wf_body_reset(row, 'C')
	CASE "open_ymd", "change_date"
		If gf_datechk(data) = False Then Return 1
	CASE "cust_cd", "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_91010_t
end type

type tab_1 from tab within w_91010_t
integer x = 5
integer y = 1040
integer width = 3589
integer height = 1008
integer taborder = 150
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;/* tabpage가 바뀔때 보이는 datawindow를 변경*/
If newindex = 1 Then
	dw_custl.Visible = True
	dw_custb.Visible = True
	dw_empl.Visible = False
	dw_empb.Visible = False
	dw_empd.Visible = False
	dw_custl.SetColumn("sugm_mmfg")
	dw_custl.SetFocus()
Else
	dw_custl.Visible = False
	dw_custb.Visible = False
	dw_empl.Visible = True
	dw_empb.Visible = True
	dw_empd.Visible = True
	dw_empl.SetFocus()
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 896
long backcolor = 79741120
string text = "거래처내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3552
integer height = 896
long backcolor = 79741120
string text = "사원내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_empb from u_dw within w_91010_t
event ue_keydown pbm_dwnkey
integer x = 919
integer y = 1140
integer width = 2656
integer height = 892
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_91010_d05"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
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

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

This.GetChild("upte", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('914')

This.GetChild("jongmok", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('915')

This.GetChild("comm_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('919')

This.GetChild("pay_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('920')

This.GetChild("bank", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('921')

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28																  */	
/* 수정일      : 2001.12.28																  */
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

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28                                                  */	
/* 수정일      : 2001.12.28                                                  */
/*===========================================================================*/
ib_changed = true
lb_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_rows

ib_changed = true
lb_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "st_dt", "end_date"
		If gf_datechk(data) = False Then Return 1
	CASE "pay_way"
		is_pay_way = data
		If data = '1' Then 
			dw_empd.DataObject = 'd_91010_d06'
		ElseIf data = '2' Then
			dw_empd.DataObject = 'd_91010_d07'
		End If
		dw_empd.SetTransObject(SQLCA)
		
		is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
		If IsNull(is_ed_dt) or is_ed_dt = "" Then 
			is_ed_dt = '99999999'
		End If
		
		ll_rows = dw_empd.Retrieve(is_shop_cd, is_ed_dt, is_pay_way)
		If ll_rows = 0 Then
			dw_empd.InsertRow(0)
		End IF
		
	CASE "sale_emp", "emp_cust"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
long   ll_cur_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

Choose Case ls_column_nm
	Case "insert_row"
		if dw_empb.AcceptText() <> 1 then return
		
		/* 변경된 자료가 있을때 저장여부를 확인*/
		IF lb_changed THEN 
			CHOOSE CASE gf_update_yn(This.title)
				CASE 1
					IF Parent.Trigger Event ue_update() < 1 THEN
						return
					ELSE
						ib_changed = false
						lb_changed = false
						cb_update.enabled = false
					END IF		
				CASE 3
					return
			END CHOOSE
		END IF
		
		lb_changed = false
		If ib_changed = False Then cb_update.enabled = false

		dw_empb.Reset()
		dw_empd.Reset()
		
		il_rows = dw_empb.InsertRow(0)
		is_pay_way = '1'
		dw_empb.SetItem(il_rows, "pay_way", is_pay_way)
		dw_empd.DataObject = 'd_91010_d06'
		dw_empd.SetTransObject(SQLCA)
//		dw_empd.Reset()
		dw_empd.InsertRow(0)
		
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			dw_empb.ScrollToRow(il_rows)
			dw_empb.SetColumn("st_dt")
			dw_empb.SetFocus()
		end if
		
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
		
		Parent.Trigger Event ue_msg(2, il_rows)
		Return
	Case "delete_row"
		ll_cur_row = dw_empb.GetRow()
		
		if ll_cur_row <= 0 then return
		
		idw_status = dw_empb.GetItemStatus (ll_cur_row, 0, primary!)	
		
		if idw_status <> new! and idw_status <> newmodified! then
			// 지급방법에 대한 수수료 내역 삭제
			  DELETE 
				 FROM TB_91104_H
				WHERE SHOP_CD = :is_shop_cd
				  AND ED_DT = :is_ed_dt ;
	
			If SQLCA.SQLCODE <> 0 Then
				MessageBox("삭제오류", "지급방법에 대한 수수료 내역을 삭제 하는데 실패했습니다!")
			   rollback  USING SQLCA;
				Return
			End If
			ib_changed = true
			lb_changed = true
			cb_update.enabled = true
		end if

		il_rows = dw_empb.DeleteRow (ll_cur_row)

		if il_rows = 1 then
			cb_print.enabled = false
			cb_preview.enabled = false
			cb_excel.enabled = false
			
			dw_empd.DataObject = 'd_91010_d06'
			dw_empd.SetTransObject(SQLCA)
		end if

		dw_empb.SetFocus()
		
		Parent.Trigger Event ue_msg(4, il_rows)
		Return
End Choose

ls_report = This.Describe(ls_column_nm + ".Protect")
IF ls_report = "1" THEN RETURN 
ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
IF This.Describe("Evaluate(~"" + ls_report + "~", " + String(row) + ")") = '1' THEN RETURN 

IF row = This.GetRow() AND ls_column_nm = This.GetColumnName() THEN
	ls_column_value = This.GetText()
ELSE
	ls_column_value = This.GetItemString(row, ls_column_nm)
END IF

Parent.Trigger Event ue_popup (ls_column_nm, row, ls_column_value, 2)

end event

type dw_empd from u_dw within w_91010_t
event ue_keydown pbm_dwnkey
integer x = 2053
integer y = 1400
integer width = 1504
integer height = 620
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_91010_d06"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_keydown;/*===========================================================================*/
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

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28																  */	
/* 수정일      : 2001.12.28																  */
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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28                                                  */	
/* 수정일      : 2001.12.28                                                  */
/*===========================================================================*/
ib_changed = true
lb_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
lb_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
long   ll_cur_row

Choose Case dwo.name
	Case "cb_insert_row"
		if dw_empd.AcceptText() <> 1 then return
		
		il_rows = dw_empd.InsertRow(0)
		
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			dw_empd.ScrollToRow(il_rows)
			dw_empd.SetColumn("COMM_RATE1")
			dw_empd.SetFocus()
		end if
		
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
		Parent.Trigger Event ue_msg(2, il_rows)
	Case "cb_delete_row"
		ll_cur_row = dw_empd.GetRow()
		
		if ll_cur_row <= 0 then return
		
		idw_status = dw_empd.GetItemStatus (ll_cur_row, 0, primary!)	
		
		il_rows = dw_empd.DeleteRow (ll_cur_row)
		dw_empd.SetFocus()
		
		if il_rows = 1 then
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            lb_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
		end if
		Parent.Trigger Event ue_msg(4, il_rows)
End Choose

end event

type dw_empl from u_dw within w_91010_t
integer x = 23
integer y = 1140
integer width = 891
integer height = 892
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_91010_d04"
end type

event constructor;call super::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28																  */	
/* 수정일      : 2001.12.28																  */
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

event clicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
Long ll_rows

IF row <= 0 THEN Return

IF lb_changed THEN 
  	CHOOSE CASE gf_update_yn(Parent.title)
		CASE 1
			IF Parent.Trigger Event ue_update() < 1 THEN
				RETURN
			ELSE
				ib_changed = false
				lb_changed = false
				cb_update.enabled = false
			END IF		
		CASE 3
			RETURN
	END CHOOSE
END IF

lb_changed = false
If ib_changed = false Then cb_update.enabled = false

This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

is_ed_dt = This.GetItemString(row, 'ed_dt') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_ed_dt) THEN return
il_rows = dw_empb.retrieve(is_shop_cd, is_ed_dt)
dw_empd.Reset()

If il_rows >= 1 Then
	is_pay_way = Trim(dw_empb.GetItemString(1, "pay_way"))
	If IsNull(is_pay_way) = False and is_pay_way <> "" Then
		If is_pay_way = '1' Then
			dw_empd.DataObject = 'd_91010_d06'
		ElseIf is_pay_way = '2' Then
			dw_empd.DataObject = 'd_91010_d07'
		End If
		dw_empd.SetTransObject(SQLCA)
	
		ll_rows = dw_empd.retrieve(is_shop_cd, is_ed_dt, is_pay_way)
		If ll_rows = 0 Then dw_empd.InsertRow(0)
	End If
End If

Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_custl from u_dw within w_91010_t
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 1140
integer width = 1851
integer height = 892
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_91010_d02"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
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

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
DataWindowChild ldw_child

This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

This.GetChild("sugm_mm1", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('916')

This.GetChild("sugm_mm2", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('916')

This.GetChild("vat_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('917')

This.GetChild("amt_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('918')

end event

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28                                                  */	
/* 수정일      : 2001.12.28                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name
	CASE "slip_ymd" 
		If gf_datechk(data) = False Then Return 1
END CHOOSE

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28																  */	
/* 수정일      : 2001.12.28																  */
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

type dw_custb from u_dw within w_91010_t
event ue_keydown pbm_dwnkey
integer x = 1879
integer y = 1140
integer width = 1696
integer height = 892
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_91010_d03"
boolean vscrollbar = false
boolean livescroll = false
end type

event ue_keydown;/*===========================================================================*/
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

event constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28																  */	
/* 수정일      : 2001.12.28																  */
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

event editchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.28                                                  */	
/* 수정일      : 2001.12.28                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event itemerror;return 1
end event

event itemfocuschanged;/*===========================================================================*/
/* 작성자      : (주) 지우정보 (김 태범)                                     */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
String ls_column_nm,  ls_tag, ls_helpMsg

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)

This.SelectText(1, 3000)

//CHOOSE CASE ls_column_name
//	CASE "cust_cd"
//		ls_helpMsg = "▶ ※ 거래처 코드를 입력하세요! "
//	CASE ELSE
//		ls_helpMsg = " "
//END CHOOSE
//
//Parent.SetMicroHelp(ls_helpMsg)

end event

