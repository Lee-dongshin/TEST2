$PBExportHeader$w_56310_e.srw
$PBExportComments$중국매장 출고집계(제품,기타)등록
forward
global type w_56310_e from w_com010_e
end type
end forward

global type w_56310_e from w_com010_e
end type
global w_56310_e w_56310_e

type variables
STRING IS_SHOP_CD, IS_INPUT_DATE, IS_FRM_DATE, IS_TO_DATE, is_dupl_chk, is_dupl_chk1, is_dupl_chk2, is_dupl_chk3
DECIMAL ID_EXCHANGE_RATE
end variables

on w_56310_e.create
call super::create
end on

on w_56310_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

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

is_SHOP_CD = dw_head.GetItemString(1, "SHOP_CD")
if IsNull(is_SHOP_CD) or Trim(is_SHOP_CD) = "" then
   MessageBox(ls_title,"매장 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("SHOP_CD")
   return false
end if


IS_INPUT_DATE = dw_head.GetItemString(1, "INPUT_DATE")
if IsNull(IS_INPUT_DATE) or Trim(IS_INPUT_DATE) = "" then
   MessageBox(ls_title,"입력일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("INPUT_DATE")
   return false
end if

IS_FRM_DATE = dw_head.GetItemString(1, "FRM_DATE")
if IsNull(IS_FRM_DATE) or Trim(IS_FRM_DATE) = "" then
   MessageBox(ls_title,"시작일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("FRM_DATE")
   return false
end if

IS_TO_DATE = dw_head.GetItemString(1, "TO_DATE")
if IsNull(IS_TO_DATE) or Trim(IS_TO_DATE) = "" then
   MessageBox(ls_title,"마지막일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("TO_DATE")
   return false
end if

ID_EXCHANGE_RATE = dw_head.GetItemNUMBER(1, "EXCHANGE_RATE")
if IsNull(ID_EXCHANGE_RATE) or ID_EXCHANGE_RATE <= 0 then
   MessageBox(ls_title,"기준환율을 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("EXCHANGE_RATE")
   return false
end if

is_dupl_chk = 'a'

return true

end event

event open;call super::open;datetime ld_datetime

IF gf_sysdate(ld_datetime) = FALSE THEN
	ld_datetime = DateTime(Today(), Now())
END IF

dw_head.SetItem(1, "inPUT_date" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "FRM_date" ,string(ld_datetime,"yyyymmdd"))
dw_head.SetItem(1, "TO_date" ,string(ld_datetime,"yyyymmdd"))



end event

event ue_retrieve;call super::ue_retrieve;

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(IS_INPUT_DATE, IS_SHOP_CD)
IF il_rows > 0 THEN
   dw_body.SetFocus()
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event ue_update;call super::ue_update;
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
      dw_body.Setitem(i, "yymmdd", 	is_input_date)
      dw_body.Setitem(i, "shop_cd", is_shop_cd)
      dw_body.Setitem(i, "exchange_rate", id_exchange_rate)		
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
	is_dupl_chk = 'a'
else
   rollback  USING SQLCA;
end if

This.Trigger Event ue_button(3, il_rows)
This.Trigger Event ue_msg(3, il_rows)
return il_rows

end event

event pfc_close();call super::pfc_close;gf_user_connect_pgm(gs_user_id,"w_56310_e","0")
end event

type cb_close from w_com010_e`cb_close within w_56310_e
end type

type cb_delete from w_com010_e`cb_delete within w_56310_e
end type

type cb_insert from w_com010_e`cb_insert within w_56310_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_56310_e
end type

type cb_update from w_com010_e`cb_update within w_56310_e
end type

type cb_print from w_com010_e`cb_print within w_56310_e
boolean visible = false
end type

type cb_preview from w_com010_e`cb_preview within w_56310_e
boolean visible = false
end type

type gb_button from w_com010_e`gb_button within w_56310_e
end type

type cb_excel from w_com010_e`cb_excel within w_56310_e
boolean visible = false
end type

type dw_head from w_com010_e`dw_head within w_56310_e
integer y = 184
integer width = 3355
string dataobject = "d_56310_h01"
end type

event dw_head::itemchanged;call super::itemchanged;STRING LS_FRM_DATE, LS_SHOP_CD, ls_input_date
decimal ld_exchange_rate

CHOOSE CASE dwo.name

	CASE "shop_cd"	     //  Popup 검색창이 존재하는 항목 
    IF ib_itemchanged THEN RETURN 1
		LS_SHOP_CD = DATA
		
		if data = 'NT3516' then	
			DW_HEAD.SETITEM(1, "TEXT", "※심천의 금액은 US$단위로 관리 됩니다!")		
		else		  
			DW_HEAD.SETITEM(1, "TEXT", "※대련의 금액은 원단위로 관리 됩니다!")
		end if
		
		SELECT MAX(YYMMDD) 
		INTO :LS_FRM_DATE
		FROM TB_56110_H 
		WHERE SHOP_CD = :LS_SHOP_CD;
		
		DW_HEAD.SETITEM(ROW, "FRM_DATE", LS_FRM_DATE)

		dw_head.SetColumn("INPUT_DATE")
		
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
		end if
		
		
		if isnull(Ld_exchange_rate) or ld_exchange_rate = 0 then
			DW_HEAD.SETITEM(ROW, "exchange_rate", 0)
 			dw_head.SetColumn("exchange_rate")			
		else	
			DW_HEAD.SETITEM(ROW, "exchange_rate", Ld_exchange_rate)
   		dw_head.SetColumn("to_date")		
		end if	

	
END CHOOSE

end event

event dw_head::itemfocuschanged;call super::itemfocuschanged;//STRING LS_FRM_DATE, LS_SHOP_CD
//
//
//
//CHOOSE CASE dwo.name
//
//	CASE "input_date"	   		
//		MESSAGEBOX("", "뭐여")
//		LS_SHOP_CD = DW_HEAD.GETITEMSTRING(ROW,"SHOP_CD")
//		
//		SELECT MAX(YYMMDD) 
//		INTO :LS_FRM_DATE
//		FROM TB_56110_H 
//		WHERE SHOP_CD = :LS_SHOP_CD;
//		
//		DW_HEAD.SETITEM(ROW, "FRM_DATE", LS_FRM_DATE)
//
//		dw_head.SetColumn("input_DATE")
//		
//	
//END CHOOSE
//
end event

type ln_1 from w_com010_e`ln_1 within w_56310_e
end type

type ln_2 from w_com010_e`ln_2 within w_56310_e
end type

type dw_body from w_com010_e`dw_body within w_56310_e
string dataobject = "d_56310_d01"
end type

event dw_body::itemchanged;call super::itemchanged;LONG LL_OUT_QTY, LL_OUT_AMT, LL_OUT_AMTUS

CHOOSE CASE dwo.name

	CASE "out_gubn"	     //  Popup 검색창이 존재하는 항목 
		IF ib_itemchanged THEN RETURN 1
	
		IF DATA = '1' THEN

		if is_dupl_chk = 'd' then 
			messagebox("경고!", "의류대는 당일 중복 입력할 수 없습니다!")
			return 1
		end if	
				
		is_dupl_chk = 'd'
		
		SELECT SUM(ISNULL(OUT_QTY,0) - ISNULL(RTRN_QTY,0)), 
				 SUM(ISNULL(OUT_COLLECT,0) -ISNULL(RTRN_COLLECT,0))
		INTO :LL_OUT_QTY, :LL_OUT_AMT
		FROM TB_44020_S
		WHERE SHOP_CD = :IS_SHOP_CD
		  AND YYMMDD  BETWEEN :IS_FRM_DATE AND :IS_TO_DATE ;
		  
		DW_BODY.SETITEM(ROW, 'OUT_QTY',    LL_OUT_QTY) 
		DW_BODY.SETITEM(ROW, 'OUTAMT_US',  LL_OUT_AMT / ID_EXCHANGE_RATE)
		DW_BODY.SETITEM(ROW, 'OUTAMT_KOR', LL_OUT_amt)		
		
		elseif DATA = '2' THEN 
			if is_dupl_chk = 'd1' then 	
			messagebox("경고!", "사은품은 당일 중복 입력할 수 없습니다!")
			return 1			
			end if
					is_dupl_chk = 'd1'
		elseif DATA = '3' THEN 
			if is_dupl_chk = 'd2' then 	
			messagebox("경고!", "원단은 당일 중복 입력할 수 없습니다!")
			return 1
			end if
					is_dupl_chk = 'd2'
		else 
			if is_dupl_chk = 'd3' then 	
			messagebox("경고!", "당일 중복 입력할 수 없습니다!")
			return 1						
			end if
			
			is_dupl_chk = 'd3'
		end if	

   CASE "outamt_kor"
		LL_OUT_AMT = dec(data)
	   dw_body.setitem(row, "outamt_us",  LL_OUT_AMT / ID_EXCHANGE_RATE)
			  
			

END CHOOSE

end event

type dw_print from w_com010_e`dw_print within w_56310_e
end type

