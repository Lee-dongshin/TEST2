$PBExportHeader$w_92020_e.srw
$PBExportComments$연말정산 신고서작성
forward
global type w_92020_e from w_com010_e
end type
type dw_dedu from u_dw within w_92020_e
end type
type st_1 from statictext within w_92020_e
end type
type cb_insert_don from commandbutton within w_92020_e
end type
type cb_delete_don from commandbutton within w_92020_e
end type
type shl_1 from statichyperlink within w_92020_e
end type
type tab_1 from tab within w_92020_e
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_1 from tab within w_92020_e
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type dw_pension from datawindow within w_92020_e
end type
type dw_house from datawindow within w_92020_e
end type
type dw_donate from datawindow within w_92020_e
end type
type st_2 from statictext within w_92020_e
end type
type st_3 from statictext within w_92020_e
end type
type dw_dedu_s from datawindow within w_92020_e
end type
end forward

global type w_92020_e from w_com010_e
integer width = 5961
integer height = 3652
event ue_tot_set ( )
dw_dedu dw_dedu
st_1 st_1
cb_insert_don cb_insert_don
cb_delete_don cb_delete_don
shl_1 shl_1
tab_1 tab_1
dw_pension dw_pension
dw_house dw_house
dw_donate dw_donate
st_2 st_2
st_3 st_3
dw_dedu_s dw_dedu_s
end type
global w_92020_e w_92020_e

type variables
string is_year, is_empno, is_opt, is_timer
decimal idc_keep_dedu, idc_keep_70_dedu,idc_hitch_dedu,idc_child_rearm_dedu,idc_keep_child_dedu
decimal idc_insu_amt1, idc_credit_card, idc_debit_card, idc_pay_card, idc_credit_culture, idc_debit_culture, idc_cash_culture,idc_zero_culture
decimal idc_medim_self, idc_medim_hitch_revivm, idc_medim_old, idc_medim_comm, idc_trngm_me,	idc_trngm_handi,idc_zero_pay
decimal idc_court_fund, idc_appo_fund, idc_full_apply_fund, idc_priv_school_fund, idc_religious_fund ,idc_provinces_fund
decimal idc_credit_tmarket, idc_trngm_bisock, idc_wife, idc_single_parent_dedu, idc_credit_traffic, idc_born_dedu
decimal idc_medi_insu_refund, idc_dwell_monthly, idc_medi_nta_6under
end variables

forward prototypes
public function boolean wf_jumin_chk (string as_jumin_no, long al_row)
end prototypes

event ue_tot_set();//decimal ldc_keep_dedu, ldc_keep_70_dedu,ldc_hitch_dedu,ldc_child_rearm_dedu,ldc_keep_child_dedu
//decimal ldc_insu_amt1, ldc_credit_card, ldc_debit_card, ldc_pay_card
//decimal idc_medim_self, idc_medim_hitch_revivm, idc_medim_old, idc_medim_comm, idc_trngm_me,	idc_trngm_handi
//, idc_single_parent_dedu, idc_credit_traffic
long ll_row_cnt

 dw_dedu.AcceptText() 
 dw_donate.AcceptText() 

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
 idc_credit_culture = dw_dedu.object.t_credit_culture_nta[1] // 도서문화사용 신용카드분분
 idc_debit_culture = dw_dedu.object.t_debit_culture_nta[1] // 도서문화사용 직불카드분
 idc_cash_culture = dw_dedu.object.t_cash_culture_nta[1] // 도서문화사용 현금분  
 idc_zero_culture = dw_dedu.object.t_zero_culture_nta[1] // 도서문화사용 제로페이  
 
 idc_medim_self = dw_dedu.object.t_medi_nta00[1] // 본인의료비 
 idc_medim_hitch_revivm = dw_dedu.object.t_medi_nta_hitch[1] // 장애인의료비
 idc_medim_old = dw_dedu.object.t_medi_nta_65[1] // 65세이상의료비
 idc_medi_nta_6under = dw_dedu.object.t_medi_nta_6under[1] // 6세이하의료비  
 idc_medim_comm = dw_dedu.object.t_etc_medi[1] // 일반부양가족의료비
 idc_medi_insu_refund = dw_dedu.object.t_medi_insu[1] // 실손보험료수령액

 
 idc_trngm_me = dw_dedu.object.t_train_nta00[1] // 본인교육비
 idc_trngm_handi = dw_dedu.object.t_train_nta04[1] // 장애인교육비
 idc_trngm_bisock = dw_dedu.object.t_train_bisock[1] // 기본공제자교육비
 idc_born_dedu = dw_dedu.object.t_born_deduc[1] // 기본공제자교육비
 
 
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
 dw_body.setitem(1, "zero_pay", idc_zero_pay)      
 dw_body.setitem(1, "zero_culture", idc_zero_culture)     
 
 dw_body.setitem(1, "medim_self", idc_medim_self)  
 dw_body.setitem(1, "medim_hitch_revivm", idc_medim_hitch_revivm)
 dw_body.setitem(1, "medim_old", idc_medim_old) 
 dw_body.setitem(1, "medi_nta_6under", idc_medi_nta_6under)  
 dw_body.setitem(1, "medim_comm", idc_medim_comm)
 dw_body.setitem(1, "medi_insu_refund", idc_medi_insu_refund)
 
 
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
  idc_provinces_fund = dw_donate.object.provinces_fund_c[1] // 종교단체  
 else  
  idc_court_fund = 0
  idc_appo_fund = 0
  idc_full_apply_fund = 0
  idc_priv_school_fund = 0
  idc_religious_fund = 0
  idc_provinces_fund = 0
 end if  
 
  
  dw_body.setitem(1, "court_fund", idc_court_fund) 
  dw_body.setitem(1, "appo_fund", idc_appo_fund) 
  dw_body.setitem(1, "full_apply_fund", idc_full_apply_fund) 
  dw_body.setitem(1, "priv_school_fund", idc_priv_school_fund) 
  dw_body.setitem(1, "religious_fund", idc_religious_fund)   
  dw_body.setitem(1, "provinces_fund", idc_provinces_fund)   


