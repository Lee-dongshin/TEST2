$PBExportHeader$w_sh370_e.srw
$PBExportComments$연말정산등록
forward
global type w_sh370_e from w_com010_e
end type
type dw_dedu from datawindow within w_sh370_e
end type
type st_2 from statictext within w_sh370_e
end type
type shl_1 from statichyperlink within w_sh370_e
end type
type shl_2 from statichyperlink within w_sh370_e
end type
type dw_pension from datawindow within w_sh370_e
end type
type dw_house from datawindow within w_sh370_e
end type
type dw_donate from datawindow within w_sh370_e
end type
end forward

global type w_sh370_e from w_com010_e
integer width = 4603
integer height = 2936
event ue_tot_set ( )
dw_dedu dw_dedu
st_2 st_2
shl_1 shl_1
shl_2 shl_2
dw_pension dw_pension
dw_house dw_house
dw_donate dw_donate
end type
global w_sh370_e w_sh370_e

type variables
string is_year, is_empno, is_opt,is_timer
decimal idc_keep_dedu, idc_keep_70_dedu,idc_hitch_dedu,idc_child_rearm_dedu,idc_keep_child_dedu
decimal idc_insu_amt1, idc_credit_card, idc_debit_card, idc_pay_card,idc_credit_culture, idc_debit_culture, idc_cash_culture,idc_zero_culture
decimal idc_medim_self, idc_medim_hitch_revivm, idc_medim_old, idc_medim_comm, idc_trngm_me,	idc_trngm_handi
decimal idc_court_fund, idc_appo_fund, idc_full_apply_fund, idc_priv_school_fund, idc_religious_fund, idc_zero_pay
decimal idc_credit_tmarket, idc_trngm_bisock, idc_wife, idc_single_parent_dedu, idc_credit_traffic, idc_born_dedu
end variables

