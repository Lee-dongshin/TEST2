$PBExportHeader$w_56108_e.srw
$PBExportComments$수수료 처리
forward
global type w_56108_e from w_com010_e
end type
type st_1 from statictext within w_56108_e
end type
end forward

global type w_56108_e from w_com010_e
integer width = 3675
integer height = 2284
event ue_bill_chk ( )
st_1 st_1
end type
global w_56108_e w_56108_e

type variables
DataWindowChild  idw_brand 
String is_brand, is_yymm 
end variables

event ue_bill_chk();Long ll_cnt 

Select count(bill_no)
  into :ll_cnt 
  from tb_56030_m 
 where yymm  = :is_yymm 
   and brand = :is_brand 
	and bill_no is not null;
	
//IF ll_cnt > 0 THEN 
//	dw_body.Enabled = False
//	st_1.Text = "세금계산서가 발행 되여 수정할 수 없습니다."
//ELSE
//	dw_body.Enabled = True
//	st_1.Text = ""
//END IF
end event

on w_56108_e.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_56108_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      : 김 태범                                                     */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_yymm = String(dw_head.GetitemDateTime(1, "yymm"), "yyyymm")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_yymm)
IF il_rows > 0 THEN
	This.Post Event ue_bill_chk()
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2002.03.26                                                  */	
/* 수정일      : 2002.03.26                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
String   ls_yymm , ls_bill_date

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
	ls_bill_date =  dw_body.GetitemString(i, "issue_date")
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		ls_yymm = dw_body.GetitemString(i, "yymm") 
		IF isnull(ls_yymm) OR Trim(ls_yymm) = "" THEN
         dw_body.Setitem(i, "yymm",   is_yymm)
         dw_body.Setitem(i, "reg_id", gs_user_id)
         dw_body.SetItemStatus(i, 0, Primary!, NewModified!)
		ELSE
				
         dw_body.Setitem(i, "mod_id", gs_user_id)
         dw_body.Setitem(i, "mod_dt", ld_datetime)
 		
		END IF 
   END IF
NEXT

il_rows = dw_body.Update()

if il_rows = 1 then
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;inv_resize.of_Register(st_1, "ScaleToRight")

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56108_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56108_e
end type

type cb_delete from w_com010_e`cb_delete within w_56108_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_56108_e
boolean visible = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56108_e
end type

type cb_update from w_com010_e`cb_update within w_56108_e
end type

type cb_print from w_com010_e`cb_print within w_56108_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56108_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56108_e
end type

type cb_excel from w_com010_e`cb_excel within w_56108_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56108_e
integer width = 1682
integer height = 164
string dataobject = "d_56108_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_56108_e
integer beginy = 344
integer endy = 344
end type

type ln_2 from w_com010_e`ln_2 within w_56108_e
integer beginy = 348
integer endy = 348
end type

type dw_body from w_com010_e`dw_body within w_56108_e
integer y = 368
integer height = 1680
boolean enabled = false
string dataobject = "d_56108_d01"
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
String  ls_tax_fg , ls_bill_date
Decimal ldc_fee_amt,  ldc_ded_tot, ldc_pay_tax , ldc_ded_etc, ldc_ded_10, ldc_ded_11, ldc_ded_12, ldc_ded_97,ldc_ded_13
Decimal ldc_basic_pay

IF dwo.name = "b_copy" THEN 
	ll_row_cnt = This.RowCount()
	IF ll_row_cnt < 1 THEN RETURN 
	FOR i = 1 TO ll_row_cnt 
		ls_tax_fg   = This.GetitemString(i,  "tax_fg_new") 
		ldc_fee_amt = This.GetitemDecimal(i, "edps_fee_amt")  
		ls_bill_date = This.GetitemString(i, "issue_date")  	
		ldc_basic_pay = This.GetitemDecimal(i, "basic_pay")  
	
		if isnull(ls_bill_date) or  Trim(ls_bill_date) = "" then 
					
			IF isnull(ldc_fee_amt) THEN ldc_fee_amt = 0 
			ldc_ded_tot = This.GetitemDecimal(i, "ded_tot") 
			ldc_ded_10  = This.GetitemDecimal(i, "ded_10") 			
			ldc_ded_11  = This.GetitemDecimal(i, "ded_11") 			
			ldc_ded_12  = This.GetitemDecimal(i, "ded_12") 			
			ldc_ded_13  = This.GetitemDecimal(i, "ded_13") 		
			ldc_ded_97  = This.GetitemDecimal(i, "ded_97") 						
//			ldc_ded_etc = This.GetitemDecimal(i, "ded_etc") 			
			IF isnull(ldc_ded_tot) THEN ldc_ded_tot = 0 
			IF isnull(ldc_ded_10 ) THEN ldc_ded_10  = 0 	
			IF isnull(ldc_ded_11)  THEN ldc_ded_11  = 0 	
			IF isnull(ldc_ded_12)  THEN ldc_ded_12  = 0 	
			IF isnull(ldc_ded_13)  THEN ldc_ded_13  = 0 	
			IF isnull(ldc_ded_97)  THEN ldc_ded_97  = 0 				
//			IF isnull(ldc_ded_etc) THEN ldc_ded_etc = 0 			
			
			This.Setitem(i, "sale_amt", This.GetitemNumber(i, "sale_amt"))  
			This.Setitem(i, "ded_tot",  ldc_ded_tot)  
			This.Setitem(i, "ded_10" ,  ldc_ded_10)  			
			This.Setitem(i, "ded_11" ,  ldc_ded_11)  			
			This.Setitem(i, "ded_12" ,  ldc_ded_12)  			
			This.Setitem(i, "ded_13" ,  ldc_ded_13)  			
			This.Setitem(i, "ded_97" ,  ldc_ded_97)  			
			This.Setitem(i, "basic_pay" ,  ldc_basic_pay)  	
//			This.Setitem(i, "ded_etc",  ldc_ded_etc)  			
			This.Setitem(i, "fee_amt", ldc_fee_amt)  
			This.Setitem(i, "tax_fg",  ls_tax_fg)  
	
			IF ls_tax_fg = '1' THEN
//				This.Setitem(i, "amt", (ldc_fee_amt + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) - round((ldc_fee_amt  + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) / 1.1, 0))  				
				This.Setitem(i, "amt", round((ldc_fee_amt  + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) / 1.1, 0))  								
				This.Setitem(i, "vat",  (ldc_fee_amt + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) - round((ldc_fee_amt  + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) / 1.1, 0))  
				This.Setitem(i, "pay_tax", 0)  
				This.Setitem(i, "id_tax",  0)  
				This.Setitem(i, "tot_amt", (ldc_fee_amt  + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) )// + round((ldc_fee_amt - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97 ) / 10, 0))  
			ELSE
	   		This.Setitem(i, "amt", (ldc_fee_amt + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97))  				
				ldc_pay_tax = TRUNCATE( ( round((ldc_fee_amt  + ldc_basic_pay) * 0.03, 0) / 10 ),0) * 10  // round((ldc_fee_amt - ldc_ded_tot) * 0.03, 0) //
				This.Setitem(i, "vat",     0)  
				This.Setitem(i, "pay_tax", ldc_pay_tax)  
				This.Setitem(i, "id_tax",  TRUNCATE( ( round(ldc_pay_tax / 10, 0) ) /10 ,0 ) * 10 )
				This.Setitem(i, "tot_amt", (ldc_fee_amt  + ldc_basic_pay - ldc_ded_tot - ldc_ded_10 - ldc_ded_11 - ldc_ded_12 - ldc_ded_13 - ldc_ded_97) - ldc_pay_tax -  TRUNCATE( ( round(ldc_pay_tax / 10, 0) ) /10 ,0 ) * 10 )  // round(ldc_pay_tax / 10, 0))  
			END IF
   	end if  
		
	NEXT 
   ib_changed = true
   cb_update.enabled = true
END IF 

end event

event dw_body::constructor;call super::constructor;DataWindowChild ldw_child 

This.GetChild("pay_way", ldw_child)
ldw_child.SetTransObject(SQLCA)
ldw_child.Retrieve('920')
end event

type dw_print from w_com010_e`dw_print within w_56108_e
end type

type st_1 from statictext within w_56108_e
integer x = 1751
integer y = 236
integer width = 1792
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 128
long backcolor = 67108864
boolean focusrectangle = false
end type

