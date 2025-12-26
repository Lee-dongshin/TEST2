$PBExportHeader$w_56311_e.srw
$PBExportComments$중국매장 수금 등록
forward
global type w_56311_e from w_com010_e
end type
end forward

global type w_56311_e from w_com010_e
integer width = 3680
integer height = 2276
end type
global w_56311_e w_56311_e

type variables
string is_shop_cd, is_input_date
decimal id_exchange_rate

end variables

on w_56311_e.create
call super::create
end on

on w_56311_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "inPUT_date" ,string(ld_datetime,"yyyymmdd"))
end event

event ue_keycheck;call super::ue_keycheck;/*===========================================================================*/
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

is_shop_cd = dw_head.GetItemString(1, "shop_cd")
if IsNull(is_shop_cd) or Trim(is_shop_cd) = "" then
   MessageBox(ls_title,"거래처 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("shop_cd")
   return false
end if

is_input_date = dw_head.GetItemString(1, "input_date")
if IsNull(is_input_date) or Trim(is_input_date) = "" then
   MessageBox(ls_title,"수금일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("input_date")
   return false
end if

ID_EXCHANGE_RATE = dw_head.GetItemNUMBER(1, "EXCHANGE_RATE")
if IsNull(ID_EXCHANGE_RATE) or ID_EXCHANGE_RATE <= 0 then
   MessageBox(ls_title,"기준환율을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("EXCHANGE_RATE")
   return false
end if
return true

end event

event ue_retrieve;call super::ue_retrieve;long ll_outamt_us, ll_inamt_us

ll_inamt_us = 0
ll_outamt_us = 0
/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

select sum(isnull(outamt_us,0))
into :ll_outamt_us
from tb_56110_h
where shop_cd = :is_shop_cd
and   yymmdd <= :is_input_date;

select sum(isnull(sugmamt_US,0))
into :ll_inamt_us
from tb_56110_d
where shop_cd = :is_shop_cd
and   yymmdd <= :is_input_date;

if isnull(ll_inamt_us) then ll_inamt_us = 0

dw_head.setitem(1, "uncollected_amt", ll_outamt_us - ll_inamt_us)

il_rows = dw_body.retrieve(is_input_date, is_shop_cd)

IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/
long i, ll_row_count
datetime ld_datetime
long ll_outamt_us, ll_inamt_us

ll_inamt_us = 0
ll_outamt_us = 0


ll_row_count = dw_body.RowCount()
IF dw_body.AcceptText() <> 1 THEN RETURN -1

/* 시스템 날짜를 가져온다 */
IF gf_sysdate(ld_datetime) = FALSE THEN
	Return 0
END IF

FOR i=1 TO ll_row_count
   idw_status = dw_body.GetItemStatus(i, 0, Primary!)
   IF idw_status = NewModified! THEN				/* New Record */

      dw_body.Setitem(i, "yymmdd", is_input_date)
      dw_body.Setitem(i, "no",    i)		
      dw_body.Setitem(i, "shop_cd", is_shop_cd)
      dw_body.Setitem(i, "exchange_rate", id_exchange_rate )
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

select sum(isnull(outamt_us,0))
into :ll_outamt_us
from tb_56110_h
where shop_cd = :is_shop_cd
and   yymmdd <= :is_input_date;

select sum(isnull(sugmamt_US,0))
into :ll_inamt_us
from tb_56110_d
where shop_cd = :is_shop_cd
and   yymmdd <= :is_input_date;

if isnull(ll_inamt_us) then ll_inamt_us = 0

dw_head.setitem(1, "uncollected_amt", ll_outamt_us - ll_inamt_us)
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56311_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56311_e
end type

type cb_delete from w_com010_e`cb_delete within w_56311_e
end type

type cb_insert from w_com010_e`cb_insert within w_56311_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56311_e
end type

type cb_update from w_com010_e`cb_update within w_56311_e
end type

type cb_print from w_com010_e`cb_print within w_56311_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56311_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56311_e
end type

type cb_excel from w_com010_e`cb_excel within w_56311_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56311_e
integer y = 176
integer height = 240
string dataobject = "d_56311_h01"
end type

event dw_head::itemchanged;call super::itemchanged;STRING LS_FRM_DATE, LS_SHOP_CD, ls_input_date
decimal ld_exchange_rate

CHOOSE CASE dwo.name
		
	case "shop_cd" 	
    IF ib_itemchanged THEN RETURN 1
		
		if data = 'NT3516' then	
			DW_HEAD.SETITEM(1, "TEXT", "※심천의 금액은 US$단위로 관리 됩니다!")		
		else
		  
			DW_HEAD.SETITEM(1, "TEXT", "※대련의 금액은 원단위로 관리 됩니다!")
		end if
		

 	CASE "input_date"	     //  Popup 검색창이 존재하는 항목 
    IF ib_itemchanged THEN RETURN 1
		ls_input_date = DATA
		ls_shop_cd = dw_head.getitemstring(row, "shop_cd")
			
			
		if ls_shop_cd = 'NT3516' then	
			
			SELECT min(isnull(exchange_rate,0))
			INTO :Ld_exchange_rate
			FROM TB_56110_H 
			WHERE SHOP_CD = :LS_SHOP_CD
			  and yymmdd  = :ls_input_date;
		else
			Ld_exchange_rate = 1			  
			DW_HEAD.SETITEM(1, "TEXT", "* 대련의 경우 금액은 원단위로 관리 됩니다!")
		end if
		
		
		if isnull(Ld_exchange_rate) or ld_exchange_rate = 0 then
			DW_HEAD.SETITEM(ROW, "exchange_rate", 0)
 			dw_head.SetColumn("exchange_rate")			
		else	
			DW_HEAD.SETITEM(ROW, "exchange_rate", Ld_exchange_rate)
   	end if	

	
END CHOOSE

end event

type ln_1 from w_com010_e`ln_1 within w_56311_e
end type

type ln_2 from w_com010_e`ln_2 within w_56311_e
end type

type dw_body from w_com010_e`dw_body within w_56311_e
integer width = 3593
string dataobject = "d_56311_d01"
end type

event dw_body::dberror;//
end event

type dw_print from w_com010_e`dw_print within w_56311_e
end type