//ll_row_cnt = dw_house.rowcount()
// 
// if ll_row_cnt > 0 then
//
//  idc_dwell_monthly = dw_house.object.dwell_monthly_c[1] // 정치자금
// else  
//  idc_dwell_monthly = 0
//
// end if  
// 
//  dw_body.setitem(1, "dell_monthly", idc_dwell_monthly) 
//

Return




end event

public function boolean wf_jumin_chk (string as_jumin_no, long al_row);  IF LenA(as_jumin_no) = 13 THEN
		 if gf_jumin_chk(as_jumin_no) = false then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			dw_dedu.setitem(al_row, "jumin_chk", -1)
			return  false
		 end 	if
   END IF
	 
  return true	 
end function

on w_92020_e.create
int iCurrent
call super::create
this.dw_dedu=create dw_dedu
this.st_1=create st_1
this.cb_insert_don=create cb_insert_don
this.cb_delete_don=create cb_delete_don
this.shl_1=create shl_1
this.tab_1=create tab_1
this.dw_pension=create dw_pension
this.dw_house=create dw_house
this.dw_donate=create dw_donate
this.st_2=create st_2
this.st_3=create st_3
this.dw_dedu_s=create dw_dedu_s
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_dedu
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_insert_don
this.Control[iCurrent+4]=this.cb_delete_don
this.Control[iCurrent+5]=this.shl_1
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.dw_pension
this.Control[iCurrent+8]=this.dw_house
this.Control[iCurrent+9]=this.dw_donate
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.dw_dedu_s
end on

on w_92020_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_dedu)
destroy(this.st_1)
destroy(this.cb_insert_don)
destroy(this.cb_delete_don)
destroy(this.shl_1)
destroy(this.tab_1)
destroy(this.dw_pension)
destroy(this.dw_house)
destroy(this.dw_donate)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_dedu_s)
end on

event pfc_preopen();of_SetResize(True)

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
inv_resize.of_Register(shl_1, "FixedToRight")
inv_resize.of_Register(st_2, "FixedToRight")


/* Data window Resize */
//inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_head, "ScaleToRight")
inv_resize.of_Register(dw_body, "ScaleToRight")
inv_resize.of_Register(ln_1, "ScaleToRight")
inv_resize.of_Register(ln_2, "ScaleToRight")
inv_resize.of_Register(dw_dedu, "ScaleToRight")
inv_resize.of_Register(dw_dedu_s, "ScaleToRight")
inv_resize.of_Register(dw_donate, "ScaleToRight&bottom")
inv_resize.of_Register(dw_pension, "ScaleToRight&bottom")
inv_resize.of_Register(dw_house, "ScaleToRight&bottom")
inv_resize.of_Register(tab_1, "ScaleToRight&Bottom")

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

event open;call super::open;string ls_year, ls_emp_nm


dw_dedu.ShareData(dw_dedu_s)

select substring(convert(char(08), dateadd(year, -1, getdate()), 112),1,4)
into :ls_year
from dual;

select dbo.sf_emp_nm(:gs_user_id)
into :ls_emp_nm
from dual;

messagebox("경고!", "내역 조회 및 수정후에는 반드시 저장을 하셔야 정상적인 정산데이터가 적용됩니다!")


if gs_dept_cd = "9000" or gs_user_id = "B90908"  or gs_user_id = "991001" or MidA(gs_dept_cd,2,3) = "240" or MidA(gs_dept_cd,2,3) = "242" or gs_user_id = "B20407" then
	dw_head.object.empno.protect = 0
	dw_head.object.base_year.protect = 0
