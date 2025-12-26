$PBExportHeader$w_58032_d.srw
$PBExportComments$SALES CONTRACT 출력
forward
global type w_58032_d from w_com020_d
end type
end forward

global type w_58032_d from w_com020_d
integer width = 3694
integer height = 2288
end type
global w_58032_d w_58032_d

type variables
string   is_brand, is_from_date, is_to_date
DataWindowChild  idw_brand
end variables

on w_58032_d.create
call super::create
end on

on w_58032_d.destroy
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
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_from_date = dw_head.GetItemString(1, "from_date")
if IsNull(is_from_date) or Trim(is_from_date) = "" then
   MessageBox(ls_title,"from일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("from_date")
   return false
end if

is_to_date = dw_head.GetItemString(1, "to_date")
if IsNull(is_to_date) or Trim(is_to_date) = "" then
   MessageBox(ls_title,"to일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("to_date")
   return false
end if



return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */
/* 작성일      : 2001..                                                  */
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_list.retrieve(is_brand, is_from_date, is_to_date)
dw_body.Reset()
IF il_rows > 0 THEN
   dw_list.SetFocus()
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

dw_head.Setitem(1,"from_date", ls_from_date)
dw_head.Setitem(1,"to_date", ls_to_date)
end event

type cb_close from w_com020_d`cb_close within w_58032_d
end type

type cb_delete from w_com020_d`cb_delete within w_58032_d
end type

type cb_insert from w_com020_d`cb_insert within w_58032_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_58032_d
end type

type cb_update from w_com020_d`cb_update within w_58032_d
end type

type cb_print from w_com020_d`cb_print within w_58032_d
end type

type cb_preview from w_com020_d`cb_preview within w_58032_d
end type

type gb_button from w_com020_d`gb_button within w_58032_d
end type

type cb_excel from w_com020_d`cb_excel within w_58032_d
end type

type dw_head from w_com020_d`dw_head within w_58032_d
integer y = 184
integer width = 2546
integer height = 204
string dataobject = "d_58032_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("Brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com020_d`ln_1 within w_58032_d
end type

type ln_2 from w_com020_d`ln_2 within w_58032_d
end type

type dw_list from w_com020_d`dw_list within w_58032_d
integer y = 444
integer width = 1093
integer height = 1604
string dataobject = "d_58032_d01"
end type

event dw_list::clicked;call super::clicked;/*===========================================================================*/
/* 작성자      : 지우정보                                                    */	
/* 작성일      : 2001.05.29                                                  */	
/* 수성일      : 2001.05.29                                                  */
/*===========================================================================*/
String ls_brand,  ls_invoice_date, ls_invoice_no 

IF row <= 0 THEN Return
	
This.SelectRow(0, FALSE)
This.SelectRow(row, TRUE)

/* DataWindow에 Key 항목을 가져온다 */
ls_brand 	    = This.GetItemString(row, 'brand') 
ls_invoice_date = This.GetItemString(row, 'invoice_date') 
ls_invoice_no 	 = This.GetItemString(row, 'invoice_no')


IF IsNull(ls_brand) THEN return


	
il_rows = dw_body.retrieve(ls_brand,ls_invoice_date,ls_invoice_no)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_58032_d
integer x = 1138
integer y = 444
integer width = 2473
integer height = 1604
string dataobject = "d_58032_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_d`st_1 within w_58032_d
integer x = 1125
end type

type dw_print from w_com020_d`dw_print within w_58032_d
integer x = 1605
integer y = 460
string dataobject = "d_58032_d02"
end type

