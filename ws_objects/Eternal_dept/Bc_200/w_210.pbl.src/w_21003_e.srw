$PBExportHeader$w_21003_e.srw
$PBExportComments$원자재 발주등록
forward
global type w_21003_e from w_com010_e
end type
type dw_master from datawindow within w_21003_e
end type
type dw_rate from datawindow within w_21003_e
end type
type dw_model from datawindow within w_21003_e
end type
type dw_1 from datawindow within w_21003_e
end type
type dw_2 from datawindow within w_21003_e
end type
end forward

global type w_21003_e from w_com010_e
integer width = 3689
integer height = 2296
dw_master dw_master
dw_rate dw_rate
dw_model dw_model
dw_1 dw_1
dw_2 dw_2
end type
global w_21003_e w_21003_e

type variables
DataWindowChild idw_price_claim
String is_mat_cd 
String is_brand, is_year, is_season, is_sojae, is_sojae_gubn

end variables

forward prototypes
public function long wf_gram_to_ons (long al_ons)
public function boolean wf_mat_chk (string as_mat_cd)
end prototypes

public function long wf_gram_to_ons (long al_ons);long ll_gram

ll_gram = round(al_ons * 28.3496,0)
return ll_gram

end function

public function boolean wf_mat_chk (string as_mat_cd);// 원자재 코드 CHECK
String ls_year_cd, ls_nm 

IF isnull(as_mat_cd) OR LenA(as_mat_cd) <> 10 THEN Return False

// 자재 구분
IF MidA(as_mat_cd, 2, 1) <> '1' THEN Return False 

// 브랜드 
is_brand  = MidA(as_mat_cd, 1, 1)
IF gf_inter_nm('001', is_brand, ls_nm) <> 0 THEN Return False 
//시즌년도 
ls_year_cd   = MidA(as_mat_cd, 3, 1)
IF gf_inter_nm('002', ls_year_cd, ls_nm) <> 0 THEN Return False 
gf_get_inter_sub('002', ls_year_cd, '1', is_year)

// 시즌 
is_season = MidA(as_mat_cd, 4, 1)
IF gf_inter_nm('003', is_season, ls_nm) <> 0 THEN Return False 

is_sojae  = MidA(as_mat_cd, 5, 1)
IF gf_sojae_nm(is_sojae, ls_nm) <> 0 THEN Return False 

Return True
end function

on w_21003_e.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_rate=create dw_rate
this.dw_model=create dw_model
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_rate
this.Control[iCurrent+3]=this.dw_model
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
end on

on w_21003_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
destroy(this.dw_rate)
destroy(this.dw_model)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(dw_rate, "ScaleToRight")
inv_resize.of_Register(dw_model, "ScaleToRight")
inv_resize.of_Register(dw_1, "ScaleToBottom")

dw_master.SetTransObject(SQLCA)
dw_rate.SetTransObject(SQLCA)
dw_model.SetTransObject(SQLCA)
dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

dw_master.InsertRow(0)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
String     ls_mat_nm, ls_cust_nm, ls_emp_nm 
Boolean    lb_check 
DataStore  lds_Source 

CHOOSE CASE as_column
	CASE "mat_cd"				
			IF ai_div = 1 THEN 	
				IF gf_mat_nm(as_data, ls_mat_nm) = 0 THEN
					RETURN 0
				END IF 
				IF wf_mat_chk(as_data) THEN
					RETURN 0 
				ELSEIF LenA(as_data) = 10 THEN 
					MessageBox("오류", "원자재 코드가 형식에 맞지안습니다 !")
					Return 1
				END IF
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "원자재코드 검색" 
			gst_cd.datawindow_nm   = "d_com020" 
			gst_cd.default_where   = ""
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "mat_cd LIKE '" + as_data + "%'"
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
				dw_head.SetItem(al_row, "mat_cd", lds_Source.GetItemString(1,"mat_cd"))
				/* 다음컬럼으로 이동 */
				cb_retrieve.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "cust_cd"				
			IF ai_div = 1 and as_data = '' or isnull(as_data) then 
				return 0