else
	dw_head.object.empno.protect = 1
end if	


//insu_etc,
//medi_etc,
//train_etc,
//credit_etc,
//cash_etc,
//donation_etc,
//debit_etc,
//credit_tmarket_etc

	if gs_dept_cd = "9000" or gs_user_id = "A51121" or MidA(gs_dept_cd,2,3) = "240" or MidA(gs_dept_cd,2,3) = "242" or gs_user_id = "B20407"  then
		
		dw_body.object.dwell_repay_imf.protect = 0
		dw_body.object.dwell_rent_small.protect = 0		
		
		dw_dedu.object.insu_etc.protect = 0
		dw_dedu.object.medi_etc.protect = 0
		dw_dedu.object.train_etc.protect = 0		
		dw_dedu.object.credit_etc.protect = 0		
		dw_dedu.object.cash_etc.protect = 0				
		dw_dedu.object.donation_etc.protect = 0
		dw_dedu.object.debit_etc.protect = 0		
		dw_dedu.object.credit_tmarket_etc.protect = 0				
		dw_dedu.object.credit_traffic_etc.protect = 0						
		
		dw_dedu.object.credit_etc_2.protect = 0				
		dw_dedu.object.cash_etc_2.protect = 0					
		dw_dedu.object.debit_etc_2.protect = 0		
		dw_dedu.object.credit_tmarket_etc_2.protect = 0				
		dw_dedu.object.credit_traffic_etc_2.protect = 0						
		
		
		dw_dedu.object.insu_etc.visible = true
		dw_dedu.object.medi_etc.visible = true
		dw_dedu.object.train_etc.visible = true		
		dw_dedu.object.credit_etc.visible = true		
		dw_dedu.object.cash_etc.visible = true				
		dw_dedu.object.donation_etc.visible = true
		dw_dedu.object.debit_etc.visible = true		
		dw_dedu.object.credit_tmarket_etc.visible = true				
		dw_dedu.object.credit_traffic_etc.visible = true			
		dw_dedu.object.t_9.visible = true		
		
		dw_dedu.object.credit_etc_2.visible = true
		dw_dedu.object.cash_etc_2.visible = true
		dw_dedu.object.debit_etc_2.visible = true
		dw_dedu.object.credit_tmarket_etc_2.visible = true
		dw_dedu.object.credit_traffic_etc_2.visible = true
		
		dw_donate.enabled = true
		dw_pension.enabled = true		
		dw_house.enabled = true
		cb_insert_don.visible = true
		cb_delete_don.visible = true
	else
		
		dw_body.object.dwell_repay_imf.protect = 1
		dw_body.object.dwell_rent_small.protect = 1		

		
		dw_dedu.object.insu_etc.protect = 1
		dw_dedu.object.medi_etc.protect = 1
		dw_dedu.object.train_etc.protect = 1		
		dw_dedu.object.credit_etc.protect = 1		
		dw_dedu.object.donation_etc.protect = 1
		dw_dedu.object.debit_etc.protect = 1		
		dw_dedu.object.cash_etc.protect = 1				
		dw_dedu.object.credit_tmarket_etc.protect = 1	
		
		dw_dedu.object.credit_etc_2.protect = 1				
		dw_dedu.object.cash_etc_2.protect = 1					
		dw_dedu.object.debit_etc_2.protect = 1		
		dw_dedu.object.credit_tmarket_etc_2.protect = 1				
		dw_dedu.object.credit_traffic_etc_2.protect = 1				
		
		dw_dedu.object.insu_etc.visible = false
		dw_dedu.object.medi_etc.visible = false
		dw_dedu.object.train_etc.visible = false		
		dw_dedu.object.credit_etc.visible = false		
		dw_dedu.object.cash_etc.visible = false				
		dw_dedu.object.donation_etc.visible = false
		dw_dedu.object.debit_etc.visible = false		
		dw_dedu.object.credit_tmarket_etc.visible = false	
		dw_dedu.object.credit_traffic_etc.visible = false
		dw_dedu.object.t_9.visible = false			
		
		dw_dedu.object.credit_etc_2.visible = false
		dw_dedu.object.cash_etc_2.visible = false
		dw_dedu.object.debit_etc_2.visible = false
		dw_dedu.object.credit_tmarket_etc_2.visible = false
		dw_dedu.object.credit_traffic_etc_2.visible = false
		
		
		dw_donate.enabled = true
		dw_pension.enabled = false		
		dw_house.enabled = false
		cb_insert_don.visible = true
		cb_delete_don.visible = true

		
	end if	

dw_head.setitem(1, "base_year", ls_year)
dw_head.setitem(1, "empno", gs_user_id)
dw_head.setitem(1, "emp_nm", ls_emp_nm)

