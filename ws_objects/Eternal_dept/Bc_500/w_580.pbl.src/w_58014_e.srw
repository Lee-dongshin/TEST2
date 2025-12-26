$PBExportHeader$w_58014_e.srw
$PBExportComments$부자재수출 Invoice등록
forward
global type w_58014_e from w_com010_e
end type
type dw_detail from datawindow within w_58014_e
end type
type dw_2 from datawindow within w_58014_e
end type
type dw_1 from datawindow within w_58014_e
end type
type dw_3 from datawindow within w_58014_e
end type
end forward

global type w_58014_e from w_com010_e
integer width = 3694
integer height = 2284
dw_detail dw_detail
dw_2 dw_2
dw_1 dw_1
dw_3 dw_3
end type
global w_58014_e w_58014_e

type variables
string is_brand, is_invoice_date, is_invoice_no, is_style, is_chno, is_style_no
string is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_country_cd
decimal idc_us_exchange
decimal id_detail_rows
boolean ib_flag = false
Datawindowchild  idw_brand, idw_country_cd


end variables

forward prototypes
public function integer wf_detail_retrieve (string as_flag)
end prototypes

public function integer wf_detail_retrieve (string as_flag);string 	ls_out_from_date, ls_out_to_date, ls_country_cd, ls_cust_cd, ls_seq_no, ls_omit_gbn
string	ls_Style,ls_item_nm,ls_Composition
decimal	i, ld_exchange_rate, ld_qty, ld_amount,  ld_row_count
decimal	ld_sale_qty,ld_Exchange_price,ld_exchange_amt,ld_sale_amt, ld_tot_sale_amt
			


			ls_out_from_date = dw_body.GetItemString(1,"out_from_Date")
			ls_out_to_date   = dw_body.GetItemString(1,"out_to_Date")
			ld_exchange_rate = dw_body.GetItemDecimal(1,"exchange_rate")
			ls_country_cd    = dw_body.GetItemString(1,"country_cd")
			ls_cust_cd 		  = dw_body.GetItemString(1,"cust_cd")

//messagebox("is_brand", is_brand)
//messagebox("ls_country_cd" ,ls_country_cd)
//messagebox("ld_exchange_rate", ld_exchange_rate)
//messagebox("is_Invoice_Date" ,is_Invoice_Date)
//messagebox("is_invoice_no", is_invoice_no)
//messagebox("as_flag", as_flag)
//

			if as_flag = 'New' then
				ld_row_count   = dw_detail.retrieve(is_brand, ls_country_cd, ld_exchange_rate, is_Invoice_Date, is_invoice_no, as_flag)
//				for i = 1 to ld_row_count
//					dw_detail.SetItemStatus(i, 0, Primary!, NewModified!)
//					ls_seq_no			= string(i, '0000')					
//					dw_detail.setitem(i,"seq_no",ls_seq_no)
//				next
			else
				id_detail_rows = dw_detail.retrieve(is_brand, ls_country_cd, ld_exchange_rate, is_Invoice_Date, is_invoice_no, as_flag)
			end if 
			


										
			ld_qty =    dw_detail.GetItemDecimal(1,"tot_qty")
			ld_amount = dw_detail.GetItemDecimal(1,"tot_amount")
			ld_tot_sale_amt = dw_detail.GetItemDecimal(1,"tot_sale_amt")
			dw_body.SetItem(1,"quantity",ld_qty)
			dw_body.SetItem(1,"amount",ld_amount)
			dw_body.SetItem(1,"sale_amt",ld_tot_sale_amt)
				    
					 
			dw_2.retrieve(is_brand, is_invoice_date, is_invoice_no)
return 1

end function

on w_58014_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.dw_2=create dw_2
this.dw_1=create dw_1
this.dw_3=create dw_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.dw_2
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.dw_3
end on

on w_58014_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.dw_3)
end on

event type boolean ue_keycheck(string as_cb_div);call super::ue_keycheck;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
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

