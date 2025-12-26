$PBExportHeader$w_91010_e.srw
$PBExportComments$매장 등록
forward
global type w_91010_e from w_com010_e
end type
type tab_1 from tab within w_91010_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_1 from tab within w_91010_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_empb from u_dw within w_91010_e
end type
type dw_empd from u_dw within w_91010_e
end type
type dw_list from u_dw within w_91010_e
end type
type dw_custl from u_dw within w_91010_e
end type
type dw_custb from u_dw within w_91010_e
end type
end forward

global type w_91010_e from w_com010_e
integer width = 3698
integer height = 2288
event type boolean ue_nullcheck ( string as_cb_div )
tab_1 tab_1
dw_empb dw_empb
dw_empd dw_empd
dw_list dw_list
dw_custl dw_custl
dw_custb dw_custb
end type
global w_91010_e w_91010_e

type variables
DataWindowChild idw_brand, idw_shop_div, idw_shop_stat

String is_brand, is_shop_cd, is_empno, is_ed_dt, is_pay_way, is_shop_div, is_shop_stat
DateTime id_datetime
Boolean lb_changed

end variables

forward prototypes
public function integer wf_emp_info (string as_sale_emp, ref string as_sale_empnm, ref string as_jumn_no, ref string as_cust_cd)
public function integer wf_shop_cd (string as_brand, string as_shop_div, ref string as_shop_cd)
public function integer wf_cust_info (string as_cust_cd, ref string as_cust_nm, ref string as_cust_snm, ref string as_saup_no, ref string as_upte, ref string as_jongmok, ref string as_tel_no, ref string as_fax_no, ref string as_cust_zip, ref string as_cust_addr, ref string as_bank_cd)
public subroutine wf_empb_reset (long al_row, string as_flag)
public function integer wf_empb_emp ()
public function integer wf_custb_cust ()
public subroutine wf_body_reset (long al_row, string as_flag)
public subroutine wf_body_set ()
public function integer wf_empb_cust ()
public function integer wf_body_update ()
public function integer wf_custb_update ()
public function integer wf_empb_update ()
public subroutine wf_empd_update ()
public function integer wf_body_cust ()
end prototypes

event ue_nullcheck;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
String ls_null_chk

Choose Case as_cb_div
	Case '1'
//		ls_null_chk = Trim(dw_body.GetItemString(1, "cust_name"))
//		if IsNull(ls_null_chk) or ls_null_chk = "" then
//			MessageBox("저장오류","매장의 거래처 명을 입력하십시요!")
//			dw_body.SetFocus()
//			dw_body.SetColumn("cust_name")
//			return false
//		end if
//	
//		ls_null_chk = Trim(dw_body.GetItemString(1, "cust_sname"))
//		if IsNull(ls_null_chk) or ls_null_chk = "" then
//			MessageBox("저장오류","매장의 거래처 약칭명을 입력하십시요!")
//			dw_body.SetFocus()
//			dw_body.SetColumn("cust_sname")
//			return false
//		end if
	
		ls_null_chk = Trim(dw_body.GetItemString(1, "saup_no"))
		if IsNull(ls_null_chk) or ls_null_chk = "" then
			MessageBox("저장오류","매장의 사업자 번호를 입력하십시요!")
			dw_body.SetFocus()
			dw_body.SetColumn("saup_no")
			return false
		end if
	Case '2'
		ls_null_chk = Trim(dw_empb.GetItemString(1, "st_dt"))
		If IsNull(ls_null_chk) or ls_null_chk = "" Then
			MessageBox("저장오류", "시작 일자를 입력하십시요!")
			dw_empb.SetColumn("st_dt")
			dw_empb.SetFocus()
			rollback  USING SQLCA;
			Return False
		End If
	Case '3'
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
End Choose

return true

end event

public function integer wf_emp_info (string as_sale_emp, ref string as_sale_empnm, ref string as_jumn_no, ref string as_cust_cd);/* 매장 수수료 사원 정보를 읽어온다 */

  SELECT SALE_EMPNM,			JUMN_NO,			CUST_CD
    INTO :as_sale_empnm,	:as_jumn_no,	:as_cust_cd
    FROM TB_91102_M 
	WHERE SALE_EMP = :as_sale_emp ;
	
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

public function integer wf_cust_info (string as_cust_cd, ref string as_cust_nm, ref string as_cust_snm, ref string as_saup_no, ref string as_upte, ref string as_jongmok, ref string as_tel_no, ref string as_fax_no, ref string as_cust_zip, ref string as_cust_addr, ref string as_bank_cd);/* 거래처 정보를 읽어온다 */

  SELECT CUST_NAME,	CUST_SNAME,	SAUP_NO,		UPTE,		JONGMOK,
			TEL_NO,		FAX_NO,		CUST_ZIP,	CUST_ADDR,		BANK
    INTO :as_cust_nm, :as_cust_snm, :as_saup_no,  :as_upte,        :as_jongmok,
	      :as_tel_no,  :as_fax_no,   :as_cust_zip, :as_cust_addr,   :as_bank_cd
    FROM VI_91102_1 
	WHERE CUSTCODE = :as_cust_cd ;
	
Return SQLCA.SQLCODE

end function

public subroutine wf_empb_reset (long al_row, string as_flag);/* dw_empb의 거래처 관련 column을 리셋 */
/* as_flag ('C':거래처 코드까지 리셋)  */

If as_flag = 'C' Then
	dw_empb.SetItem(al_row, "emp_cust", "")
	dw_empb.SetItem(al_row, "cust_cd", "")
End If
dw_empb.SetItem(al_row, "cust_nm", "")
dw_empb.SetItem(al_row, "cust_snm", "")
dw_empb.SetItem(al_row, "saup_no", "")
dw_empb.SetItem(al_row, "upte", "")
dw_empb.SetItem(al_row, "jongmok", "")
dw_empb.SetItem(al_row, "bank", "")

end subroutine

public function integer wf_empb_emp ();String ls_sale_emp, ls_sale_empnm, ls_jumn_no, ls_cust_cd, LS_BANK, LS_BANK_CODE
STRING ls_zip_code, ls_addr, ls_note
ls_sale_emp   = dw_empb.GetItemString(1, "sale_emp")
ls_sale_empnm = dw_empb.GetItemString(1, "sale_empnm")
ls_jumn_no    = dw_empb.GetItemString(1, "jumn_no")
ls_cust_cd    = dw_empb.GetItemString(1, "emp_cust")
ls_BANK       = dw_empb.GetItemString(1, "BANK")
ls_BANK_CODE  = dw_empb.GetItemString(1, "BANK_CODE")
ls_zip_code   = dw_empb.GetItemString(1, "zip_code")
ls_addr       = dw_empb.GetItemString(1, "addr")
ls_note		  = dw_empb.GetItemString(1, "note")	

  INSERT
    INTO TB_91102_M
	      ( SALE_EMP,			SALE_EMPNM,			JUMN_NO,
			  CUST_CD,			BANK,					BANK_CODE,			
			  ZIP_CODE,		 	ADDR, 				NOTE,
			   REG_ID )
  VALUES ( :ls_sale_emp,	:ls_sale_empnm,	:ls_jumn_no,
  			  :ls_cust_cd,		:ls_bank,			:ls_bank_code,		
			  :ls_zip_code,   :ls_addr,	 		:ls_note,
			  :gs_user_id )  ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE TB_91102_M
		  SET SALE_EMPNM = :ls_sale_empnm,	JUMN_NO = :ls_jumn_no,
				CUST_CD    = :ls_cust_cd,		bank	  = :ls_bank, 			bank_code = :ls_bank_code,
				zip_code   = :ls_zip_code,	   addr    = :ls_addr,			note      = :ls_note,
				MOD_ID  = :gs_user_id,	MOD_DT = :id_datetime
		WHERE SALE_EMP   = :ls_sale_emp
	  ;
		
	If SQLCA.SQLCODE <> 0 Then Return -1
	
ElseIf SQLCA.SQLCODE <> 0 Then
	Return -2
end if

Return SQLCA.SQLCODE

end function

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
dw_body.SetItem(al_row, "remark", "")
dw_custl.SetItem(al_row, "bank_cd", "")

end subroutine

public subroutine wf_body_set ();String ls_value, ls_sugm_mm1, ls_sugm_dd1, ls_sugm_mm2, ls_sugm_dd2, ls_sugm_ymd
decimal ldc_sugm_rate1, ldc_sugm_rate2 

