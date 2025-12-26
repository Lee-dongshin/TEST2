$PBExportHeader$w_58005_e.srw
$PBExportComments$기타미수금관리
forward
global type w_58005_e from w_com010_e
end type
end forward

global type w_58005_e from w_com010_e
end type
global w_58005_e w_58005_e

type variables
string is_brand, is_invoice_date, is_seq_no
datawindowchild	idw_brand
end variables

forward prototypes
public subroutine wf_seq_no ()
end prototypes

public subroutine wf_seq_no ();string	ls_brand, ls_invoice_date, ls_seq_no

			ls_brand = dw_body.getitemstring(1,'brand')
			ls_invoice_date = dw_body.getitemstring(1,'invoice_date')
   		

			select  max(seq_no)
			into    :ls_seq_no 
			from 	  tb_56202_h (nolock) 
			where   brand = :ls_brand 
			and     invoice_date = :ls_invoice_date;
						
			if      isnull(ls_seq_no) then 
						ls_seq_no = '0000'
			end if 
			
			ls_seq_no =  string(long(ls_seq_no)  + 1, '0000')
						 
			dw_body.setitem(1,"seq_no", ls_seq_no)
end subroutine

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

is_invoice_date = dw_head.GetItemString(1, "invoice_date")
if IsNull(is_invoice_date) or Trim(is_invoice_date) = "" then
 	MessageBox(ls_title,"일자를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("invoice_date")
end if


is_seq_no = dw_head.GetItemString(1, "seq_no")
if IsNull(is_seq_no) or Trim(is_seq_no) = "" then
 	MessageBox(ls_title,"일련번호를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("seq_no")
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

il_rows = dw_body.retrieve(is_brand,is_invoice_date,is_seq_no)
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
	wf_seq_no()
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

on w_58005_e.create
call super::create
end on

on w_58005_e.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insert();/*===========================================================================*/
/* 작성자      : (주)지우정보 (김 태범)                                      */	
/* 작성일      : 2001.01.01                                                  */	
/* 수정일      : 2001.01.01                                                  */
/*===========================================================================*/
string ls_brand, ls_invoice_date
if dw_body.AcceptText() <> 1 then return

/* dw_head 필수입력 column check ==> 조건을 누른후 추가시 */
IF dw_head.Enabled THEN
	IF Trigger Event ue_keycheck('2') = FALSE THEN RETURN 
	dw_body.Reset()
END IF

il_rows = dw_body.InsertRow(0)

ls_brand = dw_head.getitemstring(1,'brand')
ls_invoice_date = dw_head.getitemstring(1,'invoice_date')
   		
// messagebox('brand', ls_brand )
// messagebox('invoice_date', ls_invoice_date)

 dw_body.setitem(il_rows,"brand",ls_brand)
 dw_body.setitem(il_rows,"invoice_date",ls_invoice_date)

/* 추가된 Row의 첫번째 Tab Order 항목으로 이동 */
if il_rows > 0 then
	dw_body.ScrollToRow(il_rows)
	dw_body.SetColumn(ii_min_column_id)
	dw_body.SetFocus()
end if

This.Trigger Event ue_button(2, il_rows)
This.Trigger Event ue_msg(2, il_rows)

end event

event open;call super::open;datetime	ld_datetime
string   ls_invoice_date 

IF gf_sysdate(ld_datetime) = FALSE THEN
   ld_datetime = DateTime(Today(), Now())
END IF

ls_invoice_date = String(ld_datetime, "yyyymmdd")
 

dw_head.Setitem(1,"invoice_date", ls_invoice_date)

end event

type cb_close from w_com010_e`cb_close within w_58005_e
end type

type cb_delete from w_com010_e`cb_delete within w_58005_e
end type

type cb_insert from w_com010_e`cb_insert within w_58005_e
end type

type cb_retrieve from w_com010_e`cb_retrieve within w_58005_e
end type

type cb_update from w_com010_e`cb_update within w_58005_e
end type

type cb_print from w_com010_e`cb_print within w_58005_e
end type

type cb_preview from w_com010_e`cb_preview within w_58005_e
end type

type gb_button from w_com010_e`gb_button within w_58005_e
end type

type cb_excel from w_com010_e`cb_excel within w_58005_e
end type

type dw_head from w_com010_e`dw_head within w_58005_e
integer x = 41
integer y = 216
integer height = 144
string dataobject = "d_58005_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com010_e`ln_1 within w_58005_e
end type

type ln_2 from w_com010_e`ln_2 within w_58005_e
end type

type dw_body from w_com010_e`dw_body within w_58005_e
string dataobject = "d_58005_d01"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_body::constructor;call super::constructor;This.GetChild("brand", idw_brand)
idw_brand.SetTransObject(SQLCA)
idw_brand.Retrieve('001')
end event

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

type dw_print from w_com010_e`dw_print within w_58005_e
end type

