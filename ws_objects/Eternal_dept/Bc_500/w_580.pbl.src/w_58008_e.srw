$PBExportHeader$w_58008_e.srw
$PBExportComments$원단수출Invoice등록
forward
global type w_58008_e from w_com010_e
end type
type dw_detail from datawindow within w_58008_e
end type
end forward

global type w_58008_e from w_com010_e
integer width = 3675
integer height = 2280
dw_detail dw_detail
end type
global w_58008_e w_58008_e

type variables
string is_brand, is_invoice_date, is_invoice_no
string is_fr_yymmdd, is_to_yymmdd, is_cust_cd, is_country_cd
decimal idc_us_exchange
decimal id_detail_rows
Datawindowchild  idw_brand, idw_country_cd


end variables

forward prototypes
public function integer wf_detail_retrieve (string as_flag)
end prototypes

public function integer wf_detail_retrieve (string as_flag);string 	ls_out_from_date, ls_out_to_date, ls_country_cd, ls_cust_cd, ls_seq_no, ls_omit_gbn
string	ls_Style,ls_item_nm,ls_Composition
decimal	i, ld_exchange_rate, ld_qty, ld_amount,  ld_row_count
decimal	ld_sale_qty,ld_Exchange_price,ld_exchange_amt,ld_sale_amt, ld_tot_sale_amt
			

	IF dw_body.AcceptText() <> 1 THEN RETURN 0


	ls_out_from_date = dw_body.GetItemString(1,"out_from_Date")
	ls_out_to_date   = dw_body.GetItemString(1,"out_to_Date")
	ld_exchange_rate = dw_body.GetItemDecimal(1,"exchange_rate")
	ls_country_cd    = dw_body.GetItemString(1,"country_cd")
	ls_cust_cd 		  = dw_body.GetItemString(1,"cust_cd")
	
	if as_flag = 'New' then
		ld_row_count = dw_detail.retrieve(is_brand, ls_out_from_date, ls_out_to_date, ls_cust_cd, ls_country_cd, ld_exchange_rate, is_Invoice_Date, is_invoice_no, as_flag)
		for i = 1 to ld_row_count
			dw_detail.SetItemStatus(i, 0, Primary!, NewModified!)
			ls_seq_no			= string(i, '0000')					
			dw_detail.setitem(i,"seq_no",ls_seq_no)
		next
	else
		id_detail_rows = dw_detail.retrieve(is_brand, ls_out_from_date, ls_out_to_date, ls_cust_cd, ls_country_cd, ld_exchange_rate, is_Invoice_Date, is_invoice_no, as_flag)
	end if 
	


								
	ld_qty =    dw_detail.GetItemDecimal(1,"tot_qty")
	ld_amount = dw_detail.GetItemDecimal(1,"tot_amount")
	ld_tot_sale_amt = dw_detail.GetItemDecimal(1,"tot_sale_amt")
	dw_body.SetItem(1,"quantity",ld_qty)
	dw_body.SetItem(1,"amount",ld_amount)
	dw_body.SetItem(1,"sale_amt",ld_tot_sale_amt)
			 
					 

return 1

end function

on w_58008_e.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_58008_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
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
decimal	ld_exchange_rate, ld_qty, ld_amount 

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand,is_invoice_date,is_invoice_no)
dw_detail.reset()
IF il_rows > 0 THEN
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

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)


end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long 		i, ll_row_count
datetime ld_datetime
decimal	ld_qty, ld_amount, ld_tot_sale_amt
 

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF


ld_qty =    dw_detail.GetItemDecimal(1,"tot_qty")
ld_amount = dw_detail.GetItemDecimal(1,"tot_amount")
ld_tot_sale_amt = dw_detail.GetItemDecimal(1,"tot_sale_amt")
dw_body.SetItem(1,"quantity",ld_qty)
dw_body.SetItem(1,"amount",ld_amount)
dw_body.SetItem(1,"sale_amt",ld_tot_sale_amt)

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