// dw_custl가 변경되었으면 dw_custl의 data를 dw_body에 셋팅
idw_status = dw_custl.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! or idw_status = DataModified! THEN
	
	ls_value = dw_custl.GetItemString (1, "sugm_ymd")
	ls_sugm_ymd = dw_custl.GetItemString (1, "sugm_ymd")	
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "tb_91100_m_sugm_ymd", ls_value)
	Else
		dw_body.SetItem(1, "tb_91100_m_sugm_ymd",   String(Long(ls_value), '00'))
	End If
	
	ls_value = dw_custl.GetItemString (1, "sugm_mm1")
	ls_sugm_mm1 = dw_custl.GetItemString (1, "sugm_mm1")	
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "sugm_mm1", ls_value)
	Else
		dw_body.SetItem(1, "sugm_mm1",   String(Long(ls_value), '00'))
	End If
	
	ls_value = dw_custl.GetItemString (1, "sugm_dd1")
	ls_sugm_dd1 = dw_custl.GetItemString (1, "sugm_dd1")	
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "sugm_dd1", ls_value)
	Else
		dw_body.SetItem(1, "sugm_dd1",   String(Long(ls_value), '00'))
	End If
	
	ls_value = dw_custl.GetItemString (1, "sugm_mm2")
	ls_sugm_mm2 = dw_custl.GetItemString (1, "sugm_mm2")	
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "sugm_mm2", ls_value)
	Else
		dw_body.SetItem(1, "sugm_mm2",   String(Long(ls_value), '00'))
	End If
	
	ls_value = dw_custl.GetItemString (1, "sugm_dd2")
	ls_sugm_dd2 = dw_custl.GetItemString (1, "sugm_dd2")	
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "sugm_dd2", ls_value)
	Else
		dw_body.SetItem(1, "sugm_dd2",   String(Long(ls_value), '00'))
	End If
	
	ls_value = dw_custl.GetItemString (1, "slip_dd")
	If IsNull(ls_value) or Trim(ls_value) = "" Then
		dw_body.SetItem(1, "slip_dd", ls_value)
	Else
		dw_body.SetItem(1, "slip_dd",   String(Long(ls_value), '00'))
	End If
	
	
	
	ls_sugm_ymd = dw_custl.GetItemString (1, "sugm_ymd")	
	ls_sugm_mm1 = dw_custl.GetItemString (1, "sugm_mm1")	
	ls_sugm_dd1 = dw_custl.GetItemString (1, "sugm_dd1")	
	ls_sugm_mm2 = dw_custl.GetItemString (1, "sugm_mm2")		
	ls_sugm_dd2 = dw_custl.GetItemString (1, "sugm_dd2")		
   ldc_sugm_rate1 =	dw_custl.GetItemDecimal(1, "sugm_rate1")
   ldc_sugm_rate2 =	dw_custl.GetItemDecimal(1, "sugm_rate2")	
	
	dw_body.SetItem(1, "sugm_rate1", dw_custl.GetItemDecimal(1, "sugm_rate1"))
	dw_body.SetItem(1, "sugm_rate2", dw_custl.GetItemDecimal(1, "sugm_rate2"))
	dw_body.SetItem(1, "vat_way",    dw_custl.GetItemString (1, "vat_way"))
	dw_body.SetItem(1, "amt_fg",     dw_custl.GetItemString (1, "amt_fg"))
	dw_body.SetItem(1, "bank_cd",    dw_custl.GetItemString (1, "bank_cd"))
	dw_body.SetItem(1, "pos_yn",     dw_custl.GetItemString (1, "pos_yn"))
	
	 DECLARE sp_56041_update PROCEDURE FOR sp_56041_update  
         @shop_cd = :is_shop_cd,   
         @start_ymd = :ls_sugm_ymd,   
         @SUGM_MM1 = :ls_sugm_mm1,   
         @SUGM_DD1 = :ls_sugm_dd1,   
         @SUGM_RATE1 = :ldc_sugm_rate1,   
         @SUGM_MM2 = :ls_sugm_mm2,   
         @SUGM_DD2 = :ls_sugm_dd2,   
         @SUGM_RATE2 = :ldc_sugm_rate2  ;

   execute sp_56041_update;
   commit  USING SQLCA; 
	
End If

end subroutine

public function integer wf_empb_cust ();String ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, ls_bank
String ls_sale_empnm, ls_addr

ls_cust_cd  = dw_empb.GetItemString(1, "emp_cust")
ls_cust_nm  = dw_empb.GetItemString(1, "cust_nm")
ls_cust_snm = dw_empb.GetItemString(1, "cust_snm")
ls_saup_no  = dw_empb.GetItemString(1, "saup_no")
ls_upte     = dw_empb.GetItemString(1, "upte")
ls_jongmok  = dw_empb.GetItemString(1, "jongmok")
ls_bank     = dw_empb.GetItemString(1, "bank")
ls_sale_empnm = dw_empb.GetItemString(1, "sale_empnm")
ls_addr     = dw_empb.GetItemString(1, "cust_addr")

  INSERT
    INTO MIS.DBO.TSB04
	      ( CUST_CODE,					SHOP_TYPE,							BRAND,
			  CUSTCODE, 					CUST_NAME, 							CUST_SNAME,
			  SAUP_NO, 						UPTE, 								JONGMOK,
  			  OWNR_NAME,
			  BANK,							UID,									IDATE,
			  cust_addr)
  VALUES ( RIGHT(:ls_cust_cd, 4),	SUBSTRING(:ls_cust_cd, 2, 1),	LEFT(:ls_cust_cd, 1),
  			  :ls_cust_cd, 				:ls_cust_nm, 						:ls_cust_snm,
			  :ls_saup_no, 				:ls_upte, 							:ls_jongmok,
			  :ls_sale_empnm,
			  :ls_bank,						:gs_user_id,						CONVERT(VARCHAR(10), :id_datetime, 102),
			  :ls_addr) ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE MIS.DBO.TSB04
		  SET CUSTCODE = :ls_cust_cd,	CUST_NAME = :ls_cust_nm,	CUST_SNAME = :ls_cust_snm,
		      OWNR_NAME = :ls_sale_empnm,
				SAUP_NO  = :ls_saup_no,	UPTE      = :ls_upte,		JONGMOK    = :ls_jongmok,
				BANK     = :ls_bank,		UID       = :gs_user_id,	IDATE      = CONVERT(VARCHAR(10), :id_datetime, 102),
				cust_addr = :ls_addr
		WHERE CUST_CODE = RIGHT(:ls_cust_cd, 4)
		  AND SHOP_TYPE = SUBSTRING(:ls_cust_cd, 2, 1)
		  AND BRAND     = LEFT(:ls_cust_cd, 1) ;
		  
	If SQLCA.SQLCODE <> 0 Then Return -3
	
ElseIf SQLCA.SQLCODE <> 0 Then
	Return -4
end if

Return SQLCA.SQLCODE

end function

public function integer wf_body_update ();Integer li_chk
String ls_cust_cd, ls_shop_stat


// 거래처 마스터 
// dw_body 저장
idw_status = dw_body.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */

	ls_cust_cd = dw_body.GetItemString(1, "cust_cd")						// 거래처 코드가 있는지 체크
	If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then		// 거래처 코드가 있으면
		IF Trigger Event ue_nullcheck('1') = FALSE THEN RETURN -3		// 거래처 코드 내역 Null Check
		li_chk = wf_body_cust()														// 거래처 코드 내역을 거래처 마스터에 셋팅
		If li_chk < 0 Then Return li_chk
	End If

	ls_shop_stat = dw_body.GetItemString(1, "shop_stat")
	If LeftA(ls_shop_stat, 1) <> '1' Then 
//		dw_body.SetItem(1, "close_ymd", dw_body.GetItemString(1, "change_date") )
//	Else
		dw_body.SetItem(1, "close_ymd", "" )
	End If
	dw_body.SetItem(1, "shop_seq", RightA(is_shop_cd, 4))
	dw_body.Setitem(1, "reg_id", gs_user_id)
	dw_body.Setitem(1, "reg_dt", id_datetime)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */

	ls_cust_cd = dw_body.GetItemString(1, "cust_cd")						// 거래처 코드가 있는지 체크
	If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then		// 거래처 코드가 있으면
		IF Trigger Event ue_nullcheck('1') = FALSE THEN RETURN -3		// 거래처 코드 내역 Null Check
		li_chk = wf_body_cust()														// 거래처 코드 내역을 거래처 마스터에 셋팅
		If li_chk < 0 Then Return li_chk
	End If

	ls_shop_stat = dw_body.GetItemString(1, "shop_stat")
	If LeftA(ls_shop_stat, 1) <> '1' Then 
//		dw_body.SetItem(1, "close_ymd", dw_body.GetItemString(1, "change_date") )
//	Else
		dw_body.SetItem(1, "close_ymd", "" )
	End If
	dw_body.SetItem(1, "shop_seq", RightA(is_shop_cd, 4))
	dw_body.Setitem(1, "mod_id", gs_user_id)
	dw_body.Setitem(1, "mod_dt", id_datetime)
END IF




Return 0

end function

public function integer wf_custb_update ();// dw_custb 저장
Long li_chk
String ls_cust_cd

idw_status = dw_custb.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */

	// 매장의 거래처 코드 내역을 거래처 DETAIL에 셋팅
	ls_cust_cd = dw_body.GetItemString(1, "cust_cd")
	If IsNull(ls_cust_cd) = False And Trim(ls_cust_cd) <> "" Then
		li_chk = wf_custb_cust()
		If li_chk < 0 Then Return li_chk
	End If
	
	dw_custb.Setitem(1, "shop_cd", is_shop_cd)
	dw_custb.Setitem(1, "reg_id", gs_user_id)
	dw_custb.Setitem(1, "reg_dt", id_datetime)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */

	// 매장의 거래처 코드 내역을 거래처 DETAIL에 셋팅
	ls_cust_cd = dw_body.GetItemString(1, "cust_cd")
	If IsNull(ls_cust_cd) = False And Trim(ls_cust_cd) <> "" Then
		li_chk = wf_custb_cust()
		If li_chk < 0 Then Return li_chk
	End If
	
	dw_custb.Setitem(1, "mod_id", gs_user_id)
	dw_custb.Setitem(1, "mod_dt", id_datetime)
END IF

Return 0

end function

public function integer wf_empb_update ();// dw_empb 저장
Integer li_chk
Long ll_row_count, i
String ls_sale_emp, ls_cust_cd, ls_st_dt
DwItemStatus ldw_status_empb