event ue_tot_set();//decimal ldc_keep_dedu, ldc_keep_70_dedu,ldc_hitch_dedu,ldc_child_rearm_dedu,ldc_keep_child_dedu
//decimal ldc_insu_amt1, ldc_credit_card, ldc_debit_card, ldc_pay_card
//decimal idc_medim_self, idc_medim_hitch_revivm, idc_medim_old, idc_medim_comm, idc_trngm_me,	idc_trngm_handi
long ll_row_cnt

 dw_dedu.AcceptText() 

 idc_wife = dw_dedu.object.t_wife[1] //기본공제
 idc_keep_dedu = dw_dedu.object.t_base_deduc[1] //기본공제
 idc_keep_70_dedu = dw_dedu.object.t_keep_old[1] // 경로우내
 idc_hitch_dedu = dw_dedu.object.t_hitch_deduc[1] // 경로우내
 idc_child_rearm_dedu = dw_dedu.object.t_rearing_deduc[1] // 자녀양육비대상
 idc_keep_child_dedu = dw_dedu.object.t_keep_child_dedu[1] // 다자녀
 idc_single_parent_dedu = dw_dedu.object.t_single_parent_deduc[1] // 한부모
 
 idc_insu_amt1 = dw_dedu.object.t_insu_nta[1] // 보장성보험료
 idc_credit_card = dw_dedu.object.t_credit_nta[1] // 신용카드
 idc_debit_card  = dw_dedu.object.t_debit_nta[1] // 직불카드
 idc_pay_card  = dw_dedu.object.t_cash_nta[1] // 직불카드 
 idc_zero_pay  = dw_dedu.object.t_zeropay[1] // 직불카드 
 
 
 idc_credit_tmarket = dw_dedu.object.t_credit_tmarket_nta[1] // 전통시장사용분
 idc_credit_traffic = dw_dedu.object.t_credit_traffic_nta[1] // 대중교통사용분
 idc_credit_culture = dw_dedu.object.t_credit_culture_nta[1] // 대중교통사용분
 idc_credit_culture = dw_dedu.object.t_credit_culture_nta[1] // 도서문화사용 신용카드분분
 idc_debit_culture = dw_dedu.object.t_debit_culture_nta[1] // 도서문화사용 직불카드분
 idc_cash_culture = dw_dedu.object.t_cash_culture_nta[1] // 도서문화사용 현금분  
 idc_zero_culture = dw_dedu.object.t_zero_culture_nta[1] // 도서문화사용 제로페이    
  
 
 idc_medim_self = dw_dedu.object.t_medi_nta00[1] // 본인의료비 
 idc_medim_hitch_revivm = dw_dedu.object.t_medi_nta_hitch[1] // 장애인의료비
 idc_medim_old = dw_dedu.object.t_medi_nta_65[1] // 65세이상의료비
 idc_medim_comm = dw_dedu.object.t_etc_medi[1] // 일반부양가족의료비
 idc_trngm_me = dw_dedu.object.t_train_nta00[1] // 본인교육비
 idc_trngm_handi = dw_dedu.object.t_train_nta04[1] // 장애인교육비
 idc_trngm_bisock = dw_dedu.object.t_train_bisock[1] // 기본공제자교육비
 idc_born_dedu = dw_dedu.object.t_born_deduc[1] // 출생입양
 
 
 if idc_wife > 0 then 
  	dw_body.setitem(1, "wife_dedu", "1")
 else
	dw_body.setitem(1, "wife_dedu", "0")
 end if	
 
 if idc_single_parent_dedu > 0 then
  	dw_body.setitem(1, "single_parent_dedu", "Y")
 else
  	dw_body.setitem(1, "single_parent_dedu", "N")
 end if	
 
  dw_body.setitem(1, "hitch_dedu", idc_hitch_dedu)
 dw_body.setitem(1, "child_rearm_dedu", idc_child_rearm_dedu)
 dw_body.setitem(1, "keep_dedu", idc_keep_dedu)
 dw_body.setitem(1, "keep_70_dedu", idc_keep_70_dedu)
 dw_body.setitem(1, "keep_child_dedu", idc_keep_child_dedu)
 dw_body.setitem(1, "insu_amt1", idc_insu_amt1)
 
 dw_body.setitem(1, "credit_card", idc_credit_card)
 dw_body.setitem(1, "debit_card", idc_debit_card)
 dw_body.setitem(1, "pay_card", idc_pay_card)
 
 dw_body.setitem(1, "credit_tmarket", idc_credit_tmarket)   
 dw_body.setitem(1, "credit_traffic", idc_credit_traffic)   
 
 dw_body.setitem(1, "credit_culture", idc_credit_culture)   
 dw_body.setitem(1, "debit_culture", idc_debit_culture)   
 dw_body.setitem(1, "cash_culture", idc_cash_culture)    
  dw_body.setitem(1, "zero_culture", idc_zero_culture)     
 
 
 dw_body.setitem(1, "medim_self", idc_medim_self)  
 dw_body.setitem(1, "medim_hitch_revivm", idc_medim_hitch_revivm)
 dw_body.setitem(1, "medim_old", idc_medim_old) 
 dw_body.setitem(1, "medim_comm", idc_medim_comm)
 dw_body.setitem(1, "trngm_me", idc_trngm_me)
 dw_body.setitem(1, "trngm_handi", idc_trngm_handi) 
 dw_body.setitem(1, "trngm_bisok", idc_trngm_bisock)  
 dw_body.setitem(1, "born_dedu", idc_born_dedu)    
 

  ll_row_cnt = dw_donate.rowcount()
 
 if ll_row_cnt > 0 then
