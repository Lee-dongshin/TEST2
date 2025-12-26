$PBExportHeader$w_58011_d.srw
$PBExportComments$원단수출조회
forward
global type w_58011_d from w_com010_d
end type
end forward

global type w_58011_d from w_com010_d
integer width = 3680
integer height = 2276
end type
global w_58011_d w_58011_d

type variables
string is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd
decimal idc_exchange_rate

datawindowchild idw_brand
end variables

on w_58011_d.create
call super::create
end on

on w_58011_d.destroy
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

is_brand = dw_head.GetItemString(1, "brand")
is_fr_yymmdd = dw_head.GetItemString(1, "fr_yymmdd")
is_to_yymmdd = dw_head.GetItemString(1, "to_yymmdd")
is_cust_cd = dw_head.GetItemString(1, "cust_cd")
idc_exchange_rate = dw_head.GetItemNumber(1, "exchange_rate")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_fr_yymmdd, is_to_yymmdd, is_cust_cd, idc_exchange_rate)
IF il_rows > 0 THEN
   dw_body.SetFocus()
ELSEIF il_rows = 0 THEN
   MessageBox("조회", "조회할 자료가 없습니다.")
ELSE
   MessageBox("조회오류", "조회 실패 하였습니다.")
END IF

This.Trigger Event ue_button(1, il_rows)
This.Trigger Event ue_msg(1, il_rows)

end event

event open;call super::open;datetime	ld_datetime
string   ls_from_date, ls_to_date

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_to_date = String(ld_datetime, "yyyymmdd")
ls_from_date = LeftA(ls_to_date,6) + '01'

dw_head.Setitem(1,"fr_yymmdd", ls_from_date)
dw_head.Setitem(1,"to_yymmdd", ls_to_date)
end event

type cb_close from w_com010_d`cb_close within w_58011_d
end type

type cb_delete from w_com010_d`cb_delete within w_58011_d
end type

type cb_insert from w_com010_d`cb_insert within w_58011_d
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_58011_d
end type

type cb_update from w_com010_d`cb_update within w_58011_d
end type

type cb_print from w_com010_d`cb_print within w_58011_d
end type

type cb_preview from w_com010_d`cb_preview within w_58011_d
end type

type gb_button from w_com010_d`gb_button within w_58011_d
end type

type cb_excel from w_com010_d`cb_excel within w_58011_d
end type

type dw_head from w_com010_d`dw_head within w_58011_d
string dataobject = "d_58011_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')

end event

type ln_1 from w_com010_d`ln_1 within w_58011_d
end type

type ln_2 from w_com010_d`ln_2 within w_58011_d
end type

type dw_body from w_com010_d`dw_body within w_58011_d
string dataobject = "d_58011_d01"
end type

event dw_body::constructor;/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 1999.11.09                                                  */	
/* 수정일      : 1999.11.09                                                  */
/*===========================================================================*/
This.of_SetRowManager(True)
This.of_SetBase(True)
This.of_SetSort(True)

This.inv_base.of_SetColumnNameSource(2)  // header로 sort
This.inv_sort.of_SetUseDisplay(True)     // dddw같은 경우 display value로 sort
// This.inv_sort.of_SetColumnHeader(True)

//This.SetRowFocusIndicator(Hand!)

end event

type dw_print from w_com010_d`dw_print within w_58011_d
integer x = 439
integer y = 1148
string dataobject = "d_58011_r01"
end type