idw_status = dw_empb.GetItemStatus(1, 0, Primary!)
ldw_status_empb = idw_status

ls_st_dt = Trim(dw_empb.GetItemString(1, "st_dt"))

IF idw_status = NewModified! and isnull(ls_st_dt) = false THEN				/* New Record */

	ls_sale_emp = dw_empb.GetItemString(1, "sale_emp")						// 판매사원 코드가 있는지 체크
	If IsNull(ls_sale_emp) = False and Trim(ls_sale_emp) <> "" Then	// 판매사원 코드가 있으면
		IF Trigger Event ue_nullcheck('2') = FALSE THEN RETURN -5		// 판매사원 코드 내역 Null Check
		li_chk = wf_empb_emp()														// 판매사원 코드 내역을 판매사원 마스터에 셋팅
		If li_chk < 0 Then Return li_chk
		
		ls_cust_cd = dw_empb.GetItemString(1, "cust_cd")						// 판매사원 거래처코드가 있는지 체크
		If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then		// 판매사원 거래처코드가 있으면
			IF Trigger Event ue_nullcheck('3') = FALSE THEN RETURN -5		// 판매사원 거래처코드 내역 Null Check
			li_chk = wf_empb_cust()														// 판매사원 거래처코드 내역을 거래처 마스터에 셋팅
			If li_chk < 0 Then Return li_chk
		End If
	End If

//	is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
//	If IsNull(is_ed_dt) or is_ed_dt = "" Then 
//		is_ed_dt = '99999999'
//	End If
	dw_empb.SetItem(1, "ed_dt", '99999999')//is_ed_dt)
	dw_empb.Setitem(1, "shop_cd", is_shop_cd)
	dw_empb.Setitem(1, "brand", LeftA(is_shop_cd, 1))
	dw_empb.Setitem(1, "shop_div", MidA(is_shop_cd, 2, 1))
	dw_empb.Setitem(1, "reg_id", gs_user_id)
	dw_empb.Setitem(1, "reg_dt", id_datetime)
	
ELSEIF idw_status = DataModified! THEN		/* Modify Record */

	ls_sale_emp = dw_empb.GetItemString(1, "sale_emp")						// 판매사원 코드가 있는지 체크
	If IsNull(ls_sale_emp) = False and Trim(ls_sale_emp) <> "" Then	// 판매사원 코드가 있으면
		IF Trigger Event ue_nullcheck('2') = FALSE THEN RETURN -5		// 판매사원 코드 내역 Null Check
		li_chk = wf_empb_emp()														// 판매사원 코드 내역을 판매사원 마스터에 셋팅
		If li_chk < 0 Then Return li_chk
		
		ls_cust_cd = dw_empb.GetItemString(1, "emp_cust")						// 판매사원 거래처코드가 있는지 체크
		If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then		// 판매사원 거래처코드가 있으면
			IF Trigger Event ue_nullcheck('3') = FALSE THEN RETURN -5		// 판매사원 거래처코드 내역 Null Check
			li_chk = wf_empb_cust()														// 판매사원 거래처코드 내역을 거래처 마스터에 셋팅
			If li_chk < 0 Then Return li_chk
		End If
	End If
	
	ls_st_dt = Trim(dw_empb.GetItemString(1, "st_dt"))
	
	// 적용일 이후 자료 삭제
	DELETE 
	  FROM TB_91103_H
	 WHERE SHOP_CD = :is_shop_cd
	   AND ST_DT >= :ls_st_dt
	;
	DELETE 
	  FROM TB_91104_H
	 WHERE SHOP_CD = :is_shop_cd
	   AND ST_DT >= :ls_st_dt
	;
	
	// 적용일 이전 자료 ED_DT 적용일 이전 날짜로 셋팅
	UPDATE TB_91103_H
	   SET ED_DT = CONVERT(VARCHAR(8), DATEADD(DD, -1, CAST(:ls_st_dt AS DATETIME)), 112)
	 WHERE SHOP_CD = :is_shop_cd
	   AND ED_DT = ( SELECT MAX(ED_DT)
							 FROM TB_91103_H
							WHERE SHOP_CD = :is_shop_cd )
	;
	UPDATE TB_91104_H
	   SET ED_DT = CONVERT(VARCHAR(8), DATEADD(DD, -1, CAST(:ls_st_dt AS DATETIME)), 112)
	 WHERE SHOP_CD = :is_shop_cd
	   AND ED_DT = ( SELECT MAX(ED_DT)
							 FROM TB_91104_H
							WHERE SHOP_CD = :is_shop_cd )
	;
	
//	is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
//	If IsNull(is_ed_dt) or is_ed_dt = "" Then 
//		is_ed_dt = '99999999'
//	End If
	
//	dw_empb.SetItem(1, "ed_dt", '99999999')
	dw_empb.Setitem(1, "mod_id", gs_user_id)
	dw_empb.Setitem(1, "mod_dt", id_datetime)
	
	dw_empb.SetItemStatus(1, 0, primary!, NewModified!)
	
	For i = 1 to dw_empd.RowCount()
		dw_empd.SetItemStatus(i, 0, primary!, NewModified!)
	Next
END IF

Return 0

end function

public subroutine wf_empd_update ();// dw_empd 저장
Long ll_row_count, i

ll_row_count = dw_empd.RowCount()

For i = 1 to ll_row_count
	dw_empd.SetItem(i, "seq_no", i)
	idw_status = dw_empd.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
//		is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
//		If IsNull(is_ed_dt) or is_ed_dt = "" Then 
//			is_ed_dt = '99999999'
//		End If
		dw_empd.SetItem(i, "ed_dt",    '99999999')//is_ed_dt)
		dw_empd.Setitem(i, "shop_cd",  is_shop_cd)
		dw_empd.Setitem(i, "pay_way",  is_pay_way)
		If is_pay_way = '2' Then
			dw_empd.Setitem(i, "comm_rate1",  dw_empd.GetItemDecimal(i, "comm_rate1") * 1000)
			dw_empd.Setitem(i, "comm_rate2",  dw_empd.GetItemDecimal(i, "comm_rate2") * 1000)
			dw_empd.Setitem(i, "comm_rate4",  dw_empd.GetItemDecimal(i, "comm_rate4") * 1000)
		End If
		dw_empd.Setitem(i, "st_dt",    dw_empb.GetItemString(1, "st_dt"))
		dw_empd.Setitem(i, "sale_emp", dw_empb.GetItemString(1, "sale_emp"))
		dw_empd.Setitem(i, "brand",    LeftA(is_shop_cd, 1))
		dw_empd.Setitem(i, "shop_div", MidA(is_shop_cd, 2, 1))
		dw_empd.Setitem(i, "reg_id",   gs_user_id)
		dw_empd.Setitem(i, "reg_dt", id_datetime)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		If is_pay_way = '2' Then
			dw_empd.Setitem(i, "comm_rate1",  dw_empd.GetItemDecimal(i, "comm_rate1") * 1000)
			dw_empd.Setitem(i, "comm_rate2",  dw_empd.GetItemDecimal(i, "comm_rate2") * 1000)
			dw_empd.Setitem(i, "comm_rate4",  dw_empd.GetItemDecimal(i, "comm_rate4") * 1000)
		End If
		dw_empd.Setitem(i, "mod_id", gs_user_id)
		dw_empd.Setitem(i, "mod_dt", id_datetime)
	END IF
Next

end subroutine

public function integer wf_body_cust ();String ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok
String ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_shop_div
String ls_ownr_nm, ls_ownr_idno, ls_area_cd, ls_empno
String ls_shop_class, ls_shop_stat, ls_open_ymd, ls_chg_ymd
String ls_vat_way, ls_amt_fg, ls_bank_cd, ls_temp, ls_remark

ls_cust_cd    = dw_body.GetItemString(1, "cust_cd")
ls_cust_nm    = dw_body.GetItemString(1, "shop_nm")
ls_cust_snm   = dw_body.GetItemString(1, "shop_snm")
//ls_cust_nm    = dw_body.GetItemString(1, "cust_name")
//ls_cust_snm   = dw_body.GetItemString(1, "cust_sname")
ls_temp = dw_body.GetItemString(1, "saup_no")
if LenA(ls_temp) = 10  then
	ls_saup_no    = MidA(dw_body.GetItemString(1, "saup_no"),1,3) + '-' + &
						 MidA(dw_body.GetItemString(1, "saup_no"),4,2) + '-' + & 
						 MidA(dw_body.GetItemString(1, "saup_no"),6,5) 
else						 
	ls_saup_no  = 	dw_body.GetItemString(1, "saup_no")
