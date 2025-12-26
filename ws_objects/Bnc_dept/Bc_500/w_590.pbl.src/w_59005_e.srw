$PBExportHeader$w_59005_e.srw
$PBExportComments$직매입관리
forward
global type w_59005_e from w_com020_e
end type
end forward

global type w_59005_e from w_com020_e
end type
global w_59005_e w_59005_e

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_shop_cd, is_style, is_chno
STRING IS_CARD_NO, IS_JUMIN_NO, is_seq_no, is_yymmdd
DataWindowChild idw_brand, idw_color, idw_size, idw_empno, idw_shop_cd
end variables

forward prototypes
public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm)
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name)
public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_name_chk (string as_user_name, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm)
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
public function integer wf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
end prototypes

public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm);
Return 1

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
 WHERE USER_NAME = :as_user_name;

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

on w_59005_e.create
call super::create
end on

on w_59005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title

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
end if

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"매장코드를 입력하십시요!")
	return false
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_to_ymd) or Trim(is_to_ymd) = "" then
   MessageBox(ls_title,"종료일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_ymd")
end if

is_style = dw_head.GetItemString(1, "style")
if IsNull(is_style) or Trim(is_style) = "" then
	is_style = "%"
end if

is_chno = dw_head.GetItemString(1, "chno")
if IsNull(is_chno) or Trim(is_chno) = "" then
	is_chno = "%"
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
String 	  ls_zipcode, ls_addr, ls_invoice_no, ls_shop_cd, ls_column_nm
Integer    li_sex, li_return, li_okyes
long       ll_qty, ll_cnt
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)
CHOOSE CASE as_column

	CASE "shop_cd_h"				
			IF ai_div = 1 THEN 	
				If IsNull(as_data) or as_data = "" Then
					dw_body.SetItem(al_row, "shop_cd", "")
					RETURN 0
				END IF 
			END IF


		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "매장 코드 검색" 
			gst_cd.datawindow_nm   = "d_com912" 
			gst_cd.default_where   = "WHERE brand = '" + dw_head.object.brand[1] + "'" + &
			                         "  AND Shop_Stat = '00' and shop_div = 'T' " + &
											 "  AND Shop_cd in (select shop_cd from tb_91130_m with (nolock)) "

//			gst_cd.default_where   = "WHERE shop_div in ('B','E')"
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
				dw_head.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
				/* 다음컬럼으로 이동 */
				dw_head.SetColumn("fr_ymd")
				ib_itemchanged = False 
				lb_check = TRUE 
			END IF
			Destroy  lds_Source		
		
	CASE "style"
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
					dw_body.SetRow(al_row)
					dw_body.SetColumn(as_column)
				END IF
				ls_style_no = lds_Source.GetItemString(1,"style_no")
				dw_head.SetItem(al_row, "style",       LeftA(ls_style_no, 8))					
				dw_head.SetItem(al_row, "chno",        MidA(ls_style_no, 9, 1))

				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("qty")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
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

event ue_retrieve();/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

//il_rows = dw_list.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_counsel_gubn, is_person_nm, is_tel_no2, is_tel_no1, is_card_no, is_jumin_no)
il_rows = dw_list.retrieve(is_brand, is_shop_cd, is_fr_ymd, is_to_ymd, is_style+is_chno)

IF il_rows < 1 THEN
	messagebox('확인','접수건이 없습니다.')
	dw_list.Reset()	
else		
	dw_body.Reset()
   dw_list.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_in_no, ll_no, j
STRING ls_in_no, ls_no, ls_yymmdd, ls_cbit, ls_abit, ls_bbit, ls_style, ls_shop_cd
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_shop_cd = dw_head.getitemstring(1,"shop_cd")

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_yymmdd = dw_body.getitemstring(i, "yymmdd")

   IF idw_status = NewModified! THEN				/* New Record */
		// 의뢰번호 채번