timer(1)

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;String     ls_emp_nm, ls_dept
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
CASE "empno"		

			IF ai_div = 1 THEN 
				if isnull(as_data) or LenA(as_data) = 0 then  return 1
				if gf_emp_nm(as_data, ls_emp_nm) = 0 THEN
					dw_head.Setitem(al_row, "emp_nm", ls_emp_nm)
					RETURN 0
				END IF 
			END IF
		   gst_cd.ai_div          = ai_div
			gst_cd.window_title    = "사원코드 검색" 
			gst_cd.datawindow_nm   = "d_com930" 
			gst_cd.default_where   = "where goout_gubn = '1' " 
			
			
			
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

RETURN 0
end event

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;String   ls_title, ls_ok
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


select case when empno = '991001' then  'OK'
			   when right(saup_gubn,1) in ('2','4','B') THEN 'OK'
			ELSE "NO" END		
into :ls_ok
from mis.dbo.thb01
where empno = :is_empno ;

if IsNull(ls_ok) or Trim(ls_ok) = "NO" then
   MessageBox(ls_title,"처리대상 사업장이 아닙니다!")
   dw_head.SetFocus()
   dw_head.SetColumn("empno")
   return false
end if


is_opt = dw_head.GetItemString(1, "opt")
is_timer = "1"
return true
end event

event ue_retrieve();call super::ue_retrieve;DataWindowChild ldw_child
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

event ue_insert();if dw_dedu.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_dedu.Reset()
	dw_donate.Reset()	
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

event ue_delete();long			ll_cur_row

ll_cur_row = dw_dedu.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_dedu.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_dedu.DeleteRow (ll_cur_row)
dw_dedu.SetFocus()

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

event type long ue_update();call super::ue_update;long i, ll_row_count,ll_row_count1, li_jumin_chk,ll_row_count2,ll_row_count3,ll_row_count4
datetime ld_datetime
string ls_new_fg_body, ls_new_fg_dedu, ls_kname, ls_jumin, ls_reg_no, ls_reg_name, ls_donate_code
string ls_gubn, ls_fore, ls_mone_type, ls_mone_dep, ls_acc_num, ls_house_ownr, ls_house_ownr_no, ls_house_type
decimal ldc_house_area, ldc_amt
string ls_addr, ls_frm_date, ls_to_date


ll_row_count = dw_body.RowCount()
ll_row_count1 = dw_dedu.RowCount()
ll_row_count2 = dw_donate.RowCount()
ll_row_count3 = dw_pension.RowCount()
ll_row_count4 = dw_HOUSE.RowCount()

This.Trigger Event ue_tot_set()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
IF dw_dedu.AcceptText() <> 1 THEN RETURN -1
IF dw_donate.AcceptText() <> 1 THEN RETURN -1
IF dw_pension.AcceptText() <> 1 THEN RETURN -1
IF dw_HOUSE.AcceptText() <> 1 THEN RETURN -1
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
	if IsNull(ls_jumin) or Trim(ls_jumin) = "" then
		MessageBox("주의!","부양가족 주민번호를 입력하십시요!")
		return -1
	end if
	
NEXT

FOR i=1 TO ll_row_count1
	li_jumin_chk = li_jumin_chk + abs(dw_dedu.getitemNumber(i, "jumin_chk"))	
NEXT


	if li_jumin_chk <> 0 then
		messagebox("경고!","주민번호가 확인이 필요한 인원이 있습니다.!")
	//	return -1
	end if	

FOR i=1 TO ll_row_count2

	ls_kname = dw_donate.GetItemString(i, "kname")
	if IsNull(ls_kname) or Trim(ls_kname) = "" then
		MessageBox("주의!","기부자 이름을 입력하십시요!")
		return -1
	end if	
	
	
	ls_jumin = dw_donate.GetItemString(i, "jumin_no")
	if IsNull(ls_kname) or Trim(ls_kname) = "" then
		MessageBox("주의!","기부자 주민번호를 입력하십시요!")
		return -1
	end if
	
	
	ls_reg_no = dw_donate.GetItemString(i, "reg_no")
	if IsNull(ls_reg_no) or Trim(ls_reg_no) = "" then
		MessageBox("주의!","기부처 사업자번호를 입력하십시요!")
		return -1
	end if
	
	ls_reg_name = dw_donate.GetItemString(i, "reg_name")
	if IsNull(ls_reg_name) or Trim(ls_reg_name) = "" then
		MessageBox("주의!","기부처 사업장명을 입력하십시요!")
		return -1
	end if
	
	ls_reg_name = dw_donate.GetItemString(i, "reg_name")
	if IsNull(ls_reg_name) or Trim(ls_reg_name) = "" then
		MessageBox("주의!","기부처 사업장명을 입력하십시요!")
		return -1
	end if	
	
	ls_donate_code = dw_donate.GetItemString(i, "donate_code")
	if IsNull(ls_donate_code) or Trim(ls_donate_code) = "" then
		MessageBox("주의!","기부유형을 입력하십시요!")
		return -1
	end if	
	
	ls_gubn = dw_donate.GetItemString(i, "gubn")
	if IsNull(ls_gubn) or Trim(ls_gubn) = "" then
		MessageBox("주의!","관계코드를 입력하십시요!")
		return -1
	end if		
	
	ls_fore = dw_donate.GetItemString(i, "foreigner")
	if IsNull(ls_fore) or Trim(ls_fore) = "" then
		MessageBox("주의!","내외국인코드를 입력하십시요!")
		return -1
	end if			
		
	