// decimal idc_court_fund, idc_appo_fund, idc_full_apply_fund, idc_priv_school_fund, idc_religious_fund
  idc_court_fund = dw_donate.object.court_fund_c[1] // 정치자금
  idc_appo_fund = dw_donate.object.appo_fund_c[1] // 특례
  idc_full_apply_fund = dw_donate.object.full_apply_fund_c[1] // 법정기부
  idc_priv_school_fund = dw_donate.object.priv_school_fund_c[1] // 종교단체외
  idc_religious_fund = dw_donate.object.religious_fund_c[1] // 종교단체
 else  
  idc_court_fund = 0
  idc_appo_fund = 0
  idc_full_apply_fund = 0
  idc_priv_school_fund = 0
  idc_religious_fund = 0
 end if  
  dw_body.setitem(1, "court_fund", idc_court_fund) 
  dw_body.setitem(1, "appo_fund", idc_appo_fund) 
  dw_body.setitem(1, "full_apply_fund", idc_full_apply_fund) 
  dw_body.setitem(1, "priv_school_fund", idc_priv_school_fund) 
  dw_body.setitem(1, "religious_fund", idc_religious_fund)   

 
Return




end event

on w_sh370_e.create
int iCurrent
call super::create
this.dw_dedu=create dw_dedu
this.st_2=create st_2
this.shl_1=create shl_1
this.shl_2=create shl_2
this.dw_pension=create dw_pension
this.dw_house=create dw_house
this.dw_donate=create dw_donate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dedu
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.shl_1
this.Control[iCurrent+4]=this.shl_2
this.Control[iCurrent+5]=this.dw_pension
this.Control[iCurrent+6]=this.dw_house
this.Control[iCurrent+7]=this.dw_donate
end on

on w_sh370_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dedu)
destroy(this.st_2)
destroy(this.shl_1)
destroy(this.shl_2)
destroy(this.dw_pension)
destroy(this.dw_house)
destroy(this.dw_donate)
end on

event open;call super::open;string ls_year, ls_emp_nm

select substring(convert(char(08), dateadd(year, -1, getdate()), 112),1,4)
into :ls_year
from dual;
//
//select dbo.sf_emp_nm(:gs_user_id)
//into :ls_emp_nm
//from dual;


//	   if gs_dept_cd = "9000" or gs_user_id = 'A90303'then
//			dw_head.object.empno.protect = 0
//		else
//			dw_head.object.empno.protect = 1
//		end if	


//insu_etc,
//medi_etc,
//train_etc,
//credit_etc,
//cash_etc,
//donation_etc,
//debit_etc,
//credit_tmarket_etc

//	if gs_dept_cd = "9000" or gs_user_id = 'A90303'then
//		dw_dedu.object.insu_etc.protect = 0
//		dw_dedu.object.medi_etc.protect = 0
//		dw_dedu.object.train_etc.protect = 0		
//		dw_dedu.object.credit_etc.protect = 0		
//		dw_dedu.object.cash_etc.protect = 0				
//		dw_dedu.object.donation_etc.protect = 0
//		dw_dedu.object.debit_etc.protect = 0		
//		dw_dedu.object.credit_tmarket_etc.protect = 0				
//		
//		dw_dedu.object.insu_etc.visible = true
//		dw_dedu.object.medi_etc.visible = true
//		dw_dedu.object.train_etc.visible = true		
//		dw_dedu.object.credit_etc.visible = true		
//		dw_dedu.object.cash_etc.visible = true				
//		dw_dedu.object.donation_etc.visible = true
//		dw_dedu.object.debit_etc.visible = true		
//		dw_dedu.object.credit_tmarket_etc.visible = true				
//		dw_dedu.object.t_9.visible = true						
//		
//	else
//		dw_dedu.object.insu_etc.protect = 1
//		dw_dedu.object.medi_etc.protect = 1
//		dw_dedu.object.train_etc.protect = 1		
//		dw_dedu.object.credit_etc.protect = 1		
//		dw_dedu.object.donation_etc.protect = 1
//		dw_dedu.object.debit_etc.protect = 1		
//		dw_dedu.object.cash_etc.protect = 1				
//		dw_dedu.object.credit_tmarket_etc.protect = 1	
//		
//		dw_dedu.object.insu_etc.visible = false
//		dw_dedu.object.medi_etc.visible = false
//		dw_dedu.object.train_etc.visible = false		
//		dw_dedu.object.credit_etc.visible = false		
//		dw_dedu.object.cash_etc.visible = false				
//		dw_dedu.object.donation_etc.visible = false
//		dw_dedu.object.debit_etc.visible = false		
//		dw_dedu.object.credit_tmarket_etc.visible = false		
//		dw_dedu.object.t_9.visible = false								
//		
//	end if	