//		SELECT CAST(ISNULL(MAX(IN_NO), '0') AS INT)
//		  INTO :ll_in_no 
//		  FROM tb_53014_d
//		 WHERE YYMMDD = :ls_yymmdd;
//		
//		If SQLCA.SQLCODE <> 0 Then 
//			MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
//			Return -1
//		End If

//		if ls_in_no = 0 then
//			ls_in_no = String(ll_in_no + 1, '0000')
//		else
      //의뢰번호 채번 - 싱가폴만 사용함.
		ls_in_no = String( i, '0000')

//		end if
		
		dw_body.Setitem(i, "in_no", ls_in_no )
		
		ls_style = dw_body.getitemstring(i, "style")

		dw_body.Setitem(i, "shop_cd", ls_shop_cd)
//		dw_body.Setitem(i, "cust_cd", '')
//		dw_body.Setitem(i, "in_gubn", '')
//		dw_body.Setitem(i, "jup_gubn", '')
//		dw_body.Setitem(i, "house_cd", '')
//		dw_body.Setitem(i, "class", '')
		dw_body.Setitem(i, "dc_rate", 0)
		dw_body.Setitem(i, "make_price", 0)
		dw_body.Setitem(i, "real_make_amt", 0)
		dw_body.Setitem(i, "close_yn", '')
		dw_body.Setitem(i, "iwol_yn", '')
		dw_body.Setitem(i, "bill_date", '')
		dw_body.Setitem(i, "bill_no", '')
		dw_body.Setitem(i, "trigger_yn", '')
		dw_body.Setitem(i, "brand", MidA(ls_style,1,1))
		dw_body.Setitem(i, "year", '201' + MidA(ls_style,3,1))
		dw_body.Setitem(i, "season", MidA(ls_style,4,1))
		dw_body.Setitem(i, "item", MidA(ls_style,5,1))
		dw_body.Setitem(i, "sojae", MidA(ls_style,2,1))
		dw_body.Setitem(i, "iche_style", '')
		dw_body.Setitem(i, "iche_chno", '')
		dw_body.Setitem(i, "dlvy_claim", '')
		dw_body.Setitem(i, "qty_chn", 0)
		dw_body.Setitem(i, "pda_no", '')
		dw_body.Setitem(i, "note", '')
		dw_body.Setitem(i, "qty_rus", 0)
		dw_body.Setitem(i, "qty_sing", 0)
				
      dw_body.Setitem(i, "reg_id", gs_user_id)
		dw_body.Setitem(i, "reg_dt", ld_datetime)
		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */		
		ls_style = dw_body.getitemstring(i, "style")
		dw_body.Setitem(i, "dc_rate", 0)
		dw_body.Setitem(i, "make_price", 0)
		dw_body.Setitem(i, "real_make_amt", 0)
		dw_body.Setitem(i, "close_yn", '')
		dw_body.Setitem(i, "iwol_yn", '')
		dw_body.Setitem(i, "bill_date", '')
		dw_body.Setitem(i, "bill_no", '')
		dw_body.Setitem(i, "trigger_yn", '')
		dw_body.Setitem(i, "brand", MidA(ls_style,1,1))
		dw_body.Setitem(i, "year", '201' + MidA(ls_style,3,1))
		dw_body.Setitem(i, "season", MidA(ls_style,4,1))
		dw_body.Setitem(i, "item", MidA(ls_style,5,1))
		dw_body.Setitem(i, "sojae", MidA(ls_style,2,1))
		dw_body.Setitem(i, "iche_style", '')
		dw_body.Setitem(i, "iche_chno", '')
		dw_body.Setitem(i, "dlvy_claim", '')
		dw_body.Setitem(i, "qty_chn", 0)
		dw_body.Setitem(i, "pda_no", '')
		dw_body.Setitem(i, "note", '')
		dw_body.Setitem(i, "qty_rus", 0)
		dw_body.Setitem(i, "qty_sing", 0)
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT


