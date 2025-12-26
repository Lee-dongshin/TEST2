$PBExportHeader$w_79019_e.srw
$PBExportComments$상담내역관리
forward
global type w_79019_e from w_com020_e
end type
end forward

global type w_79019_e from w_com020_e
end type
global w_79019_e w_79019_e

type variables
string is_brand, is_fr_ymd, is_to_ymd, is_person_nm, is_counsel_gubn, is_tel_no2, is_tel_no1
STRING IS_CARD_NO, IS_JUMIN_NO, is_seq_no, is_yymmdd
DataWindowChild idw_brand, idw_color, idw_size
end variables

forward prototypes
public function boolean wf_data_chk (ref string as_yymmdd, ref string as_jumin, ref string as_custom_nm)
public function integer wf_style_chk (string as_style, string as_chno, ref string as_year, ref string as_season, ref string as_sojae, ref string as_item, ref string as_st_cust_cd, ref string as_st_cust_nm, ref string as_mat_cust_cd, ref string as_mat_cust_nm, ref string as_mat_cd, ref string as_mat_nm, ref decimal adc_tag_price)
public function integer wf_cust_name_chk (string as_user_name, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm)
public function integer wf_cust_card_chk (string as_card_no, ref string as_jumin, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_cust_jumin_chk (string as_jumin, ref string as_card_no, ref string as_user_name, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3)
public function integer wf_tel_no_chk (string as_tel_no, ref string as_card_no, ref string as_jumin, ref integer ai_sex, ref string as_tel_no1, ref string as_tel_no2, ref string as_tel_no3, ref string as_user_name)
end prototypes

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

public function integer wf_cust_set (string as_style_no, string as_dept_cd, ref string as_cust_cd, ref string as_cust_nm, ref string as_mat_cd, ref string as_mat_nm);
Return 1

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

on w_79019_e.create
call super::create
end on

on w_79019_e.destroy
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
   return false
end if

is_fr_ymd = dw_head.GetItemString(1, "fr_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if

is_to_ymd = dw_head.GetItemString(1, "to_ymd")
if IsNull(is_fr_ymd) or Trim(is_fr_ymd) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("fr_ymd")
   return false
end if


is_person_nm = dw_head.GetItemString(1, "person_nm")
if IsNull(is_person_nm) or Trim(is_person_nm) = "" then
	is_person_nm = "%"
end if

is_card_no = dw_head.GetItemString(1, "card_no")
if IsNull(is_card_no) or Trim(is_card_no) = "" then
	is_card_no = "%"
end if

is_jumin_no = dw_head.GetItemString(1, "jumin_no")
if IsNull(is_jumin_no) or Trim(is_jumin_no) = "" then
	is_jumin_no = "%"
end if

is_counsel_gubn = dw_head.GetItemString(1, "counsel_gubn")
if IsNull(is_counsel_gubn) or Trim(is_counsel_gubn) = "" then
   MessageBox(ls_title,"상담구분을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("counsel_gubn")
   return false
end if

is_tel_no1 = dw_head.GetItemString(1, "tel")
if IsNull(is_tel_no1) or Trim(is_tel_no1) = "" then
	is_tel_no1 = "%"
end if

is_tel_no2 = dw_head.GetItemString(1, "mobile")
if IsNull(is_tel_no2) or Trim(is_tel_no2) = "" then
	is_tel_no2 = "%"
end if

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_card_no, ls_jumin, ls_custom_nm, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_null, ls_tel_no, ls_user_name
String     ls_style_no, ls_year, ls_season, ls_sojae, ls_item, ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, ls_mat_cd, ls_mat_nm
String 	  ls_zipcode, ls_addr	
Integer    li_sex, li_return, li_okyes
Boolean    lb_check
Decimal    ldc_tag_price
DataStore  lds_Source

SetNull(ls_null)

CHOOSE CASE as_column
CASE "custom_h"
			If dw_head.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			ls_card_no   = dw_head.GetItemString(al_row, "card_no_h"  )
			ls_jumin     = dw_head.GetItemString(al_row, "jumin_no_h"    )
			ls_custom_nm = dw_head.GetItemString(al_row, "person_nm_h")
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
				dw_head.SetItem(al_row, "jumin_no_h",     lds_Source.GetItemString(1,"jumin")    )
				dw_head.SetItem(al_row, "person_nm_h", lds_Source.GetItemString(1,"user_name"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
//				dw_head.SetColumn("end_ymd")
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
			
	CASE "jumin_no_h"
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
			
	CASE "person_nm_h"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or Trim(as_data) = "" THEN
					RETURN 0
				END IF 
				IF gf_cust_name_chk(as_data, ls_custom_nm, ls_jumin, ls_card_no) = TRUE THEN
					li_okyes = MessageBox("입력오류", "등록된 이름이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)
					IF li_okyes = 1 THEN	
						dw_head.SetItem(al_row, "card_no_h", ls_card_no)
						dw_head.SetItem(al_row, "jumin_no_h",   ls_jumin  )
						RETURN 0
					else	
						dw_head.SetItem(al_row, "card_no_h", "")
						dw_head.SetItem(al_row, "jumin_no_h",   "")
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
								dw_head.SetItem(al_row, "jumin_no_h",     lds_Source.GetItemString(1,"jumin")    )
								dw_head.SetItem(al_row, "person_nm_h", lds_Source.GetItemString(1,"user_name"))
								/* 다음컬럼으로 이동 */
								cb_retrieve.SetFocus()
				//				dw_head.SetColumn("end_ymd")
								ib_itemchanged = False 
								lb_check = TRUE 
							END IF
							Destroy  lds_Source						
					ELSE
						dw_head.SetItem(al_row, "card_no_h", "")
						dw_head.SetItem(al_row, "jumin_no_h",   "")
						RETURN 0	
					END IF
				END IF 
			END IF

	CASE "custom"
			If dw_body.AcceptText() <> 1 Then Return 1
			
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "회원 코드 검색" 
			gst_cd.datawindow_nm   = "d_com701" 
			gst_cd.default_where   = ""		//WHERE Shop_Stat = '00' 
			ls_card_no   = dw_body.GetItemString(al_row, "card_no"  )
			ls_jumin     = dw_body.GetItemString(al_row, "jumin_no"    )
			ls_custom_nm = dw_body.GetItemString(al_row, "person_nm")
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
				dw_body.SetItem(al_row, "jumin_no",     lds_Source.GetItemString(1, "jumin")      )
				dw_body.SetItem(al_row, "person_nm", lds_Source.GetItemString(1, "user_name")  )
				dw_body.SetItem(al_row, "tel_no1",   lds_Source.GetItemString(1, "tel_no1")    )
				dw_body.SetItem(al_row, "tel_no2",   lds_Source.GetItemString(1, "tel_no3")    )

				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("zipcode")
				ib_itemchanged = False 
				lb_check = TRUE 
				ib_changed = true
				cb_update.enabled = true
				cb_print.enabled = false
				cb_preview.enabled = false
				cb_excel.enabled = false
			END IF
			Destroy  lds_Source
	
	CASE "card_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_cust_card_chk(as_data, ls_jumin, ls_custom_nm, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
				   dw_body.SetItem(al_row, "jumin_no",     ls_jumin      )
				   dw_body.SetItem(al_row, "person_nm", ls_custom_nm  )
				   dw_body.SetItem(al_row, "tel_no1",   ls_tel_no1    )
				   dw_body.SetItem(al_row, "tel_no2",   ls_tel_no3    )
					RETURN 0
				ElseIf li_return = -2 Then
					MessageBox("입력오류", "중복된 카드번호가 있습니다! ~n~r 주민번호를 입력하십시요.")
					RETURN 0
				END IF
			END IF
			
	CASE "jumin_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_cust_jumin_chk(as_data, ls_card_no, ls_custom_nm, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
				   dw_body.SetItem(al_row, "card_no",   ls_card_no    )
				   dw_body.SetItem(al_row, "person_nm", ls_custom_nm  )
				   dw_body.SetItem(al_row, "tel_no1",   ls_tel_no1    )
				   dw_body.SetItem(al_row, "tel_no2",   ls_tel_no3    )
					RETURN 0
				ElseIf LenA(as_data) = 13 Then
					dw_body.SetItem(al_row, "card_no", ls_null)
					RETURN 0
				END IF 
			END IF
			
	CASE "person_nm"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				
				li_return = wf_cust_name_chk(as_data, ls_card_no, ls_jumin, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3)
				IF li_return = 0 THEN
					
					li_okyes = MessageBox("입력오류", "등록된 이름이 있습니다. 기존회원입니까?", Exclamation!, YesNo! , 2)
					IF li_okyes = 1 THEN	
						dw_body.SetItem(al_row, "card_no", ls_card_no    )
						dw_body.SetItem(al_row, "jumin_no",   ls_jumin      )
						dw_body.SetItem(al_row, "tel_no1", ls_tel_no1    )
						dw_body.SetItem(al_row, "tel_no2", ls_tel_no3    )
						RETURN 0
					else
						dw_body.SetItem(al_row, "card_no", ""    )
						dw_body.SetItem(al_row, "jumin_no",   ""      )
						dw_body.SetItem(al_row, "tel_no1", ""    )
						dw_body.SetItem(al_row, "tel_no2", ""    )
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
								dw_body.SetItem(al_row, "person_nm",  lds_Source.GetItemString(1,"user_name")   )								
								dw_body.SetItem(al_row, "card_no",  lds_Source.GetItemString(1,"card_no")   )
								dw_body.SetItem(al_row, "jumin_no",    lds_Source.GetItemString(1,"jumin")     )
								dw_body.SetItem(al_row, "tel_no1",  lds_Source.GetItemString(1,"tel_no1")    )
								dw_body.SetItem(al_row, "tel_no2",  lds_Source.GetItemString(1,"tel_no3")    )
								
								/* 다음컬럼으로 이동 */
								cb_retrieve.SetFocus()
				//				dw_head.SetColumn("end_ymd")
								ib_itemchanged = False 
								lb_check = TRUE 
							END IF
							Destroy  lds_Source						
					ELSE
					
						dw_body.SetItem(al_row, "card_no", ""    )
						dw_body.SetItem(al_row, "jumin_no",   ""      )
						dw_body.SetItem(al_row, "tel_no1", ""    )
						dw_body.SetItem(al_row, "tel_no2", ""    )
						RETURN 0
					
					END IF
					
					
				ElseIf Not(IsNull(as_data) or Trim(as_data) = "") Then
					dw_body.SetItem(al_row, "card_no", ls_null)
					RETURN 0
				END IF 
			END IF
			
	
			
//	CASE "shop_cd"				
//			IF ai_div = 1 THEN 	
//				If IsNull(as_data) or as_data = "" Then
//					dw_body.SetItem(al_row, "shop_nm", "")
//					dw_body.SetItem(al_row, "tel_no", "")					
//					RETURN 0
//				END IF 
//				IF Left(as_data, 1) = is_brand and gf_shop_nm(as_data, 'S', ls_custom_nm) = 0 THEN
//					dw_body.SetItem(al_row, "shop_nm", ls_custom_nm)
//					
//					select tel_no
//					into :ls_tel_no 
//					from tb_91100_m with (nolock)
//					where shop_cd = :as_data;
//
//					dw_body.SetItem(al_row, "tel_no", ls_tel_no)					
//					
//					RETURN 0
//				END IF 
//			END IF
//			gst_cd.ai_div          = ai_div
//			gst_cd.window_title    = "매장 코드 검색" 
//			gst_cd.datawindow_nm   = "d_com918" 
//			gst_cd.default_where   = "WHERE BRAND = '" + is_brand + "' AND SHOP_STAT = '00' "
//			IF Trim(as_data) <> "" THEN
//				gst_cd.Item_where = "SHOP_CD LIKE '" + as_data + "%'"
//			ELSE
//				gst_cd.Item_where = ""
//			END IF
//	
//			lds_Source = Create DataStore
//			OpenWithParm(W_COM200, lds_Source)
//	
//			lb_check = FALSE 
//			IF Isvalid(Message.PowerObjectParm) THEN
//				ib_itemchanged = True
//				lds_Source = Message.PowerObjectParm
//				IF ai_div = 2 THEN
//					dw_body.SetRow(al_row)
//					dw_body.SetColumn(as_column)
//				END IF
//				dw_body.SetItem(al_row, "shop_cd", lds_Source.GetItemString(1,"shop_cd"))
//				dw_body.SetItem(al_row, "shop_nm", lds_Source.GetItemString(1,"shop_snm"))
//				/* 다음컬럼으로 이동 */
//				dw_body.SetColumn("rcv_how")
//				ib_itemchanged = False 
//				lb_check = TRUE 
//				ib_changed = true
//				cb_update.enabled = true
//				cb_print.enabled = false
//				cb_preview.enabled = false
//				cb_excel.enabled = false
//			END IF
//			Destroy  lds_Source
	CASE "style_no"
			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					dw_body.SetItem(al_row, "year",        ls_null)
					dw_body.SetItem(al_row, "season",      ls_null)
					dw_body.SetItem(al_row, "sojae",       ls_null)
					dw_body.SetItem(al_row, "item",        ls_null)
					dw_body.SetItem(al_row, "color",       ls_null)
					dw_body.SetItem(al_row, "size",        ls_null)
					RETURN 0
				END IF 

				IF LeftA(as_data, 1) = is_brand and &
					wf_style_chk(LeftA(as_data, 8), MidA(as_data, 9, 1), &
					             ls_year, ls_season, ls_sojae, ls_item, &
									 ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, &
									 ls_mat_cd, ls_mat_nm, ldc_tag_price) = 0 THEN
					dw_body.SetItem(al_row, "style",        LeftA(as_data, 8))
					dw_body.SetItem(al_row, "chno",        MidA(as_data, 9, 1))					
					dw_body.SetItem(al_row, "year",        ls_year)
					dw_body.SetItem(al_row, "season",      ls_season)
					dw_body.SetItem(al_row, "sojae",       ls_sojae)
					dw_body.SetItem(al_row, "item",        ls_item)
					dw_body.SetItem(al_row, "color",       ls_null)
					dw_body.SetItem(al_row, "size",        ls_null)
					RETURN 0
				END IF 
			END IF
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
				IF wf_style_chk(LeftA(ls_style_no, 8), MidA(ls_style_no, 9, 1), &
				                ls_year, ls_season, ls_sojae, ls_item, &
					             ls_st_cust_cd, ls_st_cust_nm, ls_mat_cust_cd, ls_mat_cust_nm, &
									 ls_mat_cd, ls_mat_nm, ldc_tag_price) = 0 THEN
					dw_body.SetItem(al_row, "style_no",    ls_style_no)
					dw_body.SetItem(al_row, "style",       LeftA(ls_style_no, 8))					
					dw_body.SetItem(al_row, "chno",       MidA(ls_style_no, 9, 1)	)									
					dw_body.SetItem(al_row, "year",        ls_year)
					dw_body.SetItem(al_row, "season",      ls_season)
					dw_body.SetItem(al_row, "sojae",       ls_sojae)
					dw_body.SetItem(al_row, "item",        ls_item)
					dw_body.SetItem(al_row, "color",       ls_null)
					dw_body.SetItem(al_row, "size",        ls_null)
					/* 다음컬럼으로 이동 */
					dw_body.SetColumn("color")
					ib_itemchanged = False 
					lb_check = TRUE 
					ib_changed = true
					cb_update.enabled = true
					cb_print.enabled = false
					cb_preview.enabled = false
					cb_excel.enabled = false
				End If
			END IF
			Destroy  lds_Source

			
	CASE "zipcode"				
			IF ai_div = 1 THEN 	
				IF gf_zipcode_chk(as_data, ls_zipcode, ls_addr) = True THEN
				   dw_body.SetItem(al_row, "zip_code", ls_zipcode)
				   dw_body.SetItem(al_row, "addr", ls_addr)
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
				dw_body.SetRow(al_row)
				dw_body.SetColumn(as_column)
				dw_body.SetItem(al_row, "zip_code", lds_Source.GetItemString(1,"zipcode1"))
				dw_body.SetItem(al_row, "addr",    lds_Source.GetItemString(1,"jiyeok")+" "+lds_Source.GetItemString(1,"gu")+" "+lds_Source.GetItemString(1,"dong"))
				ib_itemchanged = False 
				lb_check = TRUE 
				/* 다음컬럼으로 이동 */
				dw_body.SetColumn("addr_s")
				ib_changed = true
				cb_update.enabled = true
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source		
	
			
CASE "tel_no2"

			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_tel_no_chk(as_data, ls_card_no, ls_jumin, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_user_name)
				IF li_return = 0 THEN
						dw_body.SetItem(al_row, "card_no", ls_card_no    )
						dw_body.SetItem(al_row, "jumin_no",   ls_jumin      )
						dw_body.SetItem(al_row, "person_nm",   ls_user_name)						
						dw_body.SetItem(al_row, "tel_no1", ls_tel_no1    )
						dw_body.SetItem(al_row, "tel_no2", ls_tel_no3    )
						RETURN 0						
				END IF 
						RETURN 0						
			END IF			
			
CASE "mobile"

			IF ai_div = 1 THEN 	
				IF IsNull(as_data) or as_data = "" THEN
					RETURN 0
				END IF 
				li_return = wf_tel_no_chk(as_data, ls_card_no, ls_jumin, li_sex, ls_tel_no1, ls_tel_no2, ls_tel_no3, ls_user_name)
				IF li_return = 0 THEN
						dw_head.SetItem(al_row, "card_no_h", ls_card_no    )
						dw_head.SetItem(al_row, "jumin_no_h",   ls_jumin      )
						dw_head.SetItem(al_row, "person_nm_h",   ls_user_name)						
						RETURN 0						
				END IF 
						RETURN 0						
			END IF			
					
			
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

event ue_retrieve();call super::ue_retrieve;/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_fr_ymd, is_to_ymd, is_brand, is_counsel_gubn, is_person_nm, is_tel_no2, is_tel_no1, is_card_no, is_jumin_no)
IF il_rows > 0 THEN
	dw_body.Reset()
   dw_list.SetFocus()
else	
	dw_list.Reset()	
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count, ll_seq_NO
sTRING LS_SEQ_NO, ls_yymmdd
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_yymmdd = dw_body.getitemstring(i, "yymmdd")
   IF idw_status = NewModified! THEN				/* New Record */
		// 의뢰번호 채번
		SELECT CAST(ISNULL(MAX(SEQ_NO), '0') AS INT)
		  INTO :ll_seq_no
		  FROM TB_79013_d
		 WHERE YYMMDD = :ls_yymmdd
		;
		If SQLCA.SQLCODE <> 0 Then 
			MessageBox("저장오류", "의뢰번호 채번에 실패하였습니다!")
			Return -1
		End If
	
		ls_seq_no = String(ll_seq_no + 1, '0000')

		dw_body.Setitem(1, "seq_no", ls_seq_no )
		dw_body.Setitem(1, "brand" , is_brand  )
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
	This.Trigger Event ue_retrieve()
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_79019_e","0")
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

dw_body.setitem(1, "yymmdd", ls_yymmdd)
end event

event ue_insert();
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN
END IF

dw_body.reset()
il_rows = dw_body.InsertRow(0)
dw_body.setitem(1,'counsel_empno', gs_user_id)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

type cb_close from w_com020_e`cb_close within w_79019_e
end type

type cb_delete from w_com020_e`cb_delete within w_79019_e
end type

type cb_insert from w_com020_e`cb_insert within w_79019_e
boolean enabled = true
string text = "신규(&A)"
end type

type cb_retrieve from w_com020_e`cb_retrieve within w_79019_e
end type

type cb_update from w_com020_e`cb_update within w_79019_e
end type

type cb_print from w_com020_e`cb_print within w_79019_e
end type

type cb_preview from w_com020_e`cb_preview within w_79019_e
end type

type gb_button from w_com020_e`gb_button within w_79019_e
end type

type cb_excel from w_com020_e`cb_excel within w_79019_e
end type

type dw_head from w_com020_e`dw_head within w_79019_e
integer y = 156
integer height = 268
string dataobject = "D_79019_H01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE  "card_no_h", "jumin_no_h", "person_nm_h", "mobile", "tel"	//  Popup 검색창이 존재하는 항목 
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
								
		Choose Case ls_column_name
			Case "card_no_h", "jumin__noh", "person_nm_h"
				ls_column_name = "custom_h"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

type ln_1 from w_com020_e`ln_1 within w_79019_e
end type

type ln_2 from w_com020_e`ln_2 within w_79019_e
end type

type dw_list from w_com020_e`dw_list within w_79019_e
integer x = 5
integer width = 1047
string dataobject = "D_79019_D01"
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
is_seq_no = This.GetItemString(row, 'seq_no') /* DataWindow에 Key 항목을 가져온다 */

IF IsNull(is_yymmdd) or IsNull(is_seq_no) THEN return

il_rows = dw_body.retrieve(is_yymmdd, is_seq_no)
		
Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_e`dw_body within w_79019_e
integer x = 1074
integer width = 2528
string dataobject = "D_79019_D02"
end type

event dw_body::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
	CASE "yymmdd"
    IF gf_datechk(data) = False THEN Return 1
	CASE "card_no", "jumin_no", "person_nm", "mobile","style_no"     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
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
								
		Choose Case ls_column_name
			Case "card_no", "jumin_NO", "PERSON_nm"
				ls_column_name = "custom"
		End Choose
		
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event dw_body::itemfocuschanged;call super::itemfocuschanged;string ls_column_nm, ls_style_no, ls_color
String ls_tag, ls_helpMsg

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

event dw_body::constructor;call super::constructor;This.GetChild("color", idw_color)
idw_color.SetTransObject(SQLCA)
idw_color.InsertRow(0)


This.GetChild("size", idw_size)
idw_size.SetTransObject(SQLCA)
idw_size.InsertRow(0)


end event

event dw_body::dberror;//
end event

type st_1 from w_com020_e`st_1 within w_79019_e
integer x = 1056
end type

type dw_print from w_com020_e`dw_print within w_79019_e
end type