end if


		
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
ls_empno      = dw_body.GetItemString(1, "empno")
ls_shop_class = dw_body.GetItemString(1, "shop_class")
ls_shop_stat  = dw_body.GetItemString(1, "shop_stat")
ls_open_ymd   = String(dw_body.GetItemString(1, "open_ymd"),    '@@@@.@@.@@')
ls_chg_ymd    = String(dw_body.GetItemString(1, "change_date"), '@@@@.@@.@@')
ls_vat_way    = dw_body.GetItemString(1, "vat_way")
ls_amt_fg     = dw_body.GetItemString(1, "amt_fg")
ls_bank_cd    = dw_body.GetItemString(1, "bank_cd")
ls_remark	  = dw_body.GetItemString(1, "remark")

  INSERT
    INTO MIS.DBO.TSB04
	      ( CUST_CODE,					SHOP_TYPE,							BRAND,
			  CUSTCODE, 					CUST_NAME, 							CUST_SNAME,
			  SAUP_NO, 						UPTE, 								JONGMOK, 
			  TEL_NO, 						FAX_NO, 								CUST_ZIP, 
			  CUST_ADDR,					OWNR_NAME,							OWNR_IDNO,
			  AREA_CODE,					EMPNO,
			  SHOP_CLASS,					CHANGE_GUBN,						CHANGE_DATE,
			  OPEN_DATE,					CLOSE_DATE,
			  VAT_WAY,						AMT_GUBN,							SHOP_GUBN,
			  BANK,							UID,							IDATE, remark )
  VALUES ( RIGHT(:ls_cust_cd, 4),	SUBSTRING(:ls_cust_cd, 2, 1),	LEFT(:ls_cust_cd, 1),
  			  :ls_cust_cd, 				:ls_cust_nm, 						:ls_cust_snm,
			  :ls_saup_no, 				:ls_upte, 							:ls_jongmok,
			  :ls_tel_no, 					:ls_fax_no, 						:ls_cust_zip, 
			  :ls_cust_addr,				:ls_ownr_nm,						:ls_ownr_idno,
			  :ls_area_cd,					:ls_empno,
			  :ls_shop_class,				:ls_shop_stat,						:ls_chg_ymd, 
			  :ls_open_ymd,				(CASE LEFT(:ls_shop_stat, 1) WHEN '1' THEN :ls_chg_ymd ELSE NULL END),
			  :ls_vat_way,					:ls_amt_fg,							(CASE :ls_shop_div
			  																			WHEN 'A' THEN '01' 
			  																			WHEN 'G' THEN '02' 
			  																			WHEN 'K' THEN '03' 
			  																			WHEN 'T' THEN '04' 
			  																			WHEN 'Z' THEN '05' 
																						ELSE '' END),
			  :ls_bank_cd,					:gs_user_id,						CONVERT(VARCHAR(10), :id_datetime, 102) ,
			  :ls_remark 
		   ) ;

If SQLCA.SQLCODE = -1 Then
	  UPDATE MIS.DBO.TSB04
		  SET CUSTCODE   = :ls_cust_cd,		CUST_NAME   = :ls_cust_nm,		CUST_SNAME  = :ls_cust_snm,
				SAUP_NO    = :ls_saup_no,		UPTE        = :ls_upte,			JONGMOK     = :ls_jongmok,
				TEL_NO     = :ls_tel_no,		FAX_NO      = :ls_fax_no,		CUST_ZIP    = :ls_cust_zip, 
				CUST_ADDR  = :ls_cust_addr,	OWNR_NAME   = :ls_ownr_nm,		OWNR_IDNO   = :ls_ownr_idno,
				AREA_CODE   = :ls_area_cd,		EMPNO       = :ls_empno,
				SHOP_CLASS = :ls_shop_class,	CHANGE_GUBN = :ls_shop_stat,	CHANGE_DATE = :ls_chg_ymd,
				OPEN_DATE  = :ls_open_ymd,		CLOSE_DATE  = (CASE LEFT(:ls_shop_stat, 1) WHEN '1' THEN :ls_chg_ymd ELSE NULL END),
				VAT_WAY    = :ls_vat_way,		AMT_GUBN    = :ls_amt_fg,		SHOP_GUBN   = (CASE :ls_shop_div
			  																									  WHEN 'A' THEN '01' 
			  																									  WHEN 'G' THEN '02' 
									  																			  WHEN 'K' THEN '03' 
			  																									  WHEN 'T' THEN '04' 
			  																									  WHEN 'Z' THEN '05' 
																												  ELSE '' END),
				BANK      = :ls_bank_cd,		UID        = :gs_user_id,		IDATE       = CONVERT(VARCHAR(10), :id_datetime, 102),
				remark    = :ls_remark
		WHERE CUST_CODE = RIGHT(:ls_cust_cd, 4)
		  AND SHOP_TYPE = SUBSTRING(:ls_cust_cd, 2, 1)
		  AND BRAND     = LEFT(:ls_cust_cd, 1) ;

	If SQLCA.SQLCODE <> 0 Then Return -1

ElseIf SQLCA.SQLCODE <> 0 Then 
	Return -2
end if

Return SQLCA.SQLCODE

end function

on w_91010_e.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.dw_empb=create dw_empb
this.dw_empd=create dw_empd
this.dw_list=create dw_list
this.dw_custl=create dw_custl
this.dw_custb=create dw_custb
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_empb
this.Control[iCurrent+3]=this.dw_empd
this.Control[iCurrent+4]=this.dw_list
this.Control[iCurrent+5]=this.dw_custl
this.Control[iCurrent+6]=this.dw_custb
end on

on w_91010_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_empb)
destroy(this.dw_empd)
destroy(this.dw_list)
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
inv_resize.of_Register(dw_empb, "ScaleToRight&Bottom")
inv_resize.of_Register(dw_empd, "ScaleToRight&Bottom")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")

/* DataWindow의 Transction 정의 */
dw_list.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_custl.SetTransObject(SQLCA)
dw_custb.SetTransObject(SQLCA)
dw_empb.SetTransObject(SQLCA)
dw_empd.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)

/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)
dw_body.InsertRow(0)
dw_custl.InsertRow(0)
dw_custb.InsertRow(0)
dw_empb.InsertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/* 비  고      : dw_head와 dw_body용                                         */
/*===========================================================================*/
String     ls_shop_cd, ls_shop_nm, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_dept_cd
String     ls_upte, ls_jongmok, ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr
String     ls_sale_empnm, ls_jumn_no, ls_cust_cd, ls_zipcode, ls_addr, ls_bank_cd
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
	CASE "shop_cd_h"
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) or Trim(as_data) = "" THEN
				dw_head.SetItem(al_row, "shop_nm_h", "")
				RETURN 0
			END IF
			IF gf_shop_nm2(as_data, 'S', ls_shop_nm) = 0 THEN
				dw_head.SetItem(al_row, "shop_nm_h", ls_shop_nm)
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
			dw_head.SetItem(al_row, "shop_cd_h", lds_Source.GetItemString(1,"shop_cd"))
			dw_head.SetItem(al_row, "shop_nm_h", lds_Source.GetItemString(1,"shop_snm"))
			/* 다음컬럼으로 이동 */
			cb_retrieve.SetFocus()
//			dw_head.SetColumn("end_ymd")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
		
	CASE "empno_h"
		is_brand = Trim(dw_head.GetItemString(1, "brand"))
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_head.SetItem(al_row, "emp_nm_h", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 	
		
//				gst_cd.default_where   = " WHERE DEPT_CODE in ( '1000','5010','5001','5003','5004','N223','N221','5000','5200','5010','K000','K120','T400','R400','S300','RB20', 'X400', 'X100','L220', 'S400', 'N222','N220','V960','G410', 'I900','N751','N740','N741', 'B081','B082','B083','D020','A030','A031','A032','A033','D020','B030','B031','D020') " + &
//								 "   AND GOOUT_GUBN = '1' "
								 
				gst_cd.default_where   = " WHERE	GOOUT_GUBN = '1'  "
								 

	//		end if	
				
	
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "empno_h", lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm_h", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
	//			dw_head.SetColumn("empno")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

	CASE "shop_cd"
		is_brand = Trim(dw_body.GetItemString(1, "brand"))
		iF IsNull(is_brand) or is_brand = "" Then
			MessageBox("입력오류", "브랜드 코드를 먼저 입력하십시요")
			dw_body.SetItem(al_row, "shop_cd", "")
			dw_body.SetItem(al_row, "shop_nm", "")
			dw_body.SetItem(al_row, "shop_snm", "")
			wf_body_reset(al_row, 'C')
			dw_body.SetColumn("brand")
			Return 1
		End If
		
		IF ai_div = 1 THEN 	
			IF IsNull(as_data) or Trim(as_data) = "" THEN
				dw_body.SetItem(al_row, "shop_nm", "")
				dw_body.SetItem(al_row, "shop_snm", "")
				wf_body_reset(al_row, 'C')
				RETURN 0
			END IF
			If LeftA(as_data, 1) <> is_brand Then
				MessageBox("입력오류", "해당 브랜드의 매장 코드가 아닙니다!")
				Return 1
			End If				
			IF gf_shop_nm2(as_data, 'S', ls_shop_nm) = 0 THEN
				MessageBox("입력오류", "사용되고 있는 매장 코드입니다!")
				Return 1
			ElseIf LenA(as_data) = 6 Then
				dw_body.SetItem(al_row, "shop_nm", "")
				dw_body.SetItem(al_row, "shop_snm", "")
				wf_body_reset(al_row, 'C')
				RETURN 0
			Else
				MessageBox("입력오류", "매장 코드는 6자리 입니다!")
				Return 1
			END IF
		END IF
			
	CASE "cust_cd"
		ls_shop_cd = Trim(dw_body.GetItemString(al_row, "shop_cd"))
		If IsNull(ls_shop_cd) or LenA(ls_shop_cd) <> 6 Then
			MessageBox("입력오류", "매장 코드를 먼저 입력하십시요!")
			wf_body_reset(al_row, 'C')
			dw_body.SetColumn("shop_cd")
			Return 1
		End If
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				wf_body_reset(al_row, 'C')
				RETURN 0
			END IF 
			If LenA(as_data) = 6 Then
				If (LeftA(ls_shop_cd, 1) <> LeftA(as_data, 1) or RightA(ls_shop_cd, 4) <> RightA(as_data, 4)) and &
					RightA(as_data, 4) <> '4999' Then
//					MessageBox("입력오류", "매장코드와 거래처코드의 앞의 1자리와 뒤의 4자리가 같아야합니다!")
//					Return 1
				End If
			End If
			IF wf_cust_info(as_data, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
			                ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_bank_cd) = 0 THEN
				dw_body.SetItem(al_row, "shop_nm", ls_cust_nm)
//				dw_body.SetItem(al_row, "cust_sname", ls_cust_snm)
				dw_body.SetItem(al_row, "saup_no", ls_saup_no)
				dw_body.SetItem(al_row, "upte", ls_upte)
				dw_body.SetItem(al_row, "jongmok", ls_jongmok)
				dw_body.SetItem(al_row, "tel_no", ls_tel_no)
				dw_body.SetItem(al_row, "fax_no", ls_fax_no)
				dw_body.SetItem(al_row, "cust_zip", ls_cust_zip)
				dw_body.SetItem(al_row, "cust_addr", ls_cust_addr)
				dw_custl.SetItem(al_row, "bank_cd", ls_bank_cd)
				RETURN 0
			ElseIf LenA(as_data) = 6 Then
				wf_body_reset(al_row, 'N')
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "거래처 코드 검색" 
		gst_cd.datawindow_nm   = "d_com911" 
//		gst_cd.default_where   = " WHERE BRAND     = ~'" + Left(ls_shop_cd, 1)  + "~' "  //+ &
		gst_cd.default_where   = " WHERE BRAND     = brand "  //+ &
//										 "   AND ( CUST_CODE = ~'" + Right(ls_shop_cd, 4) + "~' " + &
//										 "   OR    CUST_CODE = ~'4999~' ) " 
		IF Trim(as_data) <> "" THEN
//			gst_cd.Item_where = " CUSTCODE LIKE '" + as_data + "%' "
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
			dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"cust_name"))