il_rows = dw_body.Update(TRUE, FALSE)
if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	messagebox('완료','자료가 저장되었습니다.')
	This.Trigger Event ue_retrieve()
	This.Trigger Event ue_insert()
else
   rollback  USING SQLCA;
	messagebox('저장요류!','저장이 실패하였습니다!')
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_59005_e","0")
end event

event pfc_preopen();call super::pfc_preopen;//dw_body.InsertRow(0)

end event

event open;call super::open;datetime ld_datetime
String ls_yymmdd

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

ls_yymmdd = string(ld_datetime, "YYYYMMDD")
dw_head.setitem(1, "shop_cd", "")
dw_head.setitem(1, "fr_ymd", MidA(ls_yymmdd,1,6)+"01")
dw_head.setitem(1, "to_ymd", ls_yymmdd)
dw_head.setitem(1, "style", "")
dw_head.setitem(1, "chno", "")




end event

event ue_insert();datetime ld_datetime
String ls_yymmdd
long ll_cnt

if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.reset()
il_rows = dw_body.InsertRow(0)

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
ls_yymmdd = string(ld_datetime, "YYYYMMDD")
dw_body.setitem(1, "yymmdd", ls_yymmdd)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_59005_e
end type

type cb_delete from w_com020_e`cb_delete within w_59005_e
end type

type cb_insert from w_com020_e`cb_insert within w_59005_e
boolean enabled = true
string text = "신규(&A)"
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_59005_e
end type

type cb_update from w_com020_e`cb_update within w_59005_e
end type

type cb_print from w_com020_e`cb_print within w_59005_e
end type

type cb_preview from w_com020_e`cb_preview within w_59005_e
end type

type gb_button from w_com020_e`gb_button within w_59005_e
end type

type cb_excel from w_com020_e`cb_excel within w_59005_e
end type

type dw_head from w_com020_e`dw_head within w_59005_e
integer x = 14
integer y = 152
integer width = 3584
integer height = 192
string dataobject = "D_59005_H01"
end type

event dw_head::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')


end event

event dw_head::itemchanged;CHOOSE CASE dwo.name	
	CASE  "style", "shop_cd_h"//  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

event dw_head::ue_keydown;call super::ue_keydown;/*===========================================================================*/
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
								
//		Choose Case ls_column_name
//			Case "person_nm_h"
//				ls_column_name = "custom_h"
//		End Choose
		ls_column_name = "person_nm_h"
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_59005_e
integer beginy = 352
integer endy = 352
end type

type ln_2 from w_com020_e`ln_2 within w_59005_e
integer beginy = 356
integer endy = 356
end type

type dw_list from w_com020_e`dw_list within w_59005_e
integer x = 5
integer y = 368
integer width = 741
integer height = 1652
string dataobject = "D_59005_D01"
boolean hscrollbar = true
end type

event dw_list::clicked;call super::clicked;

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
//is_seq_no = This.GetItemString(row, 'in_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

//il_rows = dw_body.retrieve(is_yymmdd, is_seq_no)
il_rows = dw_body.retrieve(is_yymmdd)
		
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_59005_e
integer x = 763
integer y = 368
integer width = 2834
integer height = 1652
string dataobject = "D_59005_D03"
end type

event dw_body::itemchanged;call super::itemchanged;string ls_column_nm, ls_style_no, ls_color
dw_body.accepttext()
ls_column_nm = This.GetColumnName()
CHOOSE CASE ls_column_nm
	CASE "yymmdd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "person_nm", "style_no"     //  Popup 검색창이 존재하는 항목 		
//	CASE "person_nm", "style_no", "shop_cd"     //  Popup 검색창이 존재하는 항목 		
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
		
//	case "color"
//			dw_body.setitem(1,'size','')
//			ls_style_no = dw_body.getitemstring(1,"style_no")
//			ls_color = dw_body.getitemstring(1,"color")
//			
//			dw_body.GetChild("size", idw_size)
//			idw_size.SetTransObject(SQLCA)
//			idw_size.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1),ls_color)

			
END CHOOSE

