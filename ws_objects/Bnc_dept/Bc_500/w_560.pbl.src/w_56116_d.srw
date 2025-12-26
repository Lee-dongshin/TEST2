$PBExportHeader$w_56116_d.srw
$PBExportComments$수수료기간별내역조회
forward
global type w_56116_d from w_com010_e
end type
end forward

global type w_56116_d from w_com010_e
integer width = 3675
integer height = 2284
end type
global w_56116_d w_56116_d

type variables
DataWindowChild  idw_brand 
String is_brand, is_yymm, is_yymmdd, is_bungi, is_sale_emp, is_fr_yymm, is_to_yymm
end variables

on w_56116_d.create
call super::create
end on

on w_56116_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
String   ls_title, ls_mm

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


if gs_brand = 'N' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"보끄레 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
elseif gs_brand = 'O' and (is_brand = 'N' or is_brand = 'B' or is_brand = 'L' or is_brand = 'F' or is_brand = 'G' or is_brand = 'J') then
   MessageBox(ls_title,"올리브 직원은 보끄레 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false	
elseif gs_brand = 'B' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false		
elseif gs_brand = 'G' and (is_brand = 'O' or is_brand = 'D') then
   MessageBox(ls_title,"이터널 직원은 올리브 데이터 조회에 제한이 있습니다.!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false			
end if	


is_yymm   = String(dw_head.GetitemDateTime(1, "yymm"), "yyyymm")
is_yymmdd = String(dw_head.GetitemDate(1, "yymmdd"), "yyyy.mm.dd")
is_fr_yymm   = String(dw_head.GetitemDateTime(1, "fr_yymm"), "yyyymm")
is_to_yymm   = String(dw_head.GetitemDateTime(1, "to_yymm"), "yyyymm")


is_sale_emp = dw_head.GetItemString(1, "sale_emp")
if IsNull(is_sale_emp) or Trim(is_sale_emp) = "" then
	is_sale_emp = "%"
end if

/*
ls_mm = mid(is_yymmdd,6,2)

CHOOSE CASE ls_mm 
	CASE '01', '02', '03' 
		dw_head.Setitem(1, "rep_bungi", '1')
	CASE '04', '05', '06' 
		dw_head.Setitem(1, "rep_bungi", '2')
	CASE '07', '08', '09' 
		dw_head.Setitem(1, "rep_bungi", '3')
   CASE ELSE
		dw_head.Setitem(1, "rep_bungi", '4')
END CHOOSE 


is_bungi = dw_head.GetitemString(1, "rep_bungi")
if IsNull(is_bungi) or Trim(is_bungi) = "" then
   MessageBox(ls_title,"신고분기 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("rep_bungi")
   return false
end if
*/
return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */



IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN


il_rows = dw_body.retrieve(is_brand, is_fr_yymm, is_to_yymm, is_sale_emp)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;String ls_mm 

ls_mm = String(dw_head.GetitemDate(1, "yymmdd"), "mm")

CHOOSE CASE ls_mm 
	CASE '01', '02', '03' 
		dw_head.Setitem(1, "rep_bungi", '1')
	CASE '04', '05', '06' 
		dw_head.Setitem(1, "rep_bungi", '2')
	CASE '07', '08', '09' 
		dw_head.Setitem(1, "rep_bungi", '3')
   CASE ELSE
		dw_head.Setitem(1, "rep_bungi", '4')
END CHOOSE 
end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
String ls_ErrMsg
Long   ll_sqlcode

IF MessageBox("확인", "계산처 처리 하시겠습니까 ?", Question!, YesNo! ) = 2 THEN 
	RETURN 0 
END IF

 DECLARE SP_56110_BILL PROCEDURE FOR SP_56110_BILL  
         @brand     = :is_brand,   
         @yymm      = :is_yymm,   
         @yymmdd    = :is_yymmdd,   
         @rep_bungi = :is_bungi,   
         @user_id   = :gs_user_id,
			@sale_emp  = :is_sale_emp;

EXECUTE SP_56110_BILL;

if SQLCA.SQLCODE = 0  OR SQLCA.SQLCODE = 100 then
   commit  USING SQLCA;
	il_rows = 1 
	dw_body.retrieve(is_brand, is_yymm,is_sale_emp)
	cb_update.Enabled = False
else 
	ll_sqlcode = SQLCA.SQLCODE
	ls_ErrMsg  = SQLCA.SQLErrText 
   rollback  USING SQLCA; 
	MessageBox("SQL 오류", "[" + String(ll_sqlcode) + "]" + ls_ErrMsg) 
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event ue_button(integer ai_cb_div, long al_rows);call super::ue_button;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
String ls_bill_no, ls_slip_no 
String ls_report_bungi
Date   ld_issue_date

CHOOSE CASE ai_cb_div
   CASE 1		/* 조회 */
      if al_rows > 0 then
         ls_bill_no = dw_body.GetitemString(1, "bill_no")
         ls_slip_no = dw_body.GetitemString(1, "slip_no") 
         IF isnull(ls_bill_no) OR Trim(ls_bill_no) = "" THEN
            cb_update.Enabled = True 
         ELSE 
				dw_head.Setitem(1, "yymmdd", Date(dw_body.GetitemString(1, "issue_date")))
				dw_head.Setitem(1, "rep_bungi", dw_body.GetitemString(1, "report_bungi"))
				IF isnull(ls_slip_no) OR Trim(ls_slip_no) = "" THEN 
//				   cb_slip.Enabled = True 
				END IF 
         END IF 
      end if
   CASE 5    /* 조건 */
      cb_update.enabled = false
//      cb_slip.enabled = false
END CHOOSE

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56110_e","0")
end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;
String     ls_shop_nm 
Boolean    lb_check 
DataStore  lds_Source

CHOOSE CASE as_column
CASE "sale_emp"
		IF ai_div = 1 THEN 	
			If IsNull(as_data) or Trim(as_data) = "" Then			
				RETURN 0
			END IF 
		END IF	
			iF LeftA(as_data, 1) <> '8' Then
				MessageBox("입력오류", "판매사원 코드는 '8'로 시작합니다!")
				Return 1
			End If
			
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

			lb_check = FALSE 
			IF Isvalid(Message.PowerObjectParm) THEN
				ib_itemchanged = True
				lds_Source = Message.PowerObjectParm
				IF ai_div = 2 THEN 
				   dw_head.SetRow(al_row)
				   dw_head.SetColumn(as_column)
				END IF
				dw_head.SetItem(al_row, "sale_emp", lds_Source.GetItemString(1,"sale_emp"))
				dw_head.SetItem(al_row, "emp_nm", lds_Source.GetItemString(1,"sale_empnm"))
			/* 다음컬럼으로 이동 */

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


	Return 0
end event

event ue_title();call super::ue_title;
datetime ld_datetime
string ls_modify, ls_datetime, ls_shop

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")



ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
            "t_user_id.Text = '" + gs_user_id + "'" + &
            "t_datetime.Text = '" + ls_datetime + "'" + & 				
				"t_brand.Text = '" + idw_brand.GetitemString(idw_brand.GetRow(), "inter_display") + "'" + &
				"t_fr_yymm.Text = '" + is_fr_yymm + "'" + & 
				"t_to_yymm.Text = '" + is_to_yymm + "'" 
				

dw_print.Modify(ls_modify)


end event

event ue_print();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()


end event

event ue_preview();/*===========================================================================*/
/* 작성자      : (주)지우정보                                                */	
/* 작성일      : 2002.01.03                                                  */	
/* 수정일      : 2002.01.03                                                  */
/*===========================================================================*/

This.Trigger Event ue_title ()
dw_print.Object.DataWindow.Print.Orientation = 0  // 0:세로, 1:가로

dw_body.ShareData(dw_print)
dw_print.inv_printpreview.of_SetZoom()
end event

type cb_close from w_com010_e`cb_close within w_56116_d
integer taborder = 120
end type

type cb_delete from w_com010_e`cb_delete within w_56116_d
boolean visible = false
integer taborder = 60
end type

type cb_insert from w_com010_e`cb_insert within w_56116_d
boolean visible = false
integer taborder = 50
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56116_d
end type

type cb_update from w_com010_e`cb_update within w_56116_d
boolean visible = false
integer width = 466
integer taborder = 110
string text = "계산서 처리(&S)"
end type

type cb_print from w_com010_e`cb_print within w_56116_d
integer x = 2190
integer taborder = 80
boolean enabled = true
end type

type cb_preview from w_com010_e`cb_preview within w_56116_d
boolean visible = false
integer x = 1838
integer taborder = 90
end type

type gb_button from w_com010_e`gb_button within w_56116_d
end type

type cb_excel from w_com010_e`cb_excel within w_56116_d
integer x = 2533
integer taborder = 100
boolean enabled = true
end type

type dw_head from w_com010_e`dw_head within w_56116_d
integer width = 3547
integer height = 212
string dataobject = "d_56116_h01"
end type

event dw_head::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("rep_bungi", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('017')


end event

event dw_head::itemchanged;call super::itemchanged;int li_ret
string ls_brand, ls_year, ls_season

CHOOSE CASE dwo.name

	CASE "sale_emp"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56116_d
integer beginy = 392
integer endy = 392
end type

type ln_2 from w_com010_e`ln_2 within w_56116_d
integer beginy = 396
integer endy = 396
end type

type dw_body from w_com010_e`dw_body within w_56116_d
integer y = 412
integer height = 1636
integer taborder = 40
string dataobject = "d_56116_d01"
boolean hscrollbar = true
boolean hsplitscroll = true
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

event dw_body::buttonclicked;call super::buttonclicked;Long    i, ll_row_cnt  
String  ls_tax_fg 
Decimal ldc_fee_amt,  ldc_ded_tot, ldc_pay_tax 

IF dwo.name = "b_copy" THEN 
	ll_row_cnt = This.RowCount()
	IF ll_row_cnt < 1 THEN RETURN 
	FOR i = 1 TO ll_row_cnt 
		ls_tax_fg   = This.GetitemString(i,  "tax_fg_new") 
		ldc_fee_amt = This.GetitemDecimal(i, "edps_fee_amt")  
		IF isnull(ldc_fee_amt) THEN ldc_fee_amt = 0 
		ldc_ded_tot = This.GetitemDecimal(i, "ded_tot") 
		IF isnull(ldc_ded_tot) THEN ldc_ded_tot = 0 
		This.Setitem(i, "fee_amt", ldc_fee_amt)  
		This.Setitem(i, "tax_fg",  ls_tax_fg)  
		IF ls_tax_fg = '1' THEN
		   This.Setitem(i, "vat",     round(ldc_fee_amt / 10, 0))  
		   This.Setitem(i, "pay_tax", 0)  
		   This.Setitem(i, "id_tax",  0)  
		   This.Setitem(i, "tot_amt", ldc_fee_amt + round(ldc_fee_amt / 10, 0))  
		ELSE
			ldc_pay_tax = round(ldc_fee_amt * 0.03, 0)
		   This.Setitem(i, "vat",     0)  
		   This.Setitem(i, "pay_tax", ldc_pay_tax)  
		   This.Setitem(i, "id_tax",  round(ldc_pay_tax / 10, 0))  
		   This.Setitem(i, "tot_amt", ldc_fee_amt - ldc_pay_tax - round(ldc_pay_tax / 10, 0))  
		END IF
	NEXT 
   ib_changed = true
   cb_update.enabled = true
   cb_print.enabled = true	
END IF 


this.accepttext()
if dwo.name = 'b_prt' then
	ll_row_cnt = This.RowCount()
	if this.object.b_prt.text = '전체선택' then		
		this.scrolltorow(0)
		IF ll_row_cnt < 1 THEN RETURN 
		FOR i = 1 TO ll_row_cnt 
			this.setitem(i,'prt','Y')
			this.ScrollNextRow()
  			SetPointer(HourGlass!)			
		NEXT
		this.modify("b_prt.text = '전체해제'")
	else
		IF ll_row_cnt < 1 THEN RETURN 
		this.scrolltorow(0)
		FOR i = 1 TO ll_row_cnt 
			this.setitem(i,'prt','N')
			this.ScrollNextRow()
  			SetPointer(HourGlass!)		
		NEXT
		this.modify("b_prt.text = '전체선택'")
	end if
end if



end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("pay_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('920')
end event

event dw_body::itemchanged;ib_changed = true
cb_update.enabled = true
cb_print.enabled = true
end event

type dw_print from w_com010_e`dw_print within w_56116_d
string dataobject = "d_56116_r01"
end type