//			elseIF ai_div = 1 THEN 	
//				IF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
//					dw_master.Setitem(al_row, "cust_nm", ls_cust_nm)
//					RETURN 0
//				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 

					gst_cd.default_where   = "Where change_gubn = '00' "      + &
													 "  and cust_code between '5000' and '8999'"


			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (custcode LIKE '" + as_data + "%' or cust_sname like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "cust_cd",    lds_Source.GetItemString(1,"custcode"))
				dw_master.SetItem(al_row, "cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_master.SetColumn("ord_dlvy")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "ord_emp"				

			IF ai_div = 1 THEN 	
				IF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_master.Setitem(al_row, "ord_emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1'"
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = " (empno LIKE '" + as_data + "%' or kname like '%" + as_data + "%')"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "ord_emp",    lds_Source.GetItemString(1,"empno"))
				dw_master.SetItem(al_row, "ord_emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_rate.SetFocus()
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source

		CASE "req_cust"				
		

			IF ai_div = 1 THEN 	
				if LenA(as_data) = 0 then				
				elseIF gf_cust_nm(as_data, 'S', ls_cust_nm) = 0 THEN
					dw_master.Setitem(al_row, "req_cust_nm", ls_cust_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "거래처코드 검색" 
			gst_cd.datawindow_nm   = "d_com911" 
			
			if as_data = '9111' then
				gst_cd.default_where   = "Where change_gubn = '00'  "
			elseif  LeftA(is_mat_cd ,1) = 'O' or LeftA(is_mat_cd ,1) = 'Y' then
  			    gst_cd.default_where   = "Where change_gubn = '00' and ((cust_code between '5000' and '8999' and brand = 'O') or cust_code = '9111') " 				
			else
 			    gst_cd.default_where   = "Where change_gubn = '00' and ((cust_code between '5000' and '8999' and brand = 'N') or cust_code = '9111') "				
			end if
			
			
// 			    gst_cd.default_where   = "Where ((cust_code between '5000' and '8999' and brand = 'N') or cust_code = '9111') "
//         elseif  left(is_mat_cd ,1) = 'J'  then				  
//  			    gst_cd.default_where   = "Where ((cust_code between '5000' and '8999' and brand in ('N','J')) or cust_code = '9111') " 
//			elseif  left(is_mat_cd ,1) = 'Y'  then				  		
//  			    gst_cd.default_where   = "Where ((cust_code between '5000' and '8999' and brand in ('O','Y')) or cust_code = '9111') " 
//   		elseif left(is_mat_cd ,1) = 'O'  then				  				
// 			    gst_cd.default_where   = "Where ((cust_code between '5000' and '8999' and brand = 'O') or cust_code = '9111') "	
//			else	  
// 			    gst_cd.default_where   = "Where ((cust_code between '5000' and '8999' ) or cust_code = '9111') "		
//			end if	  
					
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "custcode LIKE '%" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "req_cust",    lds_Source.GetItemString(1,"custcode"))
				dw_master.SetItem(al_row, "req_cust_nm", lds_Source.GetItemString(1,"cust_sname"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_master.SetColumn("req_dlvy")
				ib_itemchanged = False 
				lb_check = TRUE 
			ELSE
				lb_check = FALSE 
			END IF
			Destroy  lds_Source
	CASE "req_emp"				
			IF ai_div = 1 THEN 	
				if LenA(as_data) = 0 then
				elseIF gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_master.Setitem(al_row, "req_emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1'"
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%'"
			ELSE
				gst_cd.Item_where = ""
			END IF

			lds_Source = Create DataStore
			OpenWithParm(W_COM200, lds_Source)

			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				dw_master.SetRow(al_row)
				dw_master.SetColumn(as_column)
				dw_master.SetItem(al_row, "req_emp",    lds_Source.GetItemString(1,"empno"))
				dw_master.SetItem(al_row, "req_emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_master.TriggerEvent(Editchanged!)
				dw_rate.SetFocus()
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

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
string ls_claim_agree
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

dw_body.retrieve(is_mat_cd)
dw_rate.retrieve(is_mat_cd) 
dw_model.retrieve(is_mat_cd)

il_rows = dw_master.retrieve(is_mat_cd,gs_user_id)
IF il_rows = 0 THEN 
		
	This.Post Event ue_insert()
ELSEIF il_rows = 1 THEN
	is_brand  = dw_master.GetitemString(1, "brand")
	is_year   = dw_master.GetitemString(1, "mat_year")
	is_season = dw_master.GetitemString(1, "mat_season")
	is_sojae  = dw_master.GetitemString(1, "mat_sojae")
END IF

dw_1.Retrieve(is_brand, is_year, is_season, is_sojae_gubn)

This.Trigger Event ue_button(1, il_rows)

ls_claim_agree = dw_master.getitemstring(1,"claim_agree")
if ls_claim_agree = 'Y' then 
	cb_print.enabled = true
else 
	cb_print.enabled = false
end if
		
This.Trigger Event ue_msg(1, il_rows)

end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
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

is_mat_cd = dw_head.GetItemString(1, "mat_cd")
if IsNull(is_mat_cd) or Trim(is_mat_cd) = "" then
   MessageBox(ls_title,"원자재 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("mat_cd")
   return false
end if

is_sojae_gubn = dw_head.GetItemString(1, "sojae_gubn")

return true

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         dw_master.Enabled = true
//         dw_rate.Enabled   = true
//         dw_model.Enabled  = true
         dw_master.SetFocus()
      end if
   CASE 2   /* 추가 */
      if al_rows > 0 then
         dw_master.Enabled = true
//         dw_rate.Enabled   = true
//         dw_model.Enabled  = true
         dw_body.Enabled  = true
         dw_master.SetFocus()
		end if
   CASE 5    /* 조건 */
      dw_master.Enabled = false
//      dw_rate.Enabled   = false
//      dw_model.Enabled  = false
END CHOOSE

end event

event ue_insert();datetime ld_datetime
String   ls_year

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN 
	Return 
END IF

dw_master.Reset()
il_rows = dw_master.insertRow(0)
dw_master.Setitem(1, "brand",      is_brand)

dw_master.Setitem(1, "mat_year",   is_year)
dw_master.Setitem(1, "mat_season", is_season)
dw_master.Setitem(1, "mat_sojae",  is_sojae)
dw_master.Setitem(1, "mat_chno",   MidA(is_mat_cd, 10, 1))
dw_master.Setitem(1, "req_ymd",    String(ld_datetime, "yyyymmdd"))
dw_master.Setitem(1, "status_fg",  "00")
dw_master.Enabled = True

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event type long ue_update();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String ls_brand, ls_year, ls_season, ls_sojae, ls_chno, ls_out_seq

IF dw_master.AcceptText() <> 1 THEN RETURN -1
IF dw_rate.AcceptText()   <> 1 THEN RETURN -1
IF dw_model.AcceptText()  <> 1 THEN RETURN -1
IF dw_body.AcceptText()   <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

// 원료별 혼용율 체크 
IF dw_rate.RowCount() > 0 THEN  
   IF Long(dw_rate.Describe("evaluate('sum(orgmat_rate)',0)")) <> 100 THEN 
		MessageBox("오류", "혼용율이 100% 되여야 합니다.")
		dw_rate.SetFocus()
		RETURN 0
	END IF
END IF

// 원자재 발주 마스터 
ll_row_count = dw_master.RowCount()
idw_status = dw_master.GetItemStatus(1, 0, Primary!)
IF idw_status = NewModified! THEN				/* New Record */
   dw_master.Setitem(1, "mat_cd", is_mat_cd)
   dw_master.Setitem(1, "reg_id", gs_user_id)
ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   dw_master.Setitem(1, "mod_id", gs_user_id)
   dw_master.Setitem(1, "mod_dt", ld_datetime)
END IF

ls_brand   = dw_master.GetitemString(1, "brand")
ls_year    = dw_master.GetitemString(1, "mat_year")
ls_season  = dw_master.GetitemString(1, "mat_season")
ls_sojae   = dw_master.GetitemString(1, "mat_sojae")
ls_chno    = dw_master.GetitemString(1, "mat_chno")
ls_out_seq = dw_master.GetitemString(1, "out_seq")

// 원자재 발주 상세 
ll_row_count = dw_body.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "mat_cd", is_mat_cd)
      dw_body.Setitem(i, "brand", ls_brand)
      dw_body.Setitem(i, "mat_year", ls_year)
      dw_body.Setitem(i, "mat_season", ls_season) 
      dw_body.Setitem(i, "mat_sojae", ls_sojae)
      dw_body.Setitem(i, "mat_chno", ls_chno)
      dw_body.Setitem(i, "out_seq", ls_out_seq)
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

// 원자재 원료별 혼용율
ll_row_count = dw_rate.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_rate.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_rate.Setitem(i, "mat_cd", is_mat_cd)
      dw_rate.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_rate.Setitem(i, "mod_id", gs_user_id)
      dw_rate.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

// 원자재 모델수 
ll_row_count = dw_model.RowCount()
FOR i=1 TO ll_row_count
   idw_status = dw_model.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_model.Setitem(i, "mat_cd", is_mat_cd)
      dw_model.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN	      /* Modify Record */
      dw_model.Setitem(i, "mod_id", gs_user_id)
      dw_model.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT

il_rows = dw_master.Update(TRUE, FALSE)
IF il_rows = 1 THEN
	il_rows = dw_body.Update(TRUE, FALSE) 
   IF il_rows = 1 THEN
      il_rows = dw_rate.Update(TRUE, FALSE)
      IF il_rows = 1 THEN
         il_rows = dw_model.Update(TRUE, FALSE) 
		END IF
	END IF
END IF

if il_rows = 1 then
   dw_master.ResetUpdate()
   dw_body.ResetUpdate()
   dw_rate.ResetUpdate()
   dw_model.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.12.07																  */	
/* 수정일      : 2002.12.07																  */
/*===========================================================================*/
long    ll_return,   ll_row, i 
Decimal ldc_ord_qty, ldc_in_qty

ll_row = dw_body.RowCount() 
For i = 1 TO ll_row 
//   ldc_ord_qty = dw_body.GetitemDecimal(i, "ord_qty") 
   ldc_in_qty  = dw_body.GetitemDecimal(i, "in_qty") 
	IF ldc_in_qty <> 0 THEN 
		MessageBox("경고", "삭제할수 없는 자료입니다.")
		Return 
	END IF
Next 

idw_status = dw_master.GetItemStatus (1, 0, primary!)	
ll_return  = MessageBox("확인", is_mat_cd + ' 내역을 전체 삭제하시겠습니까?', &
		                  Question!, YesNo!)

IF ll_return <> 1 THEN Return 

dw_rate.RowsMove(1, dw_rate.RowCount(), Primary!, dw_rate, 1, Delete!)
dw_model.RowsMove(1, dw_model.RowCount(), Primary!, dw_model, 1, Delete!)
dw_body.RowsMove(1, dw_body.RowCount(), Primary!, dw_body, 1, Delete!)
dw_master.RowsMove(1, dw_master.RowCount(), Primary!, dw_master, 1, Delete!)

il_rows = dw_master.Update(TRUE, FALSE)
IF il_rows = 1 THEN
	il_rows = dw_body.Update(TRUE, FALSE) 
   IF il_rows = 1 THEN
      il_rows = dw_rate.Update(TRUE, FALSE)
      IF il_rows = 1 THEN
         il_rows = dw_model.Update(TRUE, FALSE) 
		END IF
	END IF
END IF

if il_rows = 1 then
   dw_master.ResetUpdate()
   dw_body.ResetUpdate()
   dw_rate.ResetUpdate()
   dw_model.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)

end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/
datetime ld_datetime
string ls_modify, ls_datetime, ls_brand_nm 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

gf_inter_nm('001', is_brand, ls_brand_nm)

ls_modify =	"t_brand1.Text = '" + ls_brand_nm + "'" + &
            "t_brand2.Text = '" + ls_brand_nm + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()

dw_print.Modify("DataWindow.Print.Copies = 3")
dw_print.Retrieve(is_mat_cd)
dw_print.inv_printpreview.of_SetZoom()

end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title()

dw_2.Retrieve(is_mat_cd)

IF dw_2.RowCount() = 0 Then
   MessageBox("인쇄오류","인쇄할 자료가 없습니다!")
   il_rows = 0
ELSE
	dw_2.visible = true
   //il_rows = dw_2.Print()
END IF
This.Trigger Event ue_msg(6, il_rows)

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_21003_e","0")
end event

type cb_close from w_com010_e`cb_close within w_21003_e
integer taborder = 140
end type

type cb_delete from w_com010_e`cb_delete within w_21003_e
integer x = 1047
integer width = 384
integer taborder = 90
string text = "전체삭제(&D)"
end type

type cb_insert from w_com010_e`cb_insert within w_21003_e
boolean visible = false
integer taborder = 70
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_21003_e
end type

type cb_update from w_com010_e`cb_update within w_21003_e
integer taborder = 130
end type

type cb_print from w_com010_e`cb_print within w_21003_e
integer width = 494
integer taborder = 100
string text = "클레임동의서(&P)"
end type

type cb_preview from w_com010_e`cb_preview within w_21003_e
integer x = 1920
integer taborder = 110
end type

type gb_button from w_com010_e`gb_button within w_21003_e
end type

type cb_excel from w_com010_e`cb_excel within w_21003_e
boolean visible = false
integer x = 2263
integer taborder = 120
end type

type dw_head from w_com010_e`dw_head within w_21003_e
integer y = 160
integer height = 124
string dataobject = "d_12001_h01"
end type

event dw_head::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "mat_cd"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_21003_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com010_e`ln_2 within w_21003_e
integer beginy = 296
integer endy = 296
end type

type dw_body from w_com010_e`dw_body within w_21003_e
integer x = 1061
integer y = 1724
integer width = 2546
integer height = 332
integer taborder = 60
boolean enabled = false
string dataobject = "d_21003_d02"
boolean hscrollbar = true
end type

event dw_body::buttonclicked;call super::buttonclicked;decimal ldc_ord_qty, ldc_in_qty 

IF row < 1 THEN RETURN

IF dwo.name = "b_delete" THEN 
//	ldc_ord_qty = This.GetitemDecimal(row, "ord_qty")
	ldc_in_qty  = This.GetitemDecimal(getrow(), "in_qty") 
	IF ldc_in_qty <> 0 THEN 
		MessageBox("경고", "삭제할수 없는 자료입니다")
	ELSE
      idw_status = This.GetItemStatus (getrow(), 0, primary!)	
		il_rows = This.DeleteRow(getrow()) 
      Parent.Trigger Event ue_button(4, il_rows) 
      Parent.Trigger Event ue_msg(4, il_rows) 
	END IF 
END IF 


end event

type dw_print from w_com010_e`dw_print within w_21003_e
string dataobject = "d_12001_r01"
end type

type dw_master from datawindow within w_21003_e
event ue_keydown pbm_dwnkey
integer x = 9
integer y = 304
integer width = 2437
integer height = 1404
integer taborder = 30
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_21003_d01"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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

event constructor;DataWindowChild ldw_child

This.GetChild("unit", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('004')

This.GetChild("patt_type", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('020')

This.GetChild("country_cd", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('000')

This.GetChild("Out_Seq", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('010')

This.GetChild("brand", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('001')

//라빠레트 시즌적용
is_brand = dw_master.getitemstring(1,'brand')
is_year = dw_master.getitemstring(1,'year')

this.getchild("mat_season",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('003', is_brand, is_year)
//idw_season.retrieve('003')

This.GetChild("mat_sojae", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('%', is_brand)
/*
This.GetChild("mat_season", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('003')

This.GetChild("mat_sojae", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('%')
*/
This.GetChild("status_fg", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('201')

This.GetChild("pay_gubn", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('007')


end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

end event

event editchanged;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
long ll_gram
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

CHOOSE CASE dwo.name

	CASE "ord_dlvy" 
 		IF gf_datechk(data) = FALSE THEN
			Return 1
		END IF
	CASE "cust_cd", "ord_emp"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
	case "gram_per_ons"		
		ll_gram = wf_gram_to_ons(long(data))
		this.setitem(1,"gram_per_yad",ll_gram)
	CASE "req_dlvy" 
 		IF gf_datechk(data) = FALSE THEN
			Return 1
		END IF
	CASE "req_cust", "req_emp"
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)		
END CHOOSE

end event

event buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
string ls_column_nm, ls_column_value, ls_report

IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)

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

type dw_rate from datawindow within w_21003_e
event ue_keydown pbm_dwnkey
integer x = 2446
integer y = 304
integer width = 1157
integer height = 680
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_21003_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event constructor;DataWindowChild ldw_child

This.GetChild("OrgMat_Cd", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve('021')

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

end event

event editchanged;/*===========================================================================*/
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

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event buttonclicked;IF row < 1 THEN RETURN

IF dwo.name = "b_delete" THEN 
   idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = This.DeleteRow(row) 
   Parent.Trigger Event ue_button(4, il_rows) 
   Parent.Trigger Event ue_msg(4, il_rows) 
END IF 



end event

type dw_model from datawindow within w_21003_e
event ue_keydown pbm_dwnkey
integer x = 2446
integer y = 988
integer width = 1157
integer height = 628
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_21003_d04"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
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
		ls_report = This.Describe(ls_column_name + ".Protect")
		IF ls_report = "1" THEN RETURN 0
		ls_report = MidA(ls_report, 4, LenA(ls_report) - 4)
		IF This.Describe("Evaluate(~"" + ls_report + "~", " + &
								String(This.GetRow()) + ")") = '1' THEN RETURN 0
		Parent.Trigger Event ue_popup (ls_column_name, This.GetRow(), This.GetText(), 2)
END CHOOSE

end event

event itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.01.04                                                  */	
/* 수정일      : 2002.01.04                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

end event

event dberror;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
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

end event

event editchanged;/*===========================================================================*/
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

event constructor;DataWindowChild ldw_child

This.GetChild("item", ldw_child)
ldw_child.SetTransObject(SQLCA) 
ldw_child.Retrieve()

end event

event buttonclicked;IF row < 1 THEN RETURN

IF dwo.name = "b_delete" THEN 
   idw_status = This.GetItemStatus (row, 0, primary!)	
	il_rows = This.DeleteRow(row) 
   Parent.Trigger Event ue_button(4, il_rows) 
   Parent.Trigger Event ue_msg(4, il_rows) 
END IF 

end event

type dw_1 from datawindow within w_21003_e
integer x = 27
integer y = 1716
integer width = 1010
integer height = 332
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_12001_d99"
boolean border = false
boolean livescroll = true
end type

type dw_2 from datawindow within w_21003_e
boolean visible = false
integer x = 265
integer y = 780
integer width = 3351
integer height = 1568
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "사후클레임 동의서"
string dataobject = "d_21003_r01"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;cb_print.visible = false
il_rows = dw_2.Print()
cb_print.visible = true
end event