//			dw_body.SetItem(al_row, "cust_sname", lds_Source.GetItemString(1,"cust_sname"))
			dw_body.SetItem(al_row, "saup_no", lds_Source.GetItemString(1,"saup_no"))
			dw_body.SetItem(al_row, "upte", lds_Source.GetItemString(1,"upte"))
			dw_body.SetItem(al_row, "jongmok", lds_Source.GetItemString(1,"jongmok"))
			dw_body.SetItem(al_row, "tel_no", lds_Source.GetItemString(1,"tel_no"))
			dw_body.SetItem(al_row, "fax_no", lds_Source.GetItemString(1,"fax_no"))
			dw_body.SetItem(al_row, "cust_zip", lds_Source.GetItemString(1,"cust_zip"))
			dw_body.SetItem(al_row, "cust_addr", lds_Source.GetItemString(1,"cust_addr"))
			dw_custl.SetItem(al_row, "bank_cd", ls_bank_cd)
			/* 다음컬럼으로 이동 */
			dw_body.SetColumn("cust_name")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
		
	CASE "cust_zip"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk (as_data, ls_zipcode, ls_addr) = TRUE THEN
				   dw_body.SetItem(al_row, "cust_addr", ls_addr)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "우편 번호 검색" 
			gst_cd.datawindow_nm   = "d_com916" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "zipcode1 LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "cust_zip",  lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "cust_addr", lds_Source.GetItemString(1,"jiyeok") + ' ' + &
				                                     lds_Source.GetItemString(1,"gu") + ' ' + & 
																 lds_Source.GetItemString(1,"dong"))
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("cust_addr")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source
	CASE "empno"
		is_brand = Trim(dw_body.GetItemString(1, "brand"))
		iF IsNull(is_brand) or is_brand = "" Then
			MessageBox("입력오류", "브랜드 코드를 먼저 입력하십시요")
			dw_body.SetItem(al_row, "empno", "")
			dw_body.SetItem(al_row, "emp_nm", "")
			dw_body.SetColumn("brand")
			Return 1
		End If
			IF ai_div = 1 THEN
				If IsNull(as_data) or Trim(as_data) = "" Then
					dw_body.SetItem(al_row, "emp_nm", "")
					RETURN 0
				END IF 
			END IF
			
			gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "영업부 사원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 			
		
				gst_cd.default_where   = " WHERE  GOOUT_GUBN = '1' "
	

			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "EMPNO LIKE '" + as_data + "%'"
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
				dw_body.SetItem(al_row, "empno", lds_Source.GetItemString(1,"empno"))
				dw_body.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
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
				dw_empb.SetItem(al_row, "jumn_no", "")
				wf_empb_reset(al_row, 'C')
				RETURN 0
			END IF 
			iF LeftA(as_data, 1) <> '8' Then
				MessageBox("입고오류", "판매사원 코드는 '8'로 시작합니다!")
				Return 1
			End If
			IF wf_emp_info(as_data, ls_sale_empnm, ls_jumn_no, ls_cust_cd) = 0 THEN
				dw_empb.SetItem(al_row, "sale_empnm", ls_sale_empnm)
				dw_empb.SetItem(al_row, "jumn_no", ls_jumn_no)
				If IsNull(ls_cust_cd) = False and Trim(ls_cust_cd) <> "" Then
					If wf_cust_info(ls_cust_cd, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
										 ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_bank_cd) = 0 Then
						dw_empb.SetItem(al_row, "emp_cust", ls_cust_cd)
						dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
						dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
						dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
						dw_empb.SetItem(al_row, "upte", ls_upte)
						dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
						dw_empb.SetItem(al_row, "bank", ls_bank_cd)
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
		gst_cd.default_where   = "WHERE SALE_EMP LIKE '8%' "		
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
									 ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_bank_cd) = 0 Then
					dw_empb.SetItem(al_row, "emp_cust", ls_cust_cd)
					dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
					dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
					dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
					dw_empb.SetItem(al_row, "upte", ls_upte)
					dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
					dw_empb.SetItem(al_row, "bank", ls_bank_cd)
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
		is_brand = Trim(dw_body.GetItemString(1, "brand"))
		iF IsNull(is_brand) or is_brand = "" Then
			MessageBox("입력오류", "브랜드 코드를 먼저 입력하십시요")
			wf_empb_reset(al_row, 'C')
			dw_body.SetColumn("brand")
			Return 1
		End If
		ls_shop_cd = Trim(dw_empb.GetItemString(al_row, "sale_emp"))
		If IsNull(ls_shop_cd) or LenA(ls_shop_cd) <> 6 Then
			MessageBox("입력오류", "판매 사원 코드를 먼저 입력하십시요!")
			wf_empb_reset(al_row, 'C')
			dw_empb.SetColumn("sale_emp")
			Return 1
		End If
		
		IF ai_div = 1 THEN
			If IsNull(as_data) or Trim(as_data) = "" Then
				wf_empb_reset(al_row, 'C')
				RETURN 0
			END IF 
			
			If LeftA(as_data, 1) <> is_brand or MidA(as_data, 3, 4) < '4000' or MidA(as_data, 3, 4) > '6999' Then
				MessageBox("입력오류", "판매사원 거래처 코드는 브랜드 코드로 시작하고" + &
				                       "~n~r~'4000~' 과 ~'6ZZZ~' 사이의 코드로 끝납니다!")
				Return 1
			End If

			IF wf_cust_info(as_data, ls_cust_nm, ls_cust_snm, ls_saup_no, ls_upte, ls_jongmok, &
			                ls_tel_no, ls_fax_no, ls_cust_zip, ls_cust_addr, ls_bank_cd) = 0 THEN
//				dw_empb.SetItem(al_row, "emp_cust", as_data)
				dw_empb.SetItem(al_row, "cust_nm", ls_cust_nm)
				dw_empb.SetItem(al_row, "cust_snm", ls_cust_snm)
				dw_empb.SetItem(al_row, "saup_no", ls_saup_no)
				dw_empb.SetItem(al_row, "upte", ls_upte)
				dw_empb.SetItem(al_row, "jongmok", ls_jongmok)
				dw_empb.SetItem(al_row, "bank", ls_bank_cd)
				RETURN 0
			ElseIf LenA(as_data) = 6 Then
				wf_empb_reset(al_row, 'N')
				RETURN 0
			END IF 
		END IF
		
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "거래처 코드 검색" 
		gst_cd.datawindow_nm   = "d_com911" 
		gst_cd.default_where   = "WHERE BRAND = ~'" + is_brand + "~' " + &
										 "  AND SUBSTRING(CUSTCODE, 3, 4) BETWEEN ~'4000~' AND ~'6ZZZ~' "
										 
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
			dw_empb.SetItem(al_row, "bank", ls_bank_cd)
			/* 다음컬럼으로 이동 */
			dw_empb.SetColumn("cust_nm")
			ib_itemchanged = False 
			lb_check = TRUE 
		ELSE
			lb_check = FALSE 
		END IF
		Destroy  lds_Source
		
		CASE "zipcode"				
		IF ai_div = 1 THEN 	
			IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				dw_EMPB.SetItem(al_row, "zip_code", ls_zipcode)
				dw_EMPB.SetItem(al_row, "addr", ls_addr)
				RETURN 0
			END IF 
		END IF
		gst_cd.ai_div          = ai_div
		gst_cd.window_title    = "우편번호 검색" 
		gst_cd.datawindow_nm   = "d_com916" 
		gst_cd.default_where   = ""
		IF Trim(as_data) <> "" THEN
			gst_cd.Item_where = "ZIPCODE1 LIKE '" + as_data + "%'"
		ELSE
			gst_cd.Item_where = ""
		END IF

		lds_Source = Create DataStore
		OpenWithParm(W_COM200, lds_Source)

		IF Isvalid(Message.PowerObjectParm) THEN
			ib_itemchanged = True
			lds_Source = Message.PowerObjectParm
			dw_EMPB.SetRow(al_row)
			dw_EMPB.SetColumn(as_column)
			dw_EMPB.SetItem(al_row, "zip_code", lds_Source.GetItemString(1,"zipcode1"))
			dw_EMPB.SetItem(al_row, "addr",     lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
			ib_itemchanged = False 
			lb_check = TRUE 
			/* 다음컬럼으로 이동 */
			dw_EMPB.SetColumn("addr")
			ib_changed = true
			cb_update.enabled = true
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

event ue_retrieve();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
Long ll_rows
String ls_ed_dt

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_shop_cd, is_empno, is_shop_div, is_shop_stat)
dw_body.Reset()
dw_custl.Reset()
dw_custb.Reset()
dw_empb.Reset()
dw_empd.Reset()
dw_body.InsertRow(0)
dw_custl.InsertRow(0)
dw_custb.InsertRow(0)
dw_empb.InsertRow(0)
dw_empd.InsertRow(0)