end event

event dw_body::ue_keydown;String ls_column_name, ls_tag, ls_report

ls_column_name = This.GetColumnName()

IF KeyDown(21) THEN
	ls_tag = This.Describe(ls_column_name + ".Tag")
	gf_kor_eng(Handle(Parent), ls_tag, 2)
END IF

CHOOSE CASE key
	CASE KeyEnter!
		If dw_body.GetColumnName() = 'first_counsel' OR dw_body.GetColumnName() = 'first_result' OR dw_body.GetColumnName() = 'second_counsel' OR dw_body.GetColumnName() = 'second_result' Then
			RETURN 0
		else  
			Send(Handle(This), 256, 9, long(0,0))
			Return 1
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0 
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0 
								
//		Choose Case ls_column_name
//			Case "card_no", "jumin_NO", "PERSON_nm"
//				ls_column_name = "custom"
//		End Choose
		ls_column_name = 'PERSON_nm'
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;string ls_column_nm, ls_style_no, ls_color, ls_datetime, ls_first, ls_second, ls_third, ls_abit, ls_bbit
String ls_tag, ls_helpMsg
datetime ld_datetime

ls_column_nm = This.GetColumnName()

ls_tag = This.Describe(ls_column_nm + ".Tag")

gf_kor_eng(Handle(Parent), ls_tag, 1)
this.accepttext()
This.SelectText(1, 3000)

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return
END IF
ls_datetime = string(ld_datetime, "YYYYMMDDHHMMSS")

CHOOSE CASE ls_column_nm
//	CASE "color"
//		ls_style_no = This.GetItemString(row, "style_no")
//		idw_color.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1))
//		idw_color.InsertRow(1)
//		idw_color.SetItem(1, "color", '')
//		idw_color.SetItem(1, "color_enm", '')
//		
//	CASE "size"		
//		ls_style_no = This.GetItemString(row, "style_no")
//		ls_color    = This.GetItemString(row, "color"   )
//		idw_size.Retrieve(Left(ls_style_no, 8), Mid(ls_style_no, 9, 1), ls_color)
//		idw_size.InsertRow(1)
//		idw_size.SetItem(1, "size", '')
//		idw_size.SetItem(1, "size_nm", '')

	case "first_counsel"
		ls_first = dw_body.getitemstring(1,'first_counsel')
		if isnull(ls_first) or trim(ls_first) = '' then
			dw_body.setitem(1, "first_time", ld_datetime)
		end if

	case "second_counsel"
		ls_second = dw_body.getitemstring(1,'second_counsel')
		if isnull(ls_second) or trim(ls_second) = '' then
			dw_body.setitem(1, "second_time", ld_datetime)
		end if
		
	case "third_counsel"
		ls_third = dw_body.getitemstring(1,'third_counsel')
		if isnull(ls_third) or trim(ls_third) = '' then
			dw_body.setitem(1, "third_time", ld_datetime)
		end if
	
END CHOOSE

end event

event dw_body::dberror;//
end event

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report
Long ll_row,i

dw_body.accepttext()

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

int lll_cnt
Choose Case ls_column_nm
	Case "insert_row"
			il_rows = This.InsertRow(0)			
			This.SetColumn(il_rows)
			this.setrow(il_rows)
			this.setfocus()

	Case "delete_row"			
			ll_row = This.GetRow()
			if ll_row <= 0 then return
			idw_status = This.GetItemStatus(ll_row, 0, Primary!)
			il_rows = This.DeleteRow(ll_row)
			This.SetFocus()
			
			Parent.Trigger Event ue_button (4, il_rows)
End Choose

end event

type st_1 from w_com020_e`st_1 within w_59005_e
integer x = 745
integer y = 368
integer width = 325
integer height = 1656
end type

type dw_print from w_com020_e`dw_print within w_59005_e
integer x = 1989
integer y = 396
integer width = 1358
integer height = 560
string dataobject = "d_59005_r01"
end type