is_brand = dw_head.GetItemString(1, "brand")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_invoice_date = dw_head.GetItemString(1, "invoice_date")
if IsNull(is_invoice_date) or Trim(is_invoice_date) = "" then
   MessageBox(ls_title,"invoice_date를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("invoice_date")
   return false
end if

is_invoice_no = dw_head.GetItemString(1, "invoice_no")
if IsNull(is_invoice_no) or Trim(is_invoice_no) = "" then
   MessageBox(ls_title,"invoice_no를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("invoice_no")
   return false
end if



return true

end event

event ue_retrieve;call super::ue_retrieve;/*=========================================================================-==*/
/* 작성자      : (주)지우정보 ()                                      			*/	
/* 작성일      : 2001..                                                  		*/	
/* 수정일      : 2001..                                                  		*/
/*========================================================================-===*/
string 	ls_out_from_date, ls_out_to_date, ls_country_cd, ls_shop_cd
decimal	ld_exchange_rate, ld_qty, ld_amount, ldc_rows

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

ldc_rows = dw_body.retrieve(is_brand,is_invoice_date,is_invoice_no)
dw_detail.reset()
dw_1.reset()
dw_2.reset()

IF ldc_rows > 0 THEN
   dw_body.SetFocus()
	wf_detail_retrieve('Dat')	
	
ELSE
	il_rows = dw_body.InsertRow(0)
	dw_body.Setitem(1, "brand", is_brand)
	dw_body.Setitem(1, "invoice_date", is_invoice_date)
	dw_body.Setitem(1, "invoice_no", is_invoice_no)	
	
	select usd_c 
		into :ld_exchange_rate
	from tb_91080_c (nolock) where yymmdd = :is_invoice_date;
	dw_body.Setitem(1, "exchange_rate", ld_exchange_rate)	
	
END IF
dw_2.retrieve(is_brand, is_invoice_date, is_invoice_no)
dw_1.insertrow(0)
This.Trigger Event ue_button(1, il_rows)
if ldc_rows > 0 then 
	dw_2.enabled = false
else 
	dw_2.enabled = true
end if

This.Trigger Event ue_msg(1, il_rows)


end event

event ue_update;
/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long 		i, ll_row_count
datetime ld_datetime
decimal	ld_qty, ld_amount, ld_tot_sale_amt
string  ls_out_from_date, ls_out_to_date, ls_country_cd
decimal	ld_exchange_rate 

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

IF dw_body.AcceptText() <> 1 THEN RETURN 0
IF dw_2.AcceptText() <> 1 THEN RETURN -1
IF dw_detail.AcceptText() <> 1 THEN RETURN -1


ld_exchange_rate = dw_body.GetItemDecimal(1,"exchange_rate")
ls_country_cd    = dw_body.GetItemString(1,"country_cd")

if dw_body.rowcount() > 0 then 
	if isnull(ld_exchange_rate) or ld_exchange_rate = 0 	then 
		messagebox("확인","환율을 입력해 주세요..")
		dw_body.setcolumn('exchange_rate')
		dw_body.setfocus()
		Return 0
	end if
	
	if isnull(ls_country_cd) or ls_country_cd = '' 	then 
		messagebox("확인","국가를 입력해 주세요..")
		dw_body.setcolumn('country_cd')
		dw_body.setfocus()	
		Return 0
	end if
end if
//-----------------------------------
//---------------------------------------------------------------
il_rows = dw_2.Update(TRUE, FALSE)


//----------------------------------------------------------------
//if ib_flag then							
//		il_rows = dw_detail.retrieve(is_brand, ls_country_cd, ld_exchange_rate, is_invoice_date, is_invoice_no, 'New')
//		ib_flag = false
		
		ld_qty =    dw_detail.GetItemDecimal(1,"tot_qty")
		ld_amount = dw_detail.GetItemDecimal(1,"tot_amount")
		ld_tot_sale_amt = dw_detail.GetItemDecimal(1,"tot_sale_amt")
		dw_body.SetItem(1,"quantity",ld_qty)
		dw_body.SetItem(1,"amount",ld_amount)
		dw_body.SetItem(1,"sale_amt",ld_tot_sale_amt)		
//else
		
	//----------------------------------------------------------------

	
ll_row_count = dw_detail.RowCount()
FOR i=1 TO ll_row_count
	idw_status = dw_detail.GetItemStatus(i, 0, Primary!)
	IF idw_status = NewModified! THEN				/* New Record */
		dw_detail.Setitem(i, "reg_id", gs_user_id)
	ELSEIF idw_status = DataModified! THEN		/* Modify Record */
		dw_detail.Setitem(i, "mod_id", gs_user_id)
		dw_detail.Setitem(i, "mod_dt", ld_datetime)
	END IF
NEXT
il_rows = dw_detail.Update(TRUE, FALSE)



ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1
//-----------------------------------
FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */
      dw_body.Setitem(i, "reg_id", gs_user_id)
   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
      dw_body.Setitem(i, "mod_id", gs_user_id)
      dw_body.Setitem(i, "mod_dt", ld_datetime)
   END IF
NEXT
il_rows = dw_body.Update(TRUE, FALSE)


if il_rows > 0 then
	dw_body.ResetUpdate()
   dw_2.ResetUpdate()
	dw_detail.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_preopen();call super::pfc_preopen;
dw_detail.SetTransObject(SQLCA)
inv_resize.of_Register(dw_detail, "ScaleToRight&Bottom")

dw_1.SetTransObject(SQLCA)
inv_resize.of_Register(dw_1, "ScaleToRight")

dw_2.SetTransObject(SQLCA)
inv_resize.of_Register(dw_2, "ScaleToRight")

dw_3.SetTransObject(SQLCA)

end event

event open;call super::open;datetime	ld_datetime
string   ls_invoice_date 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_invoice_date = String(ld_datetime, "yyyymmdd")
 

dw_head.Setitem(1,"invoice_date", ls_invoice_date)

end event

event ue_button;/*===========================================================================*/
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
         cb_print.enabled = true
         cb_preview.enabled = true
         cb_excel.enabled = true
         cb_retrieve.Text = "조건(&Q)"
         dw_head.Enabled = false
         dw_body.Enabled = true
			dw_1.Enabled = true
			dw_2.Enabled = true			
         dw_body.SetFocus()
      else
         cb_delete.enabled = false
         cb_print.enabled = false
         cb_preview.enabled = false
         cb_excel.enabled = true
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
				dw_1.Enabled = false
				dw_2.Enabled = false
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
      cb_delete.enabled = false
      cb_print.enabled = false
      cb_preview.enabled = false
      cb_excel.enabled = false
      cb_update.enabled = false
      ib_changed = false
      dw_body.Enabled = false
      dw_head.Enabled = true
      dw_head.SetFocus()
      dw_head.SetColumn(1)
		dw_1.Enabled = false
		dw_2.Enabled = false		

END CHOOSE

end event

event ue_excel;if messagebox("확인","인보이스 " + is_invoice_no +" 를 삭제하시겠습니다...?",Exclamation!,YesNoCancel!,1 ) <> 1 then return


			delete a
			from tb_56400_d a(nolock)
			where invoice_no = :is_invoice_no;	
			
			delete a
			from tb_56401_h a(nolock)
			where invoice_no = :is_invoice_no;	
			
			update a set invoice_no = null
			from tb_21021_d a(nolock)
			where invoice_no = :is_invoice_no;	
			
			update a set invoice_no = null
			from tb_56400_m a(nolock)
			where invoice_no = :is_invoice_no;	
			
			commit  USING SQLCA;
			
messagebox("확인","삭제되었습니다.. ")
Trigger Event ue_retrieve()
///*===========================================================================*/
///* 작성자      : (주)지우정보 (김 태범)                                      */	
///* 작성일      : 2001.01.01																  */	
///* 수정일      : 2001.01.01																  */
///*===========================================================================*/
///* row에 따라 삭제조건이 틀릴경우 새로 작성 */
//long ll_cur_row, i, ll_det_row
//string ls_null
//setnull(ls_null)
//
//
//ll_cur_row = dw_body.GetRow()
//ll_det_row = dw_detail.RowCount()
//if ll_cur_row <= 0 then return
//
//idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	
//
//il_rows = dw_body.DeleteRow (ll_cur_row)
//if il_rows > 0 then 
//	for i = ll_det_row to 1 step -1
//		dw_detail.deleterow(i)
//	next 
//	dw_body.SetFocus()
//end if
//
//for i = 1 to dw_2.rowcount() 
//		dw_2.setitem(i,"chk",0)
//		dw_2.setitem(i,"invoice_date",ls_null)
//		dw_2.setitem(i,"invoice_no",ls_null)
//next 
//
//This.Trigger Event ue_button(4, il_rows)
//This.Trigger Event ue_msg(4, il_rows)
//
end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long		i,	ll_cur_row
string 	ls_null

setnull(ls_null)

ll_cur_row = dw_detail.GetRow()

if ll_cur_row <= 0 then return

idw_status = dw_detail.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_detail.DeleteRow (ll_cur_row)
dw_detail.SetFocus()

if dw_detail.rowcount() = 0 then
	for i = 1 to dw_2.rowcount()
		dw_2.setitem(i,"chk",0)
		dw_2.setitem(i,"invoice_date",ls_null)
		dw_2.setitem(i,"invoice_no",ls_null)
		
	next
end if

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)


end event

type cb_close from w_com010_e`cb_close within w_58014_e
end type

type cb_delete from w_com010_e`cb_delete within w_58014_e
boolean visible = false
end type

type cb_insert from w_com010_e`cb_insert within w_58014_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58014_e
end type

type cb_update from w_com010_e`cb_update within w_58014_e
end type

type cb_print from w_com010_e`cb_print within w_58014_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_58014_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_58014_e
end type

type cb_excel from w_com010_e`cb_excel within w_58014_e
string text = "전체삭제"
end type

type dw_head from w_com010_e`dw_head within w_58014_e
integer height = 120
string dataobject = "d_58014_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_58014_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com010_e`ln_2 within w_58014_e
integer beginy = 296
integer endy = 296
end type

type dw_body from w_com010_e`dw_body within w_58014_e
integer y = 308
integer width = 3392
integer height = 1180
string dataobject = "d_58014_d01"
boolean vscrollbar = false
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string 	ls_invoice_no
decimal	ld_exchange_rate, ld_qty, ld_amount

CHOOSE CASE dwo.name
	CASE "cb_detail" 
		ld_exchange_rate = dw_body.GetItemDecimal(1,"exchange_rate")
		if ld_exchange_rate = 0 or isnull(ld_exchange_rate)  then
			messagebox("","환율을 입력하세요..")
			return
		end if
			ls_invoice_no = dw_head.GetItemString(1,"invoice_no")
			
			dw_3.retrieve(is_brand, ls_invoice_no)
			dw_3.visible=true
END CHOOSE



end event

event dw_body::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

This.GetChild("country_cd", idw_country_cd)
idw_country_cd.SetTransObject(SQLCA)
idw_country_cd.Retrieve('000')
idw_country_cd.InsertRow(1)
idw_country_cd.SetItem(1,"inter_cd", "%")
idw_country_cd.SetItem(1,"inter_nm", "전체")

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
		IF dw_body.GetColumnName() = "country_of_origin" OR dw_body.GetColumnName() ="remark" OR dw_body.GetColumnName() ="exp_remark" THEN
	   ELSE
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
END CHOOSE

Return 0
end event

type dw_print from w_com010_e`dw_print within w_58014_e
integer x = 786
integer y = 1328
end type

type dw_detail from datawindow within w_58014_e
event ue_keydown pbm_dwnkey
event ue_refresh ( string as_field,  long al_row )
event ue_exchange_refresh ( long al_exchange_amt,  long al_row )
integer x = 5
integer y = 1488
integer width = 3607
integer height = 560
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_58014_d02"
boolean hscrollbar = true
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
		IF dw_body.GetColumnName() = "country_of_origin" OR dw_body.GetColumnName() ="remark" OR dw_body.GetColumnName() ="exp_remark" THEN
	   ELSE
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

END CHOOSE

Return 0
end event

event ue_refresh;decimal ld_exchange_rate, ld_mat_price, ld_sale_qty, ld_weight, ld_sale_amt, ld_g_per_yd, ld_exchange_price, ld_exchange_amt
decimal ld_qty, ld_amount, ld_tot_sale_amt

IF dw_detail.AcceptText() <> 1 THEN RETURN 
ld_mat_price      = this.getitemnumber(al_row,"mat_price")
ld_sale_qty       = this.getitemnumber(al_row,"sale_qty")
ld_weight         = this.getitemnumber(al_row,"weight")
ld_sale_amt       = this.getitemnumber(al_row,"sale_amt")
ld_g_per_yd       = this.getitemnumber(al_row,"g_per_yd")
ld_exchange_price = this.getitemnumber(al_row,"exchange_price")
ld_exchange_amt   = this.getitemnumber(al_row,"exchange_amt")
ld_exchange_rate  = dw_body.getitemnumber(1,"exchange_rate")

choose case as_field
	case "sale_qty"
		this.setitem(al_row,"weight",ld_sale_qty*ld_g_per_yd)
//		this.setitem(al_row,"sale_amt",ld_sale_qty*ld_mat_price)
//		this.setitem(al_row,"exchange_price",(ld_sale_qty*ld_mat_price/ld_exchange_rate)/ld_sale_qty)
//		this.setitem(al_row,"exchange_amt",ld_sale_qty*ld_mat_price/ld_exchange_rate)
		ld_exchange_amt = ld_sale_qty*ld_exchange_price
		this.setitem(al_row,"exchange_amt",ld_exchange_amt)
		post event ue_exchange_refresh(ld_exchange_amt, al_row)

	case "weight"
		this.setitem(al_row,"g_per_yd",ld_weight / ld_sale_qty)
		
	case "sale_amt"
		this.setitem(al_row,"exchange_price",(ld_sale_amt / ld_exchange_rate)/ld_sale_qty)
		this.setitem(al_row,"exchange_amt"  ,ld_sale_amt / ld_exchange_rate)

end choose

ld_qty =    dw_detail.GetItemDecimal(1,"tot_qty")
ld_amount = dw_detail.GetItemDecimal(1,"tot_amount")
ld_tot_sale_amt = dw_detail.GetItemDecimal(1,"tot_sale_amt")
dw_body.SetItem(1,"quantity",ld_qty)
dw_body.SetItem(1,"amount",ld_amount)
dw_body.SetItem(1,"sale_amt",ld_tot_sale_amt)



end event

event ue_exchange_refresh;decimal ldc_exchange_amt, ldc_exchange_price, ldc_sale_qty, ldc_exchange_rate, ldc_tot_sale_amt

ldc_exchange_rate = dw_body.getitemnumber(1,"exchange_rate")
ldc_sale_qty = dw_detail.getitemnumber(al_row,"sale_qty")
ldc_exchange_amt = dw_detail.getitemnumber(al_row,"exchange_amt")

dw_detail.setitem(al_row,"exchange_price",ldc_exchange_amt / ldc_sale_qty)
dw_detail.setitem(al_row,"sale_amt"      ,ldc_exchange_amt * ldc_exchange_rate)

ldc_tot_sale_amt = dw_detail.getitemdecimal(1,"tot_sale_amt")
dw_body.setitem(1,"sale_amt",ldc_tot_sale_amt)
end event

event itemchanged;cb_update.enabled  =true
ib_changed = true

choose case dwo.name
	case "sale_qty"
		post event ue_refresh("sale_qty",row)
	case "weight"
		post event ue_refresh("weight",row)
//	case "sale_amt"
//		post event ue_refresh("sale_amt",row)		
	case "exchange_amt"
		post event ue_exchange_refresh(dec(data), row)
end choose

			
end event

type dw_2 from datawindow within w_58014_e
integer x = 3397
integer y = 308
integer width = 210
integer height = 1176
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_58014_d03"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;string ls_null
setnull(ls_null)

choose case dwo.name
	case "chk"
		if string(data) = '1' then
			this.setitem(row,"invoice_date",is_invoice_date)
			this.setitem(row,"invoice_no"  ,is_invoice_no)
		else 
			this.setitem(row,"invoice_date",ls_null)
			this.setitem(row,"invoice_no"  ,ls_null)			
		end if
end choose

ib_changed = true
cb_update.enabled = true
ib_flag = true
end event

event buttonclicking;choose case dwo.name
	case "cb_contack"
		IF dw_1.AcceptText() <> 1 THEN RETURN 1		
		is_style_no = dw_1.getitemstring(1,"style_no")		
		if isnull(is_style_no) or is_style_no = '' then 
			messagebox("확인","스타일번호를 입력하세요..")
		else	
			dw_2.retrieve(is_brand, is_style_no, is_invoice_date, is_invoice_no)
		end if
end choose

end event

type dw_1 from datawindow within w_58014_e
boolean visible = false
integer x = 3397
integer y = 308
integer width = 210
integer height = 48
integer taborder = 40
boolean bringtotop = true
boolean enabled = false
string title = "none"
string dataobject = "d_58012_d04"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;is_style_no = this.getitemstring(1,"style_no")
is_style = LeftA(is_style_no,8)
is_chno  = MidA(is_style_no,9,1)


end event

event buttonclicked;//choose case dwo.name
//	case "cb_search"
//		IF dw_1.AcceptText() <> 1 THEN RETURN 1		
//		is_style_no = dw_1.getitemstring(1,"style_no")		
//		if isnull(is_style_no) or is_style_no = '' then 
//			messagebox("확인","스타일번호를 입력하세요..")
//		else	
//			dw_2.retrieve(is_brand, is_style_no, is_invoice_date, is_invoice_no)
//		end if
//end choose
//
end event

type dw_3 from datawindow within w_58014_e
event type decimal ue_update ( )
boolean visible = false
integer x = 466
integer y = 448
integer width = 3639
integer height = 1692
integer taborder = 20
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_58014_d04"
boolean controlmenu = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count, ldc_select
string ls_ord_origin, ls_mat_cd, ls_invoice_no, sql
datetime ld_datetime

ll_row_count = dw_3.RowCount()
IF dw_3.AcceptText() <> 1 THEN RETURN -1

il_rows = dw_3.Update(TRUE, FALSE)

//FOR i=1 TO ll_row_count
//   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
//   IF idw_status = NewModified! THEN				/* New Record */
//      dw_body.Setitem(i, "reg_id", gs_user_id)
//   ELSEIF idw_status = DataModified! THEN		/* Modify Record */
//      dw_body.Setitem(i, "mod_id", gs_user_id)
//      dw_body.Setitem(i, "mod_dt", ld_datetime)
//   END IF
//NEXT


is_invoice_no = dw_head.getitemstring(1,"invoice_no")
for i=1 to dw_3.rowcount() 
	ldc_select = dw_3.GetItemnumber(i, "selected")
	ls_ord_origin = dw_3.getitemstring(i,"ord_origin")
	ls_mat_cd = dw_3.getitemstring(i,"mat_cd")
	ls_invoice_no = dw_3.getitemstring(i,"invoice_no")


   idw_status = dw_3.GetItemStatus(i, 0, Primary!)
   IF idw_status = DataModified! THEN		/* Modify Record */
		if ldc_select= 1 then
			update vi_21020_1 set invoice_no = :is_invoice_no
			where ord_origin = :ls_ord_origin
			and   isnull(price_ok,'N')  = 'Y'
			and   isnull(expert_yn,'N') = 'Y'
			and   isnull(invoice_no,'') = ''
			and   mat_cd like '%' + :ls_mat_cd;
				
			commit  USING SQLCA;
		elseif isnull(ldc_select) or ldc_select = 0 then 
			update vi_21020_1 set invoice_no = null
			where ord_origin = :ls_ord_origin
			and   isnull(price_ok,'N')  = 'Y'
			and   isnull(expert_yn,'N') = 'Y'
			and   invoice_no = :is_invoice_no
			and   mat_cd like '%' + :ls_mat_cd;
				
			commit  USING SQLCA;			
		end if

   END IF
	

next 

messagebox("확인","저장되었습니다.")
delete a
from tb_56401_h a(nolock)
where brand = :is_brand
and   invoice_date = :is_invoice_date
and   Invoice_no   = :is_invoice_no;	
commit  USING SQLCA;		
		
wf_detail_retrieve('Dat')	
return il_rows



end event

event buttonclicked;decimal i
decimal ldc_select

CHOOSE CASE dwo.name		
	CASE "b_all_select" 
		ldc_select = dw_3.getitemdecimal(1,"selected")
		if ldc_select = 0 then 
			for i=1 to dw_3.rowcount()
				dw_3.setitem(i,"selected",1)
				dw_3.SetItemStatus(i, 0, Primary!, DataModified!)
			next 
		else
			for i=1 to dw_3.rowcount()
				dw_3.setitem(i,"selected",0)
				dw_3.SetItemStatus(i, 0, Primary!, NotModified!)
			next 			
		end if
		
	CASE "b_save"
		trigger event ue_update()
		
END CHOOSE
end event

event itemchanged;decimal i

//dw_3.SetItemStatus(row, "invoice_no", Primary!, DataModified!)
end event