IF il_rows > 0 THEN
   dw_list.SetFocus()
END IF

//IF il_rows > 0 THEN
//	ll_rows = dw_custb.Retrieve(is_shop_cd)
//				 dw_custl.Retrieve(is_shop_cd)
//	If ll_rows <= 0 Then dw_custb.InsertRow(0)
//
//	ll_rows = dw_empb.Retrieve(is_shop_cd)
//	
//	If ll_rows >= 1 Then
//		is_pay_way = Trim(dw_empb.GetItemString(1, "pay_way"))
//		If IsNull(is_pay_way) = False and is_pay_way <> "" Then
//			If is_pay_way = '1' Then
//				dw_empd.DataObject = 'd_91010_d06'
//			ElseIf is_pay_way = '2' Then
//				dw_empd.DataObject = 'd_91010_d07'
//			End If
//			dw_empd.SetTransObject(SQLCA)
//		
//			ll_rows = dw_empd.retrieve(is_shop_cd, is_pay_way)
//			If ll_rows = 0 Then dw_empd.InsertRow(0)
//		Else
//			dw_empd.DataObject = 'd_91010_d06'
//			dw_empd.SetTransObject(SQLCA)
//		End If
//	Else
//		dw_empb.InsertRow(0)
//		dw_empd.DataObject = 'd_91010_d06'
//		dw_empd.SetTransObject(SQLCA)
//	End If
//	dw_body.SetFocus()
//Else
//	dw_body.InsertRow(0)
//END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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

is_brand = Trim(dw_head.GetItemString(1, "brand"))
if IsNull(is_brand) or is_brand = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
End If

is_shop_cd = Trim(dw_head.GetItemString(1, "shop_cd_h"))
if IsNull(is_shop_cd) or is_shop_cd = "" then is_shop_cd = '%'

is_empno = Trim(dw_head.GetItemString(1, "empno_h"))
if IsNull(is_empno) or is_empno = "" then is_empno = '%'

is_shop_div = Trim(dw_head.GetItemString(1, "shop_div"))
if IsNull(is_shop_div) or is_shop_div = "" then is_shop_div = '%'

is_shop_stat = Trim(dw_head.GetItemString(1, "shop_stat"))
if IsNull(is_shop_stat) or is_shop_stat = "" then is_shop_stat = '%'


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

dw_body.Reset()
dw_custl.Reset()
dw_custb.Reset()
dw_empb.Reset()
dw_empd.DataObject = 'd_91010_d06'
dw_empd.SetTransObject(SQLCA)

il_rows = dw_body.InsertRow(0)
dw_custl.InsertRow(0)
dw_custb.InsertRow(0)
dw_empb.InsertRow(0)

//dw_body.SetItem(1, "shop_stat", '00')
//dw_body.SetItem(1, "area_cd",   '99')
//dw_body.SetItem(1, "vat_way",   '2')
//dw_body.SetItem(1, "amt_fg",    '2')

//dw_custl.SetItem(1, "vat_way",  '2')
//dw_custl.SetItem(1, "amt_fg",   '2')

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
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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
      else
         dw_head.SetFocus()
      end if

   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled  = true
			cb_print.enabled   = false
			cb_preview.enabled = false
			cb_excel.enabled   = false
			dw_list.Enabled  = true
			dw_body.Enabled  = true
			dw_custl.Enabled = true
			dw_custb.Enabled = true
			dw_empb.Enabled  = true
			dw_empd.Enabled  = true
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Reset()
				dw_head.InsertRow(1)
				dw_head.Enabled  = false
				dw_list.Reset()
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			lb_changed = false
			cb_print.enabled   = true
			cb_preview.enabled = true
			cb_excel.enabled   = true
		end if

	CASE 4		/* 삭제 */
		if al_rows = 1 then
			if dw_body.RowCount() = 0 then
            cb_delete.enabled = false
			end if
         if idw_status <> new! and idw_status <> newmodified! then
            ib_changed = true
            lb_changed = true
            cb_update.enabled = true
			end if
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text   = "조회(&Q)"
//      cb_insert.enabled  = false
      cb_delete.enabled  = false
      cb_print.enabled   = false
      cb_preview.enabled = false
      cb_excel.enabled   = false
      cb_update.enabled  = false
      ib_changed = false
      lb_changed = false
      dw_list.Enabled  = false
      dw_body.Enabled  = false
		dw_custl.Enabled = false
		dw_custb.Enabled = false
		dw_empb.Enabled  = false
		dw_empd.Enabled  = false
      dw_head.Enabled  = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)

   CASE 7  /* dw_list clicked 조회 */
      if al_rows > 0 then
         cb_delete.enabled  = true
         cb_print.enabled   = true
         cb_preview.enabled = true
         cb_excel.enabled   = true
         dw_body.Enabled  = true
         dw_custl.Enabled = true
         dw_custb.Enabled = true
         dw_empb.Enabled  = true
			If IsNull(is_pay_way) or Trim(is_pay_way) = "" Then
	         dw_empd.Enabled  = false
			Else
				dw_empd.Enabled  = true
			End If
		else
         cb_delete.enabled  = false
         cb_print.enabled   = false
         cb_preview.enabled = false
         cb_excel.enabled   = false
		end if

      if al_rows >= 0 then
         ib_changed = false
         lb_changed = false
         cb_update.enabled = false
//         cb_insert.enabled = true
      end if
END CHOOSE

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/
dwItemStatus ldw_status_empb
long         i, ll_row_count, ll_rows_custb, ll_rows_empb, ll_rows_empd, ll_cur_row
Integer      li_chk
String       ls_shop_stat
String ls_value, ls_sugm_mm1, ls_sugm_dd1, ls_sugm_mm2, ls_sugm_dd2, ls_sugm_ymd
decimal ldc_sugm_rate1, ldc_sugm_rate2 

IF dw_body.AcceptText()  <> 1 THEN RETURN -1
IF dw_custl.AcceptText() <> 1 THEN RETURN -1
IF dw_custb.AcceptText() <> 1 THEN RETURN -1
IF dw_empb.AcceptText()  <> 1 THEN RETURN -1
IF dw_empd.AcceptText()  <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(id_datetime) = FALSE THEN
	Return 0
END IF

is_shop_cd = dw_body.GetItemString(1, "shop_cd")

// dw_custl가 변경되었으면 dw_custl의 data를 dw_body에 셋팅
wf_body_set()

// dw_body 저장
li_chk = wf_body_update()