dw_head.setitem(1, "base_year", ls_year)
//dw_head.setitem(1, "empno", gs_user_id)
//dw_head.setitem(1, "emp_nm", ls_emp_nm)

timer(1)

end event

event pfc_preopen();of_SetResize(True)

This.SetMicroHelp("작업을 시작하십시오!")
/* button & Group box Resize */
inv_resize.of_Register(gb_button, "ScaleToRight")

inv_resize.of_Register(cb_insert, "FixedToRight")
inv_resize.of_Register(cb_delete, "FixedToRight")
inv_resize.of_Register(cb_print, "FixedToRight")
inv_resize.of_Register(cb_preview, "FixedToRight")
//inv_resize.of_Register(cb_excel, "FixedToRight")
inv_resize.of_Register(cb_retrieve, "FixedToRight")
inv_resize.of_Register(cb_close, "FixedToRight")


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_dedu, "ScaleToRight&bottom")
//inv_resize.of_Register(dw_donate, "ScaleToRight&bottom")


/* DataWindow의 Transction 정의 */
dw_dedu.SetTransObject(SQLCA)
dw_donate.SetTransObject(SQLCA)
dw_pension.SetTransObject(SQLCA)
dw_house.SetTransObject(SQLCA)
dw_body.SetTransObject(SQLCA)
dw_print.SetTransObject(SQLCA)


/* Tab order가 존재한 처음과 마지막 Colunm 검색 */
this.Trigger Event ue_init(dw_body)

/* DataWindow Head에 One Row 추가 */
dw_head.InsertRow(0)

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;
CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_insert.enabled = true			
//         cb_delete_don.enabled = true
//         cb_insert_don.enabled = true			
			
         cb_print.enabled = true
         cb_preview.enabled = true
//         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
//         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
   CASE 2   /* 추가 */
      if al_rows > 0 then
			cb_delete.enabled = true
			cb_print.enabled = false
			cb_preview.enabled = false
//			cb_excel.enabled = false
			if dw_head.Enabled then
				cb_retrieve.Text = "조건(&Q)"
				dw_head.Enabled = false
				dw_body.Enabled = true
			end if
		end if

	CASE 3		/* 저장 */
		if al_rows = 1 then
			ib_changed = false
			cb_print.enabled = true
			cb_preview.enabled = true
//			cb_excel.enabled = true
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
//         cb_excel.enabled = false
		end if

   CASE 5    /* 조건 */
      cb_retrieve.Text = "조회(&Q)"
	   cb_insert.enabled = false
      cb_delete.enabled = false
//         cb_delete_don.enabled = false
//         cb_insert_don.enabled = false				
//		
      cb_print.enabled = false
      cb_preview.enabled = false
//      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event ue_delete();long			ll_cur_row

ll_cur_row = dw_dedu.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_dedu.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_dedu.DeleteRow (ll_cur_row)
dw_dedu.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event ue_insert();if dw_dedu.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_dedu.Reset()

END IF

il_rows = dw_dedu.InsertRow(0)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_dedu.ScrollToRow(il_rows)
	dw_dedu.SetColumn(ii_min_column_id)
	dw_dedu.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

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

