$PBExportHeader$w_58031_e.srw
$PBExportComments$L/C관리
forward
global type w_58031_e from w_com010_e
end type
end forward

global type w_58031_e from w_com010_e
integer width = 3675
integer height = 2260
end type
global w_58031_e w_58031_e

type variables
string is_lc_no, is_brand
decimal il_eur_usd = 0
datawindowchild idw_money_type, idw_brand

end variables

on w_58031_e.create
call super::create
end on

on w_58031_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

is_lc_no = dw_head.GetItemString(1, "lc_no")
is_brand = dw_head.GetItemString(1, "brand")
il_eur_usd = dw_head.GetItemDecimal(1, "eur_usd")

return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_lc_no, is_brand)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event type long ue_update();call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime

ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

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

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event type integer ue_popup(string as_column, long al_row, string as_data, integer ai_div);call super::ue_popup;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
String     ls_shop_nm, ls_money_type
Boolean    lb_check 
decimal	  ll_open_amt, ll_open_amt2, ll_close_amt, ll_balance_amt, ll_deposit_amt, ll_deposit_blnc
decimal    ll_balance_usd, ll_deposit_blnc_usd, ll_eur_usd, ll_open_pcnt
DataStore  lds_Source

ls_money_type = dw_body.getitemstring(al_row,"money_type")
if ls_money_type = '02' then  //usd 
	ll_eur_usd = 1
elseif ls_money_type = '06' then //eur
	ll_eur_usd = il_eur_usd	
else 
	ll_eur_usd = 0