NEXT


FOR i=1 TO ll_row_count3
	
//	ls_mone_type, ls_mone_dep, ls_acc_num
	
		ls_mone_type = dw_pension.GetItemString(i, "mone_type")
	if IsNull(ls_mone_type) or Trim(ls_mone_type) = "" then
		MessageBox("주의!","공제유형을 입력하십시요!")
		return -1
	end if	
	
	ls_mone_dep = dw_pension.GetItemString(i, "mone_dep")
	if IsNull(ls_mone_dep) or Trim(ls_mone_dep) = "" then
		MessageBox("주의!","금융기관을 입력하십시요!")
		return -1
	end if		
	
	ls_acc_num = dw_pension.GetItemString(i, "acc_num")
	if IsNull(ls_acc_num) or Trim(ls_acc_num) = "" then
		MessageBox("주의!","계좌번호를 입력하십시요!")
		return -1
	end if			
	
NEXT

// ls_house_ownr, ls_house_ownr_no, ls_house_type, ldc_house_area
FOR i=1 TO ll_row_count4
	
	
		ls_house_ownr = dw_house.GetItemString(i, "house_ownr")
	if IsNull(ls_house_ownr) or Trim(ls_house_ownr) = "" then
		MessageBox("주의!","임대인명을 입력하십시요!")
		return -1
	end if	
	
	ls_house_ownr_no = dw_house.GetItemString(i, "house_ownr_no")
	if IsNull(ls_house_ownr_no) or Trim(ls_house_ownr_no) = "" then
		MessageBox("주의!","임대인 주민번호나 사업자 번호을 입력하십시요!")
		return -1
	end if		
	
	ls_house_type = dw_house.GetItemString(i, "house_type")
	if IsNull(ls_house_type) or Trim(ls_house_type) = "" then
		MessageBox("주의!","주택유형을 입력하십시요!")
		return -1
	end if			
	
	ldc_house_area = dw_house.GetItemNumber(i, "house_area")
	if IsNull(ldc_house_area) or ldc_house_area = 0 then
		MessageBox("주의!","계약면적을 입력하십시요!")
		return -1
	end if		
//ldc_house_area, ldc_amt ls_addr, ls_frm_date, ls_to_date	

	ldc_amt = dw_house.GetItemNumber(i, "amt")
	if IsNull(ldc_amt) or ldc_amt = 0 then
		MessageBox("주의!","년간 월세액을 입력하십시요!")
		return -1
	end if		
	
	ls_addr = dw_house.GetItemString(i, "addr")
	if  IsNull(ls_addr) or Trim(ls_addr) = "" then
		MessageBox("주의!","계약 거주지 주소를 입력하십시요!")
		return -1
	end if		
	
	ls_frm_date = dw_house.GetItemString(i, "frm_date")
	if  IsNull(ls_frm_date) or Trim(ls_frm_date) = "" then
		MessageBox("주의!","계약 시작일을 입력하십시요!")
		return -1
	end if		

	ls_to_date = dw_house.GetItemString(i, "to_date")
	if  IsNull(ls_to_date) or Trim(ls_to_date) = "" then
		MessageBox("주의!","계약 종료일 입력하십시요!")
		return -1
	end if		


NEXT

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


FOR i=1 TO ll_row_count2
   idw_status = dw_donate.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_donate.Setitem(i, "base_year", is_year)
      dw_donate.Setitem(i, "empno", is_empno)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */  
   END IF
NEXT

FOR i=1 TO ll_row_count3
   idw_status = dw_pension.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_pension.Setitem(i, "base_year", is_year)
      dw_pension.Setitem(i, "empno", is_empno)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */  
   END IF
NEXT

FOR i=1 TO ll_row_count4
   idw_status = dw_HOUSE.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_HOUSE.Setitem(i, "base_year", is_year)
      dw_HOUSE.Setitem(i, "empno", is_empno)
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

if il_rows = 1 then
	il_rows = dw_donate.Update(TRUE, FALSE)
		if il_rows = 1 then
			commit  USING SQLCA;
			dw_donate.ResetUpdate()
		else
			rollback  USING SQLCA;
		end if
end if		

