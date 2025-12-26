$PBExportHeader$w_58010_d.srw
$PBExportComments$원단수출Invoice출력
forward
global type w_58010_d from w_com020_d
end type
type cbx_1 from checkbox within w_58010_d
end type
end forward

global type w_58010_d from w_com020_d
cbx_1 cbx_1
end type
global w_58010_d w_58010_d

type variables
string   is_brand, is_from_date, is_to_date
DataWindowChild  idw_brand
end variables

on w_58010_d.create
int iCurrent
call super::create
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
end on

on w_58010_d.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
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

type cb_close from w_com020_d`cb_close within w_58010_d
end type

type cb_delete from w_com020_d`cb_delete within w_58010_d
end type

type cb_insert from w_com020_d`cb_insert within w_58010_d
end type

type cb_retrieve from w_com020_d`cb_retrieve within w_58010_d
end type

type cb_update from w_com020_d`cb_update within w_58010_d
end type

type cb_print from w_com020_d`cb_print within w_58010_d
end type

type cb_preview from w_com020_d`cb_preview within w_58010_d
end type

type gb_button from w_com020_d`gb_button within w_58010_d
end type

type cb_excel from w_com020_d`cb_excel within w_58010_d
end type

type dw_head from w_com020_d`dw_head within w_58010_d
integer y = 184
integer width = 2546
integer height = 204
string dataobject = "d_58010_h01"
end type

event dw_head::constructor;call super::constructor;This.GetChild("Brand", idw_brand)
idw_brand.SetTRansObject(SQLCA)
idw_brand.Retrieve('001')
end event

type ln_1 from w_com020_d`ln_1 within w_58010_d
end type

type ln_2 from w_com020_d`ln_2 within w_58010_d
end type

type dw_list from w_com020_d`dw_list within w_58010_d
string dataobject = "d_58010_d01"
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


	
IF cbx_1.Checked = TRUE THEN
		dw_body.DataObject  = 'd_58010_d02'
		dw_print.DataObject = 'd_58010_d02'	
//	IF ls_brand = 'N'  THEN
//		dw_body.DataObject  = 'd_58010_d02'
//		dw_print.DataObject = 'd_58010_d02'
//	ELSEIF ls_brand = 'W'  THEN
//		dw_body.DataObject  = 'd_58010_d12'
//		dw_print.DataObject = 'd_58010_d12'
//	ELSEIF ls_brand = 'C'  THEN
//		dw_body.DataObject  = 'd_58010_d22'
//		dw_print.DataObject = 'd_58010_d22'		
//	END IF
ELSE
		dw_body.DataObject  = 'd_58010_d03'
		dw_print.DataObject = 'd_58010_d03'	
//		IF ls_brand = 'N'  THEN
//		dw_body.DataObject  = 'd_58010_d03'
//		dw_print.DataObject = 'd_58010_d03'
//	ELSEIF ls_brand = 'W'  THEN
//		dw_body.DataObject  = 'd_58010_d13'
//		dw_print.DataObject = 'd_58010_d13'
//	ELSEIF ls_brand = 'C'  THEN
//		dw_body.DataObject  = 'd_58010_d23'
//		dw_print.DataObject = 'd_58010_d23'			
//	END IF
END IF	

	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)

il_rows = dw_body.retrieve(ls_brand,ls_invoice_date,ls_invoice_no)

Parent.Trigger Event ue_button(7, il_rows)
Parent.Trigger Event ue_msg(1, il_rows)

end event

type dw_body from w_com020_d`dw_body within w_58010_d
integer x = 800
integer y = 444
string dataobject = "d_58010_d02"
boolean hscrollbar = true
end type

type st_1 from w_com020_d`st_1 within w_58010_d
end type

type dw_print from w_com020_d`dw_print within w_58010_d
integer x = 1605
integer y = 460
string dataobject = "d_58010_d03"
end type

type cbx_1 from checkbox within w_58010_d
integer x = 2715
integer y = 276
integer width = 402
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
long textcolor = 33554432
long backcolor = 67108864
string text = "결재용"
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_brand 

ls_brand = dw_head.GetItemString(1, "brand")
	
IF cbx_1.Checked = TRUE THEN
		dw_body.DataObject  = 'd_58010_d02'
		dw_print.DataObject = 'd_58010_d02'	
//	IF ls_brand = 'N'  THEN
//		dw_body.DataObject  = 'd_58010_d02'
//		dw_print.DataObject = 'd_58010_d02'
//	ELSEIF ls_brand = 'W'  THEN
//		dw_body.DataObject  = 'd_58010_d12'
//		dw_print.DataObject = 'd_58010_d12'
//	ELSEIF ls_brand = 'C'  THEN
//		dw_body.DataObject  = 'd_58010_d22'
//		dw_print.DataObject = 'd_58010_d22'		
//	END IF
ELSE
		dw_body.DataObject  = 'd_58010_d03'
		dw_print.DataObject = 'd_58010_d03'
//	IF ls_brand = 'N'  THEN
//		dw_body.DataObject  = 'd_58010_d03'
//		dw_print.DataObject = 'd_58010_d03'
//	ELSEIF ls_brand = 'W'  THEN
//		dw_body.DataObject  = 'd_58010_d13'
//		dw_print.DataObject = 'd_58010_d13'
//	ELSEIF ls_brand = 'C'  THEN
//		dw_body.DataObject  = 'd_58010_d23'
//		dw_print.DataObject = 'd_58010_d23'			
//	END IF
END IF	

	dw_body.SetTransObject(SQLCA)
	dw_print.SetTransObject(SQLCA)

end event