end if

	
CHOOSE CASE as_column
	case "open_pcnt"
			ll_open_pcnt   = dec(as_data)
			ll_open_amt    = dw_body.getitemdecimal(al_row,"open_amt")	
			ll_open_amt2   = round(ll_open_amt*(100+ll_open_pcnt)/100.0,2)
			ll_close_amt   = dw_body.getitemdecimal(al_row,"close_amt")
			ll_deposit_amt = dw_body.getitemdecimal(al_row,"deposit_amt")

			if ll_open_amt2 > ll_close_amt then 
				ll_balance_amt = ll_open_amt2 - ll_close_amt
				ll_balance_usd = ll_balance_amt * ll_eur_usd		
			else
				ll_balance_amt = 0
				ll_balance_usd = 0					
			end if
			if ll_deposit_amt > ll_close_amt then 
				ll_deposit_blnc = ll_deposit_amt - ll_close_amt			
				ll_deposit_blnc_usd = ll_deposit_blnc * ll_eur_usd			
			else
				ll_deposit_blnc = 0	
				ll_deposit_blnc_usd = 0				
			end if

			dw_body.setitem(al_row,"open_amt2",ll_open_amt2)
			dw_body.setitem(al_row,"balance_amt",ll_balance_amt)
			dw_body.setitem(al_row,"balance_usd",ll_balance_usd)			
			dw_body.setitem(al_row,"deposit_blnc",ll_deposit_blnc)
			dw_body.setitem(al_row,"deposit_blnc_usd",ll_deposit_blnc_usd)		
			
	case "open_amt"
			ll_open_pcnt   = dw_body.getitemdecimal(al_row,"open_pcnt")
			ll_open_amt    = dec(as_data)			
			ll_open_amt2   = round(dec(as_data)*(100+ll_open_pcnt)/100.0,2)
			ll_close_amt   = dw_body.getitemdecimal(al_row,"close_amt")
			ll_deposit_amt = dw_body.getitemdecimal(al_row,"deposit_amt")

			if ll_open_amt2 > ll_close_amt then 
				ll_balance_amt = ll_open_amt2 - ll_close_amt
				ll_balance_usd = ll_balance_amt * ll_eur_usd			
			else
				ll_balance_amt = 0
				ll_balance_usd = 0					
			end if
			if ll_deposit_amt > ll_close_amt then 
				ll_deposit_blnc = ll_deposit_amt - ll_close_amt			
				ll_deposit_blnc_usd = ll_deposit_blnc * ll_eur_usd			
			else
				ll_deposit_blnc = 0	
				ll_deposit_blnc_usd = 0				
			end if

			dw_body.setitem(al_row,"open_amt2",ll_open_amt2)
			dw_body.setitem(al_row,"balance_amt",ll_balance_amt)
			dw_body.setitem(al_row,"balance_usd",ll_balance_usd)			
			dw_body.setitem(al_row,"deposit_blnc",ll_deposit_blnc)
			dw_body.setitem(al_row,"deposit_blnc_usd",ll_deposit_blnc_usd)			
			
	case "close_amt"
			ll_open_pcnt   = dw_body.getitemdecimal(al_row,"open_pcnt")		
			ll_open_amt    = dw_body.getitemdecimal(al_row,"open_amt")		
			ll_open_amt2   = round(dec(ll_open_amt)*(100+ll_open_pcnt)/100.0,2)
			ll_close_amt   = dec(as_data)
			ll_deposit_amt = dw_body.getitemdecimal(al_row,"deposit_amt")


			if ll_open_amt2 > ll_close_amt then 
				ll_balance_amt = ll_open_amt2 - ll_close_amt
				ll_balance_usd = ll_balance_amt * ll_eur_usd			
			else
				ll_balance_amt = 0
				ll_balance_usd = 0					
			end if
			if ll_deposit_amt > ll_close_amt then 
				ll_deposit_blnc = ll_deposit_amt - ll_close_amt			
				ll_deposit_blnc_usd = ll_deposit_blnc * ll_eur_usd			
			else
				ll_deposit_blnc = 0	
				ll_deposit_blnc_usd = 0				
			end if		

			dw_body.setitem(al_row,"open_amt2",ll_open_amt2)
			dw_body.setitem(al_row,"balance_amt",ll_balance_amt)
			dw_body.setitem(al_row,"balance_usd",ll_balance_usd)			
			dw_body.setitem(al_row,"deposit_blnc",ll_deposit_blnc)
			dw_body.setitem(al_row,"deposit_blnc_usd",ll_deposit_blnc_usd)	

	case "deposit_amt"
			ll_open_pcnt   = dw_body.getitemdecimal(al_row,"open_pcnt")	
			ll_open_amt    = dw_body.getitemdecimal(al_row,"open_amt")		
			ll_open_amt2   = round(dec(ll_open_amt)*(100+ll_open_pcnt)/100.0,2)
			ll_close_amt   = dw_body.getitemdecimal(al_row,"close_amt")
			ll_deposit_amt = dec(as_data)


			if ll_open_amt2 > ll_close_amt then 
				ll_balance_amt = ll_open_amt2 - ll_close_amt
				ll_balance_usd = ll_balance_amt * ll_eur_usd			
			else
				ll_balance_amt = 0
				ll_balance_usd = 0					
			end if
			if ll_deposit_amt > ll_close_amt then 
				ll_deposit_blnc = ll_deposit_amt - ll_close_amt			
				ll_deposit_blnc_usd = ll_deposit_blnc * ll_eur_usd			
			else
				ll_deposit_blnc = 0	
				ll_deposit_blnc_usd = 0				
			end if		

			dw_body.setitem(al_row,"open_amt2",ll_open_amt2)
			dw_body.setitem(al_row,"balance_amt",ll_balance_amt)
			dw_body.setitem(al_row,"balance_usd",ll_balance_usd)			
			dw_body.setitem(al_row,"deposit_blnc",ll_deposit_blnc)
			dw_body.setitem(al_row,"deposit_blnc_usd",ll_deposit_blnc_usd)	

	case "money_type"
			ls_money_type = string(as_data)
			if ls_money_type = '02' then  //usd 
				ll_eur_usd = 1
			elseif ls_money_type = '06' then //eur
				ll_eur_usd = il_eur_usd	
			else 
				ll_eur_usd = 0
			end if

			ll_open_amt    = dw_body.getitemdecimal(al_row,"open_amt")		
			ll_open_amt2   = dw_body.getitemdecimal(al_row,"open_amt2")	
			ll_close_amt   = dw_body.getitemdecimal(al_row,"close_amt")
			ll_deposit_amt = dw_body.getitemdecimal(al_row,"deposit_amt")	


			if ll_open_amt2 > ll_close_amt then 
				ll_balance_amt = ll_open_amt2 - ll_close_amt
				ll_balance_usd = ll_balance_amt * ll_eur_usd			
			else
				ll_balance_amt = 0
				ll_balance_usd = 0					
			end if
			if ll_deposit_amt > ll_close_amt then 
				ll_deposit_blnc = ll_deposit_amt - ll_close_amt			
				ll_deposit_blnc_usd = ll_deposit_blnc * ll_eur_usd			
			else
				ll_deposit_blnc = 0	
				ll_deposit_blnc_usd = 0				
			end if		

			dw_body.setitem(al_row,"open_amt2",ll_open_amt2)
			dw_body.setitem(al_row,"balance_amt",ll_balance_amt)
			dw_body.setitem(al_row,"balance_usd",ll_balance_usd)			
			dw_body.setitem(al_row,"deposit_blnc",ll_deposit_blnc)
			dw_body.setitem(al_row,"deposit_blnc_usd",ll_deposit_blnc_usd)				
			Destroy  lds_Source