if il_rows = 1 then
	il_rows = dw_pension.Update(TRUE, FALSE)
		if il_rows = 1 then
			commit  USING SQLCA;
			dw_pension.ResetUpdate()
		else
			rollback  USING SQLCA;
		end if
end if		

if il_rows = 1 then
	il_rows = dw_house.Update(TRUE, FALSE)
		if il_rows = 1 then
			commit  USING SQLCA;
			dw_house.ResetUpdate()
		else
			rollback  USING SQLCA;
		end if
end if		

commit  USING SQLCA;

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
This.Trigger Event ue_retrieve()
return il_rows


end event

event ue_button(integer ai_cb_div, long al_rows);/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
/* ai_cd_div   : 1 - 조회, 2 - 추가, 3 - 저장, 4 - 삭제, 5 - 조건            */
/*	al_rows     : 조회, 추가, 저장, 삭제 리턴값                               */
/*===========================================================================*/

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         cb_delete.enabled = true
         cb_insert.enabled = true			
         cb_delete_don.enabled = true
         cb_insert_don.enabled = true			
			
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = false
      end if

      if al_rows >= 0 then
         ib_changed = false
         cb_update.enabled = false
      end if
		
		ib_changed = true
		cb_update.enabled = true
		
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
         cb_delete_don.enabled = false
         cb_insert_don.enabled = false				
		
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
END CHOOSE

end event

event timer;call super::timer;

if is_timer = "1" then 
//	dw_body.object.t_47.color = rgb(251,13,49)
	dw_dedu.object.t_6.color = rgb(49,9,213)	
	dw_dedu.object.t_16.color = rgb(49,9,213)			
	dw_dedu.object.t_19.color = rgb(49,9,213)	
	dw_dedu.object.t_18.color = rgb(251,13,49)	
	dw_dedu.object.t_20.color = rgb(251,13,49)	
	dw_dedu.object.t_12.color =  rgb(49,9,213)		
	st_2.textcolor  = rgb(251,13,49)
	dw_body.object.t_48.text = is_timer	
	is_timer = "2"
else	
//	dw_body.object.t_47.color = rgb(49,9,213)	
	dw_dedu.object.t_6.color =  rgb(49,9,213)		
	dw_dedu.object.t_16.color =  rgb(49,9,213)		
	dw_dedu.object.t_19.color =  rgb(49,9,213)		
	dw_dedu.object.t_18.color = rgb(49,9,213)			
	dw_dedu.object.t_20.color = rgb(49,9,213)		
	dw_dedu.object.t_12.color =  rgb(251,13,49)	
	st_2.textcolor  =  rgb(49,9,213)	
	dw_body.object.t_48.text = is_timer
	is_timer = "1"	
end if	




end event

type cb_close from w_com010_e`cb_close within w_92020_e
end type

type cb_delete from w_com010_e`cb_delete within w_92020_e
end type

type cb_insert from w_com010_e`cb_insert within w_92020_e
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_92020_e
end type

type cb_update from w_com010_e`cb_update within w_92020_e
end type

type cb_print from w_com010_e`cb_print within w_92020_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_92020_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_92020_e
end type

type cb_excel from w_com010_e`cb_excel within w_92020_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_92020_e
integer y = 160
integer height = 120
string dataobject = "d_92020_h01"
end type

event dw_head::itemchanged;call super::itemchanged;CHOOSE CASE dwo.name
CASE "empno"
		IF ib_itemchanged THEN RETURN 1
	//	return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 		
		
		if gs_dept_cd = "9000" or gs_user_id = 'B90908' or MidA(gs_dept_cd,2,3) = "240" or MidA(gs_dept_cd,2,3) = "242" or  gs_user_id = "C10147" then
			return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1) 
		else
			if gs_user_id <> data then 
				this.setitem(1,"empno", gs_user_id)				
			end if	
		end if	
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_92020_e
integer beginy = 280
integer endy = 280
end type

type ln_2 from w_com010_e`ln_2 within w_92020_e
integer beginy = 284
integer endy = 284
end type

type dw_body from w_com010_e`dw_body within w_92020_e
integer x = 0
integer y = 288
integer width = 5879
integer height = 1040
string title = "공제대상금액등록"
string dataobject = "d_92020_d01"
boolean hscrollbar = true
end type

event dw_body::dberror;//
end event

event dw_body::itemchanged;call super::itemchanged;//householder_yn


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

