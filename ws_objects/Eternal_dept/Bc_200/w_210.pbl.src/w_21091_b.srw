$PBExportHeader$w_21091_b.srw
$PBExportComments$가격택생성처리(TAG)
forward
global type w_21091_b from w_com010_d
end type
type cb_batch from commandbutton within w_21091_b
end type
end forward

global type w_21091_b from w_com010_d
integer width = 3675
integer height = 2276
windowstate windowstate = maximized!
cb_batch cb_batch
end type
global w_21091_b w_21091_b

type variables
string is_brand, is_year, is_opt
end variables

on w_21091_b.create
int iCurrent
call super::create
this.cb_batch=create cb_batch
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_batch
end on

on w_21091_b.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_batch)
end on

event type boolean ue_keycheck(string as_cb_div);/*===========================================================================*/
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
is_year = dw_head.GetItemString(1, "year")
if IsNull(is_brand) or Trim(is_brand) = "" then
   MessageBox(ls_title,"브랜드 코드를 입력하십시요!")
   dw_head.SetFocus()
   dw_head.SetColumn("brand")
   return false
end if

is_opt = dw_head.GetItemString(1, "opt")


return true

end event

event ue_retrieve();call super::ue_retrieve;/*===========================================================================*/
/* 작성자      : (주)지우정보 ()                                      */	
/* 작성일      : 2001..                                                  */	
/* 수정일      : 2001..                                                  */
/*===========================================================================*/

/* dw_head 필수입력 column check */
IF Trigger Event ue_keycheck('1') = FALSE THEN RETURN

il_rows = dw_body.retrieve(is_brand, is_year, is_opt)
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

type cb_close from w_com010_d`cb_close within w_21091_b
end type

type cb_delete from w_com010_d`cb_delete within w_21091_b
end type

type cb_insert from w_com010_d`cb_insert within w_21091_b
end type

type cb_retrieve from w_com010_d`cb_retrieve within w_21091_b
end type

type cb_update from w_com010_d`cb_update within w_21091_b
end type

type cb_print from w_com010_d`cb_print within w_21091_b
end type

type cb_preview from w_com010_d`cb_preview within w_21091_b
end type

type gb_button from w_com010_d`gb_button within w_21091_b
end type

type cb_excel from w_com010_d`cb_excel within w_21091_b
end type

type dw_head from w_com010_d`dw_head within w_21091_b
integer height = 132
string dataobject = "d_21091_h01"
end type

event dw_head::constructor;call super::constructor;datawindowchild ldw_child

this.getchild("brand",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('001')

this.getchild("fr_year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')

this.getchild("to_year",ldw_child)
ldw_child.settransobject(sqlca)
ldw_child.retrieve('002')



end event

type ln_1 from w_com010_d`ln_1 within w_21091_b
integer beginy = 328
integer endy = 328
end type

type ln_2 from w_com010_d`ln_2 within w_21091_b
integer beginy = 332
integer endy = 332
end type

type dw_body from w_com010_d`dw_body within w_21091_b
integer y = 348
integer height = 1692
string dataobject = "d_21091_d01"
end type

type dw_print from w_com010_d`dw_print within w_21091_b
end type

type cb_batch from commandbutton within w_21091_b
integer x = 2103
integer y = 196
integer width = 402
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = hangeul!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "굴림체"
string text = "생성처리"
end type

event clicked;long ret
ret =  messagebox("실행확인","실행하시겠습니까..?",Exclamation!,YesNo!,1)
if ret = 1 then
	parent.trigger event ue_retrieve()
	if is_brand = 'N' and dw_body.rowcount() > 1 then
		FileDelete("C:\zebra\qbcom\tag_n")
		dw_body.SaveAs("C:\zebra\qbcom\tag_n" ,Text!, FALSE)
	elseif is_brand = 'O' Then
		FileDelete("C:\zebra\qbcom\tag_o")
		dw_body.SaveAs("C:\zebra\qbcom\tag_o" ,Text!, FALSE)		
	elseif is_brand = 'W' Then
		FileDelete("C:\zebra\qbcom\tag_w")
		dw_body.SaveAs("C:\zebra\qbcom\tag_w" ,Text!, FALSE)		
	elseif is_brand = 'T' Then
		FileDelete("C:\zebra\qbcom\tag_t")
		dw_body.SaveAs("C:\zebra\qbcom\tag_t" ,Text!, FALSE)		
	else
		FileDelete("C:\zebra\qbcom\tag_" + is_brand)
		dw_body.SaveAs("C:\zebra\qbcom\tag_" + is_brand ,Text!, FALSE)				
	end if
	
end if
return ret

end event