END CHOOSE


RETURN 0

end event

event open;call super::open;il_eur_usd = 1.5774
dw_head.setitem(1,"brand","1")
end event

event ue_title();call super::ue_title;/*===========================================================================*/
/* 작성자      :                                                      */	
/* 작성일      : 2002..                                                  */	
/* 수정일      : 2002..                                                  */
/*===========================================================================*/

datetime ld_datetime
string ls_modify, ls_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_datetime = String(ld_datetime, "yyyy/mm/dd-hh:mm:ss")

ls_modify =	"t_pg_id.Text = '" + is_pgm_id + "'" + &
             "t_user_id.Text = '" + gs_user_id + "'" + &
             "t_datetime.Text = '" + ls_datetime + "'"

dw_print.Modify(ls_modify)


end event

type cb_close from w_com010_e`cb_close within w_58031_e
end type

type cb_delete from w_com010_e`cb_delete within w_58031_e
end type

type cb_insert from w_com010_e`cb_insert within w_58031_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58031_e
end type

type cb_update from w_com010_e`cb_update within w_58031_e
end type

type cb_print from w_com010_e`cb_print within w_58031_e
end type

type cb_preview from w_com010_e`cb_preview within w_58031_e
end type

type gb_button from w_com010_e`gb_button within w_58031_e
end type

type cb_excel from w_com010_e`cb_excel within w_58031_e
end type

type dw_head from w_com010_e`dw_head within w_58031_e
integer height = 144
string dataobject = "d_58031_h01"
end type

event dw_head::itemchanged;call super::itemchanged;
CHOOSE CASE dwo.name
	case "brand"
		
		string DWfilter2
		DWfilter2 = "right(inter_cd1,1) = '" +string(data) +"'"
		idw_brand.SetFilter(DWfilter2)
		idw_brand.Filter( )

END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_58031_e
integer beginy = 332
integer endy = 332
end type

type ln_2 from w_com010_e`ln_2 within w_58031_e
integer beginy = 336
integer endy = 336
end type

type dw_body from w_com010_e`dw_body within w_58031_e
integer y = 356
integer height = 1672
string dataobject = "d_58031_d01"
boolean hscrollbar = true
end type

event dw_body::constructor;call super::constructor;string DWfilter2


This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

DWfilter2 = "right(inter_cd1,1) = '1'"
idw_brand.SetFilter(DWfilter2)
idw_brand.Filter( )


This.GetChild("money_type", idw_money_type)
idw_money_type.SetTransObject(SQLCA)
idw_money_type.Retrieve('013')
end event

event dw_body::itemchanged;call super::itemchanged;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.08                                                  */	
/* 수정일      : 1999.11.08                                                  */
/*===========================================================================*/
ib_changed = true
cb_update.enabled = true
cb_print.enabled = false
cb_preview.enabled = false
cb_excel.enabled = false
/*===========================================================================*/
/* 작성자      :                                                       */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

CHOOSE CASE dwo.name
	CASE "colunm1" 
    IF data = 'A' THEN
	      /*action*/
    END IF
	CASE "open_amt","close_amt","deposit_amt","money_type","open_pcnt"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
		return Parent.Trigger Event ue_Popup(dwo.name, row, data, 1)
END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_58031_e
integer x = 114
integer y = 540
string dataobject = "d_58031_r01"
end type

event dw_print::constructor;call super::constructor;datawindowchild idw_child

This.GetChild("brand", idw_child)
idw_child.SetTransObject(SQLCA)
idw_child.Retrieve('001')


This.GetChild("money_type", idw_money_type)
idw_money_type.SetTransObject(SQLCA)
idw_money_type.Retrieve('013')
end event