type dw_print from w_com010_e`dw_print within w_92020_e
end type

type dw_dedu from u_dw within w_92020_e
event ue_keydown pbm_dwnkey
integer y = 1408
integer width = 5879
integer height = 1504
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "부양가족정보 "
string dataobject = "d_92020_d02"
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
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

event itemchanged;call super::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

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
				if MidA(ls_jumin_no,1,2) = '17' then
					this.setitem(row, "born_deduc", "N")
				end if					
				
	else 		
		if MidA(ls_jumin_no,1,2) = '18' then
			this.setitem(row, "born_deduc", "Y")
		end if	

 	end if			 
 
	      

END CHOOSE
end event

event editchanged;call super::editchanged;string ls_gubn

ls_gubn = this.getitemstring(row, "gubn")

CHOOSE CASE dwo.name
	CASE "jumin_no" 
    IF LenA(data) = 13  THEN
		
		if ls_gubn <> "00" then
			
		 if MidA(DATA,1,4) < '2010' AND gf_jumin_chk(data) = false then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
	   end if
    END IF
END CHOOSE

end event

event itemfocuschanged;call super::itemfocuschanged;string ls_jumin_no, ls_gubn

ls_jumin_no = this.getitemstring(row, "jumin_no")
ls_gubn = this.getitemstring(row, "gubn")

CHOOSE CASE dwo.name
	CASE "gubn","nation_gubn","kname", "base_deduc", "hitch_deduc", "rearing_deduc", "children_deduc"
    IF LenA(ls_jumin_no) = 13 THEN
		if ls_gubn <> "00" then
		 if MidA(LS_JUMIN_NO,1,2) < "20" AND gf_jumin_chk(ls_jumin_no) = false then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
	end if 
    END IF
	CASE  "born_deduc", "insu_nta", "medi_nta","train_nta", "credit_nta", "debit_nta", "cash_nta","donation_nta","edu_gubn"
    IF LenA(ls_jumin_no) = 13 THEN
		if ls_gubn <> "00" then
		 if MidA(LS_JUMIN_NO,1,2) < "20" AND  gf_jumin_chk(ls_jumin_no) = false then
			messagebox("경고","주민번호가 잘못된 형식입니다!")
			this.setitem(row, "jumin_chk", -1)
		 else
			this.setitem(row, "jumin_chk", 0)
		 end 	if
		end if 
    END IF	 
	 
END CHOOSE

end event

event getfocus;call super::getfocus;//string ls_gubn
//
//
//CHOOSE CASE dwo.name
//	CASE "medi_postnatal" 
//   		messagebox("알림","국세청 제공자료가 아닌 경우 증빙자료가 필요합니다. !")
//	
//END CHOOSE
end event

event buttonclicked;call super::buttonclicked;string ls_column_nm, ls_column_value
Long ll_row,i, ll_row_cnt, ll_row1


IF PosA(dwo.name, "cb_") = 0 THEN RETURN

ls_column_nm = MidA(dwo.name, 4)


Choose Case ls_column_nm


	Case "credit"
			IF This.AcceptText() <> 1 THEN RETURN
			dw_dedu_s.visible = true		
			dw_dedu_s.SetReDraw(False)
			dw_dedu_s.ScrollToRow(row)
			dw_dedu_s.SetReDraw(True)

End Choose

end event

type st_1 from statictext within w_92020_e
boolean visible = false
integer x = 5
integer y = 1288
integer width = 466
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
string text = "부양가족 정보"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_insert_don from commandbutton within w_92020_e
integer x = 2784
integer y = 3000
integer width = 366
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "추가"
end type

event clicked;if dw_donate.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_donate.Reset()	
END IF


if dw_pension.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_pension.Reset()	
END IF

Parent.Trigger Event ue_update()

DataWindowChild ldw_child
	
if dw_donate.visible= true then
	
	dw_donate.GetChild("jumin_no", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve(is_year, is_empno)
	
	dw_donate.GetChild("kname", ldw_child)
	ldw_child.SetTransObject(SQLCA)
	ldw_child.Retrieve(is_year, is_empno, "%")
	
	il_rows = dw_donate.InsertRow(0)
	
	/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
	if il_rows > 0 then
		dw_donate.ScrollToRow(il_rows)
		dw_donate.SetColumn(ii_min_column_id)
		dw_donate.SetFocus()
	end if
elseif dw_pension.visible = true then
	
	il_rows = dw_pension.InsertRow(0)
	
	/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
	if il_rows > 0 then
		dw_pension.ScrollToRow(il_rows)
		dw_pension.SetColumn(ii_min_column_id)
		dw_pension.SetFocus()
	end if
elseif dw_house.visible = true then
	
	il_rows = dw_house.InsertRow(0)
	
	/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
	if il_rows > 0 then
		dw_house.ScrollToRow(il_rows)
		dw_house.SetColumn(ii_min_column_id)
		dw_house.SetFocus()
	end if
	
end if	

parent.Trigger Event ue_button(2, il_rows)
parent.Trigger Event ue_msg(2, il_rows)

end event

type cb_delete_don from commandbutton within w_92020_e
integer x = 3145
integer y = 3000
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
boolean enabled = false
string text = "삭제"
end type

event clicked;long			ll_cur_row


if dw_donate.visible = true then
	ll_cur_row = dw_donate.GetRow()
	
	if ll_cur_row <= 0 then return
	
	idw_status = dw_donate.GetItemStatus (ll_cur_row, 0, primary!)	
	
	il_rows = dw_donate.DeleteRow (ll_cur_row)
	dw_donate.SetFocus()
elseif dw_pension.visible = true	then  
	ll_cur_row = dw_pension.GetRow()
	
	if ll_cur_row <= 0 then return
	
	idw_status = dw_pension.GetItemStatus (ll_cur_row, 0, primary!)	
	
	il_rows = dw_pension.DeleteRow (ll_cur_row)
	dw_pension.SetFocus()	
else
	ll_cur_row = dw_house.GetRow()
	
	if ll_cur_row <= 0 then return
	
	idw_status = dw_house.GetItemStatus (ll_cur_row, 0, primary!)	
	
	il_rows = dw_house.DeleteRow (ll_cur_row)
	dw_house.SetFocus()	
	
end if	

parent.Trigger Event ue_button(4, il_rows)
parent.Trigger Event ue_msg(4, il_rows)

end event

type shl_1 from statichyperlink within w_92020_e
integer x = 1623
integer y = 48
integer width = 1102
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
long backcolor = 79741120
string text = "※ 연말정산 간소화파일(PDF) 등록"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
string url = "http://work.ibeaucre.co.kr:8080/member/login"
end type

type tab_1 from tab within w_92020_e
integer y = 3000
integer width = 5879
integer height = 412
integer taborder = 60
integer textsize = -9
integer weight = 700
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
tabpage_3 tabpage_3
end type

event clicked;//IF dw_head.Enabled = TRUE THEN Return 1

  	CHOOSE CASE index
		CASE 1
		 dw_donate.visible = true
		 dw_pension.visible = false
		 dw_house.visible = false
		CASE 2
		 dw_donate.visible = false 
		 dw_pension.visible = true			
 		 dw_house.visible = false
		CASE 3
		 dw_donate.visible = false 
		 dw_pension.visible = false
		 dw_house.visible = true
		 

	END CHOOSE

end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 5842
integer height = 300
long backcolor = 79741120
string text = "기부금명세"
long tabtextcolor = 16711680
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 5842
integer height = 300
long backcolor = 79741120
string text = "연금/주택저축명세"
long tabtextcolor = 16711680
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 96
integer width = 5842
integer height = 300
long backcolor = 79741120
string text = "월세계약 내용"
long tabtextcolor = 16711680
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type dw_pension from datawindow within w_92020_e
event ue_keydown pbm_dwnkey
boolean visible = false
integer y = 3108
integer width = 5861
integer height = 276
integer taborder = 60
boolean bringtotop = true
string title = "기부금명세"
string dataobject = "d_92020_d04"
boolean hscrollbar = true
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
cb_excel.enabled = false

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

type dw_house from datawindow within w_92020_e
event ue_keydown pbm_dwnkey
boolean visible = false
integer y = 3108
integer width = 5861
integer height = 276
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_92020_d05"
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

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false


end event

type dw_donate from datawindow within w_92020_e
event ue_keydown pbm_dwnkey
integer y = 3108
integer width = 5861
integer height = 276
integer taborder = 50
boolean bringtotop = true
string title = "기부금명세"
string dataobject = "d_92020_d03"
boolean hscrollbar = true
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
//
//This.GetChild("jumin_no", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve(is_year, is_empno)
//
//
//This.GetChild("kname", ldw_child)
//ldw_child.SetTransObject(SQLCA)
//ldw_child.Retrieve(is_year, is_empno, "%")
end event

event itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false

datawindowchild ldw_child
string ls_jumin_no

CHOOSE CASE dwo.name
	CASE "jumin_no" 
		This.GetChild("kname", ldw_child)
		ldw_child.SetTransObject(SQLCA)
		ldw_child.Retrieve(is_year, is_empno, data)   

END CHOOSE




end event

type st_2 from statictext within w_92020_e
integer x = 14
integer y = 1340
integer width = 2560
integer height = 52
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 255
long backcolor = 67108864
string text = "* 부양가족 정보 입력시 오류 방지를 위해 (ㅁ)최대화 버튼을 누르고 작업하시기 바랍니다."
boolean focusrectangle = false
end type

type st_3 from statictext within w_92020_e
integer x = 18
integer y = 2924
integer width = 2871
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 16711680
long backcolor = 67108864
string text = "* 기부금 항목 공제등록시 필수로 입력해주세요. 연금과 월세내역(입력불가)은 자료 제출만 해주세요."
boolean focusrectangle = false
end type

type dw_dedu_s from datawindow within w_92020_e
boolean visible = false
integer y = 292
integer width = 5477
integer height = 2232
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "신용카드 상세 확인"
string dataobject = "d_92020_d02_sub"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