Choose Case li_chk
	Case -1
		MessageBox("저장오류", "거래처 마스터(매장MASTER) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -2
		MessageBox("저장오류", "거래처 마스터(매장MASTER) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -3
		rollback  USING SQLCA;
		Return -1
End Choose




// dw_custb 저장
li_chk = wf_custb_update()

If li_chk = -1 Then
	MessageBox("저장오류", "거래처 마스터(매장MASTER) UPDATE에 실패하였습니다!")
	rollback  USING SQLCA;
	Return -1
End If

// dw_empb 저장
li_chk = wf_empb_update()

Choose Case li_chk
	Case -1
		MessageBox("저장오류", "판매 사원 마스터 UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -2
		MessageBox("저장오류", "판매 사원 마스터 INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -3
		MessageBox("저장오류", "거래처 마스터(판매 사원) UPDATE에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -4
		MessageBox("저장오류", "거래처 마스터(판매 사원) INSERT에 실패하였습니다!")
		rollback  USING SQLCA;
		Return -1
	Case -5
		rollback  USING SQLCA;
		Return -1
End Choose

dw_empd.SetReDraw(False)
// dw_empd 저장
wf_empd_update()

il_rows       = dw_body.Update(TRUE, FALSE)
ll_rows_custb = dw_custb.Update(TRUE, FALSE)
ll_rows_empb  = dw_empb.Update(TRUE, FALSE)
ll_rows_empd  = dw_empd.Update(TRUE, FALSE)

  ls_sugm_ymd = dw_custl.GetItemString (1, "sugm_ymd")	
	ls_sugm_mm1 = dw_custl.GetItemString (1, "sugm_mm1")	
	ls_sugm_dd1 = dw_custl.GetItemString (1, "sugm_dd1")	
	ls_sugm_mm2 = dw_custl.GetItemString (1, "sugm_mm2")		
	ls_sugm_dd2 = dw_custl.GetItemString (1, "sugm_dd2")		
   ldc_sugm_rate1 =	dw_custl.GetItemDecimal(1, "sugm_rate1")
   ldc_sugm_rate2 =	dw_custl.GetItemDecimal(1, "sugm_rate2")

	 DECLARE sp_56041_update PROCEDURE FOR sp_56041_update  
         @shop_cd    = :is_shop_cd,   
         @start_ymd  = :ls_sugm_ymd,   
         @SUGM_MM1   = :ls_sugm_mm1,   
         @SUGM_DD1   = :ls_sugm_dd1,   
         @SUGM_RATE1 = :ldc_sugm_rate1,   
         @SUGM_MM2 = :ls_sugm_mm2,   
         @SUGM_DD2 = :ls_sugm_dd2,   
         @SUGM_RATE2 = :ldc_sugm_rate2,
			@user_id    = :gs_user_id	;

   execute sp_56041_update;
   commit  USING SQLCA; 

if il_rows = 1 and ll_rows_custb = 1 and ll_rows_empb = 1 and ll_rows_empd = 1 then
   dw_body.ResetUpdate()
   dw_custb.ResetUpdate()
   dw_empb.ResetUpdate()
   dw_empd.ResetUpdate()
   commit  USING SQLCA;
	
	If is_pay_way = '2' Then
		dw_empd.Retrieve(is_shop_cd, is_pay_way)
	End If
	
 	dw_empd.SetReDraw(True)
	This.Trigger Event ue_button(3, 1)
	This.Trigger Event ue_msg(3, 1)
	return 1
else
	il_rows = -1
   rollback  USING SQLCA;
	
	dw_empd.SetReDraw(True)
	This.Trigger Event ue_button(3, -1)
	This.Trigger Event ue_msg(3, -1)
	return -1
end if


end event

event pfc_postopen;call super::pfc_postopen;dw_head.SetColumn("shop_cd")
dw_head.SetFocus()

end event

event pfc_dberror();//
end event

type cb_close from w_com010_e`cb_close within w_91010_e
integer taborder = 160
end type

type cb_delete from w_com010_e`cb_delete within w_91010_e
boolean visible = false
integer taborder = 100
end type

type cb_insert from w_com010_e`cb_insert within w_91010_e
integer taborder = 90
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_91010_e
end type

type cb_update from w_com010_e`cb_update within w_91010_e
integer taborder = 140
end type

type cb_print from w_com010_e`cb_print within w_91010_e
boolean visible = false
integer taborder = 110
end type

type cb_preview from w_com010_e`cb_preview within w_91010_e
boolean visible = false
integer taborder = 120
end type

type gb_button from w_com010_e`gb_button within w_91010_e
end type

type cb_excel from w_com010_e`cb_excel within w_91010_e
boolean visible = false
integer taborder = 130
end type

type dw_head from w_com010_e`dw_head within w_91010_e
integer y = 140
integer height = 120
string dataobject = "d_91010_h01"
end type

event dw_head::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "brand"
		This.SetItem(row, "empno_h", "")
		This.SetItem(row, "emp_nm_h", "")
	CASE "shop_cd_h", "empno_h"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
idw_brand.InsertRow(1)
idw_brand.SetItem(1, "inter_cd", '0')
idw_brand.SetItem(1, "inter_nm", '공통')

This.GetChild("shop_div", idw_shop_div)
idw_shop_div.SetTransObject(SQLCA)
idw_shop_div.Retrieve('910')
idw_shop_div.InsertRow(1)
idw_shop_div.SetItem(1, "inter_cd", '%')
idw_shop_div.SetItem(1, "inter_nm", '전체')

This.GetChild("shop_stat", idw_shop_stat)
idw_shop_stat.SetTransObject(SQLCA)
idw_shop_stat.Retrieve('913')
idw_shop_stat.InsertRow(1)
idw_shop_stat.SetItem(1, "inter_cd", '%')
idw_shop_stat.SetItem(1, "inter_nm", '전체')

end event

type ln_1 from w_com010_e`ln_1 within w_91010_e
integer beginy = 264
integer endy = 264
end type

type ln_2 from w_com010_e`ln_2 within w_91010_e
integer beginy = 268
integer endy = 268
end type

type dw_body from w_com010_e`dw_body within w_91010_e
integer x = 850
integer y = 272
integer width = 2743
integer height = 784
integer taborder = 40
boolean enabled = false
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
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '0')
ldw_child.SetItem(1, "inter_nm", '공통')

This.GetChild("shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('910')

This.GetChild("area_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('090')

This.GetChild("shop_grp", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('912')

This.GetChild("shop_class", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('922')

This.GetChild("shop_stat", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('913')


This.GetChild("etc_shop_div", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('970')



This.GetChild("tb_91100_m_shop_channel", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('91A')

This.GetChild("tb_91100_m_shop_major_class", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('91B')

This.GetChild("tb_91100_m_shop_mid_class", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('91C')

This.GetChild("tb_91100_m_shop_diff_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('91D')

This.GetChild("tb_91100_m_shop_div_fin", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('91E')


end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.26                                                  */	
/* 수정일      : 2001.12.26                                                  */
/*===========================================================================*/
String ls_shop_chk

CHOOSE CASE dwo.name
	CASE "brand" 
		This.SetItem(1, "empno", "")
		This.SetItem(1, "emp_nm", "")
//		ls_shop_chk = This.GetItemString(row, "shop_div")
//
//		If IsNull(ls_shop_chk) or Trim(ls_shop_chk) = "" Then Return 0
//		If wf_shop_cd(data, ls_shop_chk, is_shop_cd) <> 0 Then Return 1
//		
//		This.SetItem(row, "shop_cd", is_shop_cd)
//		wf_body_reset(row, 'C')
//	CASE "shop_div" 
//		ls_shop_chk = This.GetItemString(row, "brand")
//		
//		If IsNull(ls_shop_chk) or Trim(ls_shop_chk) = "" Then Return 0
//		If wf_shop_cd(ls_shop_chk, data, is_shop_cd) <> 0 Then Return 1
//
//		This.SetItem(row, "shop_cd", is_shop_cd)
//		wf_body_reset(row, 'C')
	CASE "open_ymd", "change_date"
		If gf_datechk(data) = False Then Return 1
	CASE "shop_cd", "cust_cd", "cust_zip", "empno"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
END CHOOSE

end event

event dw_body::clicked;call super::clicked;
Choose Case dwo.name
	Case "cust_zip"
		Parent.Trigger Event ue_popup (dwo.name, row, "", 2)
End Choose

end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_91010_e
end type

type tab_1 from tab within w_91010_e
integer x = 9
integer y = 1052
integer width = 3598
integer height = 996
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
	dw_empb.Visible = False
	dw_empd.Visible = False
	dw_custl.SetColumn("sugm_mmfg")
	dw_custl.SetFocus()
Else
	dw_custl.Visible = False
	dw_custb.Visible = False
	dw_empb.Visible = True
	dw_empd.Visible = True
	dw_empb.SetFocus()
End If

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 884
long backcolor = 79741120
string text = "거래처내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 3561
integer height = 884
long backcolor = 79741120
string text = "사원내역"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_empb from u_dw within w_91010_e
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 1148
integer width = 3570
integer height = 888
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_91010_d05"
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

This.GetChild("comm_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('919')

This.GetChild("pay_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('920')
ldw_child.InsertRow(1)
ldw_child.SetItem(1, "inter_cd", '')
ldw_child.SetItem(1, "inter_nm", '없음')

This.GetChild("bank", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('923')

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
		If data = '2' Then
			dw_empd.DataObject = 'd_91010_d07'
		Else
			dw_empd.DataObject = 'd_91010_d06'
		End If
		dw_empd.SetTransObject(SQLCA)
		
//		is_ed_dt = Trim(dw_empb.GetItemString(1, "end_date"))
//		If IsNull(is_ed_dt) or is_ed_dt = "" Then 
//			is_ed_dt = '99999999'
//		End If
		
		ll_rows = dw_empd.Retrieve(is_shop_cd, data)
		If ll_rows = 0 Then dw_empd.InsertRow(0)
		
		If IsNull(data) or Trim(data) = "" Then
			dw_empd.Enabled = False
		Else
			dw_empd.Enabled = True
		End If

		is_pay_way = data

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
/* 작성자      : (주)지우정보 (권 진택)                                      */	
/* 작성일      : 2001.12.09                                                  */	
/* 수정일      : 2001.12.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
long   ll_cur_row

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

//Choose Case ls_column_nm
//	Case "insert_row"
//		if dw_empb.AcceptText() <> 1 then return
//		
//		/* 변경된 자료가 있을때 저장여부를 확인*/
//		IF lb_changed THEN 
//			CHOOSE CASE gf_update_yn(This.title)
//				CASE 1
//					IF Parent.Trigger Event ue_update() < 1 THEN
//						return
//					ELSE
//						ib_changed = false
//						lb_changed = false
//						cb_update.enabled = false
//					END IF		
//				CASE 3
//					return
//			END CHOOSE
//		END IF
//		
//		lb_changed = false
//		If ib_changed = False Then cb_update.enabled = false
//
//		dw_empb.Reset()
//		dw_empd.Reset()
//		
//		il_rows = dw_empb.InsertRow(0)
//		is_pay_way = '1'
//		dw_empb.SetItem(il_rows, "pay_way", is_pay_way)
//		dw_empd.DataObject = 'd_91010_d06'
//		dw_empd.SetTransObject(SQLCA)
////		dw_empd.Reset()
//		dw_empd.InsertRow(0)
//		
//		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
//		if il_rows > 0 then
//			dw_empb.ScrollToRow(il_rows)
//			dw_empb.SetColumn("st_dt")
//			dw_empb.SetFocus()
//		end if
//		
//		cb_print.enabled = false
//		cb_preview.enabled = false
//		cb_excel.enabled = false
//		
//		Parent.Trigger Event ue_msg(2, il_rows)
//		Return
//	Case "delete_row"
//		ll_cur_row = dw_empb.GetRow()
//		
//		if ll_cur_row <= 0 then return
//		
//		idw_status = dw_empb.GetItemStatus (ll_cur_row, 0, primary!)	
//		
//		if idw_status <> new! and idw_status <> newmodified! then
//			// 지급방법에 대한 수수료 내역 삭제
//			  DELETE 
//				 FROM TB_91104_H
//				WHERE SHOP_CD = :is_shop_cd
//				  AND ED_DT = :is_ed_dt ;
//	
//			If SQLCA.SQLCODE <> 0 Then
//				MessageBox("삭제오류", "지급방법에 대한 수수료 내역을 삭제 하는데 실패했습니다!")
//			   rollback  USING SQLCA;
//				Return
//			End If
//			ib_changed = true
//			lb_changed = true
//			cb_update.enabled = true
//		end if
//
//		il_rows = dw_empb.DeleteRow (ll_cur_row)
//
//		if il_rows = 1 then
//			cb_print.enabled = false
//			cb_preview.enabled = false
//			cb_excel.enabled = false
//			
//			dw_empd.DataObject = 'd_91010_d06'
//			dw_empd.SetTransObject(SQLCA)
//		end if
//
//		dw_empb.SetFocus()
//		
//		Parent.Trigger Event ue_msg(4, il_rows)
//		Return
//End Choose

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

type dw_empd from u_dw within w_91010_e
event ue_keydown pbm_dwnkey
integer x = 1399
integer y = 1388
integer width = 2107
integer height = 632
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
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

Decimal ldc_comm_rate3, ldc_comm_rate4
Long i

If is_pay_way = '2' Then
	CHOOSE CASE dwo.name
		CASE "comm_rate1" 
			This.SetItem(row - 1, "comm_rate2", Dec(data))
		CASE "comm_rate2" 
			This.SetItem(row + 1, "comm_rate1", Dec(data))
		CASE "comm_rate3" 
			If row = 1 Then Return 0
			
			ldc_comm_rate3 = Dec(data)
			ldc_comm_rate4 = This.GetItemDecimal(row, "comm_rate4")
			For i = row + 1 to This.RowCount()
				This.SetItem(i, "comm_rate4", (ldc_comm_rate3 * 100) + ldc_comm_rate4)
				ldc_comm_rate3 = This.GetItemDecimal(i, "comm_rate3")
				ldc_comm_rate4 = This.GetItemDecimal(i, "comm_rate4")
			Next
		CASE "comm_rate4" 
			If row = 1 Then Return 0
			
			ldc_comm_rate3 = This.GetItemDecimal(row, "comm_rate3")
			ldc_comm_rate4 = Dec(data)
			For i = row + 1 to This.RowCount()
				This.SetItem(i, "comm_rate4", (ldc_comm_rate3 * 100) + ldc_comm_rate4)
				ldc_comm_rate3 = This.GetItemDecimal(i, "comm_rate3")
				ldc_comm_rate4 = This.GetItemDecimal(i, "comm_rate4")
			Next
	END CHOOSE
End If

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
long   ll_cur_row, i, ll_row_cnt
Decimal ldc_comm_rate1, ldc_comm_rate2, ldc_comm_rate3, ldc_comm_rate4

Choose Case dwo.name
	Case "cb_insert_row"
		if This.AcceptText() <> 1 then return
		
		il_rows = This.InsertRow(0)
		
		This.SetItem(il_rows, "comm_rate2", 999999999)
			
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			This.ScrollToRow(il_rows)
			This.SetColumn("comm_rate1")
			This.SetFocus()
		end if
		
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
      Parent.Trigger Event ue_msg(2, il_rows)
	Case "cb_delete_row"
//		ll_cur_row = This.GetRow()
//		if ll_cur_row <= 0 then return
		
//		idw_status = This.GetItemStatus (ll_cur_row, 0, primary!)	
//		il_rows = This.DeleteRow (ll_cur_row)

		idw_status = This.GetItemStatus (This.RowCount(), 0, primary!)	
		il_rows = This.DeleteRow (This.RowCount())
		This.SetFocus()
		
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
Case "cb_default"
	   SELECT COUNT(SEQ_NO)
		  INTO :ll_row_cnt
		  FROM TB_91104_H
			 WHERE SHOP_CD = 'TEST01'
			   AND ED_DT   = '99999999'
		;

		For i = 1 to ll_row_cnt

			If i > This.RowCount() Then
				il_rows = This.InsertRow(0)
			Else
				il_rows = i
			End If
			
			SELECT COMM_RATE1, COMM_RATE2, COMM_RATE3, COMM_RATE4
			  INTO :ldc_comm_rate1, :ldc_comm_rate2, :ldc_comm_rate3, :ldc_comm_rate4
			  FROM TB_91104_H
			 WHERE SHOP_CD = 'TEST01'
			   AND ED_DT   = '99999999'
				AND SEQ_NO  = :il_rows
			;

			This.SetItem(il_rows, "comm_rate1", ldc_comm_rate1)
			This.SetItem(il_rows, "comm_rate2", ldc_comm_rate2)
			This.SetItem(il_rows, "comm_rate3", ldc_comm_rate3)
			This.SetItem(il_rows, "comm_rate4", ldc_comm_rate4)
		Next
		
		/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
		if il_rows > 0 then
			dw_empd.ScrollToRow(il_rows)
			dw_empd.SetColumn("comm_rate1")
			dw_empd.SetFocus()
		end if

		ib_changed = true
		lb_changed = true
		cb_update.enabled = true
		cb_print.enabled = false
		cb_preview.enabled = false
		cb_excel.enabled = false
		Parent.Trigger Event ue_msg(2, il_rows)
End Choose

end event

type dw_list from u_dw within w_91010_e
integer x = 23
integer y = 272
integer width = 814
integer height = 784
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_91010_d00"
boolean hscrollbar = true
boolean hsplitscroll = true
end type

event clicked;/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
Long ll_rows
string ls_max_empno

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

is_shop_cd = This.GetItemString(row, 'shop_cd') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_shop_cd) THEN return

il_rows = dw_body.retrieve(is_shop_cd)

IF il_rows > 0 THEN
	ll_rows = dw_custb.Retrieve(is_shop_cd)
				 dw_custl.Retrieve(is_shop_cd)
	If ll_rows <= 0 Then dw_custb.InsertRow(0)

	ll_rows = dw_empb.Retrieve(is_shop_cd)
	
	If ll_rows >= 1 Then
		is_pay_way = Trim(dw_empb.GetItemString(1, "pay_way"))
		If is_pay_way = '2' Then
			dw_empd.DataObject = 'd_91010_d07'
		Else
			dw_empd.DataObject = 'd_91010_d06'
		End If
		dw_empd.SetTransObject(SQLCA)
	
		ll_rows = dw_empd.retrieve(is_shop_cd, is_pay_way)
		If ll_rows = 0 Then dw_empd.InsertRow(0)
		
	Else
		dw_empb.InsertRow(0)
		
		SELECT RIGHT('000000' + RTRIM(CAST(MAX(SALE_EMP) + 1 AS VARCHAR(6))), 6)
		into :ls_max_empno
      FROM TB_91102_M
      WHERE SALE_EMP LIKE '8%' ;
		
		dw_empb.setitem(1, "max_emp", ls_max_empno)
		
		dw_empd.DataObject = 'd_91010_d06'
		dw_empd.SetTransObject(SQLCA)
	End If
	dw_body.SetFocus()
END IF

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

event constructor;call super::constructor;/*===========================================================================*/
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

// DATAWINDOW COLUMN Modify
Integer i, li_column_count
String  ls_column_name, ls_modify

li_column_count = Integer(This.Describe("DataWindow.Column.Count"))

IF li_column_count = 0 THEN RETURN

FOR i=1 TO li_column_count
	ls_column_name = This.Describe('#' + String(i) + '.Name')
	IF This.Describe(ls_column_name + '.Visible') = '1' THEN
		ls_modify   = ls_modify + ls_column_name + &
		              ".color='0~tif (getrow() = currentrow(), rgb(255,0,0), 0) '"
	END IF
NEXT

This.Modify(ls_modify)
end event

event itemerror;call super::itemerror;return 1
end event

type dw_custl from u_dw within w_91010_e
event ue_keydown pbm_dwnkey
integer x = 23
integer y = 1180
integer width = 1851
integer height = 740
integer taborder = 50
boolean enabled = false
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

This.GetChild("vat_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('917')

This.GetChild("amt_fg", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('918')

This.GetChild("bank_cd", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('921')

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

event itemchanged;call super::itemchanged;/*===========================================================================*/
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
	CASE "sugm_mm1", "sugm_dd1", "sugm_mm2", "sugm_dd2", "slip_dd", "SUGM_YMD"
		If Long(data) < 0 or Long(data) > 99 Then Return 1
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

type dw_custb from u_dw within w_91010_e
event ue_keydown pbm_dwnkey
integer x = 1879
integer y = 1180
integer width = 1696
integer height = 740
integer taborder = 70
boolean enabled = false
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