is_year = dw_head.GetItemString(1, "base_year")
if IsNull(is_year) or Trim(is_year) = "" then
   MessageBox(ls_title,"기준년도를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("base_year")
   return false
end if

is_empno = dw_head.GetItemString(1, "empno")
if IsNull(is_empno) or Trim(is_empno) = "" then
   MessageBox(ls_title,"사번을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if

is_opt = dw_head.GetItemString(1, "opt")

return true
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_emp_nm, ls_dept
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
CASE "empno"		

			IF ai_div = 1 THEN 
				
//				if isnull(as_data) or len(as_data) = 0 then  return 1  // 입력기간동안 주석처리 기간외에는 아래 if문 주석처리

//				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
//					dw_head.Setitem(al_row, "emp_nm", ls_emp_nm)
//					RETURN 0
//				END IF 
			END IF
			
			if as_data = "991001" then
				gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "사원코드 검색" 
				gst_cd.datawindow_nm   = "d_com930" 
				gst_cd.default_where   = "where goout_gubn = '1' " 
				
			else
				
				gst_cd.ai_div          = ai_div
				gst_cd.window_title    = "사원코드 검색" 
				gst_cd.datawindow_nm   = "d_com932" 
				
				if MidA(gs_shop_cd_1,1,2) = 'xx' then
					gst_cd.default_where   = "where goout_gubn = '1' and substring(shop_cd,3,4) = '" + MidA(gs_shop_cd,3,4) + "' " 				
				else
					gst_cd.default_where   = "where goout_gubn = '1' and shop_cd = '" + gs_shop_cd + "' " 				
				end if
				
			end if
			
			IF Trim(as_data) <> "" THEN
				gst_cd.Item_where = "empno LIKE '" + as_data + "%' "
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
				dw_head.SetItem(al_row, "empno",    lds_Source.GetItemString(1,"empno"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"kname"))
				/* 다음컬럼으로 이동 */
				dw_head.TriggerEvent(Editchanged!)
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


end event

event ue_retrieve();call super::ue_retrieve;//DataWindowChild ldw_child
//long ll_row
///* dw_head 필수입력 column check */
//IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN
//
//il_rows = dw_body.retrieve(is_year, is_empno, is_opt)
//IF il_rows > 0 THEN
//		dw_dedu.reset()
//   	dw_dedu.retrieve(is_year, is_empno, is_opt)
//
//  		
//	   dw_body.SetFocus()
//		
//END IF
//messagebox("경고!", "내역 조회 및 수정후에는 반드시 저장을 하셔야 정상적인 정산데이터가 적용됩니다!")
//
////Post Event ue_tot_set()
//This.Trigger Event ue_button(1, il_rows)
//This.Trigger Event ue_msg(1, il_rows)
//

DataWindowChild ldw_child
long ll_row
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_year, is_empno, is_opt)
IF il_rows > 0 THEN
		dw_dedu.reset()
   	dw_dedu.retrieve(is_year, is_empno, is_opt)

		dw_donate.reset()
  		
		dw_donate.GetChild("jumin_no", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(is_year, is_empno)
		
		dw_donate.GetChild("kname", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(is_year, is_empno, "%")

	 	ll_row = dw_donate.retrieve(is_year, is_empno)		
		 
	   dw_pension.reset()
  	

	 	ll_row = dw_pension.retrieve(is_year, is_empno)				
		 
		 
  		 dw_house.reset()
  	

	 	ll_row = dw_house.retrieve(is_year, is_empno)				 
		 		 
		 
	   dw_body.SetFocus()
		
END IF

This.Trigger Event ue_tot_set()

messagebox("경고!", "내역 조회 및 수정후에는 반드시 저장을 하셔야 정상적인 정산데이터가 적용됩니다!")
//Post Event ue_tot_set()
This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)
end event

event type long ue_update();call super::ue_update;long i, ll_row_count,ll_row_count1, li_jumin_chk,ll_row_count2
datetime ld_datetime
string ls_new_fg_body, ls_new_fg_dedu, ls_kname, ls_jumin, ls_reg_no, ls_reg_name, ls_donate_code
string ls_gubn, ls_fore, ls_mone_type, ls_mone_dep, ls_acc_num

ll_row_count = dw_body.RowCount()
ll_row_count1 = dw_dedu.RowCount()


This.Trigger Event ue_tot_set()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_dedu.AcceptText() <> 1 THEN RETURN -1

This.Trigger Event ue_tot_set()


/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

li_jumin_chk = 0

FOR i=1 TO ll_row_count1
	li_jumin_chk = li_jumin_chk + abs(dw_dedu.getitemNumber(i, "jumin_chk"))
	
	ls_kname = dw_dedu.GetItemString(i, "kname")
	if IsNull(ls_kname) or Trim(ls_kname) = "" then
		MessageBox("주의!","부양가족이름을 입력하십시요!")
		return -1
	end if
	
	ls_jumin = dw_dedu.GetItemString(i, "jumin_no")
	if IsNull(ls_kname) or Trim(ls_kname) = "" then
		MessageBox("주의!","부양가족 주민번호를 입력하십시요!")
		return -1
	end if
	
NEXT

FOR i=1 TO ll_row_count1
	li_jumin_chk = li_jumin_chk + abs(dw_dedu.getitemNumber(i, "jumin_chk"))	
NEXT


	if li_jumin_chk <> 0 then
		messagebox("경고!","주민번호가 잘못된 인원이 있어 저장할 수 없습니다!")
		return -1
	end if	



FOR i=1 TO ll_row_count
	ls_new_fg_body = dw_body.getitemstring(i, "new_flag")
	if ls_new_fg_body = 'Y' then
		dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
	else
		dw_body.SetItemStatus(i, 0, Primary!, DataModified!)
	end if	
NEXT


FOR i=1 TO ll_row_count1
	ls_new_fg_dedu = dw_dedu.getitemstring(i, "new_fg")
	if ls_new_fg_dedu = 'Y' then
		dw_dedu.SetItemStatus(i, 0, Primary!, NewModified!)
	else
		dw_dedu.SetItemStatus(i, 0, Primary!, DataModified!)
	end if	
NEXT

FOR i=1 TO ll_row_count1
   idw_status = dw_dedu.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_dedu.Setitem(i, "base_year", is_year)
      dw_dedu.Setitem(i, "empno", is_empno)		
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
   END IF
NEXT



il_rows = dw_body.Update(TRUE, FALSE)

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if


if il_rows = 1 then
	il_rows = dw_dedu.Update(TRUE, FALSE)
		if il_rows = 1 then
			commit  USING SQLCA;
			dw_dedu.ResetUpdate()
		else
			rollback  USING SQLCA;
		end if
end if		



This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
This.Trigger Event ue_retrieve()
return il_rows

end event

event timer;call super::timer;
if is_timer = "1" then 
	dw_body.object.t_47.color = rgb(251,13,49)
	dw_dedu.object.t_6.color = rgb(49,9,213)	
	st_2.textcolor = rgb(251,13,49)
	is_timer = "2"
else	
	dw_body.object.t_47.color = rgb(49,9,213)	
	dw_dedu.object.t_6.color = rgb(251,13,49)
	st_2.textcolor =rgb(49,9,213)	
	is_timer = "1"	
end if	




end event

type cb_close from w_com010_e`cb_close within w_sh370_e
integer x = 2720
end type

type cb_delete from w_com010_e`cb_delete within w_sh370_e
integer x = 1746
integer width = 224
end type

type cb_insert from w_com010_e`cb_insert within w_sh370_e
integer x = 1522
integer width = 229
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_sh370_e
integer x = 2377
end type

type cb_update from w_com010_e`cb_update within w_sh370_e
end type

type cb_print from w_com010_e`cb_print within w_sh370_e
boolean visible = false
integer x = 1765
integer width = 238
end type

type cb_preview from w_com010_e`cb_preview within w_sh370_e
boolean visible = false
integer x = 2002
end type

type gb_button from w_com010_e`gb_button within w_sh370_e
integer width = 3104
end type

type dw_head from w_com010_e`dw_head within w_sh370_e
integer x = 5
integer y = 156
integer width = 4521
integer height = 112
string dataobject = "d_sh370_h01"
end type

event dw_head::itemchanged;call super::itemchanged;string ls_emp_nm

CHOOSE CASE dwo.name
CASE "empno"
		IF ib_itemchanged THEN RETURN 1
		
//		if isnull(data) or len(data) = 0 then  return 1
//				if gf_emp_nm(data, ls_emp_nm) = 0 THEN
//					dw_head.Setitem(row, "emp_nm", ls_emp_nm)
//					RETURN 0
//		END IF 
//		
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 		
		
//		if gs_dept_cd = "9000" or gs_user_id = 'A90303'then
//			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
//		else
//			if gs_user_id <> data then 
//				this.setitem(1,"empno", gs_user_id)				
//			end if	
//		end if	
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_sh370_e
integer beginy = 276
integer endx = 4485
integer endy = 276
end type

type ln_2 from w_com010_e`ln_2 within w_sh370_e
integer beginy = 280
integer endx = 4485
integer endy = 280
end type

type dw_body from w_com010_e`dw_body within w_sh370_e
integer y = 288
integer width = 4521
integer height = 1072
string dataobject = "d_92020_d01"
boolean hscrollbar = true
end type

event dw_body::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	
	CASE "householder_yn" 
    IF data = 'N' THEN
			this.setitem(row, "dwell_deposit_a",0)
			this.setitem(row, "dwell_deposit_b",0)
			this.setitem(row, "dwell_deposit_c",0)			
			this.setitem(row, "dwell_deposit_d",0)						
			
			this.setitem(row, "dwell_borrm",0)			
			this.setitem(row, "dwell_borrm2",0)						
			this.setitem(row, "dwell_monthly",0)									
			
			this.setitem(row, "dwell_repay",0)									
			this.setitem(row, "dwell_repay_15",0)									
			this.setitem(row, "dwell_repay_30",0)												
			this.setitem(row, "dwell_repay_fix",0)												
			this.setitem(row, "dwell_repay_etc",0)															

			this.setitem(row, "dwell_repay_imf",0)												
		end if		
	      

END CHOOSE
end event

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_sh370_e
end type

type dw_dedu from datawindow within w_sh370_e
integer y = 1440
integer width = 4521
integer height = 1248
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "부양가족정보"
string dataobject = "d_92020_d02"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
//cb_excel.enabled = false

string ls_gubn,ls_hitch_deduc, ls_jumin_no

ls_gubn = this.getitemstring(row, "gubn")
ls_hitch_deduc = this.getitemstring(row, "hitch_deduc")

CHOOSE CASE dwo.name
	CASE "edu_gubn" 
    IF data = '00' AND ls_gubn <> '00' THEN
	      messagebox("알림!", "교육비 구분이 잘못되었습니다!")
			this.setitem(row, "edu_gubn", 'XX')
 	 elseif data = '04' AND ls_hitch_deduc <> 'Y' THEN	
			messagebox("알림!", "교육비 구분이 잘못되었습니다!")
			this.setitem(row, "edu_gubn", 'XX')
    END IF
	 
	CASE "hitch_deduc" 
    IF data = 'Y' THEN
			this.setitem(row, "base_deduc", 'Y')
 	 else
			this.setitem(row, "base_deduc", 'N')
    END IF	 
	 
	 
	CASE "base_deduc" 
		dw_dedu.AcceptText()	
		ls_jumin_no = this.getitemstring(row, "jumin_no")
    IF data = 'N'  THEN			
				this.setitem(ROW, "insu_nta",0)
//				this.setitem(ROW, "medi_nta",0)
//				this.setitem(ROW, "train_nta",0)
//				this.setitem(ROW, "credit_nta",0)
//				this.setitem(ROW, "debit_nta",0)
//				this.setitem(ROW, "cash_nta",0)				
				this.setitem(ROW, "donation_nta",0)
				if MidA(ls_jumin_no,1,2) = '12' then
					this.setitem(row, "born_deduc", "N")
				end if					
				
	else 		
		if MidA(ls_jumin_no,1,2) = '18' then
			this.setitem(row, "born_deduc", "Y")
		end if	

 	end if			 
 
	      

END CHOOSE
end event

event itemfocuschanged;string ls_jumin_no, ls_nation
ls_jumin_no = this.getitemstring(row, "jumin_no")
ls_nation = this.getitemstring(row, "nation")

CHOOSE CASE dwo.name
	CASE "gubn","nation_gubn","kname", "base_deduc", "hitch_deduc", "rearing_deduc", "children_deduc"
    IF LenA(ls_jumin_no) = 13 THEN
		 if gf_jumin_chk2(ls_jumin_no) = false and ls_nation = "1"  then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
    END IF
	CASE  "born_deduc", "insu_nta", "medi_nta","train_nta", "credit_nta", "debit_nta", "cash_nta","donation_nta","edu_gubn"
    IF LenA(ls_jumin_no) = 13 THEN
		 if gf_jumin_chk2(ls_jumin_no) = false  and ls_nation = "1" then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
    END IF	 
	 
END CHOOSE

end event

event editchanged;CHOOSE CASE dwo.name
	CASE "jumin_no" 
    IF LenA(data) = 13 THEN
		 if gf_jumin_chk2(data) = false then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
    END IF
END CHOOSE

end event

type st_2 from statictext within w_sh370_e
integer x = 1563
integer y = 1372
integer width = 2926
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 8388736
long backcolor = 67108864
string text = "* 부양가족 정보 입력시 오류 방지를 위해 (ㅁ)최대화 버튼을 누르고 작업하시기 바랍니다."
alignment alignment = right!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_sh370_e
boolean visible = false
integer x = 379
integer y = 48
integer width = 1015
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "※ 연말정산 간소화파일(PDF) 등록"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
string url = "http://work.ibeaucre.co.kr:8080/member/login"
end type

type shl_2 from statichyperlink within w_sh370_e
integer x = 384
integer y = 48
integer width = 1061
integer height = 84
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 79741120
string text = "※ 연말정산 간소화파일(PDF) 등록"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
string url = "http://work.ibeaucre.co.kr:8080/member/login"
end type

type dw_pension from datawindow within w_sh370_e
boolean visible = false
integer x = 2450
integer y = 712
integer width = 1349
integer height = 840
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "연금기타"
string dataobject = "d_92020_d04"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;DataWindowChild ldw_child

This.GetChild("mone_type", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("925")


This.GetChild("mone_dep", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve("924")

end event

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
//cb_excel.enabled = false

datawindowchild ldw_child
string ls_mone_dep_nm

CHOOSE CASE dwo.name
	CASE "mone_dep" 
		 select dbo.sf_inter_nm("924", :data)
		 into :ls_mone_dep_nm
		 from dual;
		 
		This.setitem(row, "mone_dep_nm", ls_mone_dep_nm)		 
		 

END CHOOSE




end event

type dw_house from datawindow within w_sh370_e
boolean visible = false
integer x = 2469
integer y = 1588
integer width = 1819
integer height = 876
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "월세"
string dataobject = "d_92020_d05"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_donate from datawindow within w_sh370_e
boolean visible = false
integer x = 2107
integer y = 1200
integer width = 2377
integer height = 776
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "기부금명세"
string dataobject = "d_92020_d03"
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