if il_rows = 1 then
   dw_body.ResetUpdate()
   commit  USING SQLCA;
else
   rollback  USING SQLCA;
end if

//---------------------------------------------------------------

ll_row_count = dw_detail.RowCount()
IF dw_detail.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

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

if il_rows = 1 then
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
end event

event open;call super::open;datetime	ld_datetime
string   ls_invoice_date 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_invoice_date = String(ld_datetime, "yyyymmdd")
 

dw_head.Setitem(1,"invoice_date", ls_invoice_date)

end event

event ue_delete();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01																  */	
/* 수정일      : 2001.01.01																  */
/*===========================================================================*/
/* row에 따라 삭제조건이 틀릴경우 새로 작성 */
long			ll_cur_row, i, ll_det_row

ll_cur_row = dw_body.GetRow()
ll_det_row = dw_detail.RowCount()
if ll_cur_row <= 0 then return

idw_status = dw_body.GetItemStatus (ll_cur_row, 0, primary!)	

il_rows = dw_body.DeleteRow (ll_cur_row)
if il_rows > 0 then 
	for i = ll_det_row to 1 step -1
		dw_detail.deleterow(i)
	next 
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(4, il_rows)
This.Trigger Event ue_msg(4, il_rows)

end event

type cb_close from w_com010_e`cb_close within w_58008_e
end type

type cb_delete from w_com010_e`cb_delete within w_58008_e
end type

type cb_insert from w_com010_e`cb_insert within w_58008_e
boolean visible = false
boolean enabled = false
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58008_e
end type

type cb_update from w_com010_e`cb_update within w_58008_e
end type

type cb_print from w_com010_e`cb_print within w_58008_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_58008_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_58008_e
end type

type cb_excel from w_com010_e`cb_excel within w_58008_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_58008_e
integer height = 120
string dataobject = "d_58008_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_e`ln_1 within w_58008_e
integer beginy = 292
integer endy = 292
end type

type ln_2 from w_com010_e`ln_2 within w_58008_e
integer beginy = 296
integer endy = 296
end type

type dw_body from w_com010_e`dw_body within w_58008_e
integer y = 308
integer height = 1280
string dataobject = "d_58008_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::buttonclicked;call super::buttonclicked;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
string 	ls_out_from_date, ls_out_to_date, ls_country_cd, ls_shop_cd
decimal	ld_exchange_rate, ld_qty, ld_amount

CHOOSE CASE dwo.name
	CASE "cb_detail" 
			
			if id_detail_rows = 0 then 
				wf_detail_retrieve('New')
			end if		    
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

type dw_print from w_com010_e`dw_print within w_58008_e
integer x = 786
integer y = 1328
end type

type dw_detail from datawindow within w_58008_e
event ue_exchange_refresh ( long al_exchange_amt,  long al_row )
event ue_refresh ( string as_field,  long al_row )
integer x = 5
integer y = 1596
integer width = 3589
integer height = 452
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_58008_d02"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_exchange_refresh;decimal ldc_exchange_amt, ldc_exchange_price, ldc_sale_qty, ldc_exchange_rate


ldc_exchange_rate = dw_body.getitemnumber(1,"exchange_rate")
ldc_exchange_amt = dw_detail.getitemnumber(al_row,"exchange_amt")
ldc_sale_qty = dw_detail.getitemnumber(al_row,"sale_qty")


dw_detail.setitem(al_row,"exchange_price",ldc_exchange_amt / ldc_sale_qty)
//messagebox('al_exchange_amt',ldc_exchange_amt)
//messagebox('al_exchange_rate',ldc_exchange_rate)
//messagebox('sale_amt',ldc_exchange_amt * ldc_exchange_rate)

dw_detail.setitem(al_row,"sale_amt"      ,ldc_exchange_amt * ldc_exchange_rate)
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

event itemchanged;cb_update.enabled  =true

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

